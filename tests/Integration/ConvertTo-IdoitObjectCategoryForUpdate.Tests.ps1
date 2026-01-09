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
Describe 'Integration ConvertTo-IdoitObjectCategoryForUpdate' -Tag 'Integration' -Skip:$isNotConnected {
    BeforeAll {
        & (Join-Path $testIntegrationHelpersPath Remove-PesterLeftOvers.ps1)
        Register-IdoitCategoryMap -Path (Join-Path -Path $testHelpersPath -ChildPath 'SampleMapping.yaml') -Force
    }
    AfterEach {
        & (Join-Path $testIntegrationHelpersPath Remove-PesterLeftOvers.ps1)
    }
    Context 'CustomObject' {
        It 'does not convert because no updateable properties are set' {
            InModuleScope -ScriptBlock {
                $mappingName = 'CustomObjectMapped'
                # $nameTestObject = "Pester $(Get-Date -Format 'yyyy-MM-dd hh:mm:ss') $(New-Guid)"
                $testObject = [PSCustomObject]@{
                    ComponentType = 'Job / Schnittstelle'
                }
                $splatConvert = @{
                    InputObject     = $testObject
                    MappingName     = $mappingName
                }
                $ret = ConvertTo-IdoitObjectCategoryForUpdate @splatConvert
                $ret | Should -BeOfType 'Hashtable'
                $ret.Keys.Count | Should -Be 0
            }
        }
        It 'Using include * converts popup with full popup object to title string' {
            InModuleScope -ScriptBlock {
                $mappingName = 'CustomObjectMapped'
                # $nameTestObject = "Pester $(Get-Date -Format 'yyyy-MM-dd hh:mm:ss') $(New-Guid)"
                $testObject = [PSCustomObject]@{
                    CustomProperty = [PSCustomObject]@{
                        id    = 85
                        title = 'Job / Schnittstelle'
                    }
                }
                $splatConvert = @{
                    InputObject     = $testObject
                    MappingName     = $mappingName
                    IncludeProperty = '*'
                }
                $ret = ConvertTo-IdoitObjectCategoryForUpdate @splatConvert
                $ret | Should -BeOfType 'Hashtable'
                $ret.C__CATG__CUSTOM_FIELDS_KOMPONENTE['f_popup_c_17289168067044910'] | Should -Be 'Job / Schnittstelle'
            }
        }
        It 'Using include propertyNames mapped to same category value only once' {
            InModuleScope -ScriptBlock {
                $mappingName = 'CustomObjectMapped'
                # $nameTestObject = "Pester $(Get-Date -Format 'yyyy-MM-dd hh:mm:ss') $(New-Guid)"
                $testObject = [PSCustomObject]@{
                    CustomProperty = [PSCustomObject]@{
                        id    = 85
                        title = 'Job / Schnittstelle'
                    }
                }
                $splatConvert = @{
                    InputObject     = $testObject
                    MappingName     = $mappingName
                    IncludeProperty = 'ComponentType','CustomProperty'
                }
                $ret = ConvertTo-IdoitObjectCategoryForUpdate @splatConvert
                $ret | Should -BeOfType 'Hashtable'
                $ret.C__CATG__CUSTOM_FIELDS_KOMPONENTE['f_popup_c_17289168067044910'] | Should -Be 'Job / Schnittstelle'
                $ret.Keys.Count | Should -Be 1                  # Mapping the same category value twice should still only result in one category being created
            }
        }
    }
    It 'converts more than one category' {
        InModuleScope -ScriptBlock {
            $mappingName = 'ServerMapped'
            $testObject = [PSCustomObject]@{
                ComputerName            = 'pester-test-server'
                BeschreibungUndefined   = 'Test server for Pester'
                MemoryGB                = 16
                CategoryAsArray         = 16384
            }
            $splatConvert = @{
                InputObject     = $testObject
                MappingName     = $mappingName
                IncludeProperty = 'ComputerName','BeschreibungUndefined','CategoryAsArray'
            }
            $ret = ConvertTo-IdoitObjectCategoryForUpdate @splatConvert
            $ret | Should -BeOfType 'Hashtable'
            $ret.C__CATG__GLOBAL.title | Should -Be 'pester-test-server'
            $ret.C__CATG__GLOBAL.description | Should -Be 'Test server for Pester'
            $ret.C__CATG__MEMORY.CategoryAsArray | Should -BeNullOrEmpty   # currently no support for script properties
            $ret.Properties.Name | Should -Not -Contain 'Tag'           # is not in the property of the object
            $ret.Properties.Name | Should -Not -Contain 'MemoryGB'      # is excluded because is a script property
        }
    }
}