# Simple test for Get-IdoitMappedObjectFromTemplate
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
    # . $testHelpersPath/MockData_Cmdb_object_read.ps1
    # . $testHelpersPath/MockData_Cmdb_objects_read.ps1
    # . $testHelpersPath/MockData_Cmdb_object_types_read.ps1
    . $testHelpersPath/MockData_cmdb_category_info_read.ps1
    # . $testHelpersPath/MockData_cmdb_object_type_categories_read.ps1
    # . $testHelpersPath/MockData_cmdb_category_read.ps1
    # . $testHelpersPath/MockData_idoit_constants_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1

}
AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe 'Get-IdoitMappedObjectFromTemplate' {
    BeforeEach {
        InModuleScope -ModuleName $script:moduleName {
            $Script:IdoitCategoryMaps = @{}
        }
    }
    #add test
    It 'Returns a PSObject with properties from YAML mapping (DemoComponent)' {
        $yamlPath = Join-Path $testHelpersPath 'ObjectWithCustomCategory.yaml'
        Register-IdoitCategoryMap -Path $yamlPath -Force

        $result = Get-IdoitMappedObjectFromTemplate -MappingName 'DemoComponent'
        $result | Should -Not -BeNullOrEmpty

        $result.PSObject.Properties.Name | Should -Contain 'JobName'
        $result.PSObject.Properties.Name | Should -Contain 'KomponentenTyp'
        $result.PSObject.Properties.Name | Should -Contain 'Technologie'
        $result.PSObject.Properties.Name | Should -Contain 'PrimaryContact'
        $result.PSObject.Properties.Name | Should -Contain 'Email'
    }
    Context 'When mapping does not exist' {
        It 'Throws an error' {
            { Get-IdoitMappedObjectFromTemplate -MappingName 'NonExistentMapping' } | Should -Throw "No category map registered for name 'NonExistentMapping'. Use Register-IdoitCategoryMap to register a mapping."
        }
    }
}
