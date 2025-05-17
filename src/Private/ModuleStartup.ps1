function ModuleStartup {
    <#
    .SYNOPSIS
        Initializes the module by setting up the script parameters.

    .DESCRIPTION
        This function is called when the module is loaded. It sets up the script parameters and initializes the module.

    .EXAMPLE
        ModuleStartup
        This will initialize the module and set up the script parameters.

    .NOTES
        The function will be inserted into the .psm1 as any other function.
        At the end of the file, the function will be called to initialize the module.
        So the code will be executed when the module is loaded.
    #>
    [CmdletBinding()]
    param()

    $Script:IdoItParams = @{}
    $Script:IdoItParams['Connection'] = @{
        Uri       = $null
        Username  = $null
        Password  = $null
        ApiKey    = $null
        SessionId = $null
    }
}
ModuleStartup