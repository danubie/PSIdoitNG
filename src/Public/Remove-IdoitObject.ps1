function Remove-IdoitObject {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ObjId')]
        [int] $Id,

        [ValidateSet('Archive', 'Delete','Purge','QuickPurge','')]
        [string] $Method = 'Archive'
    )

    begin {

    }

    process {
        $params = @{
            id = $Id
        }
        $apiEndpoint = 'cmdb.object.delete'
        switch ($Method) {
            'Archive' { $params.status = 'C__RECORD_STATUS__ARCHIVED' }
            'Delete'  { $params.status = 'C__RECORD_STATUS__DELETED' }
            'Purge'   { $params.status = 'C__RECORD_STATUS__PURGE' }
            'QuickPurge' { $apiEndpoint = 'cmdb.object.quick_purge' }
        }
        $apiResult = Invoke-IdoIt -Endpoint $apiEndpoint -Params $params
        Write-Output $apiResult
    }

    end {

    }
}