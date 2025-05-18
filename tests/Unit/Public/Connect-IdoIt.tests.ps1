BeforeAll {
    $script:ModuleName = 'PSIdoitNG'
    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
    Import-Module -Name $script:moduleName -Force

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:moduleName

    $testRoot = Join-Path -Path (Get-SamplerAbsolutePath) -ChildPath 'tests'
    $testHelpersPath = Join-Path -Path $testRoot -ChildPath 'Unit\Helpers'
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe 'Invoke-IdoIt' {
    BeforeAll {
        function CheckAPICall {
            param ($simRestMethod, $body)

            $request = $body | ConvertFrom-Json
            $requestParams = $request.params
            $requestParams | Get-Member -MemberType NoteProperty | ForEach-Object {
                $property = $_.Name
                if ($property -ne 'apikey') {
                    $request.params.$property | Should -Be $requestParams.$property
                }
            }
            # create response from the simulated response (with the same id as the request)
            # I use replace here, because otherwise I would have to escape the {0} in the json string
            $simRestMethod.Response.Id = $request.id
            return $simRestMethod.Response
        }
        Mock 'Get-IdoItVersion' -ModuleName PSidoitNG -MockWith {
            Write-Output [PSCustomObject] @{
                login   = [PSCustomObject]@{
                    language = 'en';
                    mail     = '';
                    name     = 'myAPI';
                    tenant   = 'MyTenant';
                    userid   = '39296';
                    username = 'myAPIUser'
                };
                version = '33'
            }
        }
    }
    Context 'Sucessful login' {
        BeforeDiscovery {
            $uri = 'https://test.uri'
            $username = 'TestUser'
            $password = ConvertTo-SecureString 'TestPassword' -AsPlainText -Force
            $apikey = 'TestApiKey'
        }
        BeforeAll {
            $uri = 'https://test.uri'
            $username = 'TestUser'
            $password = ConvertTo-SecureString 'TestPassword' -AsPlainText -Force
            $apikey = 'TestApiKey'

            $simRestMethod = [PSCustomObject] @{
                Endpoint = 'idoit.login';
                Request  = [PSCustomObject] @{
                    method = 'idoit.login';
                    id = '1bc59703-f8d9-4013-ae66-e98102425f67';
                    version = '2.0';
                    params = @{
                        apikey = '***'
                    }
                };
                Response = [PSCustomObject]@{
                    id      = '{0}';
                    jsonrpc = '2.0';
                    result  = [PSCustomObject] @{
                        result   = 'True';
                        userid   = '39296';
                        name     = 'APIUser';
                        username = 'MyAPIUser';
                        session  = '60msp1o72ah2ti26sk4o870mp9';
                        'client-id' = 1;
                        'client-name' = 'MyClient';
                    }
                };
                Time     = '2025-05-12 17:13:36'
            }
            Mock -CommandName Invoke-RestMethod -ModuleName PSidoitNG -MockWith {
                # check request values: All properties in the simulated request param (except apikey) should be in the request
                # returns the simulated response with the same id as the request
                CheckAPICall -simRestMethod $simRestMethod -body $body
            } -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq $simRestMethod.Endpoint
            }

            Mock -CommandName Invoke-RestMethod -ModuleName PSidoitNG -MockWith {
                Throw "Mock endpoint error $(($body | ConvertFrom-Json).method)"
            }   # default mock

            $Global:IdoitApiTrace = @()
        }
        AfterAll {
            Remove-Variable -Name IdoitApiTrace -Scope global -ErrorAction Ignore
        }
        BeforeEach {
            $Global:IdoitApiTrace = @()
        }
        It 'Login sucessful' {
            $ret = Connect-IdoIt -Uri $uri -Username $username -Password $password -ApiKey $apikey
            $ret.Account | Should -Be 'APIUser'
            $ret.ClientName | Should -Be 'MyClient'
            $ret.ClientId | Should -Be 1

            $Global:IdoitApiTrace[-1].Endpoint | Should -Be 'idoit.login'
            $Global:IdoitApiTrace[-1].Request.method | Should -Be 'idoit.login'
            $Global:IdoitApiTrace[-1].Request.params.apikey | Should -Be $apikey
        }
        It 'Login sucessful <case>' -ForEach @(
            @{ Case = 'UserPasswordApiKey'; splat = @{ Uri = $uri; Username = $username; Password = $password; ApiKey = $apikey } }
            @{ Case = 'Credential'; splat = @{ Uri = $uri; Credential = [PSCredential]::new($username, $password); ApiKey = $apikey } }
        ) {
            $ret = Connect-IdoIt -Uri $uri -Username $username -Password $password -ApiKey $apikey
            $ret.Account | Should -Be 'APIUser'
            $ret.ClientName | Should -Be 'MyClient'
            $ret.ClientId | Should -Be 1

            $Global:IdoitApiTrace[-1].Endpoint | Should -Be 'idoit.login'
            $Global:IdoitApiTrace[-1].Request.method | Should -Be 'idoit.login'
            $Global:IdoitApiTrace[-1].Request.params.apikey | Should -Be $apikey
        }
    }
    Context 'Unsuccessful login' {
        It 'login fails' {
            $simRestMethod = [PSCustomObject] @{
                Endpoint = 'idoit.login';
                Request  = [PSCustomObject] @{ method = 'idoit.login'; id = '24afe7bc-1817-4ef5-9801-a94049971568'; version = '2.0'; params = [PSCustomObject] @{
                        apikey = '****'
                    }
                };
                Response = [PSCustomObject]@{
                    error   = [PSCustomObject] @{
                        code    = -32604;
                        message = 'Authentication error: Unable to login using given credentials and apiKey.'
                    };
                    id      = '24afe7bc-1817-4ef5-9801-a94049971568';
                    jsonrpc = '2.0'
                };
                Time     = '2025-05-12 17:43:15'
            }
            Mock -CommandName Invoke-RestMethod -ModuleName PSidoitNG -MockWith {
                # check request values: All properties in the simulated request param (except apikey) should be in the request
                # returns the simulated response with the same id as the request
                CheckAPICall -simRestMethod $simRestMethod -body $body
            } -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq $simRestMethod.Endpoint
            }

            Mock -CommandName Invoke-RestMethod -ModuleName PSidoitNG -MockWith {
                Throw "Mock endpoint error $(($body | ConvertFrom-Json).method)"
            }   # default mock

            { Connect-IdoIt -Uri 'something' -Username 'user' -Password (ConvertTo-SecureString -String 'PW' -AsPlainText -Force) -ApiKey 'apikey' } | Should -Throw '*Error -32604 -  - Authentication error*'
        }
    }
}