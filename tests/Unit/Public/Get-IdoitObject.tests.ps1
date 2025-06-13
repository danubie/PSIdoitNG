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
        . $testHelpersPath/MockData_Cmdb_object_read.ps1
        . $testHelpersPath/MockDefaultMockAtEnd.ps1
    }
    Context 'Return and not return values' {
        It 'Returns a single object' {
            $return = Get-IdoitObject -ObjId 540
            ($return | Measure-Object).Count | Should -Be 1
            $return.typeId | Should -Be 5
            $return.PSObject.TypeNames | Should -Contain 'Idoit.Object'
            Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly -Scope It
        }
        It 'Returns error if no object is found' {
            Mock -CommandName Invoke-Idoit -ModuleName 'PSIdoitNG' -MockWith { $null }
            $ret = Get-IdoitObject -ObjId 540 -ErrorAction SilentlyContinue -ErrorVariable err
            $ret | Should -BeNullOrEmpty
            $err | Should -Belike "*not found Id=540"
            { Get-IdoitObject -ObjId 540 -ErrorAction Stop -ErrorVariable err } | Should -Throw "*not found Id=540*"
        }
    }

    Context 'Pipeline' {
        It 'Accepts values from the pipeline by value' {
            $return = 37, 540 | Get-IdoitObject
            Assert-MockCalled Invoke-RestMethod -Times 2 -Exactly -Scope It
            $return[0].ObjId | Should -Be 37
            $return[1].ObjId | Should -Be 540
        }

        It 'Accepts value from the pipeline by property name' {
            $return = 37, 540 | ForEach-Object {
                [PSCustomObject]@{
                    ObjId         = $_
                    OtherProperty = 'other'
                }
            } | Get-IdoitObject

            Assert-MockCalled Invoke-RestMethod -Times 2 -Exactly -Scope It
            $return[0].ObjId | Should -Be 37
            $return[1].ObjId | Should -Be 540
        }
    }
}
