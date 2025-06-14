function New-IdoitMappedObject {
    <#
    .SYNOPSIS
    Creates a new Idoit object based on the specified mapping.

    .DESCRIPTION
    This function creates a new Idoit object of the type specified in the mapping.
    It uses the provided input object to set the properties of the new object according to the mapping.
    The mapping must be registered using `Register-IdoitCategoryMap` before calling this function.

    .PARAMETER InputObject
    The input object containing the properties to be set on the new Idoit object.
    This object should match the structure defined in the mapping.

    .PARAMETER MappingName
    The name of the mapping to use for creating the new Idoit object.

    .PARAMETER IncludeProperty
    An array of property names to include when creating the new object.
    This is useful, if properties are set only on creation and not on update.
    attributes/properties which are defined as updatetable in the mapping will be set, even if not included here.

    .PARAMETER ExcludeProperty
    An array of property names to exclude when creating the new object.
    This is useful, if you want to skip certain properties that are not relevant for the new object.

    .EXAMPLE
    New-IdoitMappedObject -InputObject $inputObject -MappingName 'MyMapping' -IncludeProperty 'Name', 'Description' -ExcludeProperty 'Tags'
    Creates a new Idoit object using the specified mapping, including only the 'Name' and 'Description' properties,
    and excluding the 'Tags' property from the input object.

    .NOTES
    This function requires the mapping to be registered using `Register-IdoitCategoryMap`.

    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'ShouldProcess is handled in called functions.')]
    param (
        [Parameter(Mandatory = $true)]
        [PSObject] $InputObject,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Name')]
        [string] $MappingName,

        [string[]] $IncludeProperty,

        [string[]] $ExcludeProperty
    )

    begin {
        # check if mapping exists
        if (-not $Script:IdoitCategoryMaps.ContainsKey($MappingName)) {
            throw "No category map registered for name '$MappingName'. Use Register-IdoitCategoryMap to register a mapping."
        }
        $mapping = $Script:IdoitCategoryMaps[$MappingName]
    }

    process {
        $newobj = New-IdoitObject -Name "new($($mapping.IdoitObjectType)-$(New-GUID))" -ObjectType $mapping.IdoitObjectType
        if ($null -eq $newobj) {
            throw "Failed to create a new Idoit object of type '$($mapping.IdoitObjectType)'."
        }
        # even for attributes that are read-only, we have to set them, otherwise the object will not be created correctly
        $splatSetMappedObject = @{
            InputObject = $InputObject
            ObjId       = $newobj.objId
            MappingName = $MappingName
            IncludeProperty = $IncludeProperty
            ExcludeProperty = $ExcludeProperty
        }
        $InputObject.objId = $newobj.objId
        $ret = Set-IdoitMappedObject @splatSetMappedObject
        $ret
    }

    end {

    }
}