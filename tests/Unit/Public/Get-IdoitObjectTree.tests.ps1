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
    Context 'Categories as array' {
        It 'Should return an object including all non-empty categories' {
            $return = Get-IdoitObjectTree -ObjId 37
            $return.Id | Should -Be 37
            $return.Categories | Should -Not -BeNullOrEmpty
            $return.Categories | Where-Object { $_.Category -eq 'C__CATG__LOGBOOK' } | Should -BeNullOrEmpty -Because 'Logbook is excluded by default'
            $return.Categories | Where-Object { $_.Category -eq 'C__CATG__OVERVIEW' } | Should -BeNullOrEmpty -Because 'Obj 37 has no mock for overview category'
            $return.Categories | Where-Object { $_.Category -eq 'C__CATS__PERSON' } | Should -Not -BeNullOrEmpty -Because 'Obj 37 has a mocked person category'
            $return.Categories.Count |  Should -Be 1
        }
        It 'Should return categories for server540' {
            $return = Get-IdoitObjectTree -ObjId 540
            $return.Id | Should -Be 540
            $return.Categories.Count | Should -Be 2
            $return.Categories | Where-Object { $_.Category -eq 'C__CATG__GLOBAL' } | Should -Not -BeNullOrEmpty
            $return.Categories | Where-Object { $_.Category -eq 'C__CATG__MEMORY' } | Should -Not -BeNullOrEmpty
        }
        It 'Should return an object excluding memory category' {
            $return = Get-IdoitObjectTree -ObjId 540 -ExcludeCategory 'C__CATG__MEMORY'
            $return.Id | Should -Be 540
            $return.Categories.Count | Should -Be 1
            $return.Categories | Where-Object { $_.Category -eq 'C__CATG__GLOBAL' } | Should -Not -BeNullOrEmpty
            $return.Categories | Where-Object { $_.Category -eq 'C__CATG__MEMORY' } | Should -BeNullOrEmpty
        }
    }
    Context 'Categories as properties' {
        It 'Should return an object with categories as properties' {
            $return = Get-IdoitObjectTree -ObjId 540 -CategoriesAsProperties
            $return.Id | Should -Be 540
            $return.Categories | Should -Not -BeNullOrEmpty
            $return.Categories.'C__CATG__GLOBAL' | Should -Not -BeNullOrEmpty
            $return.Categories.'C__CATG__MEMORY' | Should -Not -BeNullOrEmpty
        }
        It 'Should return an object excluding memory category' {
            $return = Get-IdoitObjectTree -ObjId 540 -CategoriesAsProperties -ExcludeCategory 'C__CATG__MEMORY'
            $return.Id | Should -Be 540
            $return.Categories | Should -Not -BeNullOrEmpty
            $return.Categories.'C__CATG__GLOBAL' | Should -Not -BeNullOrEmpty
            $return.Categories.'C__CATG__MEMORY' | Should -BeNullOrEmpty
        }
    }
}