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
    . $testHelpersPath/MockData_Cmdb_object_delete.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')
    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe 'Remove-IdoitObject' {
    BeforeAll {
        Start-IdoitApiTrace
    }
    AfterAll {
        Stop-IdoitApiTrace
    }
    It 'should remove an object' -ForEach @(
        @{ Id = 12345; Method = 'Archive'; expEndpoint = 'cmdb.object.delete'; expStatus = 'C__RECORD_STATUS__ARCHIVED' }
        @{ Id = 12345; Method = 'Delete'; expEndpoint = 'cmdb.object.delete'; expStatus = 'C__RECORD_STATUS__DELETED' }
        @{ Id = 12345; Method = 'Purge'; expEndpoint = 'cmdb.object.delete'; expStatus = 'C__RECORD_STATUS__PURGE' }
    ) {
        $result = Remove-IdoitObject -ObjId $objectId -Method $Method
        $result | Should -BeTrue

        $Global:IdoitApiTrace[-1].Request.method | Should -Be $expEndpoint
        $Global:IdoitApiTrace[-1].Request.params.status | Should -Be $expStatus
    }
    It 'Sould not call Invoke-RestMethod if -WhatIf is used' {
        $result = Remove-IdoitObject -ObjId ([int]::MaxValue) -Method 'Archive' -WhatIf
        $result | Should -Not -BeNullOrEmpty
        Assert-MockCalled Invoke-RestMethod -Times 0 -Exactly -Scope It
    }
}