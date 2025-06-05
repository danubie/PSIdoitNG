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

Describe "Register-IdoitCategoryMap" {

    Context "When path does not exist" {
        It "Throws an error" {
            { Register-IdoitCategoryMap -Path 'Z:\notfound.yaml' } | Should -Throw
        }
    }

    Context "When path is a directory" {
            BeforeEach {
        # Reset the script variable before each test
        Remove-Variable -Name IdoitCategoryMaps -Scope Script -ErrorAction SilentlyContinue
    }
        It "Loads all .yaml files in directory" {
            $Path = $testHelpersPath            # Path to the test helpers directory
            Register-IdoitCategoryMap -Path $Path
            InModuleScope -ModuleName $script:moduleName {
                $Script:IdoitCategoryMaps.Keys | Should -Contain "PersonMapped"
                $Script:IdoitCategoryMaps.Keys | Should -Contain "ServerMapped"
                $Script:IdoitCategoryMaps.Keys | Should -Contain "DemoComponent"
            }
        }
    }

    Context "When path is a file" {
        BeforeEach {
            # Reset the script variable before each test
            Remove-Variable -Name IdoitCategoryMaps -Scope Script -ErrorAction SilentlyContinue
        }
        It "Loads mapping from file" {
            $Path = Join-Path -Path $testHelpersPath -ChildPath 'SampleMapping.yaml'
            Register-IdoitCategoryMap -Path $Path
            InModuleScope -ModuleName $script:moduleName {
                $Script:IdoitCategoryMaps.Keys | Should -Contain "PersonMapped"
                $Script:IdoitCategoryMaps.Keys | Should -Contain "ServerMapped"
            }
        }
    }

    Context "When duplicate key exists" {
        BeforeEach {
            # Reset the script variable before each test
            Remove-Variable -Name IdoitCategoryMaps -Scope Script -ErrorAction SilentlyContinue
        }
        It "Warns and does not overwrite without -Force" {
            $Path = Join-Path -Path $testHelpersPath -ChildPath 'SampleMapping.yaml'
            Register-IdoitCategoryMap -Path $Path
            InModuleScope -ModuleName $script:moduleName {
                $Script:IdoitCategoryMaps.Keys | Should -Contain "PersonMapped"
                $Script:IdoitCategoryMaps["PersonMapped"] | Add-Member -Name TestValue -MemberType NoteProperty -Value 1
            }
            $null = Register-IdoitCategoryMap -Path $Path -WarningAction SilentlyContinue -WarningVariable warn
            InModuleScope -ModuleName $script:moduleName {
                $Script:IdoitCategoryMaps.Keys | Should -Contain "PersonMapped"
                $Script:IdoitCategoryMaps["PersonMapped"].TestValue | Should -Be 1
            }
            $warn | Should -Match "already exists"
        }
        It "Overwrites with -Force" {
            $Path = Join-Path -Path $testHelpersPath -ChildPath 'SampleMapping.yaml'
            Register-IdoitCategoryMap -Path $Path
            # Simulate change by adding a property
            InModuleScope -ModuleName $script:moduleName {
                $Script:IdoitCategoryMaps["PersonMapped"] | Add-Member -Name TestValue -MemberType NoteProperty -Value 1
            }
            Register-IdoitCategoryMap -Path $Path -Force
            InModuleScope -ModuleName $script:moduleName {
                $Script:IdoitCategoryMaps.Keys | Should -Contain "PersonMapped"
                $Script:IdoitCategoryMaps.Keys | Should -Not -Contain "TestValue"
            }
        }
    }
}
