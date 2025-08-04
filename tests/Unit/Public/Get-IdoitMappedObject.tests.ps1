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
    . $testHelpersPath/MockData_cmdb_category_info_read.ps1
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
        . $testHelpersPath/SampleMapping.ps1
        Start-IdoitApiTrace
    }
    AfterAll {
        Stop-IdoitApiTrace
    }
    Context 'Sample user mapping' {
        It 'Should get object mapped to MyUser' {
            $objId = 37

            $result = Get-IdoitMappedObject -ObjId $objId -PropertyMap $PersonMapped
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
            $result = Get-IdoitMappedObject -ObjId $objId -PropertyMap $thisMapTested
            $result | Should -Not -BeNullOrEmpty
            $result.ObjId | Select-Object -Unique | Should -Be $objId
            $result.FirstName | Should -Be 'User'
            $result.LastName | Should -Be 'W'
        }
    }
    Context 'Sample user mapping Parameterset ByTitleMappingName' {
        It 'Should get object mapped to MyUser by Title' {
            $PathMappingFile = Join-Path -Path $testHelpersPath -ChildPath 'SampleMapping.yaml'
            Register-IdoitCategoryMap -Path $PathMappingFile -Force
            $title = 'userw@spambog.com'
            $result = Get-IdoitMappedObject -Title $title -MappingName 'PersonMapped'
            $result | Should -Not -BeNullOrEmpty
            $result.ObjId | Select-Object -Unique | Should -Be 37
            $result.FirstName | Should -Be 'User'
            $result.LastName | Should -Be 'W'
            $Global:IdoItAPITrace[-1].request.method | Should -Be 'cmdb.objects.read'
            $global:IdoItAPITrace[-1].request.params.filter.title | Should -Be $title
        }
    }
    Context 'Sample server mapping' {
        It 'Should get object mapped to MyServer' {
            $objId = 540
            $result = Get-IdoitMappedObject -ObjId $objId -PropertyMap $ServerMapped
            $result | Should -Not -BeNullOrEmpty
            $result.Id | Should -Be $objId
            $result.BeschreibungUndefined | Should -Be $null                # in I-doit undefined attributes get null
            $result.PSObject.Properties.Name | Should -Contain 'BeschreibungUndefined'      # but should exist as attribute
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
            $result = Get-IdoitMappedObject -ObjId $objId -PropertyMap $thisMapTested
            $result | Should -Not -BeNullOrEmpty
            $result.Id | Should -Be $objId
            $result.BeschreibungUndefined | Should -Be $null                # in I-doit undefined attributes get null
            $result.PSObject.Properties.Name | Should -Contain 'BeschreibungUndefined'      # but should exist as attribute
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
    Context 'Demo with custom object' {
        BeforeEach {
            # Reset the script variable before each test
            Remove-Variable -Name IdoitCategoryMaps -Scope Script -ErrorAction SilentlyContinue
        }
        AfterAll {
            # Reset the script variable after each test
            Remove-Variable -Name IdoitCategoryMaps -Scope Script -ErrorAction SilentlyContinue
        }
        It 'Should get object mapped "DemoComponent; <case>"' -ForEach @(
            @{ case = 'uses ConvertFrom-MappingFile'; MappingName = $null }
            @{ case = 'uses RegisterMapping'; MappingName = 'DemoComponent' }
        ) {
            # Register mapping or use a mapping definition
            if ($null -ne $MappingName) {
                # Arrange: register all mapping files
                Register-IdoitCategoryMap -Path $testHelpersPath -Force
                # Act
                $objId = 4675
                $result = Get-IdoitMappedObject -ObjId $objId -MappingName $MappingName

            } else {
                $path = Join-Path -Path $testHelpersPath -ChildPath 'ObjectWithCustomCategory.yaml'
                $mapComponent = ConvertFrom-MappingFile -Path $path
                $mapComponent | Should -Not -BeNullOrEmpty

                # Act
                $objId = 4675
                $result = Get-IdoitMappedObject -ObjId $objId -PropertyMap $mapComponent
            }

            # Assert
            # do not wonder: it returns "server540" as JobName, because the object is a component of a server540
            $result         | Should -Not -BeNullOrEmpty
            $result.ObjId   | Should -Be 4675
            $result.JobName | Should -Be 'title4675'
            $result.KomponentenTyp | Should -Be @('Job / Schnittstelle')
            $result.Technologie | Should -Be @('SQL Server','Biztalk')
            # the next must exist as property, but are not set (no mocked data for these)
            $result.PrimaryContact | Should -Be $null
            $result.Email | Should -Be $null
            ($result | Get-Member -MemberType NoteProperty).Name | Should -Contain 'PrimaryContact'
            ($result | Get-Member -MemberType NoteProperty).Name | Should -Contain 'Email'
        }
    }
}