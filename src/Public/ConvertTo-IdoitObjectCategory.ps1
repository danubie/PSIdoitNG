function ConvertTo-IdoitObjectCategory {
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

    .PARAMETER ExcludeProperty
    An array of properties to exclude from the conversion.
    This might be useful to prepare an object for a specific update, where some properties should not be updated later on.

    .EXAMPLE
    ConvertTo-IdoitObjectCategory -InputObject $inputObject -MappingName 'MyMapping'
    This example converts the input object to an I-doit object using the mapping defined by 'MyMapping'.

    .EXAMPLE
    ConvertTo-IdoitObjectCategory -InputObject $inputObject -MappingName 'MyMapping' -ExcludeProperty 'Password'
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
        $objTypeCatList = Get-IdoItObjectTypeCategory -Type $PropertyMap.IdoitObjectType
        if ($null -eq $objTypeCatList) {
            Throw "No categories found for object type $($PropertyMap.IdoitObjectType)"
            return
        }
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
                $PSpropNameList = $thisMapping.PropertyList.PSProperty | Where-Object { $_ -notin $ExcludeProperty }
                foreach ($propListItem in ($thisMapping.PropertyList | Where-Object { $_.PSProperty -in $PSpropNameList })) {
                    $attr, $field, $index = $propListItem.iAttribute -split '\.'
                    # id is automatically inserted by API
                    if ($srcObject.PSObject.Properties.Name -notcontains $propListItem.PSProperty -and $propListItem.PSProperty -ne 'Id') {
                        Write-Warning "Property $($propListItem.PSProperty) not found in input object. Skipping conversion for $($thisMapping.Category).$($attr)"
                        continue
                    }
                    if (-not [string]::IsNullOrEmpty($propListItem.Action)) {
                        Write-Warning "Property $($propListItem.PSProperty) has an action defined ($($propListItem.Action)). This is not supported in ConvertTo-IdoitObjectCategory. Skipping conversion for $($thisMapping.Category).$($attr)"
                        continue
                    }
                    if ([string]::IsNullOrEmpty($field)) {
                        $resultCategoriesAttributes[$thisMapping.Category][$attr] = $srcObject.$($propListItem.PSProperty)
                    } else {
                        # multiselect fields are stored as a string array
                        if ($propListItem.iInfo.type -eq 'multiselect') {
                            $resultCategoriesAttributes[$thisMapping.Category][$attr] = @($srcObject.$($propListItem.PSProperty))
                        } else {
                            $resultCategoriesAttributes[$thisMapping.Category][$attr] = @{
                                $field = $srcObject.$($propListItem.PSProperty)
                            }
                        }
                    }
                }
            }
        }
        Write-Output $resultCategoriesAttributes
    }

    end {

    }
}