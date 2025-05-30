BeforeAll {
    $script:ModuleName = 'PSIdoitNG'
    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
    Import-Module -Name $script:moduleName -Force

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:moduleName

    $testRoot = Join-Path -Path (Get-SamplerAbsolutePath) -ChildPath 'tests'
    $testHelpersPath = Join-Path -Path $testRoot -ChildPath 'Unit\Helpers'
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}
Describe 'ConvertFrom-MappingFile' {
    It 'should throw an error if file not found' {
        $PathMappingFile = Join-Path -Path $testHelpersPath -ChildPath 'NonExistingFile.yaml'
        InModuleScope -ModuleName $script:moduleName {
            param ([string] $Path)
            { ConvertFrom-MappingFile -Path $Path } | Should -Throw "Mapping file not found*"
        } -Parameters @{
            Path = $PathMappingFile
        }
    }
    Context 'Should convert mapping file' {
        It 'should convert from <Case>' -ForEach @(
            # @{ Case = 'json'; FileName = 'SampleMapping.json' }
            @{ Case = 'yaml'; FileName = 'SampleMapping.yaml' }
        ) {
            $PathMappingFile = Join-Path -Path $testHelpersPath -ChildPath $_.FileName
            $result = InModuleScope -ModuleName $script:moduleName {
                param ([string] $Path)
                ConvertFrom-MappingFile -Path $Path
            } -Parameters @{
                Path = $PathMappingFile
            }
            $result | Should -HaveCount 2
            $mapPerson = $result | Where-Object { $_.IdoitObjectType -eq 'C__OBJTYPE__PERSON' }
            $mapPerson.Name | Should -Be 'PersonMapped'
            $mapPerson.PSType | Should -Be 'Person'
            $mapPerson.IdoitObjectType | Should -Be 'C__OBJTYPE__PERSON'
            $mapPerson.Mapping | Should -HaveCount 1
            $cat0 = $mapPerson.Mapping[0]
            $cat0.Category | Should -Be 'C__CATS__PERSON'
            $cat0.PropertyList | Should -HaveCount 3
            $cat0.PropertyList.Property | Should -Be 'Id','FirstName','LastName'
            $cat0.PropertyList.Attribute | Should -Be 'Id','first_name','last_name'

            $mapServer = $result | Where-Object { $_.IdoitObjectType -eq 'C__OBJTYPE__SERVER' }
            $mapServer.Name | Should -Be 'ServerMapped'
            $mapServer.PSType | Should -Be $null
            $mapServer.IdoitObjectType | Should -Be 'C__OBJTYPE__SERVER'
            $mapServer.Mapping | Should -HaveCount 2
            $cat0 = $mapServer.Mapping[0]
            $cat0.Category | Should -Be 'C__CATG__GLOBAL'
            $cat0.PropertyList | Should -HaveCount 4
            $cat0.PropertyList.Property | Should -Be 'Id','Kommentar','CDate','EDate'
            $cat0.PropertyList.Attribute | Should -Be 'Id','title','created','changed'

            $cat1 = $mapServer.Mapping[1]
            $cat1.Category | Should -Be 'C__CATG__MEMORY'
            $cat1.PropertyList | Should -HaveCount 4

            $cat1.PropertyList[0].Property | Should -Be 'MemoryGB'
            $cat1.PropertyList[0].Attribute | Should -Be 'capacity.title'
            $cat1.PropertyList[0].Action | Should -Be 'sum'

            $cat1.PropertyList[1].Property | Should -Be 'MemoryMB'
            $cat1.PropertyList[1].Attribute | Should -Be 'capacity.title.2'
            $cat1.PropertyList[1].Action | Should -Be $null

            $cat1.PropertyList[2].Property | Should -Be 'NbMemorySticks'
            $cat1.PropertyList[2].Attribute | Should -Be 'capacity'
            $cat1.PropertyList[2].Action | Should -Be 'count'

            $cat1.PropertyList[3].Property | Should -Be 'CategoryAsArray'
            $cat1.PropertyList[3].Attribute | Should -Be '!capacity'
            $cat1.PropertyList[3].Action | Should -Be $null
        }
    }
}