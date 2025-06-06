function ConvertFrom-MappingFile {
    <#
    .SYNOPSIS
    Convert a file containing a mapping of I-doit categories to a PSObject

    .DESCRIPTION
    The content of the file and convert it to a PSObject for later use as mapping between I-doit categories and PowerShell objects.
    Allowed file formats are yaml and JSON.
    For converting yaml files, the module 'powershell-yaml' is required.

    .PARAMETER Path
    The path to the file containing the mapping.

    .EXAMPLE
    ConvertFrom-MappingFile -Path 'C:\path\to\mapping.yaml'
    Returns an object with the mapping defined in the file.

    .EXAMPLE
    ConvertFrom-MappingFile -Path 'C:\path\to\mapping.json'
    Returns an object with the mapping defined in the file.

    .OUTPUTS
    PCustomObject
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $Path
    )

    begin {
        if (-not (Test-Path $Path -ErrorAction SilentlyContinue)) {
            throw [System.IO.FileNotFoundException] "Mapping file not found ($Path)."
        }
    }

    process {
        $Content = Get-Content -Path $Path -Raw
        if ($Path.EndsWith('.yaml')) {
            $rawMapping = ConvertFrom-Yaml -Yaml $Content -Ordered -ErrorAction Stop |
                ConvertTo-Yaml -JsonCompatible |
                ConvertFrom-Json -AsHashtable
        } elseif ($Path.EndsWith('.json')) {
            $rawMapping = $Content | ConvertFrom-Json
        } else {
            throw "Unsupported file format: $Path"
        }
        # loop through the keys defining all object map definitions
        $MappingList = foreach ($key in $rawMapping.keys) {
            $definition = $rawMapping[$key]
            $obj = [PSCustomObject]@{
                Name            = $key
                PSType          = $definition.PSType
                IdoitObjectType = $definition.IdoitObjectType
                Mapping         = @()
            }
            # loop through each category in the definition
            $thisMappings = foreach ($catKey in $definition.Category.Keys) {
                $mapOneCategory = [PSCustomObject]@{
                    Category = $catKey
                    PropertyList = @()
                }
                # loop through each PSProperty/property mapping in this category
                foreach ($attributeDef in ($definition.Category.$catKey).GetEnumerator()) {
                    $thisDefinition = [PSCustomObject]@{
                        PSProperty = $attributeDef.Value.PSProperty
                        iAttribute = $attributeDef.Key
                        Action = $attributeDef.Value.Action
                        ScriptAction = $null
                        DisplayFormat = $null
                        Update = $attributeDef.Value.Update -eq $true
                    }
                    if ($null -eq $thisDefinition.PSProperty) {
                        $thisDefinition.PSProperty = $thisDefinition.iAttribute    # if no property is defined, it uses the same name
                    }
                    if ('ScriptAction' -eq $thisDefinition.Action) {
                        $thisDefinition.ScriptAction = [scriptblock]::Create($attributeDef.Value.ScriptAction)
                    }
                    if (-not [string]::IsNullOrEmpty($attributeDef.Value.DisplayFormat)) {
                        $thisDefinition.DisplayFormat = $attributeDef.Value.DisplayFormat
                    }
                    $mapOneCategory.PropertyList += $thisDefinition
                }
                $mapOneCategory
            }
            $obj.Mapping = $thisMappings
            $obj
        }
        $MappingList
    }

    end {

    }
}