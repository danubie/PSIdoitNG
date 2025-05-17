Function Get-IdoItVersion {
    <#
        .SYNOPSIS
            Get the version of the Idoit instance
        .DESCRIPTION
            This function retrieves the version of the Idoit instance. Since some version of the API, it does return a integer value and not a version string.
        .EXAMPLE
            Get-IdoItVersion
            This will retrieve the version of the Idoit instance.
        .NOTES
    #>
    $result = Invoke-IdoIt -Method "idoit.version" -Params @{}
    return $result | Select-Object version, type, step
}