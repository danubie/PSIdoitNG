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

    .PARAMETER Title
    The title of the new Idoit object. This is typically the name or identifier of the object.

    .PARAMETER MappingName
    The name of the mapping to use for creating the new Idoit object.

    .PARAMETER IncludeProperty
    An array of property names to include when creating the new object.
    This can be useful, if your object comes from a different source and you want to include only specific properties.

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
        [string] $Title,

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
        # we have to exclude id, objId because to avoid these if somebody cloned a mapped object
        # and tries to create a new object with the same parameters
        $idoitCategoryHash = ConvertTo-IdoitObjectCategory -InputObject $InputObject -MappingName $MappingName -ExcludeProperty (@('id','ObjID') + $ExcludeProperty)
        if ($PSCmdlet.ShouldProcess("Creating new Idoit object of type '$($mapping.IdoitObjectType)'")) {
            $newobjId = New-IdoitObject -Name $Title -ObjectType $mapping.IdoitObjectType -Category $idoitCategoryHash
            if ($null -eq $newobjId) {
                throw "Failed to create a new Idoit object of type '$($mapping.IdoitObjectType)'."
            }
            Write-Output $newobjId
        } else {
            # return a pseudo objId
            [PSCustomObject]@{
                ObjId = [int]::MaxValue
            }
        }
    }

    end {

    }
}