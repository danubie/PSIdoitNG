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

Describe 'Integration Get-IdoitMappedObject' -Tag 'Integration' -Skip:$isNotConnected {
        BeforeAll {
        & (Join-Path $testIntegrationHelpersPath Remove-PesterLeftOvers.ps1)
        Register-IdoitCategoryMap -Path (Join-Path -Path $testHelpersPath -ChildPath 'SampleMapping.yaml') -Force
    }
    AfterAll {
        & (Join-Path $testIntegrationHelpersPath Remove-PesterLeftOvers.ps1)
    }
    Context 'My test object' {
        BeforeAll {
            Register-IdoitCategoryMap -Path (Join-Path -Path $testHelpersPath -ChildPath 'SampleMapping.yaml')
        }
        It 'Get mapped object by ObjId' {
            $ObjId = 540
            $mappedObj = Get-IdoitMappedObject -ObjId $ObjId -MappingName 'ServerMapped'
            $mappedObj | Should -BeOfType 'PSCustomObject'
            $mappedObj.Id | Should -Be $ObjId
            $mappedObj.ObjId | Should -Be $ObjId
            $mappedObj.ComputerName | Should -Not -BeNullOrEmpty       # Title mapped to ComputerName
            Get-Date ($mappedObj.CDate) | Should -BeOfType 'DateTime'
            Get-Date ($mappedObj.EDate) | Should -BeOfType 'DateTime'
            $mappedObj.CategoryAsArray.Count | Should -BeGreaterThan 0
            $mappedObj.CategoryAsArray[0].Id | Should -BeGreaterThan 0
            $mappedObj.CategoryAsArray[0].Category | Should -Be 'C__CATG__MEMORY'
        }

        It 'Get mapped object by Title' {
            $objId = 540
            $compareObject = Get-IdoitMappedObject -ObjId $objId -MappingName 'ServerMapped'
            $title = $compareObject.ComputerName
            $mappedObj = Get-IdoitMappedObject -Title $title -MappingName 'ServerMapped'
            $mappedObj | Should -BeOfType 'PSCustomObject'
            $mappedObj.ComputerName | Should -Be $title
            $mappedObj.objId | Should -Be $objId
        }
    }
}