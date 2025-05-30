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
    . $testHelpersPath/MockData_Cmdb_object_read.ps1
    . $testHelpersPath/MockData_Cmdb_object_types_read.ps1
    . $testHelpersPath/MockData_cmdb_object_type_categories_read.ps1
    . $testHelpersPath/MockData_cmdb_category_read.ps1
    . $testHelpersPath/MockData_idoit_constants_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe 'Get-IdoitMappedObject' {
    BeforeAll {
        Mock 'Connect-IdoIt' -ModuleName 'PSIdoitNG' -MockWith {
            Write-Host "Connect-IdoIt called with $($args | Out-String)"
            return $true
        }
        #region old definitions
        # $PersonMapped = [PSCustomObject] @{
        #     PSType  = 'Person'
        #     IdoitObjectType = 'C__OBJTYPE__PERSON'
        #     Mapping = [PSCustomObject] @(
        #         [PSCustomObject] @{
        #             Category        = 'C__CATS__PERSON';
        #             PropertyList    = @(
        #                 [PSCustomObject] @{ Property = 'Id'; PSProperty = 'id' },
        #                 [PSCustomObject] @{ Property = 'FirstName'; PSProperty = 'first_name' },
        #                 [PSCustomObject] @{ Property = 'LastName'; PSProperty = 'last_name' }
        #             )
        #         }
        #     )
        # }
        # $ServerMapped = [PSCustomObject] @{
        #     PSType          = $null
        #     IdoitObjectType = 'C__OBJTYPE__SERVER'
        #     Mapping         = [PSCustomObject]@(
        #         [PSCustomObject] @{
        #             Category     = 'C__CATG__GLOBAL'
        #             PropertyList =[PSCustomObject] @(
        #                 [PSCustomObject] @{ Property = 'Id'; PSProperty = 'Id' }
        #                 [PSCustomObject] @{ Property = 'Kommentar'; PSProperty = 'Description' }
        #                 [PSCustomObject] @{ Property = 'CDate'; PSProperty = 'Created' }
        #                 [PSCustomObject] @{ Property = 'EDate'; PSProperty = 'Changed' }
        #             )
        #         }
        #         [PSCustomObject] @{
        #             Category     = 'C__CATG__MEMORY'
        #             PropertyList = [PSCustomObject]@(
        #                 [PSCustomObject] @{ Property = 'MemoryGB'; PSProperty = 'Capacity.title'; Action = 'Sum' }
        #                 [PSCustomObject] @{ Property = 'MemoryMBCapacityTitle'; PSProperty = 'Capacity.title'; Action = {
        #                         # args[0] is the scriptblock
        #                         $args[1] | Foreach-Object {
        #                             $_ * 1024
        #                         } | Measure-Object -Sum | Select-Object -ExpandProperty Sum
        #                     }
        #                 }
        #                 [PSCustomObject] @{ Property = 'MemoryMBCapacity'; PSProperty = 'Capacity'; Action = {
        #                         # args[0] is the scriptblock
        #                         $args[1] | Foreach-Object {
        #                             $_.Title * 1024
        #                         } | Measure-Object -Sum | Select-Object -ExpandProperty Sum
        #                     }
        #                 }
        #                [PSCustomObject] @{ Property = 'MemoryMBFromUnits'; PSProperty = '!Category'; Update = "ReadOnly"; Action = {
        #                         $tempresult = $args[1] | Foreach-Object {
        #                             $idoitCategory = $_
        #                             switch ($idoitCategory.Unit.Title) {
        #                                 'MB' { $idoitCategory.Capacity.Title; break }
        #                                 'GB' { 1024 * $idoitCategory.Capacity.Title; break }
        #                                 'TB' { 1024 * 1024 * $idoitCategory.Capacity.Title; break }
        #                                 Default { Write-Error "Unknown unit $_" }     # Achtung Erroraction Continue gibt nichts aus
        #                             }
        #                         }
        #                         $tempresult | Measure-Object -Sum | Select-Object -ExpandProperty Sum
        #                     }
        #                 }
        #                 [PSCustomObject] @{ Property = 'NbMemorySticks'; PSProperty = 'Capacity'; Action = 'Count' }
        #                 [PSCustomObject] @{ Property = 'CategoryAsArray'; PSProperty = '!Category' }
        #             )
        #         }
        #     )
        # }
        #endregion old definitions
        . $testHelpersPath/SampleMapping.ps1
    }
    Context 'Sample user mapping' {
        It 'Should get object mapped to MyUser' {
            $objId = 37

            $result = Get-IdoitMappedObject -Id $objId -PropertyMap $PersonMapped
            $result | Should -Not -BeNullOrEmpty
            $result.ObjId | Select-Object -Unique | Should -Be $objId
            $result.Id | Should -Be 11
            $result.FirstName | Should -Be 'User'
            $result.LastName | Should -Be 'W'
        }
        It 'Should work with maps from <Case> file' -Foreach @(
            # @{ Case = 'json'; FileName = 'SampleMapping.json'; PSType = 'PersonMapped' }
            @{ Case = 'yaml'; FileName = 'SampleMapping.yaml'; PSType = 'PersonMapped' }
        ) {
            $PathMappingFile = Join-Path -Path $testHelpersPath -ChildPath $($_.FileName)
            $result = InModuleScope -ModuleName $script:moduleName {
                param ([string] $Path)
                ConvertFrom-MappingFile -Path $Path
            } -Parameters @{
                Path = $PathMappingFile
            }
            $result | Should -HaveCount 2
            $thisTypeTested = $_.PSType
            $thisMapTested = $($result | Where-Object { $_.Name -eq $thisTypeTested })

            $objId = 37
            $result = Get-IdoitMappedObject -Id $objId -PropertyMap $thisMapTested
            $result | Should -Not -BeNullOrEmpty
            $result.ObjId | Select-Object -Unique | Should -Be $objId
            $result.Id | Should -Be 11
            $result.FirstName | Should -Be 'User'
            $result.LastName | Should -Be 'W'
        }
    }
    Context 'Sample server mapping' {
        It 'Should get object mapped to MyServer' {
            $objId = 540
            $result = Get-IdoitMappedObject -Id $objId -PropertyMap $ServerMapped
            $result | Should -Not -BeNullOrEmpty
            $result.Id | Should -Be $objId
            $result.MemoryGB | Should -Be (4 * 64)                          # sum
            $result.MemoryMBTitles | Should -Be (64, 64, 64, 64)            # array of titles of Memory
            $result.MemoryMBCapacity | Should -Be (4 * 64 * 1024)           # scriptblock using whole category
            $result.MemoryMBCapacityTitle | Should -Be (4 * 64 * 1024)      # scriptblock using whole category title
            $result.MemoryMBFromUnits | Should -Be (4 * 64 * 1024)          # scriptblock using whole category
            $result.NbMemorySticks | Should -Be 4                           # uses count
            $result.CategoryAsArray | Should -HaveCount 4                   # delivers the whole category
        }
        It 'Should work with maps from <Case> file' -Foreach @(
            # @{ Case = 'json'; FileName = 'SampleMapping.json'; Name = 'ServerMapped' }
            @{ Case = 'yaml'; FileName = 'SampleMapping.yaml'; Name = 'ServerMapped' }
        ) {
            $PathMappingFile = Join-Path -Path $testHelpersPath -ChildPath $($_.FileName)
            $result = InModuleScope -ModuleName $script:moduleName {
                param ([string] $Path)
                ConvertFrom-MappingFile -Path $Path
            } -Parameters @{
                Path = $PathMappingFile
            }
            $result | Should -HaveCount 2
            $thisTypeTested = $_.Name
            $thisMapTested = $($result | Where-Object { $_.Name -eq $thisTypeTested })

            $objId = 540
            $result = Get-IdoitMappedObject -Id $objId -PropertyMap $thisMapTested
            $result | Should -Not -BeNullOrEmpty
            $result.Id | Should -Be $objId
            $result.MemoryGB | Should -Be (4 * 64)
            $result.MemoryMBTitles | Should -Be (64, 64, 64, 64)            # array of titles of Memory
            $result.NbMemorySticks | Should -Be 4                           # uses count
            $result.CategoryAsArray | Should -HaveCount 4                   # delivers the whole category
            $result.MemoryMBCapacity | Should -Be (4 * 64 * 1024)           # scriptblock using whole category
            $result.MemoryMBCapacityTitle | Should -Be (4 * 64 * 1024)      # scriptblock using whole category title
            $result.MemoryMBFromUnits | Should -Be (4 * 64 * 1024)          # scriptblock using whole category
            $result
        }
    }
}