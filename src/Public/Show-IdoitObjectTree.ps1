function Show-IdoitObjectTree {
    <#
    .SYNOPSIS
    Displays the full object tree for a given i-doit object ID or input object on the console.

    .DESCRIPTION
    This cmdlet retrieves and displays the object tree for a specified i-doit object ID or input object, including its categories and properties.
    It formats the output based on the specified style, which can be a table, JSON, or Spectre JSON format.

    If you have installed the module "PwshSpectreConsole", you can get a nice view of the results by using:
    Format-SpectreJson -Data (Show-IdoitObjectTree -ObjId 37) -Depth 5

    .PARAMETER ObjId
    The ID of the i-doit object for which to retrieve the tree. This parameter is used when the input is an object ID.

    .PARAMETER InputObject
    The object already containing the full tree.

    .PARAMETER Style
    The style in which to display the object tree. Options are 'FormatTable', 'Json', or 'SpectreJson'. Default is 'FormatTable'.

    .PARAMETER ExcludeCategory
    An array of category constants to exclude from the results. Default is 'C__CATG__LOGBOOK'.

    .PARAMETER IncludeEmptyCategories
    A switch to include empty categories in the output.

    .EXAMPLE
    Show-IdoitObjectTree -ObjId 37
    Displays the object tree for the i-doit object with ID 37 in a formatted table.

    .EXAMPLE
    $object = Get-IdoitObject -ObjId 37
    Show-IdoitObjectTree -InputObject $object -Style Json
    Displays the object tree for the i-doit object with ID 37 in JSON format.

    .EXAMPLE
    Show-IdoitObjectTree -ObjId 37 -Style SpectreJson
    Displays the object tree for the i-doit object with ID 37 in Spectre JSON format, if the Spectre module is available. Falls back to JSON if not.

    .NOTES
    #>
    [CmdletBinding(DefaultParameterSetName = 'ObjId')]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'ObjId')]
        [ValidateNotNullOrEmpty()]
        # [Alias('ObjID')]
        [int] $ObjId,

        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'InputObject')]
        [ValidateNotNullOrEmpty()]
        [PSObject] $InputObject,

        [ValidateSet('FormatTable', 'Json', 'SpectreJson')]
        [string] $Style = 'FormatTable',

        [string[]] $ExcludeCategory = 'C__CATG__LOGBOOK',

        [switch] $IncludeEmptyCategories
    )

    begin {

    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'InputObject') {
            $fullObj = $InputObject
        } else {
            $splatGetIdoitObjectTree = @{
                ObjId = $ObjId
                ExcludeCategory = $ExcludeCategory
                IncludeEmptyCategories = $IncludeEmptyCategories
            }
            $fullObj = Get-IdoitObjectTree @splatGetIdoitObjectTree
            if ($null -eq $fullObj) {
                Write-Error "Object with ID $ObjId not found or no categories available."
                return
            }
        }
        switch ($Style) {
            'FormatTable' {
                $fullObj | Select-Object -ExcludeProperty Categories | Format-Table -AutoSize -Wrap
                $fullObj.Categories | Foreach-Object {
                    $_.Properties | Format-Table -GroupBy Category -AutoSize -Wrap
                }
            }
            'Json' {
                $fullObj | ConvertTo-Json -Depth 5
            }
            'SpectreJson' {
                if (Get-Command -Name Format-SpectreJson -ErrorAction SilentlyContinue) {
                    Format-SpectreJson -Data $fullObj -Depth 5
                } else {
                    Write-Warning "ConvertTo-SpectreJson function not found. Please ensure the Spectre module is imported."
                    $fullObj | ConvertTo-Json -Depth 5
                }
            }
            default {
                Write-Error "Unknown style: $Style"
            }
        }
    }

    end {

    }
}