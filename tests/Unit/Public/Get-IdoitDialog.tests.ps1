BeforeAll {
    $script:ModuleName = 'PSIdoitNG'
    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
    Import-Module -Name $script:moduleName -Force

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:moduleName

    $testRoot = Join-Path -Path (Get-SamplerAbsolutePath) -ChildPath 'tests'
    $testHelpersPath = Join-Path -Path $testRoot -ChildPath 'Unit/Helpers'
    . $testHelpersPath/MockConnectIdoIt.ps1
    . $testHelpersPath/Mockdata_cmdb_dialog.ps1
    . $testHelpersPath/MockData_Cmdb_object_read.ps1
    . $testHelpersPath/MockData_Cmdb_object_read.ps1
    . $testHelpersPath/MockData_Cmdb_object_types_read.ps1
    . $testHelpersPath/MockData_cmdb_object_type_categories_read.ps1
    . $testHelpersPath/MockData_cmdb_category_read.ps1
    . $testHelpersPath/MockData_idoit_constants_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')
    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe "Get-IdoitDialog" {
    It "Should return 2 objects" {
        $result = Get-IdoitDialog -Params @{ category='C__CATG__CPU'; property='manufacturer' }
        $result | Should -HaveCount 4
        $result[1].Id | Should -Be 2
        $result[1].const | Should -Be ''
        $result[1].Title | Should -Be 'Intel'
    }
    It "Should return 2 objects called by parameters" {
        $result = Get-IdoitDialog -Category 'C__CATG__CPU' -Property 'manufacturer'
        $result | Should -HaveCount 4
        $result[1].Id | Should -Be 2
        $result[1].const | Should -Be ''
        $result[1].Title | Should -Be 'Intel'
    }
}
