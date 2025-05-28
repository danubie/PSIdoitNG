function Connect-IdoIt {
    <#
    .SYNOPSIS
        Connect-to Idoit API.
    .DESCRIPTION
        Connect-to Idoit API. This function is used to connect to the Idoit API and authenticate the user.
    .PARAMETER Uri
        The Uri to the idoit JSON-RPC API. should be like http[s]://your.i-doit.host/src/jsonrpc.php
    .PARAMETER Credential
        User with appropiate permissions to access the cmdb.
    .PARAMETER Username
        The username to connect to the Idoit API.
    .PARAMETER Password
        The password to connect to the Idoit API.
        The password is passed as a SecureString.
    .PARAMETER ApiKey
        This is the apikey you define in idoit unter Settings-> Interface-> JSON-RPC API to access the api
    .EXAMPLE
    PS> Connect-IdoIt -Uri 'https://test.uri' -Credential $credential -ApiKey 'TestApiKey'
    This will connect to the Idoit API using the provided Uri and Credential. The result of the login will be returned.
    .EXAMPLE
        PS> Connect-IdoIt -Uri 'https://test.uri' -Username 'TestUser' -Password (ConvertTo-SecureString 'TestPassword' -AsPlainText -Force) -ApiKey 'TestApiKey'
        This will connect to the Idoit API using the provided Uri, Username, Password and ApiKey. The result of the login will be returned.
    .NOTES
#>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidGlobalVars", "")]
    [Cmdletbinding()]
    Param(
        [Parameter(Mandatory = $True, ParameterSetName = "PSCredential")]
        [Parameter(Mandatory = $True, ParameterSetName = "UserPasswordApiKey")]
        [String] $Uri,

        [Parameter(Mandatory = $true, ParameterSetName = "PSCredential")]
        [System.Management.Automation.PSCredential] $Credential,

        [Parameter(Mandatory = $True, ParameterSetName = "UserPasswordApiKey")]
        [String] $Username,

        [Parameter(Mandatory = $True, ParameterSetName = "UserPasswordApiKey")]
        [SecureString] $Password,

        [Parameter(Mandatory = $True, ParameterSetName = "PSCredential")]
        [Parameter(Mandatory = $True, ParameterSetName = "UserPasswordApiKey")]
        [String] $ApiKey
    )
    If ($PSBoundParameters['Debug']) {
        $DebugPreference = 'Continue'
    }

    switch ($PSCmdlet.ParameterSetName) {
        "UserPasswordApiKey" {
            $Script:IdoItParams["Connection"] = @{
                Uri = $Uri
                Username = $Username
                Password = $Password
                ApiKey = $ApiKey
            }
        }
        "PSCredential" {
            $Script:IdoItParams["Connection"] = @{
                Uri = $Uri
                Username = $Credential.UserName
                Password = $Credential.GetNetworkCredential().Password
                ApiKey = $ApiKey
            }
        }
        Default {
            Throw " Invalid parameter set $($PSCmdlet.ParameterSetName) specified."
        }
    }

    $Headers = @{
        "Content-Type" = "application/json"
        "X-RPC-Auth-Username" = $Script:IdoItParams["Connection"].Username
        "X-RPC-Auth-Password" = $Script:IdoItParams["Connection"].Password
    }

    $splatInvoke = @{
        Uri = $Script:IdoItParams["Connection"].Uri
        Headers = $Headers
        Method = "idoit.login"
        Params = @{}
    }
    $resultObj = Invoke-IdoIt @splatInvoke -ErrorAction Stop

    $result = [pscustomobject]@{
        Account     = $resultObj.name
        ClientName  = $resultObj.'client-name'
        ClientId    = $resultObj.'client-id'
    }
    $Script:IdoItParams["Connection"].SessionId = $resultObj.'session-id'

    # According to the i-doit API docs, this should return a version string.
    # As of version 33 is used in our environment, tt seems to be an integer. So we need to convert it to a string.
    $versionString = (Get-IdoItVersion).Version
    Try {       # ugly way to check whether the [string] is an integer
        if ("$versionString" -match '^\d+$') {
            $versionString = [Version]::new($versionString, 0)
        }
        $null = [Version]$versionString
    }

    Catch {
        Throw "IdoIt version is not a valid version string: $versionString"
    }
    $result
}
