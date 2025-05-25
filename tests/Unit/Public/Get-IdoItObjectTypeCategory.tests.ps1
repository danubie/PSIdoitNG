BeforeAll {
    $script:ModuleName = 'PSIdoitNG'
    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
    Import-Module -Name $script:moduleName -Force

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:moduleName

    $testRoot = Join-Path -Path (Get-SamplerAbsolutePath) -ChildPath 'tests'
    $testHelpersPath = Join-Path -Path $testRoot -ChildPath 'Unit\Helpers'
    . $testHelpersPath/MockConnectIdoit.ps1
    . $testHelpersPath/MockData_cmdb_object_read.ps1
    . $testHelpersPath/MockData_cmdb_object_type_categories_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe Get-IdoItObjectTypeCategory {
    Context 'Return and not return values' {
        It 'Returns server object properties' {
            $return = Get-IdoItObjectTypeCategory -Id 5
            ($return | Measure-Object).Count | Should -BeGreaterThan 1
            $return[0].PSObject.TypeNames | Should -Contain 'IdoIt.ObjectTypeCategory'
            Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly -Scope It
        }
        It 'Returns server object properties with alias' {
            $return = Get-IdoItObjectTypeCategory -TypeId 5
            ($return | Measure-Object).Count | Should -BeGreaterThan 1
            $return[0].PSObject.TypeNames | Should -Contain 'IdoIt.ObjectTypeCategory'
            Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly -Scope It
        }
        It 'Returns person object' {
            $return = Get-IdoItObjectTypeCategory -Type 53
            ($return | Measure-Object).Count | Should -BeGreaterThan 1
            # in this case, we both get catg and cats entries
            $return.type | Should -Contain 'catg'
            $return.type | Should -Contain 'cats'
            $return[0].PSObject.TypeNames | Should -Contain 'IdoIt.ObjectTypeCategory'
            Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly -Scope It
        }
        It 'Returns object type categories for an object id' {
            $return = Get-IdoItObjectTypeCategory -ObjId 540
            ($return | Measure-Object).Count | Should -BeGreaterThan 1
            $return[0].PSObject.TypeNames | Should -Contain 'IdoIt.ObjectTypeCategory'
            # called: Get-Object, Get-ObjectType
            Assert-MockCalled Invoke-RestMethod -Times 2 -Exactly -Scope It
        }
        It 'Returns error if no object is found' {
            { Get-IdoItObjectTypeCategory -Id 99999 -ErrorAction Stop -ErrorVariable err } | Should -Throw "**Object type not found."
        }
    }
}
