function Get-IdoitMappedObjectFromTemplate {
    <#
    .SYNOPSIS
        Retrieves a mapped object constructed from a registered Idoit category mapping.

    .DESCRIPTION
        This function retrieves a mapping of Idoit categories by name and constructs a PSObject based on the registered mapping.
        It checks if the mapping exists in the global script variable `$Script:IdoitCategoryMaps`.
        The returned object will have properties defined in the mapping with 'PSProperty' key, which can be used to create or update Idoit objects.

    .PARAMETER MappingName
        The name of the mapping to retrieve.

    .EXAMPLE
        Get-IdoitMappedObjectFromTemplate -MappingName 'MyMapping'
        Retrieves the mapping for 'MyMapping' and constructs a PSObject based on the registered mapping.

    .NOTES
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Name')]
        [string] $MappingName
    )
    begin {
        if ($null -eq $Script:IdoitCategoryMaps -or -not $Script:IdoitCategoryMaps.ContainsKey($MappingName)) {
            Write-Error "No category map registered for name '$MappingName'. Use Register-IdoitCategoryMap to register a mapping." -ErrorAction Stop
        }
        $PropertyMap = $Script:IdoitCategoryMaps[$MappingName]
    }
    process {
        $obj = [PSCustomObject]@{}
        foreach ($cat in $PropertyMap.Mapping) {
            foreach ($prop in $cat.PropertyList) {
                $psProp = $prop.PSProperty
                if ($null -ne $psProp) {
                    $obj | Add-Member -MemberType NoteProperty -Name $psProp -Value $null -Force
                }
            }
        }
        $obj | Add-Member -MemberType NoteProperty -Name 'objId' -Value $null -Force
        return $obj
    }
    end {
        # No cleanup needed
    }
}