function Register-IdoitCategoryMap {
    <#
    .SYNOPSIS
    Registers a mapping of Idoit categories from a YAML file or directory.

    .DESCRIPTION
    This function reads a YAML file or all YAML files in a specified directory to register for Idoit category mappings.

    .PARAMETER Path
    The path to the YAML file or directory containing mapping files.

    .PARAMETER Recurse
    Indicates whether to search subdirectories for YAML files.

    .PARAMETER Force
    Indicates whether to overwrite existing mappings.

    .EXAMPLE
    Register-IdoitCategoryMap -Path 'C:\Path\To\MappingFile.yaml'
    Registers the mapping from the specified YAML file.

    .EXAMPLE
    Register-IdoitCategoryMap -Path 'C:\Path\To\MappingDirectory' -Recurse
    Registers all YAML mapping files found in the specified directory and its subdirectories.

    .EXAMPLE
    Register-IdoitCategoryMap -Path 'C:\Path\To\MappingFile.yaml' -Force
    Registers the mapping from the specified YAML file, overwriting any existing mapping with the same name.

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]] $Path,

        [switch] $Recurse,

        [switch] $Force
    )

    begin {
        if (-not (Test-Path -Path $Path)) {
            Write-Error "Path $Path for category map file or directory does not exist." -ErrorAction Stop
        }
        if (Test-Path -Path $Path -PathType Container) {
            $Path = Get-ChildItem -Path $Path -Filter '*.yaml' -Recurse:$Recurse
        }
        if ($null -eq $Script:IdoitCategoryMaps) {
            $Script:IdoitCategoryMaps = @{}
        }
    }

    process {
        foreach ($item in $Path) {
            $mapping = ConvertFrom-MappingFile -Path $item
            if ($mapping) {
                foreach ($obj in $mapping) {
                    $rootName = $obj.Name
                    if ($Script:IdoitCategoryMaps.ContainsKey($rootName) -and -not $Force) {
                        Write-Warning "Category map for '$rootName' already exists. Use -Force to overwrite."
                        continue
                    }
                    $Script:IdoitCategoryMaps[$rootName] = $obj
                }
            }
        }
    }

    end {

    }
}