function Start-IdoitApiTrace {
    <#
        .SYNOPSIS
            Start the Idoit API trace.
        .DESCRIPTION
            This function starts the Idoit API trace by initializing a global variable to store the trace data.
        .PARAMETER None
            No parameters are required for this function.
        .EXAMPLE
            Start-IdoitApiTrace
            # Starts the Idoit API trace and initializes the global variable.
        .NOTES
            Any data already in the $Global:IdoItAPITrace variable will be lost.
            This function is intended for use in testing scenarios to capture API calls.
    #>
    [CmdletBinding(SupportsShouldProcess = $True)]
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSAVoidGlobalVars', '', Justification = 'Global variable is used outside this scope.')]
    param ()
    # Suppress PSUseDeclaredVarsMoreThanAssignments for $Global:IdoItAPITrace
    # because it is intentionally assigned but not used in this scope.
    if ($PSCmdlet.ShouldProcess('IdoitApiTrace', 'Start')) {
        Write-Verbose -Message 'Starting Idoit API trace...'
        $Global:IdoItAPITrace = @()
    }
}