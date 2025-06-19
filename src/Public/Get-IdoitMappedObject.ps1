function Get-IdoitMappedObject {
    <#
        .SYNOPSIS
        Get an object that is created based on a iAttribute map.

        .DESCRIPTION
        Get an object that is created based on a iAttribute map. The mapping is defined in the property map.
        This allows to construct Powershell objects combining different I-doit categories and their values.

        .PARAMETER ObjId
        The object ID of the I-doit object.

        .PARAMETER Title
        The title (or name) of the I-doit object you want to filter.
        This must be a unique title in I-doit.

        .PARAMETER MappingName
        The name of the mapping to be used for the object creation.
        This is a name of a mapping registered with Register-IdoitCategoryMap.

        .PARAMETER PropertyMap
        The property map that defines how the I-doit categories and their values should be mapped to the properties of the resulting object.

        .EXAMPLE
        Assume that 37 is the Id of a persons object.
        $propertyMap = @{
            PSType  = 'MyUser'
            IdoitObjectType = 'C__OBJTYPE__PERSON'
            Mapping = @(
                @{
                    Category     = 'C__CATS__PERSON';
                    PropertyList = @(
                        @{ Property = 'Id'; iAttribute = 'Id' },
                        @{ Property = 'Name'; iAttribute = 'Title' }
                    )
                }
            )
        }
        $result = Get-IdoitMappedObject -ObjId 37 -PropertyMap $propertyMap

        .EXAMPLE
        Register-IdoitCategoryMap -Path 'C:\Path\To\Your\Mapping.yaml'
        $result = Get-IdoitMappedObject -Title 'Your title' -MappingName 'PersonMapped'
        This example retrieves an I-doit object by its title using a predefined mapping named 'PersonMapped'.

        .NOTES
    #>
    [CmdletBinding(DefaultParameterSetName = 'ByObjIdMappingName')]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ByObjIdMappingName')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ByObjIdPropertyMap')]
        # [Alias('Id')]
        [int[]] $ObjId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByTitleMappingName')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ByTitlePropertyMap')]
        [string] $Title,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByTitleMappingName')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ByObjIdMappingName')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ByObjectTypePropertyMap')]
        [ValidateNotNullOrEmpty()]
        [Alias('Name')]
        $MappingName,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByObjIdPropertyMap')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ByTitlePropertyMap')]
        $PropertyMap
    )

    begin {
        if ($PSCmdlet.ParameterSetName -like '*MappingName') {
            if ($null -eq $Script:IdoitCategoryMaps -or -not $Script:IdoitCategoryMaps.ContainsKey($MappingName)) {
                Write-Error "No category map registered for name '$MappingName'. Use Register-IdoitCategoryMap to register a mapping." -ErrorAction Stop
            }
            $PropertyMap = $Script:IdoitCategoryMaps[$MappingName]
            if ($PSCmdlet.ParameterSetName -eq 'ByFilterMappingName') {
                if ($null -eq $PropertyMap.Filter) {
                    Write-Error "No filter defined for mapping '$MappingName'. Use Register-IdoitCategoryMap to register a mapping with a filter." -ErrorAction Stop
                }
                if ($PropertyMap.Filter -notcontains $Filter) {
                    Write-Error "Filter '$Filter' not found in mapping '$MappingName'. Available filters: $($PropertyMap.Filter -join ', ')." -ErrorAction Stop
                }
            }
        }
    }

    process {
        if ($PSCmdlet.ParameterSetName -match 'ByTitle') {
            $paramTitle = @{
                title = $Title
            }
        }
        $objList = Get-IdoItObject -ObjId $ObjId -Category $PropertyMap.Mapping.Category @paramTitle
        if ($null -eq $objList) {
            Write-Verbose "No objects found for ObjId: $ObjId with category: $($PropertyMap.Mapping.Category)."
            return
        }

        foreach ($obj in $objList) {
            $resultObj = @{
                ObjId      = $obj.Id
                PSTypeName = 'Idoit.MappedObject'
            }
            foreach ($propMap in $PropertyMap) {
                foreach ($thisMapping in $propMap.Mapping) {
                    $catValues = ($obj.categories.($thisMapping.Category))
                    if ($null -eq $catValues) {
                        Write-Verbose "No values found for category $($thisMapping.Category) in object $($obj.Id)."
                    }
                    foreach ($propListItem in $thisMapping.PropertyList) {
                        # I-doit iAttribute values can be simpley types or a hashtable with keys depending on the iAttribute it is representing
                        # For the later once, the if the iAttribute "name" has to be 'iAttribute.field'. This is the "deep key" to get the value
                        $attr, $field, $index = $propListItem.iAttribute -split '\.'
                        if ($attr -eq '*' -and $field -notmatch '^$|^[0-9]+$') {
                            Write-Error "The iAttribute '$($propListItem.iAttribute)' is not supported. It must be '*' or be a simple key."
                        }
                        if ($attr -eq '*') {
                            # pass the whole category object
                            # char & would bei nicer, but would collide with merge key support of powershell-yaml
                            $thisCatValue = $catValues
                        }
                        elseif (-not [string]::IsNullOrEmpty($field)) {
                            # if the iAttribute is a deep key, the value is extracted from the hashtable
                            $thisCatValue = $catValues.$attr.$field
                        }
                        else {
                            # if the iAttribute is a simple key, the value is extracted from the hashtable
                            $thisCatValue = $catValues.$attr
                        }
                        # manage simple values
                        if ([string]::IsNullOrEmpty($propListItem.Action)) {
                            if ($thisCatValue -is [System.Array]) {
                                $resultObj.Add($propListItem.PSProperty, @($thisCatValue))
                            }
                            else {
                                $resultObj.Add($propListItem.PSProperty, $thisCatValue)
                            }
                            continue
                        }
                        # manage predefined actions
                        if ($propListItem.Action -is [string]) {
                            switch ($propListItem.Action) {
                                'Sum' {
                                    $resultObj.Add($propListItem.PSProperty, ( $thisCatValue | Measure-Object -Sum | Select-Object -ExpandProperty Sum))
                                    break
                                }
                                'Count' {
                                    $resultObj.Add($propListItem.PSProperty, ($thisCatValue | Measure-Object).Count)
                                    break
                                }
                                'ScriptAction' {
                                    if (-not $propListItem.GetScript) {
                                        Write-Warning "No script action defined for property $($propListItem.PSProperty) in mapping $($thisMapping.Category)"
                                        continue
                                    }
                                    # scriptblock parameter: if iAttribute if it is defined else the whole object is passed to the action
                                    Try {
                                        $result = $propListItem.GetScript.InvokeReturnAsIs(@($thisCatValue))
                                    }
                                    catch {
                                        $result = $_ | Out-String
                                    }
                                    $resultObj.Add($propListItem.PSProperty, $result)
                                    continue
                                }
                                '' {
                                    $resultObj.Add($propListItem.PSProperty, $thisCatValue)
                                }
                                Default {
                                    Write-Warning "Unknown action: [$($_)]"
                                }
                            }
                            continue
                        }
                    }
                }
            }
            $result = ([PSCustomObject]$resultObj)[0]     # casting to [PSObject] returns an arraylist, but we want a single object
            if ($null -ne $PropertyMap.PSType) {
                $result.PSObject.TypeNames.Insert(0, $PropertyMap.PSType)
            }

            $result
        }
    }

    end {
    }
}
