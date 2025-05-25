function Get-IdoitLocationTree {
    <#
    .SYNOPSIS
        Get the next location tree from i-doit

    .DESCRIPTION
        This function retrieves the location tree from i-doit.
        The root location is returned if no Id is specified.

    .PARAMETER Id
        The Id of the location to retrieve the tree from.
        If 0 is specified, the root location is returned.

    .EXAMPLE
        Get-IdoitLocationTree -Id 0
        Retrieves the root location.

    .EXAMPLE
        Get-IdoitLocationTree -Id 1
        Retrieves the location tree starting from the location with Id 1 (root).


    >#>
    [CmdletBinding()]
    param (
        [int] $Id       # 0 returns the root location
    )

    begin {

    }

    process {
        $apiResult = Invoke-IdoIt -Endpoint 'cmdb.location_tree' -Params @{ id = $Id }
        foreach ($location in $apiResult) {
            $location.PSObject.TypeNames.Insert(0, 'PSIdoitNG.Location')
            $location | Add-Member -MemberType NoteProperty -Name 'ParentId' -Value $Id -Force -PassThru
        }
    }

    end {

    }
}