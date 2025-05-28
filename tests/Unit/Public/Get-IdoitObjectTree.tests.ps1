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
    It 'Should return an object including categories' -Skip {
        $return = Get-IdoitObjectTree -Id 37
        ($return | Measure-Object).Count | Should -Be 1
        $return.PSObject.TypeNames | Should -Contain 'Idoit.ObjectTree'
        $return.Id | Should -Be 37
        $return.Categories | Should -Not -BeNullOrEmpty
    }
}