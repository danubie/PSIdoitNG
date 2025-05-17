Mock -CommandName Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    Throw "Mock endpoint error $(($body | ConvertFrom-Json).method); $([PSCustomObject]$body)"
}   # default mock
