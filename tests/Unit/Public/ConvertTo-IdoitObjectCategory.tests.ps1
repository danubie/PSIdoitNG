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
    . $testHelpersPath/MockData_Cmdb_objects_read.ps1
    . $testHelpersPath/MockData_Cmdb_object_types_read.ps1
    . $testHelpersPath/MockData_cmdb_object_type_categories_read.ps1
    . $testHelpersPath/MockData_cmdb_category_read.ps1
    . $testHelpersPath/MockData_cmdb_category_info_read.ps1
    . $testHelpersPath/MockData_cmdb_dialog.ps1
    . $testHelpersPath/MockData_idoit_constants_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1

    Register-IdoitCategoryMap -Path (Join-Path -Path $testHelpersPath -ChildPath 'SampleMapping.yaml')
}
AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')
    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe 'ConvertTo-IdoitObjectCategory' {
    BeforeEach {
        # Reset mocks and variables
    }
    Context 'Happy path' {
        It 'Converts mapped PERSON object to I-doit object structure' {
            $InputObject = [PSCustomObject]@{ FirstName = 'John'; LastName = 'Doe' }
            $result = ConvertTo-IdoitObjectCategory -InputObject $InputObject -MappingName 'PersonMapped'
            $result | Should -BeOfType 'Hashtable'
            $result['C__CATS__PERSON']['first_name'] | Should -Be 'John'
            $result['C__CATS__PERSON']['last_name'] | Should -Be 'Doe'
            $result['C__CATS__PERSON']['id'] | Should -Be $null         # id is automatically inserted by API
        }
        It 'Converts mapped SERVER object to I-doit object structure' {
            $ObjId = 540
            $mappedObj = Get-IdoitMappedObject -ObjId $ObjId -MappingName 'ServerMapped'
            # Ignore warnings for nonconvertable action properties
            $result = ConvertTo-IdoitObjectCategory -InputObject $mappedObj -MappingName 'ServerMapped' -WarningAction SilentlyContinue
            $result | Should -BeOfType 'Hashtable'
            $result.C__CATG__GLOBAL['id'] | Should -Be $mappedObj.Id
            $result.C__CATG__GLOBAL['title'] | Should -Be $mappedObj.ComputerName
            $result.C__CATG__GLOBAL['description'] | Should -Be $mappedObj.Beschreibung
            $result.C__CATG__GLOBAL['tag'].title | Should -Be $mappedObj.Tag
            $result.C__CATG__MEMORY['capacity'].title | Should -Be $mappedObj.MemoryMBTitles
            # those who have an action defined in the mapping are not converted
        }
    }
    Context 'Edge cases' {
        It 'Throws if mapping not registered' {
            $InputObject = [PSCustomObject]@{ FirstName = 'John'; LastName = 'Doe' }
            { ConvertTo-IdoitObjectCategory -InputObject $InputObject -MappingName 'xxx' } | Should -Throw
        }
        It 'Skips properties not in input object' {
            $InputObject = [PSCustomObject]@{
                FirstName = 'John';
                LastName = 'Doe';
                UnknownProperty = 'Unknown'
            }
            $result = ConvertTo-IdoitObjectCategory -InputObject $InputObject -MappingName 'PersonMapped'
            $result['C__CATS__PERSON']['first_name'] | Should -Be 'John'
            $result['C__CATS__PERSON']['last_name'] | Should -Be 'Doe'
            $result['C__CATS__PERSON'].Keys | Should -Not -Contain 'UnknownProperty'
        }
        It 'Excludes properties via ExcludeProperty' {
            $InputObject = [PSCustomObject]@{ FirstName = 'John'; LastName = 'Doe' }
            $result = ConvertTo-IdoitObjectCategory -InputObject $InputObject -MappingName 'PersonMapped' -ExcludeProperty 'LastName'
            $result['C__CATS__PERSON']['first_name'] | Should -Be 'John'
            $result['C__CATS__PERSON'].Keys | Should -Not -Contain 'last_name'
        }
    }
}
