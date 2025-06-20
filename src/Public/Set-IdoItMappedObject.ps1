function Set-IdoitMappedObject {
    <#
    .SYNOPSIS
    Set properties of an I-doit object based on a mapping.

    .DESCRIPTION
    This function updates properties of an I-doit object based on a provided mapping.

    Criterieas for update are:
    - I-doit attribute is not readonly
    - The mapping attribute "update" is set to true.
    - Idea for the future: The value in the input object is different from the current value in I-doit.
    - The value must be different from the current value in I-doit.
    Current limitations:
    - Multi-value categories are not supported yet.
    - Calculated properties are not supported in updates.
    - Scriptblock actions are not supported yet.

    .PARAMETER InputObject
    A PSObject containing the properties to be set in on the I-doit category values.
    The properties must match the properties defined in the mapping.
    The properties are defined in the mapping as PSProperty.

    .PARAMETER ObjId
    The ID of the I-doit object to be updated.

    .PARAMETER MappingName
    The name of the mapping to be used for the update.
    This is a name of a mapping registered with Register-IdoitCategoryMap.

    .PARAMETER PropertyMap
    A mapping object that defines how the properties of the input object map to the I-doit categories.
    For a detailed description of the mapping, see the documentation TODO: link to documentation.

    .PARAMETER IncludeProperty
    An array of properties to include in the update. This is in Addition to the updateable properties defined in the mapping.
    i.e. if a property is not marked as updateable in the mapping, it can be included here to be updated.

    .PARAMETER ExcludeProperty
    An array of properties to exclude from the update. This is in Addition to the updateable properties defined in the mapping.
    i.e. if a property is marked as updateable in the mapping, it can be excluded here to not be updated.
    Excluding a property has a higher priority than including a property.
    If a property is both included and excluded, it will be excluded.

    .EXAMPLE
    Set-IdoitMappedObject -InputObject $inputObject -ObjId 12345 -MappingName 'MyMapping'
    This example updates the I-doit object with ID 12345 using the mapping defined by 'MyMapping'.

    .EXAMPLE
    Set-IdoitMappedObject -InputObject $inputObject -ObjId 12345 -PropertyMap $propertyMap
    This example updates the I-doit object with ID 12345 using the properties defined in $inputObject

    .NOTES
    #>
    [CmdletBinding(SupportsShouldProcess=$true, DefaultParameterSetName = 'MappingName')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Object] $InputObject,

        # [Alias('Id')]
        [int] $ObjId = $InputObject.objId,

        [Parameter(Mandatory = $true, ParameterSetName = 'MappingName')]
        [ValidateNotNullOrEmpty()]
        [Alias('Name')]
        [string] $MappingName,

        [Parameter(Mandatory = $true, ParameterSetName = 'PropertyMap')]
        [ValidateNotNullOrEmpty()]
        $PropertyMap,

        [string[]] $IncludeProperty = @(),

        [string[]] $ExcludeProperty = @()
    )

    begin {
        # in case of -WhatIf, we do not want to update the object
        if ($PSCmdlet.ParameterSetName -eq 'MappingName') {
            if ($null -eq $Script:IdoitCategoryMaps -or -not $Script:IdoitCategoryMaps.ContainsKey($MappingName)) {
                Write-Error "No category map registered for name '$MappingName'. Use Register-IdoitCategoryMap to register a mapping." -ErrorAction Stop
            }
            $PropertyMap = $Script:IdoitCategoryMaps[$MappingName]
        }
    }

    process {
        $obj = Get-IdoItObject -ObjId $ObjId
        if ($null -eq $obj) {
            Write-Warning "Object with objId $ObjId not found. Please use New-IdoitObject or Get-IdoItObject to get the object to change"
            return
        }
        $objTypeCatList = Get-IdoItObjectTypeCategory -Type $obj.Objecttype
        if ($null -eq $objTypeCatList) {
            Throw "No categories found for object type $($obj.Objecttype)"
            return
        }
        $notfoundCatList = $PropertyMap.mapping.category | Where-Object { $_ -notin $objTypeCatList.const }
        if ($notfoundCatList) {
            Throw "Mapping categories $($notfoundCatList -join ', ') not found for object type $($obj.Objecttype)/$($obj.type_title)"
            return
        }
        # get those categories, which are used in the mapping
        $usedCatList = $objTypeCatList | Where-Object const -in $PropertyMap.mapping.category
        if ($null -eq $usedCatList) {
            Write-Warning "No categories found for object type $($obj.Objecttype)"
            return
        }
        # # multi_value categories are not supported yet
        # $multiValueCatList = $usedCatList | Where-Object { $_.multi_value -ne 0 }
        # foreach ($mv in $multiValueCatList) {
        #     Write-Warning "Categories $($mv.const) is a multi value category. This is not supported yet."
        #     $usedCatList = $usedCatList | Where-Object { $_.const -ne $mv.const }
        # }

        $srcObject = $InputObject
        $overallSucess = $true
        foreach ($propMap in $PropertyMap) {
            foreach ($thisMapping in $propMap.Mapping) {
                $thisCat = $usedCatList | Where-Object { $_.Const -eq $thisMapping.Category }
                if ($null -eq $thisCat) {
                    Continue            # unsupported category
                }
                $catValues = Get-IdoItCategory -ObjId $obj.Id -Category $thisMapping.Category
                if ($null -eq $catValues) {
                    Write-Verbose "No categories found for object type $($thisMapping.Category)($($obj.Objecttype)); Should be new"
                }
                # if no action is defined, add the property. If the corresponding catvalue holds an array, the property is added as an array
                # TODO: Multivalue categories are not supported yet

                # create a list of property names to update
                #   include those which are defined in the mapping as updateable
                #           those which are defined by IncludeProperty parameter
                #   exclude those which are defined by ExcludeProperty parameter
                $PSpropNameList = @($thisMapping.PropertyList | Where-Object { $_.Update -eq $true }).PSProperty + $IncludeProperty | Where-Object { $_ -notin $ExcludeProperty }
                foreach ($propListItem in ($thisMapping.PropertyList | Where-Object { $_.PSProperty -in $PSpropNameList -and [String]::IsNullOrEmpty($_.Action) })) {
                    $attr, $field, $index = $propListItem.iAttribute -split '\.'
                    if ($attr[0] -eq '!') {
                        Write-Error "The iAttribute '$($propListItem.iAttribute)' is not supported for update. It must be or be a simple key."
                        continue
                    }
                    # arrays are currently support under the condition that the attribute has a dialog or dialog_plus ui
                    if ($catValues.$($attr) -is [System.Array]) {
                        $catInfo = Get-IdoItCategoryInfo -Category $thisMapping.Category
                        if ($catInfo.$attr.info.type -notin @('dialog', 'dialog_plus','multiselect')) {
                            Write-Warning "The iAttribute '$($propListItem.iAttribute)' is not a dialog,dialog_plus or multiselect type. Arrays are not supported for this type."
                            continue
                        }
                        $changedProperty = [string]::Format("{0}.{1}: {2}->{3}", $thisMapping.Category, $attr,
                            ($catValues.$attr.$field -join ', '), ($srcObject.$($propListItem.PSProperty) -join ', '))
                        if ($PSCmdlet.ShouldProcess($changedProperty, "Update property $($obj.Title)")) {
                            $result = Set-IdoItCategory -ObjId $obj.Id -Category $thisMapping.Category -Data @{
                                $attr = $srcObject.$($propListItem.PSProperty)
                            }
                            $overallSucess = $overallSucess -and $result.success
                        }
                    } else {
                        # change only if the value is different; Case sensitive!
                        if ($catValues.$attr.$field -cne $srcObject.$($propListItem.PSProperty)) {
                            $changedProperty = [string]::Format("{0}.{1}. {2}->{3}", $thisMapping.Category, $propListItem.iAttribute,
                                $catValues.$($propListItem.iAttribute), $srcObject.$($propListItem.PSProperty))
                            if ($PSCmdlet.ShouldProcess($changedProperty, "Update property $($obj.Title)")) {
                                $result = Set-IdoItCategory -ObjId $obj.Id -Category $thisMapping.Category -Data @{
                                    $attr = $srcObject.$($propListItem.PSProperty)
                                }
                                $overallSucess = $overallSucess -and $result.success
                            }
                        }
                    }
                }
            }
        }
        Write-Output $overallSucess
    }

    end {

    }
}
