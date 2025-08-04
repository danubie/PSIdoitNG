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

Describe 'Integration New-IdoitMappedObject' -Tag 'Integration' -Skip:$isNotConnected {
    BeforeAll {
        & (Join-Path $testIntegrationHelpersPath Remove-PesterLeftOvers.ps1)
        Register-IdoitCategoryMap -Path (Join-Path -Path $testHelpersPath -ChildPath 'SampleMapping.yaml') -Force
    }
    AfterEach {
        & (Join-Path $testIntegrationHelpersPath Remove-PesterLeftOvers.ps1)
    }
    Context 'PERSON' {
        It 'Creates a new mapped PERSON object' {
            $nameTestObject = "Pester $(Get-Date -Format 'yyyy-MM-dd hh:mm:ss') $(New-Guid)"
            $object = [PSCustomObject]@{
                FirstName = 'John'
                LastName  = $nameTestObject
            }
            $objId = New-IdoitMappedObject -InputObject $object -MappingName 'PersonMapped' -Title 'Ignored'
            Write-Host "Created new object with Id: $($objId)" -ForegroundColor Cyan
            $objId | Should -BeGreaterThan 0

            # try to reread by Id
            $obj = Get-IdoitMappedObject -ObjId $objId -MappingName 'PersonMapped'
            $obj | Should -Not -BeNullOrEmpty
            $obj.FirstName | Should -Be 'John'
            $obj.LastName | Should -Be $nameTestObject
            if ($obj.ObjId -ne $objId) {
                Write-Host "Warning: Object Id ($($obj.ObjId)) does not match expected Id ($objId)" -ForegroundColor Yellow
            }
            $obj.ObjId | Should -Be $objId

            # Try to reread by Title
            $obj = Get-IdoitMappedObject -ObjId $objId -MappingName 'PersonMapped'
            $obj | Should -Not -BeNullOrEmpty
            $obj.ObjId | Should -Be $objId
        }
        It 'Should allow duplicates when AllowDuplicates is set' {
            $nameTestObject = "Pester $(Get-Date -Format 'yyyy-MM-dd hh:mm:ss') $(New-Guid)"
            $object = [PSCustomObject]@{
                FirstName = 'Jane'
                LastName  = $nameTestObject
            }
            $splatNewMappedObject = @{
                InputObject     = $object
                MappingName     = 'PersonMapped'
                Title           = $nameTestObject
                AllowDuplicates = $true
            }
            $objId = New-IdoitMappedObject @splatNewMappedObject
            Write-Host "Created new object with Id: $($objId)" -ForegroundColor Cyan
            $objId | Should -BeGreaterThan 0

            # try to reread by Id
            $obj = Get-IdoitMappedObject -ObjId $objId -MappingName 'PersonMapped'
            $obj | Should -Not -BeNullOrEmpty
            $obj.FirstName | Should -Be 'Jane'
            $obj.LastName | Should -Be $nameTestObject

            $obj2Id = New-IdoitMappedObject -InputObject $object -MappingName 'PersonMapped' -Title 'Pester Ignored' -AllowDuplicates
            Write-Host "Created new object with Id: $($obj2Id)" -ForegroundColor Cyan
            $obj2Id | Should -Not -BeNullOrEmpty
            $obj2Id | Should -BeGreaterThan 0

            $objList = Search-IdoItObject -Conditions @{"property" = "C__CATG__GLOBAL-title"; "comparison" = "like"; "value" = "*Pester*"} -ErrorAction SilentlyContinue
            $objList | Should -HaveCount 2
        }
    }
    Context 'SERVER' {
        BeforeAll {
            Register-IdoitCategoryMap -Path (Join-Path -Path $testHelpersPath -ChildPath 'SampleMapping.yaml') -Force
        }
        It 'Creates a new mapped SERVER object' {
            $nameTestObject = "Pester $(Get-Date -Format 'yyyy-MM-dd hh:mm:ss') $(New-Guid)"
            $object = [PSCustomObject]@{
                ComputerName   = $nameTestObject
                Beschreibung   = 'This is a test server'
                Tag            = 'TestTag'
                MemoryMBTitles = @('8 GB', '16 GB')
            }
            $splatNewMappedObject = @{
                InputObject     = $object
                MappingName     = 'ServerMapped'
                Title           = $nameTestObject
            }
            $result = New-IdoitMappedObject @splatNewMappedObject
            $objId = $result.ObjId
            $objId | Should -BeGreaterThan 0

            # try to reread by Id
            $obj = Get-IdoitMappedObject -ObjId $objId -MappingName 'ServerMapped'
            $obj | Should -Not -BeNullOrEmpty
            $obj.ComputerName | Should -Be $nameTestObject
            $obj.Beschreibung | Should -Be 'This is a test server'
            $obj.Tag | Should -Be 'TestTag'
            $obj.MemoryMBTitles | Should -Be @('8 GB', '16 GB')

            # Try to reread by Title
            $obj = Get-IdoitMappedObject -Title "$nameTestObject" -MappingName 'ServerMapped'
            $obj | Should -Not -BeNullOrEmpty
            $obj.ObjId | Should -Be $objId
        }
    }
}