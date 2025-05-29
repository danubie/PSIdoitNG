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

Describe 'Show-IdoitObjectTree' {
    BeforeAll {
        $pathOutput = 'Testdrive:/show-output.txt'
    }
    BeforeEach {
        Remove-Item -Path $pathOutput -ErrorAction SilentlyContinue
    }
    AfterAll {
        Remove-Item -Path $pathOutput -ErrorAction SilentlyContinue
    }
    It 'Should write to host' {
        Show-IdoitObjectTree -Id 37 > $pathOutput
    }
    It 'Should write to host' {
        Show-IdoitObjectTree -Id 37 -Style 'Json' > $pathOutput
        $null = Get-Content -Path $pathOutput -Raw | ConvertFrom-Json
    }
    It 'Should write to host' {
        Mock 'Get-Command' -ModuleName 'PSIdoitNG' -MockWith {} -ParameterFilter { $Name -eq 'Format-SpectreJson' }
        Show-IdoitObjectTree -Id 37 -Style 'SpectreJson' > $pathOutput
        $null = Get-Content -Path $pathOutput -Raw | ConvertFrom-Json
    }
}