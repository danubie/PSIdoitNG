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
    . $testHelpersPath/MockData_Cmdb_object_read.ps1
    . $testHelpersPath/MockData_Cmdb_object_types_read.ps1
    . $testHelpersPath/MockData_cmdb_object_type_categories_read.ps1
    . $testHelpersPath/MockData_cmdb_category_read.ps1
    . $testHelpersPath/MockData_cmdb_category_info_read.ps1
    . $testHelpersPath/MockData_idoit_constants_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe 'Get-IdoItCategory' {
    Context 'When valid parameters are provided' {
        It 'Should return a valid category object' {
            $result = Get-IdoItCategory -ObjId 540 -Category 'C__CATG__GLOBAL'

            $result | Should -Not -BeNullOrEmpty
            $result[0].ObjId | Should -Be 540
            $result[0].title | Should -Be 'server540'
            $result[0].status.title | Should -Be 'Normal'
        }
    }

    Context 'When no status is provided' {
        It 'Should use the default status value of 2' {
            $result = Get-IdoItCategory -ObjId 540 -Category 'C__CATG__GLOBAL' -Status 2

            $result | Should -Not -BeNullOrEmpty
            $result[0].status.Id | Should -Be 2
        }
    }

    Context 'When the API returns no results' {
        BeforeEach {
            Mock -CommandName Invoke-Idoit -ModuleName PSIdoitNG -MockWith { @() }
        }

        It 'Should return an empty result set' {
            $result = Get-IdoItCategory -ObjId 540 -Category 'C__CATG__GLOBAL'

            $result | Should -BeNullOrEmpty
        }
    }
    Context 'Custom Category' {
        It 'Should use plain properties' {
            $category = Get-IdoitCategory -ObjId 4675 -Category C__CATG__CUSTOM_FIELDS_KOMPONENTE
            $category.objId | Should -Be 4675
            ($category | Get-Member -MemberType NoteProperty).Name | Should -Not -Contain 'Komponenten_Typ'
            $category.psid_custom | Should -BeNullOrEmpty
        }
        It 'Should convert to readable object properties' {
            $category = Get-IdoitCategory -ObjId 4675 -Category C__CATG__CUSTOM_FIELDS_KOMPONENTE -UseCustomTitle
            $category.objId | Should -Be 4675
            ($category | Get-Member -MemberType NoteProperty).Name | Should -Contain 'Komponenten_Typ'
            $category.Komponenten_Typ | Should -Be @('Job / Schnittstelle')
            $category.Technologie | Should -Be @('SQL Server','Biztalk')
            $category.psid_custom.Komponenten_Typ | Should -Be 'f_popup_c_17289168067044910'
        }
    }
}