function Remove-IdoitObject {
    <#
    .SYNOPSIS
    Removes an IdoIT object.

    .DESCRIPTION
    This function removes an IdoIT object by its ID and specified method.
    The used method must correspond to the objects current state (see I-doit documentation).

    .PARAMETER ObjId
    The ID of the object to be removed.

    .PARAMETER Method
    The method to use for removing the object. Valid values are 'Archive', 'Delete', 'Purge'.
    Default is 'Archive'.

    .EXAMPLE
    Remove-IdoitObject -ObjId 12345 -Method 'Archive'
    This command will archive the object with ID 12345.

    .EXAMPLE
    Remove-IdoitObject -ObjId 12345 -Method 'Purge'.
    This command will purge the object with ID 12345.
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        # [Alias('Id')]
        [int] $ObjId,

        [ValidateSet('Archive', 'Delete','Purge','')]
        [string] $Method = 'Archive'
    )

    begin {

    }

    process {
        if (-not $PSCmdlet.ShouldProcess("Idoit Object with ID $ObjId", "Remove using method $Method")) {
            Write-Output [PSCustomObject]@{ Success = $true; Message = "Operation dummy true due to -Whatif." }
            return
        }
        $params = @{
            id = $ObjId
        }
        $apiEndpoint = 'cmdb.object.delete'
        switch ($Method) {
            'Archive' { $params.status = 'C__RECORD_STATUS__ARCHIVED' }
            'Delete'  { $params.status = 'C__RECORD_STATUS__DELETED' }
            'Purge'   { $params.status = 'C__RECORD_STATUS__PURGE' }
        }
        $apiResult = Invoke-IdoIt -Endpoint $apiEndpoint -Params $params
        Write-Output $apiResult
    }

    end {

    }
}