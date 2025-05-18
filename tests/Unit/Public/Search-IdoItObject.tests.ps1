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
    . $testHelpersPath/Mockdata_cmbd_condition_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe 'Search-IdoitObject' {
    It 'Should find the object' {
        $ret = Search-IdoItObject -Conditions @(
            @{ "property" = "C__CATG__GLOBAL-title"; "comparison" = "like"; "value" = "*r540*" },
            @{ "property" = "C__CATG__GLOBAL-type"; "comparison" = "="; "value" = "5" }
        )
        $ret | Should -Not -BeNullOrEmpty
        $ret.id | Should -Be 540
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