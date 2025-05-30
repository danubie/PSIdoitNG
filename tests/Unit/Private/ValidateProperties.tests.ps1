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

Describe "ValidateProperties" {
    It "Should return the same properties if all are valid" {
        $result = InModuleScope  -ModuleName $script:ModuleName -ScriptBlock {
            $properties = @{
                'f_popup_c_17289168067044910' = 'Job / Schnittstelle'       # custom field; select one from a list
                'f_popup_c_17289128195752470' = @('SQL Server','Biztalk')   # custom field; multiselect
            }
            ValidateProperties -Category 'C__CATG__CUSTOM_FIELDS_KOMPONENTE' -Properties $properties
        }
        $result | Should -BeOfType [Hashtable]
        $result.'f_popup_c_17289168067044910' | Should -Be 'Job / Schnittstelle'
    }
    It 'Should remove invalid properties and issue a warning' {
        $result = InModuleScope  -ModuleName $script:ModuleName -ScriptBlock {
            $properties = @{
                f_popup_c_17289168067044910 = 'Job / Schnittstelle'       # custom field; select one from a list
                f_popup_c_17289128195752470 = 'something invalid'        # custom field; multiselect
            }
            $commonParameters = @{
                WarningAction = 'SilentlyContinue'  # suppress warnings
                WarningVariable = 'warn'
                ErrorAction = 'SilentlyContinue'                 # stop on error
                ErrorVariable = 'err'
            }
            ValidateProperties -Category 'C__CATG__CUSTOM_FIELDS_KOMPONENTE' -Properties $properties @commonParameters
            $warn | Should -Not -BeNullOrEmpty
            $err | Should -Not -BeNullOrEmpty
        }
        $result | Should -BeOfType [Hashtable]
        $result.'f_popup_c_17289168067044910' | Should -Be 'Job / Schnittstelle'
        $result.ContainsKey('f_popup_c_17289128195752470') | Should -BeFalse
    }
}