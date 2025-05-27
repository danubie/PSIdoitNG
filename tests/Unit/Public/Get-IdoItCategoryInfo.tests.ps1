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
    . $testHelpersPath/MockData_cmdb_category_info_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}

AfterAll {
    Get-Module -Name $script:moduleName -All | Remove-Module -Force
}

Describe 'Get-IdoitCategoryInfo' {
    Context 'When valid parameters are provided' {
        It 'Should return a valid category object' {
            $result =  Get-IdoitCategoryInfo -Category C__CATG__GLOBAL

            $result | Should -Not -BeNullOrEmpty
            $result[0].id.title | Should -Be 'ID'
            $result[0].title.title | Should -Be 'Title'
            $result[0].status.title | Should -Be 'Condition'        # whatever that means
        }
    }
    Context 'When invalid parameters are provided' {
        It 'Should throw an error when no category is found' {
            { Get-IdoitCategoryInfo -Category 'InvalidCategory' } | Should -Throw "*Category*not found*"
        }
    }
}