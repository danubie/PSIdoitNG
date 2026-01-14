function Set-IdoitMappedObject {
    <#
    .SYNOPSIS
    Set properties of an I-doit object based on a mapping.

    .DESCRIPTION
    This function updates properties of an I-doit object based on a provided mapping.

    Criterieas for update are:
    - I-doit attribute is not readonly
    - The mapping attribute "update" is set to true.
    - Idea for the future: The value in the input object is different from the current value in I-doit.
    - The value must be different from the current value in I-doit.
    Current limitations:
    - Multi-value categories are not supported yet.
    - Calculated properties are not supported in updates.
    - Scriptblock actions are not supported yet.

    .PARAMETER InputObject
    A PSObject containing the properties to be set in on the I-doit category values.
    The properties must match the properties defined in the mapping.
    The properties are defined in the mapping as PSProperty.

    .PARAMETER ObjId
    The ID of the I-doit object to be updated.

    .PARAMETER MappingName
    The name of the mapping to be used for the update.
    This is a name of a mapping registered with Register-IdoitCategoryMap.

    .PARAMETER PropertyMap
    A mapping object that defines how the properties of the input object map to the I-doit categories.
    For a detailed description of the mapping, see the documentation TODO: link to documentation.

    .PARAMETER IncludeProperty
    An array of properties to include in the update. This is in Addition to the updateable properties defined in the mapping.
    i.e. if a property is not marked as updateable in the mapping, it can be included here to be updated.

    .PARAMETER ExcludeProperty
    An array of properties to exclude from the update. This is in Addition to the updateable properties defined in the mapping.
    i.e. if a property is marked as updateable in the mapping, it can be excluded here to not be updated.
    Excluding a property has a higher priority than including a property.
    If a property is both included and excluded, it will be excluded.

    .EXAMPLE
    Set-IdoitMappedObject -InputObject $inputObject -ObjId 12345 -MappingName 'MyMapping'
    This example updates the I-doit object with ID 12345 using the mapping defined by 'MyMapping'.

    .EXAMPLE
    Set-IdoitMappedObject -InputObject $inputObject -ObjId 12345 -PropertyMap $propertyMap
    This example updates the I-doit object with ID 12345 using the properties defined in $inputObject

    .NOTES
    #>
    [CmdletBinding(SupportsShouldProcess=$true, DefaultParameterSetName = 'MappingName')]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Object] $InputObject,

        # [Alias('Id')]
        [int] $ObjId = $InputObject.objId,

        [Parameter(Mandatory = $true, ParameterSetName = 'MappingName')]
        [ValidateNotNullOrEmpty()]
        [Alias('Name')]
        [string] $MappingName,

        [Parameter(Mandatory = $true, ParameterSetName = 'PropertyMap')]
        [ValidateNotNullOrEmpty()]
        $PropertyMap,

        [string[]] $IncludeProperty = @(),

        [string[]] $ExcludeProperty = @()
    )

    begin {}

    process {
        $splatMapping = @{}
        if ($PSCmdlet.ParameterSetName -eq 'MappingName') {
            $splatMapping.MappingName = $MappingName
        } else {
            $splatMapping.PropertyMap = $PropertyMap
        }
        $prevObj = Get-IdoItMappedObject -ObjId $ObjId @splatMapping
        if ($null -eq $prevObj) {
            Throw "Object with objId $ObjId not found for Update."
        }
        $diff = Compare-ObjectProperty -ReferenceObject $prevObj -DifferenceObject $InputObject -PropertyList ($srcObject.PSObject.Properties.Name)
        if ($null -eq $diff) {
            Write-Verbose "ObjId: $ObjId; No changes detected for object; no update required."
            return $true
        }
        Write-Verbose "ObjId: $ObjId; Changes detected ; updating properties."
        $srcObject = $InputObject | Select-Object -Property $diff.Name
        $srcCategoryList = ConvertTo-IdoitObjectCategoryForUpdate -InputObject $srcObject @splatMapping -ExcludeProperty $ExcludeProperty -IncludeProperty $IncludeProperty
        $overallSucess = $true
        foreach ($catName in $srcCategoryList.Keys) {
                Set-IdoItCategory -ObjId $ObjId -Category $catName -Data $srcCategoryList[$catName]
        }
        Write-Output $overallSucess
    }

    end {

    }
}
