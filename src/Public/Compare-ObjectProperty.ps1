function Compare-ObjectProperty {
    <#
    .SYNOPSIS
    Compares specific properties of two objects and returns the differences.
    .DESCRIPTION
    In contrast to the built-in Compare-Object cmdlet, this function will return a side-by-side comparison of specified properties from two objects.
    .PARAMETER ReferenceObject
    The first object to compare.
    .PARAMETER DifferenceObject
    The second object to compare.
    .PARAMETER PropertyList
    The list of properties to compare. If not specified, all properties will be compared.
    .PARAMETER IncludeEqual
    If specified, properties that are equal in both objects will also be included in the output.
    .OUTPUTS
    A custom object containing the property name, reference value, difference value, and side indicator.
    .EXAMPLE
    $obj1 = [PSCustomObject]@{ Name = "Alice"; Age = 30; City = "New York"; Property1 = "Value1" }
    $obj2 = [PSCustomObject]@{ Name = "Alice"; Age = 32; City = "Los Angeles"; Property2 = "Value2" }
    Compare-ObjectProperty -ReferenceObject $obj1 -DifferenceObject $obj2
    Name      ReferenceValue  SideIndicator DifferenceValue
    --------  --------------- ------------- ---------------
    Age       30              <>            32
    City      New York        <>            Los Angeles
    Property1 Value1          <=
    Property2                 =>            Value2
    .EXAMPLE
    $obj1 = [PSCustomObject]@{ Name = "Alice"; Age = 30; City = "New York"; Property1 = "Value1" }
    $obj2 = [PSCustomObject]@{ Name = "Alice"; Age = 32; City = "Los Angeles"; Property2 = "Value2" }
    Compare-ObjectProperty -ReferenceObject $obj1 -DifferenceObject $obj2 -IncludeEqual
    Name      ReferenceValue  SideIndicator DifferenceValue
    --------  --------------- ------------- ---------------
    Name      Alice           ==            Alice
    Age       30              <>            32
    City      New York        <>            Los Angeles
    Property1 Value1          <=
    Property2                 =>            Value2
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $ReferenceObject,
        [Parameter(Mandatory = $true)]
        $DifferenceObject,
        [string[]]$PropertyList,
        [switch]$IncludeEqual
    )

    begin {

    }

    process {
        $allProperties = @()
        if ($null -ne $PropertyList -and $PropertyList.Count -gt 0) {
            $allProperties = $PropertyList
        } else {
            $allProperties = ($ReferenceObject | Get-Member -MemberType NoteProperty, Property).Name
            $allProperties += ($DifferenceObject | Get-Member -MemberType NoteProperty, Property).Name
            $allProperties = $allProperties | Select-Object -Unique
        }

        $resultList =foreach ($prop in $allProperties) {
            $refValue = $ReferenceObject.PSObject.Properties[$prop]?.Value
            $diffValue = $DifferenceObject.PSObject.Properties[$prop]?.Value
            $refValueString = $refValue | Out-String
            $diffValueString = $diffValue | Out-String

            if ($refValueString -eq $diffValueString) {
                if ($IncludeEqual.IsPresent) {
                    [PSCustomObject]@{
                        Name           = $prop
                        ReferenceValue = $refValue
                        SideIndicator  = '=='
                        DifferenceValue= $diffValue
                    }
                }
            } else {
                $sideIndicator = ''
                if ($null -ne $refValue -and $null -ne $diffValue) {
                    $sideIndicator = '<>'
                } elseif ($null -ne $refValue) {
                    $sideIndicator = '<='
                } else {
                    $sideIndicator = '=>'
                }

                [PSCustomObject]@{
                    Name           = $prop
                    ReferenceValue = $refValue
                    SideIndicator  = $sideIndicator
                    DifferenceValue= $diffValue
                }
            }
        }

        return $resultList
    }

    end {

    }
}