<#
    This can be included in every test script to mock a successful connection to the IdoIt API.
#>
# in case Connect is not called in the test script, the session id is set to a test value
InModuleScope $Script:moduleName {
    $script:IdoItParams["Connection"].Uri = 'https://test.uri'
    $script:IdoItParams["Connection"].ApiKey = 'TestApiKey'
    $script:IdoItParams["Connection"].Username = 'TestUser'
    $script:IdoItParams["Connection"].Password = ConvertTo-SecureString 'TestPassword' -AsPlainText -Force
    $script:IdoItParams["Connection"].ClientName = 'TestClientName'
    $script:IdoItParams["Connection"].ClientId = 1
    $script:IdoItParams["Connection"].SessionId = 'TestSessionId'
}
Mock 'Connect-IdoIt' -ModuleName $Script:moduleName -MockWith {
    Write-Host "Connect-IdoIt called with $($args | Out-String)"
    return $true
}