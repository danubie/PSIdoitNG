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
    . $testHelpersPath/MockData_Cmdb_category_delete.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')
    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe 'Remove-IdoitCategory' {
    BeforeAll {
        Start-IdoitApiTrace
    }
    AfterAll {
        Stop-IdoitApiTrace
    }
    It 'should remove an object' {
        $result = Remove-IdoitCategory -ObjId 12345 -Category 'C__CATG__MEMORY' -EntryId 12
        $result.success | Should -BeTrue

        $Global:IdoitApiTrace[-1].Request.method | Should -Be 'cmdb.category.delete'
        $Global:IdoitApiTrace[-1].Request.params.objID | Should -Be 12345
        $Global:IdoitApiTrace[-1].Request.params.category | Should -Be 'C__CATG__MEMORY'
        $Global:IdoitApiTrace[-1].Request.params.id | Should -Be 12
    }
    It 'Should not call Invoke-RestMethod if -WhatIf is used' {
        $result = Remove-IdoitCategory -ObjId 12345 -Category 'C__CATG__MEMORY' -EntryId 12 -WhatIf
        $result | Should -BeNullOrEmpty
        Assert-MockCalled Invoke-RestMethod -Times 0 -Exactly -Scope It
    }
}