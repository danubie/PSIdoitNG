BeforeAll {
    $script:ModuleName = 'PSIdoitNG'
    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
    Import-Module -Name $script:moduleName -Force

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:moduleName

    $testRoot = Join-Path -Path (Get-SamplerAbsolutePath) -ChildPath 'tests'
    $testHelpersPath = Join-Path -Path $testRoot -ChildPath 'Unit\Helpers'
    foreach ($file in (Get-ChildItem -Path $testHelpersPath -Filter 'Mock*.ps1')) {
        . $file.FullName
    }
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}
Describe 'Get-IdoitObjectTree' {
    It 'Should return an object including all non-empty categories' {
        $return = Get-IdoitObjectTree -ObjId 37
        $return.Id | Should -Be 37
        $return.Categories | Should -Not -BeNullOrEmpty
        $return.Categories | Where-Object { $_.Category -eq 'C__CATG__LOGBOOK' } | Should -BeNullOrEmpty -Because 'Logbook is excluded by default'
        $return.Categories | Where-Object { $_.Category -eq 'C__CATS__PERSON' } | Should -Not -BeNullOrEmpty -Because 'Obj 37 has a mocked person category'
        $return.Categories | Where-Object { $_.Category -eq 'C__CATG__OVERVIEW' } | Should -BeNullOrEmpty -Because 'Obj 37 has no mock for overview category'
    }
}