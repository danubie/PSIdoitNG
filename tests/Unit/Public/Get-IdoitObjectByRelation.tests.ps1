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
    . $testHelpersPath/MockData_Cmdb_objects_read.ps1
    . $testHelpersPath/MockData_Cmdb_object_types_read.ps1
    . $testHelpersPath/MockData_cmdb_object_type_categories_read.ps1
    . $testHelpersPath/MockData_cmdb_category_read.ps1
    . $testHelpersPath/MockData_cmdb_objects_by_relation.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')
    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe "Get-IdoitObjectByRelation" {
    It "Should return object with original properties (property is relation_object_id)" {
        $result = Get-IdoitObjectByRelation -ObjId 540
        $result.541 | Should -Not -BeNullOrEmpty
        $result.561 | Should -Not -BeNullOrEmpty
        $result.562 | Should -Not -BeNullOrEmpty
    }
    It "Should return 3 objects" {
        $result = Get-IdoitObjectByRelation -ObjId 540 -AsArray
        $result | Should -HaveCount 3
        $result[0].Id | Should -Be 561              # relation_object_id
        $result[0].TypeId | Should -Be 60           # relation_object_type_id
        $result[0].Title | Should -Be 'User W administriert server540'
        $result[0].related_object | Should -Be 37
        $result[0].related_title | Should -Be 'userw@spambog.com'
        $result[0].related_type | Should -Be 53
        $result[0].related_type_title | Should -Be 'Persons'
        $result[1].Id | Should -Be 562
        $result[1].TypeId | Should -Be 60
        $result[1].Title | Should -Be 'User W administriert server540'
        $result[1].related_object | Should -Be 37
        $result[1].related_title | Should -Be 'userw@spambog.com'
        $result[1].related_type | Should -Be 53
        $result[2].Id | Should -Be 541
        $result[2].TypeId | Should -Be 60
        $result[2].Title | Should -Be 'Komponente läuft auf'
        $result[2].related_object | Should -Be 4675
        $result[2].related_title | Should -Be 'Title4675'
        $result[2].related_type | Should -Be 93
        $result[2].related_type_title | Should -Be 'Komponente'
    }
    It "Should return 2 objects for type person (numeric)" {
        $result = Get-IdoitObjectByRelation -ObjId 540 -AsArray -RelationType 53
        $result | Should -HaveCount 2
        $result.related_type | Should -Be (53,53)
    }
    It "Should return 2 objects for type person (title)" {
        $result = Get-IdoitObjectByRelation -ObjId 540 -AsArray -RelationType Persons
        $result | Should -HaveCount 2
        $result.related_type | Should -Be (53,53)
    }
}
