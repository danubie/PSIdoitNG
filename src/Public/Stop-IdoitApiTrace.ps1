function Stop-IdoitApiTrace {
    <#
        .SYNOPSIS
            Stop the Idoit API trace.
        .DESCRIPTION
            This function stops the Idoit API trace by removing the global variable that stores the trace data.
        .PARAMETER None
            No parameters are required for this function.
        .EXAMPLE
            Stop-IdoitApiTrace
            # Stops the Idoit API trace and removes the global variable.
        .NOTES
            This function is intended for use in testing scenarios to stop capturing API calls.
    #>
    [CmdletBinding()]
    param ()
    if ($PSCmdlet.ShouldProcess('IdoitApiTrace', 'Stop')) {
        Write-Verbose -Message 'Stopping Idoit API trace...'
        Remove-Variable -Name 'IdoitApiTrace' -Scope Global -ErrorAction SilentlyContinue
    }
}