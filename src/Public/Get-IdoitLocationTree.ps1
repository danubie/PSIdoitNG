function Get-IdoitLocationTree {
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