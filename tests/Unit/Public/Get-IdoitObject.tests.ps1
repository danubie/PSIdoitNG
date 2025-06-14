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
    . $testHelpersPath/MockData_Cmdb_object_read.ps1
    . $testHelpersPath/MockData_Cmdb_objects_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe Get-IdoitObject {
    BeforeAll {
        Start-IdoitApiTrace
    }
    AfterAll {
        Stop-IdoitApiTrace
    }
    Context 'Return and not return values using method cmdb.object.read' {
        It 'Returns a single object' {
            $return = Get-IdoitObject -ObjId 540
            ($return | Measure-Object).Count | Should -Be 1
            $return.typeId | Should -Be 5
            $return.PSObject.TypeNames | Should -Contain 'Idoit.Object'
            Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly -Scope It
            $Global:IdoItAPITrace[-1].Request.method | Should -Be 'cmdb.object.read'
        }
        It 'Returns error if no object is found' {
            Mock -CommandName Invoke-Idoit -ModuleName 'PSIdoitNG' -MockWith { $null }
            $ret = Get-IdoitObject -ObjId 540
            $ret | Should -BeNullOrEmpty
            $Global:IdoItAPITrace[-1].Request.method | Should -Be 'cmdb.object.read'
        }
    }
    Context 'Filter by ObjectType' {
        It 'ByNumber' {
            $return = Get-IdoitObject -ObjectType 53
            ($return | Measure-Object).Count | Should -BeGreaterThan 0
            $return[0].Type_Title | Should -Be 'Persons'
            Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly -Scope It
            $Global:IdoItAPITrace[-1].Request.method | Should -Be 'cmdb.objects.read'
        }
        It 'ByString' {
            $return = Get-IdoitObject -ObjectType 'C__OBJTYPE__PERSON'
            ($return | Measure-Object).Count | Should -BeGreaterThan 0
            $return[0].Type_Title | Should -Be 'Persons'
            Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly -Scope It
            $Global:IdoItAPITrace[-1].Request.method | Should -Be 'cmdb.objects.read'
        }
    }
}
