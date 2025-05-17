BeforeAll {
    $script:dscModuleName = 'PSidoitNG'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}
exit
Describe ModuleStartup {
    Context 'Check script scope variables' {
        It 'Should have created the script scope variable IdoItParams' {
            InModuleScope -ModuleName $dscModuleName {
                $Script:IdoItParams | Should -Not -BeNullOrEmpty
            }
        }
    }
}

