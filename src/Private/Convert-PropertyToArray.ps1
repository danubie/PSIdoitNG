function Convert-PropertyToArray {
<#
    .SYNOPSIS
    Convert-PropertyToArray

    .DESCRIPTION
    This function converts a PowerShell object with properties into an array of objects.

    .PARAMETER InputObject
    The input object to be converted. Details see example.

    .OUTPUTS
    Returns an array of objects, each containing the property name and value.

    .EXAMPLE
    Convert-PropertyToArray -InputObject $inputObject
    [PSCustomObject] @{
        C__OBJTYPE__SERVICE = 'System Service';
        C__OBJTYPE__APPLICATION = 'Application';
        ...
    }
    into an array of the following definition
    [PSCustomObject] @{
        Name = 'C__OBJTYPE__SERVICE';
        Value = 'System Service';
    }
        .... and so on
#>
    [CmdletBinding()]
    param (
        [PSCustomObject]$InputObject
    )
    $result = foreach ($property in $InputObject.PSObject.Properties) {
        [PSCustomObject]@{
            Name  = $property.Name
            Value = $property.Value
        }
    }
    return $result
}