function ValidateProperties {
    <#
    .SYNOPSIS
    Validates properties for a given category.

    .DESCRIPTION
    This function checks if the provided properties are valid for the specified category in i-doit.
    It validates the properties against the category's information and returns a hashtable of valid properties.
    If any property is invalid, it issues a warning and removes that property from the returned hashtable.
    Reason to validate locally?
    Field type dialog_plus would create a new entry if was not defined in the category.
    To avoid accidental creation of new entries because of a typo, we validate the properties first.

    .PARAMETER Category
    The category to validate properties against. This should be a valid i-doit category identifier.

    .PARAMETER Properties
    A hashtable of properties to validate. The keys should be property names and the values should be the corresponding values.

    .PARAMETER ExcludeProperties
    An array of property names to exclude from validation. These properties will be included in the returned hashtable without validation.

    .EXAMPLE
    $properties = @{
        'f_popup_c_17289168067044910' = 'Job / Schnittstelle'       # custom field; select one from a list
        'f_popup_c_17289128195752470' = @('SQL Server','Biztalk')   # custom field; multiselect
    }
    $validProperties = ValidateProperties -Category 'C__CATG__CUSTOM_FIELDS_KOMPONENTE' -Properties $properties
    This example validates the properties for the category 'C__CATG__CUSTOM_FIELDS_KOMPONENTE' and returns a hashtable of valid properties.

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Category,

        [Parameter(Mandatory = $true)]
        [hashtable] $Properties,

        [string[]] $ExcludeProperties = @(
            'objID', 'id', 'psid_custom', 'entry', 'Category'
        )
    )

    $atLeastOneFailed = $false
    $validProperties = @{}
    $catInfo = Get-IdoitCategoryInfo -Category $Category -ErrorAction Stop
    $keysToCheck = @($Properties.Keys.GetEnumerator())
    foreach ($key in $keysToCheck) {
        Write-Verbose "Validating property '$key' for category '$($Category)'"
        if ($ExcludeProperties -contains $key) {
            $validProperties[$key] = $Properties[$key]
            Write-Verbose "Excluding property '$key' from validation for category '$($Category)'"
            continue
        }
        if ($null -eq $catInfo.$key) {
            Write-Warning "Property '$key' is not a valid property for category '$($Category)'. Skipping it."
            continue
        }
        if ($catInfo.$key.data.readonly) {
            Write-Verbose "Property '$key' is read-only for category '$($Category)'. Skipping it."
            $Properties.Remove($key)
            continue
        }
        switch  -Regex ($catInfo.$key.info.type) {
            'dialog' {
                # type "dialog", "dialog_plus"
                if ($null -eq $Properties[$key]) {
                    continue
                }
                $thisDialogOptions = Get-IdoitDialog -params @{ category = $Category; property = $key } -ErrorAction Stop
                $valid = $thisDialogOptions.title -contains $Properties[$key]
                if (-not $valid) {
                    $atLeastOneFailed = $true
                    Write-Warning "Value '$($Properties[$key])' for property '$key' is not valid for category '$($Category)'. Valid values are: $($thisDialogOptions.title -join ', ')"
                    continue    # we leave it to the caller to break the loop by using -ErrorAction Stop
                }
                $validProperties[$key] = $Properties[$key]
            }
            'multiselect' {
                # type "multiselect"; never so "multiselect_plus" in the field, just a guess
                $thisDialogOptions = Get-IdoitDialog -params @{ category = $Category; property = $key } -ErrorAction Stop
                foreach ($thisKey in $Properties[$key]) {
                    $valid = $thisDialogOptions.title -contains $thisKey
                    if (-not $valid) {
                        $atLeastOneFailed = $true
                        Write-Warning "Value '$thisKey' for property '$key' is not valid for category '$Category'. Valid values are: $($thisDialogOptions.title -join ', ')"
                        continue    # we leave it to the caller to break the loop by using -ErrorAction Stop
                    }
                    $validProperties[$key] = $Properties[$key]
                }
            }
            Default {
                # For other types, we assume the value is valid
                $validProperties[$key] = $Properties[$key]
            }
        }
    }
    if ($atLeastOneFailed) {
        Write-Error "One or more properties failed validation for category '$Category'. Please check the warnings above."
    }
    Write-Output $validProperties
}