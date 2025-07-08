function Get-IdoitObjectByRelation {
    <#
    .SYNOPSIS
    Get objects related to a given object.

    .DESCRIPTION
    This function retrieves objects that are related to a specified object ID.

    .PARAMETER ObjId
    The ID of the object for which related objects are to be retrieved.

    .PARAMETER RelationType
    Specifies the type of relation to filter the results. This can be a numeric ID or a string representing the relation category type.

    .PARAMETER AsArray
    If specified, the function returns the results as an array of relation objects instead of a PSCustomObject.

    .EXAMPLE
    Get-IdoitObjectByRelation -ObjId 540
    Retrieves all objects related to the object with ID 540.

    .EXAMPLE
    Get-IdoitObjectByRelation -ObjId 540 -RelationType 1
    Retrieves all objects related to the object with ID 540 and relation type 1.

    .EXAMPLE
    Get-IdoitObjectByRelation -ObjId 540 -AsArray
    Retrieves all objects related to the object with ID 540 and returns them as an array of
    relation objects.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ObjId,

        [Alias('RelationCategoryType')]
        [string[]] $RelationType,

        [switch] $AsArray
    )

    process {
        $params = @{
            id = $ObjId
        }
        if ($PSBoundParameters.ContainsKey('RelationType')) {
            foreach ($relType in $RelationType) {
                $params.relation_type = $relType
                $result = Invoke-Idoit -Method 'cmdb.objects_by_relation' -Params $params
            }
        } else {
            $result = Invoke-Idoit -Method 'cmdb.objects_by_relation' -Params $params
        }
        if ($AsArray) {           # returns above response body to an array of relation objects
            ($result | Convert-PropertyToArray).foreach({
                $_.value.data | Add-Member -MemberType NoteProperty -Name 'TypeId' -Value $_.value.data.type -PassThru
            })
        } else {
            $result
        }
    }

    end {

    }
}