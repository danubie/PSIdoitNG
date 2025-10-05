BeforeDiscovery {
    $isNotConnected = $false
    if ([string]::IsNullOrEmpty($uri) -or [string]::IsNullOrEmpty($apikey) -or $null -eq $credIdoit) {
        Write-Warning -Message "You need to set the variables `$uri`, `$apikey`, and `$credIdoit` before running the tests."
        $isNotConnected = $true
    }
}
BeforeAll {
    $script:ModuleName = 'PSIdoitNG'
    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
    Import-Module -Name $script:moduleName -Force

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:moduleName

    $testRoot = Join-Path -Path (Get-SamplerAbsolutePath) -ChildPath 'tests'
    $testHelpersPath = Join-Path -Path $testRoot -ChildPath 'Unit\Helpers'
    $testIntegrationHelpersPath = Join-Path -Path $testRoot -ChildPath 'Integration\Helpers'
    if (-not $IsNotConnected) {
        Connect-Idoit -Uri $uri -Credential $credIdoit -ApiKey (ConvertFrom-SecureString $apikey -AsPlainText)
    }
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Disconnect-Idoit -ErrorAction SilentlyContinue
    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe 'Integration Get-IdoitObject' -Tag 'Integration' -Skip:$isNotConnected {
    BeforeAll {
        & (Join-Path $testIntegrationHelpersPath Remove-PesterLeftOvers.ps1)
    }
    AfterAll {
        & (Join-Path $testIntegrationHelpersPath Remove-PesterLeftOvers.ps1)
    }
        It 'Filter by ObjectType' -Foreach @(
        @{ Case = 'ByNumber'; ObjectType = 53 }
        @{ Case = 'ByString'; ObjectType = 'C__OBJTYPE__PERSON' }
    ) {
        $ret = Get-IdoitObject -ObjectType $ObjectType
        ($ret | Measure-Object).Count | Should -BeGreaterThan 0
        $ret[0].Type_Title | Should -Be 'Persons'
    }
    It 'Filter by ObjectType title' {
        $ret = Get-IdoitObject -TypeTitle 'Persons'
        ($ret | Measure-Object).Count | Should -BeGreaterThan 0
        $ret[0].Type_Title | Should -Be 'Persons'
    }
    Context 'Person prefiltered by ObjectType' {
        BeforeAll {
            $allPersons = Get-IdoitObject -ObjectType 'C__OBJTYPE__PERSON'
        }
        It 'Filter by Title' {
            $ret = Get-IdoitObject -Title $allPersons[0].Title
            ($ret | Measure-Object).Count | Should -Be 1
            $ret[0].Title | Should -Be $allPersons[0].Title
            $ret[0].Type_Title | Should -Be 'Persons'
            $ret[0].TypeId | Should -Be 53
            $ret[0].ObjId | Should -Be $allPersons[0].ObjId
        }
        It 'Filter by Type_Title' {
            $ret = Get-IdoitObject -TypeTitle 'Persons'
            ($ret | Measure-Object).Count | Should -BeGreaterThan 0
            $ret[0].Type_Title | Should -Be 'Persons'
        }
        It 'Filter by ObjId' {
            $ret = Get-IdoitObject -ObjId $allPersons[0].ObjId
            ($ret | Measure-Object).Count | Should -Be 1
            $ret.ObjId | Should -Be $allPersons[0].ObjId
            $ret.TypeId | Should -Be 53
            $ret.objecttype | Should -Be 53     # objecttype is returned as well for compatibility with 'cmdb.objects.read'
            $ret.type | Should -Be 53           # type is returned as well for compatibility with 'cmdb.object.read'
            $ret.PSObject.TypeNames | Should -Contain 'Idoit.Object'
        }
        It 'Filter by multiple ObjIds' {
            $ret = Get-IdoitObject -ObjId $allPersons[0].ObjId, $allPersons[1].ObjId

            ($ret | Measure-Object).Count | Should -Be 2
            $ret[0].ObjId | Should -Be $allPersons[0].ObjId
            $ret[1].ObjId | Should -Be $allPersons[1].ObjId
            $ret[0].TypeId | Should -Be 53
            $ret[1].TypeId | Should -Be 53
        }
        It 'Filter by Status' {
            $ret = Get-IdoitObject -Status 'C__RECORD_STATUS__NORMAL'
            ($ret | Measure-Object).Count | Should -BeGreaterThan 0
            $ret[0].cmdb_status | Should -Be 6
            $ret[0].cmdb_status_title | Should -Be 'in operation'       # funny: the returned status does not contain the property we searched for, but the title should be correct
        }
        It 'Filter by StatusId' {
            foreach ($status in ('C__RECORD_STATUS__BIRTH', 'C__RECORD_STATUS__NORMAL', 'C__RECORD_STATUS__ARCHIVED', 'C__RECORD_STATUS__DELETED', 'C__RECORD_STATUS__TEMPLATE', 'C__RECORD_STATUS__MASS_CHANGES_TEMPLATE')) {
                # for now we only test that the function returns something, not the actual status
                # to make this more robust, we would need to create a test object with each status
                $null = Get-IdoitObject -Status $status
            }
        }
    }
    Context 'Should return categories with the object' {
        It 'filter 2 persons by type and return categories' {
            $ret = Get-IdoitObject -ObjectType 'C__OBJTYPE__PERSON' -Category 'C__CATG__GLOBAL','C__CATS__PERSON_MASTER' -Limit 2
            ($ret | Measure-Object).Count | Should -Be 2
            $ret[0].Categories | Should -Not -BeNullOrEmpty
            $ret[1].Categories | Should -Not -BeNullOrEmpty
            $ret[0].Categories.C__CATG__GLOBAL | Should -Not -BeNullOrEmpty
            $ret[1].Categories.C__CATG__GLOBAL | Should -Not -BeNullOrEmpty
            $ret[1].Categories.C__CATS__PERSON_MASTER | Should -Not -BeNullOrEmpty
            $ret[0].Categories.C__CATS__PERSON_MASTER | Should -Not -BeNullOrEmpty
        }
    }
}