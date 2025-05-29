Function Invoke-IdoIt {
    <#
    .SYNOPSIS
    Invoke-IdoIt API request to the i-doit RPC Endpoint

    .DESCRIPTION
    This function is calling the IdoIt API.
    The result is returned as a PSObject.

    .PARAMETER Endpoint
    This parameter the method yout want to call at the RPC Endpoint (see https://kb.i-doit.com/de/i-doit-add-ons/api/index.html).
    From my personal point of view, at the time of writing the documentation is not very good.

    .PARAMETER Params
    Hashtable creating request body with the methods parameters (https://kb.i-doit.com/de/i-doit-add-ons/api/index.html).
    The following additional parameters are inserted into the request body: ApiKey, Request id, Version

    .PARAMETER Headers
    Optional parameter if default headers should be overwritten (e.g. when logging into a new session).

    .PARAMETER Uri
        The Uri if the API Endpoint.

    .PARAMETER Version
        The version of the API. Default is 2.0

    .PARAMETER ApiKey
        The API key to be used. Default is the one used in Connect.

    .EXAMPLE
        $result = -Method "idoit.logout" -Params @{}

    .NOTES
    To trace the API calls, set the global variable $Global:IdoitApiTrace to @().
    For every API call, a new entry is added to the array.
    The entry contains the following properties:
        Endpoint: The endpoint called
        Request: The request body
        Response: The response body (if response was successful)
        Time: The time of the call
        Exception: The exception thrown (if any)
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidGlobalVars", "")]
    [CmdletBinding()]
    Param (
        [Parameter( Mandatory = $True )]
        [ValidateNotNullOrEmpty()]
        [Alias('Method')]
        [String] $Endpoint,

        [ValidateNotNull()]
        [Hashtable] $Params = @{},

        [Hashtable] $Headers = @{"Content-Type" = "application/json"; "X-RPC-Auth-Session" = $Script:IdoItParams["Connection"].SessionId},

        [String] $Uri = $Script:IdoItParams["Connection"].Uri,

        [string] $Version = "2.0",

        [string] $ApiKey = $Script:IdoItParams["Connection"].ApiKey
    )

    $Params['apikey'] = $ApiKey
    $body = @{
        "method" = $Endpoint
        "version" = $Version
        "id" = [Guid]::NewGuid()
        "params" = $Params
    }
    $bodyJson = ConvertTo-Json -InputObject $body -Depth 4

    Try {
        $apiResult = Invoke-RestMethod -Uri $Uri -Method Post -Body $bodyJson -Headers $Headers
        # remove quotes from integer values
        $apiResult = ($apiResult | ConvertTo-Json -Depth 10) -replace '(?m)"([0-9]+)"','$1' | ConvertFrom-Json
        if ($null -ne $Global:IdoitApiTrace) {
            $Global:IdoitApiTrace += [PSCustomObject]@{
                Endpoint = $Endpoint
                Request = [PSCustomObject]$body
                Response = $apiResult
                Time = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            }
        }
    }
    Catch {
        if ($null -ne $Global:IdoitApiTrace) {
            $Global:IdoitApiTrace += [PSCustomObject]@{
                Endpoint = $Endpoint
                Request = [PSCustomObject]$body
                Exception = $_
                Time = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            }
        }
        if ($_.CategoryInfo.Reason -eq 'UriFormatException') {
            # check if the login was missing
            if ([string]::IsNullOrEmpty($Script:IdoItParams["Connection"].SessionId)) {
                Write-Error -Message "No valid session found. Please check your API connection." -ErrorAction Stop
            }
        }
        Throw $_
    }

    If ($apiResult.PSObject.Properties.Name -Contains 'Error') {
        $errMsg = "Error $($apiResult.Error.Code) - $($apiResult.error.data.Description) - $($apiResult.error.message)"
        Write-Error $errMsg
    } else {
        If ( $body.Id -ne $apiResult.id) {
            Throw "Request id mismatch. Expected value was $RequestID but it is $($apiResult.id)"
        }
        if ($apiResult.result.PSObject.Properties.Name -Contains 'Success') {           # cast success to boolean
            $apiResult.result.success = $apiResult.result.success -eq 'True'
        }
        $apiResult.result
    }
}