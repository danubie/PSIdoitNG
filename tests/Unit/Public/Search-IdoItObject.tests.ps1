BeforeAll {
    $script:ModuleName = 'PSIdoitNG'
    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
    Import-Module -Name $script:moduleName -Force

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:moduleName

    $testRoot = Join-Path -Path (Get-SamplerAbsolutePath) -ChildPath 'tests'
    $testHelpersPath = Join-Path -Path $testRoot -ChildPath 'Unit\Helpers'
    . $testHelpersPath/MockConnectIdoIt.ps1
    . $testHelpersPath/Mockdata_cmdb_condition_read.ps1
    . $testHelpersPath/Mockdata_idoit_search_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe 'Search-IdoitObject' {
    Context 'Search by conditions' {
        It 'Should find the object' {
            $ret = Search-IdoItObject -Conditions @(
                @{ "property" = "C__CATG__GLOBAL-title"; "comparison" = "like"; "value" = "*r540*" },
                @{ "property" = "C__CATG__GLOBAL-type"; "comparison" = "="; "value" = "5" }
            )
            $ret | Should -Not -BeNullOrEmpty
            $ret | ForEach-Object {
                $_.id | Should -Be 540
                $_.objId | Should -Be 540
                $_.TypeId | Should -Be 5
            }
            $ret.title | Should -Be 'server540'
        }
        It 'Should return empty list when no object found' {
            $ret = Search-IdoItObject -Conditions @(
                @{ "property" = "C__CATG__GLOBAL-title"; "comparison" = "like"; "value" = "*unknown*" },
                @{ "property" = "C__CATG__GLOBAL-type"; "comparison" = "="; "value" = "5" }
            )
            $ret | Should -BeNullOrEmpty
        }
    }
    Context 'Search by query' {
        It 'Should find the object' {
            $ret = Search-IdoItObject -Query '*540*'
            $ret | ForEach-Object {
                $_.documentId | Should -Be 540
                $_.value | Should -Match '540'
                $_.objId | Should -Be 540
                # remark: Query returns a different object type (Idoit.QuerySearchResult), e.g. does not contain TypeId
            }
        }
        It 'Should return empty list when no object found' {
            $ret = Search-IdoItObject -Query 'unknown'
            $ret | Should -BeNullOrEmpty
        }
    }
}