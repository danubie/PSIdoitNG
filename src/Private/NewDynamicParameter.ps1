function NewDynamicParameter {
    <#
    .SYNOPSIS
    Create a new dynamic parameter.

    .DESCRIPTION
    This function creates a new dynamic parameter with the specified name, parameter set name, and attributes.

    .PARAMETER Name
    The name of the dynamic parameter.

    .PARAMETER ParametersetName
    The name of the parameter set to which the dynamic parameter belongs.

    .PARAMETER Mandatory
    Indicates whether the dynamic parameter is mandatory.

    .PARAMETER ParameterType
    The type of the dynamic parameter.

    .PARAMETER ValidateSet
    An array of valid values for the dynamic parameter.

    .OUTPUTS
    Returns a RuntimeDefinedParameter object representing the dynamic parameter.

    .EXAMPLE
    $dynParam = NewDynamicParameter -Name 'MyDynamicParam' -ParametersetName 'MyParameterSet' -Mandatory $true -ParameterType 'System.String' -ValidateSet 'Value1', 'Value2'
    This example creates a new dynamic parameter named 'MyDynamicParam' with the specified attributes.

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.RuntimeDefinedParameter])]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [string] $ParametersetName = '',

        [boolean] $Mandatory = $false,

        [string] $ParameterType = 'System.String',

        [string[]] $ValidateSet = $null
    )

    $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

    $attribute = New-Object System.Management.Automation.ParameterAttribute
    $attribute.Mandatory = $Mandatory
    $attribute.ParameterSetName = $ParametersetName
    $attributeCollection.Add($attribute)

    if ($null -ne $ValidateSet) {
        $attribute = New-Object System.Management.Automation.ValidateSetAttribute($ValidateSet)
        $attributeCollection.Add($attribute)
    }

    $dynParam = New-Object System.Management.Automation.RuntimeDefinedParameter($Name, $ParameterType, $attributeCollection)
    Write-Output $dynParam
}