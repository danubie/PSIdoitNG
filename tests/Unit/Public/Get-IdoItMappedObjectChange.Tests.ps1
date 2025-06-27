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
    . $testHelpersPath/MockData_Cmdb_objects_read.ps1
    . $testHelpersPath/MockData_Cmdb_object_types_read.ps1
    . $testHelpersPath/MockData_cmdb_object_type_categories_read.ps1
    . $testHelpersPath/MockData_cmdb_category_read.ps1
    . $testHelpersPath/MockData_cmdb_category_info_read.ps1
    . $testHelpersPath/MockData_cmdb_dialog.ps1
    . $testHelpersPath/MockData_idoit_constants_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}
AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}
Describe 'Get-IdoitMappedObjectChange' {
    BeforeEach {
        InModuleScope -ModuleName $script:moduleName {
            $Script:IdoitCategoryMaps = @{}
        }
        $null = Register-IdoitCategoryMap -Path (Join-Path -Path $testHelpersPath -ChildPath 'SampleMapping.yaml') -Force
        $splat = @{
            InputObject = (Get-IdoitObject -ObjId 540)
            MappingName = 'ServerMapped'
        }
    }

    Context 'Error Handling' {
        It 'Returns an error if no mapping is registered for the given name' {
            { Get-IdoitMappedObjectChange @splat -MappingName 'NonExistentMapping' } | Should -Throw "No category map registered for name 'NonExistentMapping'. Use Register-IdoitCategoryMap to register a mapping."
        }

        It 'Returns a warning if the object is not found' {
            Get-IdoitMappedObjectChange @splat -ObjId 9999 -WarningAction SilentlyContinue -WarningVariable warn
            $warn | Should -BeLike "*9999*"
        }

        # TODO: This would be a great help for detecting typos in the mapping
        It 'Returns an error if the mapping categories are not found for the object type' -Skip {
            { Get-IdoitMappedObjectChange @splat } | Should -Throw "Mapping categories InvalidCategory not found for object type ObjectType1/ObjectTypeTitle1"
        }
    }
    Context 'Result object should return no changes' {
        It 'An "empty" input object, does return no changes' {
            $result = Get-IdoitMappedObjectChange @splat
            $result | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'] | Should -BeOfType [hashtable]
            $result['C__CATG__MEMORY'] | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'].Keys | Should -HaveCount 0
            $result['C__CATG__MEMORY'].Keys | Should -HaveCount 0
        }
        It 'We did not change anything' {
            $obj = Get-IdoitMappedObject -ObjId 540 -MappingName 'ServerMapped'
            $splat.InputObject = $obj
            $result = Get-IdoitMappedObjectChange @splat
            $result | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'] | Should -BeOfType [hashtable]
            $result['C__CATG__MEMORY'] | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'].Keys | Should -HaveCount 0
            $result['C__CATG__MEMORY'].Keys | Should -HaveCount 0
        }
        It 'Changed properties are "read-only" by default' {
            $obj = Get-IdoitMappedObject -ObjId 540 -MappingName 'ServerMapped'
            $obj.Kommentar = 'New Server Title'
            $obj.CDate = (Get-Date).AddDays(-1)
            $splat.InputObject = $obj
            $result = Get-IdoitMappedObjectChange @splat
            $result | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'] | Should -BeOfType [hashtable]
            $result['C__CATG__MEMORY'] | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'].Keys | Should -HaveCount 0
            $result['C__CATG__MEMORY'].Keys | Should -HaveCount 0
        }
    }
    Context 'Inputobject is a plain [PSCustomObject]' {
        It 'No changes if a property is not part of the input object' {
            # Tag is not part of the InputObject => it should not change => it should not be in the result
            $obj = [PSCustomObject]@{
                Kommentar = 'New Server Title'
                CDate     = (Get-Date).AddDays(-1)
            }
            $splat.InputObject = $obj
            $splat.IncludeProperty = @('Kommentar', 'CDate','Tag')
            # Here we must specify the ObjId, because the InputObject is not a Mapped Object
            $result = Get-IdoitMappedObjectChange @splat -ObjId 540
            $result | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'] | Should -BeOfType [hashtable]
            $result['C__CATG__MEMORY'] | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'].Keys | Should -HaveCount 2 -Because "'Tag' has not been changed"
            $result['C__CATG__MEMORY'].Keys | Should -HaveCount 0
        }
        It 'Output prpoerty must be set to $null if you want to delete it in i-doit' {
            # Tag is not part of the InputObject => it should not change => it should not be in the result
            $obj = [PSCustomObject]@{
                Kommentar = 'New Server Title'
                CDate     = (Get-Date).AddDays(-1)
                Tag       = $null
            }
            $splat.InputObject = $obj
            $splat.IncludeProperty = @('Kommentar', 'CDate','Tag')
            # Here we must specify the ObjId, because the InputObject is not a Mapped Object
            $result = Get-IdoitMappedObjectChange @splat -ObjId 540
            $result | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'] | Should -BeOfType [hashtable]
            $result['C__CATG__MEMORY'] | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'].Keys | Should -HaveCount 3 -Because "'Tag' has not been changed"
            $result['C__CATG__MEMORY'].Keys | Should -HaveCount 0
            $result['C__CATG__GLOBAL'].Tag | Should -Be $null
        }
    }
    Context 'Should return changes for a Mapped Object' {
        It 'Changed properties are not "read-only" if specified' {
            $obj = Get-IdoitMappedObject -ObjId 540 -MappingName 'ServerMapped'
            $obj.Kommentar = 'New Server Title'
            $obj.CDate = (Get-Date).AddDays(-1)
            $splat.InputObject = $obj
            $splat.IncludeProperty = @('Kommentar', 'CDate','Tag')
            $result = Get-IdoitMappedObjectChange @splat
            $result | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'] | Should -BeOfType [hashtable]
            $result['C__CATG__MEMORY'] | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'].Keys | Should -HaveCount 2 -Because "'Tag' has not been changed"
            $result['C__CATG__MEMORY'].Keys | Should -HaveCount 0
        }
        It 'Add a single tag' {
            $obj = Get-IdoitMappedObject -ObjId 540 -MappingName 'ServerMapped'
            $obj.Kommentar = 'New Server Title'
            $obj.CDate = (Get-Date).AddDays(-1)
            $obj.Tag = 'ChangedTag'
            $splat.InputObject = $obj
            $splat.IncludeProperty = @('Kommentar', 'CDate','Tag')
            $result = Get-IdoitMappedObjectChange @splat
            $result | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'] | Should -BeOfType [hashtable]
            $result['C__CATG__MEMORY'] | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'].Keys | Should -HaveCount 3
            $result['C__CATG__MEMORY'].Keys | Should -HaveCount 0
            $result['C__CATG__GLOBAL'].Tag | Should -BeOfType [string]
            $result['C__CATG__GLOBAL'].Tag | Should -Be 'ChangedTag'
        }
        It 'Add a tag as array' {
            $obj = Get-IdoitMappedObject -ObjId 540 -MappingName 'ServerMapped'
            $obj.Kommentar = 'New Server Title'
            $obj.CDate = (Get-Date).AddDays(-1)
            $obj.Tag = @('ChangedTag1', 'ChangedTag2')
            $splat.InputObject = $obj
            $splat.IncludeProperty = @('Kommentar', 'CDate','Tag')
            $result = Get-IdoitMappedObjectChange @splat
            $result | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'] | Should -BeOfType [hashtable]
            $result['C__CATG__MEMORY'] | Should -BeOfType [hashtable]
            $result['C__CATG__GLOBAL'].Keys | Should -HaveCount 3
            $result['C__CATG__MEMORY'].Keys | Should -HaveCount 0
            $result['C__CATG__GLOBAL']['Tag'] | Should -HaveCount 2
        }
    }
}