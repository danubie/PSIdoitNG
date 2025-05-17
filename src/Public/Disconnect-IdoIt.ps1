function Disconnect-IdoIt {
    <#
        .SYNOPSIS
            Disconnect-IdoIt logs out of the IdoIt API-Session.

        .DESCRIPTION
            Disconnect-IdoIt logs out of the IdoIt API-Session.

        .EXAMPLE
            PS> Disconnect-IdoIt
            This will disconnect from idoit

        .NOTES
    #>
    Try {
        Invoke-IdoIt -Method "idoit.logout" -Params @{}
        $Script:IdoItParams["Connection"].SessionId = $null
    }
    Catch {
        Throw
    }
}
