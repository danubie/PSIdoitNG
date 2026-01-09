function ConvertTo-IdoitObjectCategoryForUpdate {
    <#
    .SYNOPSIS
    Converts a Mapped Object to an I-doit object based on the provided mapping.

    .DESCRIPTION
    This function takes a mapped InputObject and converts it to an I-doit object based on the provided mapping.
    It compares the properties of the input object with the properties of the I-doit object.
    The returned object does have the structure of an object returned by Get-IdoItObject (including categories).

    .PARAMETER InputObject
    A PSObject structured according to the mapping.
    The properties must match the properties defined in the mapping.
    The properties are defined in the mapping as PSProperty.
    Object properties which are not defined in the mapping will be ignored.

    .PARAMETER MappingName
    The name of the mapping to be used for the update.
    This is a name of a mapping registered with Register-IdoitCategoryMap.

    .PARAMETER PropertyMap
    A mapping object that defines how the properties of the input object map to the I-doit categories.

    .PARAMETER IncludeProperty
    An array of properties to include in the conversion.
    Use '*' to include all properties defined in the mapping.

    .PARAMETER ExcludeProperty
    An array of properties to exclude from the conversion.
    This might be useful to prepare an object for a specific update, where some properties should not be updated later on.

    .EXAMPLE
    ConvertTo-IdoitObjectCategoryForUpdate -InputObject $inputObject -MappingName 'MyMapping'
    This example converts the input object to an I-doit object using the mapping defined by 'MyMapping'.

    .EXAMPLE
    ConvertTo-IdoitObjectCategoryForUpdate -InputObject $inputObject -MappingName 'MyMapping' -ExcludeProperty 'Password'
    This example converts the input object to an I-doit object using the properties defined in $inputObject except the 'Password' property.

    .NOTES
    #>
    [CmdletBinding(DefaultParameterSetName = 'MappingName')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Object] $InputObject,

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
        # get all possible categories for the given object type
        $objTypeCatList = Get-IdoItObjectTypeCategory -Type $PropertyMap.IdoitObjectType
        if ($null -eq $objTypeCatList) {
            Throw "No categories found for object type $($PropertyMap.IdoitObjectType)"
            return
        }
        # check if all categories in the mapping are valid for the object type
        $notfoundCatList = $PropertyMap.mapping.category | Where-Object { $_ -notin $objTypeCatList.const }
        if ($notfoundCatList) {
            Throw "Mapping categories $($notfoundCatList -join ', ') not found for object type $($PropertyMap.IdoitObjectType)/$($PropertyMap.type_title)"
            return
        }
        # get those categories, which are used in the mapping
        $usedCatList = $objTypeCatList | Where-Object const -in $PropertyMap.mapping.category
        if ($null -eq $usedCatList) {
            Write-Warning "No categories found for object type $($idoitObject.IdoitObjectType)"
            return
        }

        $srcObject = $InputObject
        $resultCategoriesAttributes = @{} # to collect the results of the Set-IdoitCategory calls in a hashtable
        foreach ($propMap in $PropertyMap) {
            foreach ($thisMapping in $propMap.Mapping) {
                $thisCat = $usedCatList | Where-Object { $_.Const -eq $thisMapping.Category }
                if ($null -eq $thisCat) {
                    Continue            # unsupported category
                }
                $resultCategoriesAttributes[$thisMapping.Category] = @{}
                if ($IncludeProperty -eq '*') {
                    $IncludeProperty = $thisMapping.PropertyList.PSProperty
                }
                $propList = $thisMapping.PropertyList | Where-Object {
                    $_.PSProperty -notin $ExcludeProperty -and ($_.PSProperty -in $IncludeProperty -or $_.Update -eq $true)
                }
                foreach ($propListItem in $propList) {
                    $attr, $field, $index = $propListItem.iAttribute -split '\.'
                    if ($attr -eq '*') {
                        Write-Verbose "Wildcard attributes are not supported in ConvertTo-IdoitObjectCategoryForUpdate. Skipping conversion for $($thisMapping.Category).$($attr)"
                        continue
                    }
                    # if a property name is not found -> skip the attribute
                    if ($srcObject.PSObject.Properties.Name -notcontains $propListItem.PSProperty) {
                        Write-Verbose "Property $($propListItem.PSProperty) not found in input object. Skipping conversion for $($thisMapping.Category).$($attr)"
                        continue
                    }
                    # id is automatically inserted by API
                    if (-not [string]::IsNullOrEmpty($propListItem.Action)) {
                        Write-Warning "Property $($propListItem.PSProperty) has an action defined ($($propListItem.Action)). This is not supported in ConvertTo-IdoitObjectCategoryForUpdate. Skipping conversion for $($thisMapping.Category).$($attr)"
                        continue
                    }
                    #Depending on the field type, we have to set different values
                    $valueToSet = $srcObject.$($propListItem.PSProperty)
                    if ($propListItem.iInfo.type -in ('dialog', 'dialog_plus')) {
                        # in this case, it's only possible to set a "simple" value (id or title)
                        if ($srcObject.$($propListItem.PSProperty) -is [PSCustomObject]) {
                            if ($srcObject.$($propListItem.PSProperty).PSObject.Properties.Name -contains 'title') {
                                $valueToSet = $srcObject.$($propListItem.PSProperty).title
                            } elseif ($srcObject.$($propListItem.PSProperty).PSObject.Properties.Name -contains 'id') {
                                $valueToSet = $srcObject.$($propListItem.PSProperty).id
                            } else {
                                Write-Warning "Property $($propListItem.PSProperty) is a dialog object but does not contain 'id' or 'title'. Skipping conversion for $($thisMapping.Category).$($attr)"
                                continue
                            }
                        }
                        $field = ''  # for dialog fields, we do not need to set a subfield
                    }
                    if ([string]::IsNullOrEmpty($field)) {
                            $resultCategoriesAttributes[$thisMapping.Category][$attr] = $valueToSet
                    } else {
                        # multiselect fields are stored as a string array
                        if ($propListItem.iInfo.type -eq 'multiselect') {
                            $resultCategoriesAttributes[$thisMapping.Category][$attr] = @($valueToSet)
                        } else {
                            $resultCategoriesAttributes[$thisMapping.Category][$attr] = @{ $field = $valueToSet }
                        }
                    }
                }
                if ($resultCategoriesAttributes[$thisMapping.Category].Keys.Count -eq 0) {
                    # if no properties are set, we do not want to update this category
                    $resultCategoriesAttributes.Remove($thisMapping.Category)
                    Write-Verbose "No properties found for category '$($thisMapping.Category)'. Skipping conversion."
                }
            }
        }
        Write-Output $resultCategoriesAttributes
    }

    end {

    }
}