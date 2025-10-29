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

Describe 'Integration Set-IdoitMappedObject' -Tag 'Integration' -Skip:$isNotConnected {
        BeforeAll {
        & (Join-Path $testIntegrationHelpersPath Remove-PesterLeftOvers.ps1)
        Register-IdoitCategoryMap -Path (Join-Path -Path $testHelpersPath -ChildPath 'SampleMapping.yaml') -Force
    }
    AfterAll {
        & (Join-Path $testIntegrationHelpersPath Remove-PesterLeftOvers.ps1)
    }
    Context 'PERSON' {
        It 'Updates a mapped PERSON object by setting cmdb_status directly via mappped property CMDBStatus' {
            # create the test object first
            $nameTestObject = "Pester $(Get-Date -Format 'yyyy-MM-dd hh:mm:ss') $(New-Guid)"
            $object = [PSCustomObject]@{
                FirstName = 'John'
                LastName  = $nameTestObject
                CmdbStatus = 10             # Initial status 'inoperative'
            }
            $objId = New-IdoitMappedObject -InputObject $object -MappingName 'PersonMapped' -Title 'Ignored'
            Write-Host "Created new object with Id: $($objId)" -ForegroundColor Cyan
            $objId | Should -BeGreaterThan 0

            # try to reread by Id
            $obj = Get-IdoitMappedObject -ObjId $objId -MappingName 'PersonMapped'
            $obj | Should -Not -BeNullOrEmpty
            $obj.FirstName | Should -Be 'John'
            $obj.LastName | Should -Be $nameTestObject
            $obj.CmdbStatus.Id | Should -Be 10                  # the mapping returns an object here with all attributes
            $obj.CmdbStatus.Title | Should -Be 'inoperative'
            $obj.CMDBStatusTitle | Should -Be 'inoperative'     # additional mapped property just returning the title

            # now update the object
            $object.CmdbStatus = 6  # Change status to 'active'
            Set-IdoitMappedObject -InputObject $object -ObjId $objId -MappingName 'PersonMapped' -IncludeProperty 'CmdbStatus' -WhatIf:$false

            # try to reread by Id
            $obj = Get-IdoitMappedObject -ObjId $objId -MappingName 'PersonMapped'
            $obj | Should -Not -BeNullOrEmpty
            $obj.FirstName | Should -Be 'John'
            $obj.LastName | Should -Be $nameTestObject
            $obj.CmdbStatus.Id | Should -Be 6
            $obj.CMDBStatusTitle | Should -Be 'in operation'
        }
        It 'Updates a mapped PERSON object by setting cmdb_status indirectly via mapped property cmdb_status.title' {
            # this is different to usual setting of a single property value. Reason: It is a dialog field, which requires the id od title assigned to it for update.
            # create the test object first
            $nameTestObject = "Pester $(Get-Date -Format 'yyyy-MM-dd hh:mm:ss') $(New-Guid)"
            $createdObject = [PSCustomObject]@{
                FirstName = 'John'
                LastName  = $nameTestObject
                CmdbStatus = 10             # Initial status 'inoperative'
            }
            $objId = New-IdoitMappedObject -InputObject $createdObject -MappingName 'PersonMapped' -Title 'Ignored'
            Write-Host "Created new object with Id: $($objId)" -ForegroundColor Cyan
            $objId | Should -BeGreaterThan 0

            # try to reread by Id
            $obj = Get-IdoitMappedObject -ObjId $objId -MappingName 'PersonMapped'
            $obj | Should -Not -BeNullOrEmpty
            $obj.FirstName | Should -Be 'John'
            $obj.LastName | Should -Be $nameTestObject
            $obj.CmdbStatus.Id | Should -Be 10                  # the mapping returns an object here with all attributes
            $obj.CmdbStatus.Title | Should -Be 'inoperative'
            $obj.CMDBStatusTitle | Should -Be 'inoperative'     # additional mapped property just returning the title

            # now update the object
            $obj.CmdbStatusTitle = 'in operation'  # Change status to 'active'
            Set-IdoitMappedObject -InputObject $obj -ObjId $objId -MappingName 'PersonMapped' -IncludeProperty 'CmdbStatusTitle' -WhatIf:$false

            # try to reread by Id
            $obj = Get-IdoitMappedObject -ObjId $objId -MappingName 'PersonMapped'
            $obj | Should -Not -BeNullOrEmpty
            $obj.FirstName | Should -Be 'John'
            $obj.LastName | Should -Be $nameTestObject
            $obj.CmdbStatus.Id | Should -Be 6
            $obj.CMDBStatusTitle | Should -Be 'in operation'
        }
    }
}