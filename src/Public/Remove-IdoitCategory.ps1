function Remove-IdoitCategory {
    <#
    .SYNOPSIS
    Remove an i-doit object category entry.

    .DESCRIPTION
    This function removes an entry from a category of an object. Currently the API only supports removal of entries of multi-value categories.

    .PARAMETER ObjId
    The ID of the i-doit object.

    .PARAMETER Category
    The category of the i-doit object from which the entry should be removed.

    .PARAMETER EntryId
    The ID of the entry to be removed from the category.

    .EXAMPLE
    Remove-IdoitCategory -ObjId 12345 -Category 'C__CATG__MEMORY' -EntryId 12
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        # [Alias('Id')]
        [int] $ObjId,

        [Parameter(Mandatory = $true)]
        [string] $Category,

        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $EntryId
    )

    begin {

    }

    process {
        if (-not $PSCmdlet.ShouldProcess("Idoit Object with ID $Id in category '$Category'", "Remove")) {
            Write-Verbose "Skipping removal of object with ID $Id in category '$Category' due to ShouldProcess."
            return
        }
        $params = @{
            objID = $ObjId
            category = $Category
            id = $EntryId           # I hate this API
        }
        $apiEndpoint = 'cmdb.category.delete'
        $apiResult = Invoke-IdoIt -Endpoint $apiEndpoint -Params $params
        Write-Output $apiResult
    }

    end {

    }
}