function Get-IdoitDialog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $params = @{} # parameters for the dialog, e.g. @{ category='C__CATG__CPU'; property='manufacturer' }
    )

    begin {

    }

    process {
        $apiResult = Invoke-IdoIt -Endpoint 'cmdb.dialog' -Params $params
        foreach ($location in $apiResult) {
            $location | Add-Member -MemberType NoteProperty -Name 'ParentId' -Value $Id -Force -PassThru
        }
    }

    end {

    }
}