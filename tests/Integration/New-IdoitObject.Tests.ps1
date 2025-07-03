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
Describe 'Integration New-IdoitObject' -Tag 'Integration' -Skip:$isNotConnected {
    BeforeAll {
        & (Join-Path $testIntegrationHelpersPath Remove-PesterLeftOvers.ps1)
    }
    AfterAll {
        & (Join-Path $testIntegrationHelpersPath Remove-PesterLeftOvers.ps1)
    }
    It 'Creates a server object without categories' {
        $nameTestObject = "Pester $(Get-Date -Format 'yyyy-MM-dd hh:mm:ss') $(New-Guid)"
        $ret = New-IdoitObject -Name $nameTestObject -ObjectType "C__OBJTYPE__SERVER"
        $ret | Should -Not -BeNullOrEmpty
        $ret.ObjId | Should -BeGreaterThan 0
        $ret.success | Should -BeTrue
    }
    It 'Creates a server object including categories' {
        $nameTestObject = "Pester $(Get-Date -Format 'yyyy-MM-dd hh:mm:ss') $(New-Guid)"
        $categories = @{
            'C__CATG__GLOBAL' = [PSCustomObject]@{ title = $nameTestObject }
            'C__CATG__OPERATING_SYSTEM' = @([PSCustomObject]@{description = "Windows Server 2022"})
        }
        $ret = New-IdoitObject -Name $nameTestObject -ObjectType "C__OBJTYPE__SERVER" -Category $categories
        $ret = $ret
    }
    Context 'Error cases' {
        It 'Error when creating a server object with the same name' {
            $nameTestObject = "Pester $(Get-Date -Format 'yyyy-MM-dd hh:mm:ss') $(New-Guid)"
            $categories = @{
                'C__CATG__GLOBAL' = [PSCustomObject]@{ title = $nameTestObject }
                'C__CATG__OPERATING_SYSTEM' = @([PSCustomObject]@{description = "Windows Server 2022"})
            }
            $null = New-IdoitObject -Name $nameTestObject -ObjectType "C__OBJTYPE__SERVER" -Category $categories -ErrorVariable err  # should give no error
            $err | Should -BeNullOrEmpty
            { New-IdoitObject -Name $nameTestObject -ObjectType "C__OBJTYPE__SERVER" -Category $categories -ErrorAction Stop } | Should -Throw "An object with the name '$nameTestObject' already exists*"
        }
        It 'Creates a server object but issues a error for category INVALID_CATEGORY' {
            $nameTestObject = "Pester $(Get-Date -Format 'yyyy-MM-dd hh:mm:ss') $(New-Guid)"
            $categories = @{
                'C__CATG__GLOBAL' = [PSCustomObject]@{ title = $nameTestObject }
                'INVALID_CATEGORY' = @([PSCustomObject]@{description = "Invalid Category"})
            }
            { New-IdoitObject -Name $nameTestObject -ObjectType "C__OBJTYPE__SERVER" -Category $categories -ErrorAction Stop } | Should -Throw "error creating category*"
        }
    }
}