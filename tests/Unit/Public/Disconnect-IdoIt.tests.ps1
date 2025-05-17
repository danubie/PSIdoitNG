BeforeAll {
    $script:ModuleName = 'PSIdoitNG'

    if ($env:SAMPLER_LOCAL_TEST) {
        Import-Module (Join-Path -Path $PSScriptRoot -ChildPath "..\..\..\..\$($script:moduleName)\src\$($script:moduleName).psm1")
    } else {
        Import-Module -Name $script:moduleName
    }
}

AfterAll {
    Get-Module -Name $script:moduleName -All | Remove-Module -Force
}

Describe 'Disconnect-IdoIt' {
    BeforeEach {
        Mock -CommandName Invoke-IdoIt -ModuleName PSidoitNG -MockWith { $null }
        $global:IdoItParams = @{
            Connection = @{
                SessionId = 'TestSessionId'
            }
        }
    }

    Context 'When logout is successful' {
        It 'Should set SessionId to $null' {
            Disconnect-IdoIt
            InModuleScope -ModuleName PSidoitNG {
                $Script:IdoItParams["Connection"].SessionId | Should -BeNullOrEmpty
            }
        }
    }

    Context 'When no session was active' {
        It 'Should throw an exception' {
            InModuleScope -ModuleName PSidoitNG {
                $Script:IdoItParams["Connection"].SessionId = $null
            }
            { Disconnect-IdoIt } | Should -Not -Throw
        }
    }
}