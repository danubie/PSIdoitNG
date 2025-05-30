function ConvertFrom-CustomCategory {
    <#
    .SYNOPSIS
    Converts a custom category object into a more user-friendly format.

    .DESCRIPTION
    ConvertFrom-CustomCategory gives a more user-friendly representation of a custom category object.
    It retrieves category information and formats the properties into a custom object with more readable property names.
    The PSCustom property names are derived from the category information titles, cleaning up any non-alphanumeric characters.

    .PARAMETER InputObject
    The input object to convert.

    .PARAMETER CategoryObject
    The category object containing the category information to use for conversion.

    .EXAMPLE
    $inputObject = Get-IdoitObject -Id 12345
    $objTypeCatList = Get-IdoitObjectTypeCategory -ObjId $Id -ErrorAction Stop | Where-Object { $_.const -eq 'C__CATG__CUSTOM_FIELDS_COMPONENT' }
    $newObject = ConvertFrom-CustomCategory -InputObject $inputObject -CategoryObject $objTypeCatList

    This would be an explicit example of how to use the ConvertFrom-CustomCategory function.

    .EXAMPLE
    $inputObject = Get-IdoitObject -Id 12345
    $newObject = Get-IdoitCategory -Id 12345 -Category 'C__CATG__CUSTOM_FIELDS_COMPONENT'

    This is an example, where ConvertFrom-CustomCategory is used implicitly by Get-IdoitCategory.

    .NOTES
    The converted names get all non-alphanumeric characters replaced with an underscore.
    If the category information is not available, the original property names from the input object are retained.
    Category properties that are only for UI purposes (like 'hr' or 'html') are skipped.

    To make Set-IdoitCategory work easier, the original property names are stored in a special property called 'psid_custom'.
    The 'psid_custom' property is a hashtable that maps the new property names to the original property names.

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [PSObject]$InputObject,

        [Parameter(Mandatory = $true)]
        [PSObject] $CategoryObject
    )

    begin {

    }

    process {
        $catInfo = Get-IdoitCategoryInfo -Category $CategoryObject.const -ErrorAction Stop
        $result = [ordered]@{
            objId = $InputObject.objId
            id    = $InputObject.id
            psid_custom = @{}             # indicates that this is a modified custom category object, stores the names
        }
        foreach ($property in $catInfo.PSObject.Properties) {
            if ($catInfo.PSObject.Properties[$property.Name]) {
                $newPropName = $property.Value.title -replace '[^a-zA-Z0-9]', '_'
                # If the property seems to be just for UI purposes, we will skip it
                if ($property.Value.ui.type -in 'hr','html') {
                    continue
                }
                if ('' -eq $newPropName) {
                    continue                        # this seems to happen for the category name?
                }
                # $InputObject | Add-Member -MemberType NoteProperty -Name $property.Name -Value $catInfo.PSObject.Properties[$property.Name].Value -Force
                $result.Add($newPropName,  $InputObject.($property.name).Title)
                $result.psid_custom.Add($newPropName, $property.Name) # store the original name for later reference
            } else {
                # If the property is not defined in the category info, we will add it as a NoteProperty with value from InputObject
                $result.Add($property.Name, $InputObject[$property.Name])
                $result.psid_custom.Add($property.Name, $property.Name)
            }
        }
        [PSCustomObject] $result
    }

    end {

    }
}