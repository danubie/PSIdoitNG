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
Describe 'Compare-ObjectProperty' {
    BeforeAll {
        $obj1 = [PSCustomObject]@{ Name = "Alice"; Age = 30; City = "New York"; Property1 = "Value1" }
        $obj2 = [PSCustomObject]@{ Name = "Alice"; Age = 32; City = "Los Angeles"; Property2 = "Value2" }
    }
    It 'compares two objects and shows differences' {
        $result = Compare-ObjectProperty -ReferenceObject $obj1 -DifferenceObject $obj2
        $result | Should -Not -BeNullOrEmpty
        $result.Count | Should -Be 4

        $ageDiff = $result | Where-Object { $_.Name -eq 'Age' }
        $ageDiff.ReferenceValue | Should -Be 30
        $ageDiff.DifferenceValue | Should -Be 32
        $ageDiff.SideIndicator | Should -Be '<>'

        $cityDiff = $result | Where-Object { $_.Name -eq 'City' }
        $cityDiff.ReferenceValue | Should -Be 'New York'
        $cityDiff.DifferenceValue | Should -Be 'Los Angeles'
        $cityDiff.SideIndicator | Should -Be '<>'

        $prop1Diff = $result | Where-Object { $_.Name -eq 'Property1' }
        $prop1Diff.ReferenceValue | Should -Be 'Value1'
        $prop1Diff.DifferenceValue | Should -BeNullOrEmpty
        $prop1Diff.SideIndicator | Should -Be '<='

        $prop2Diff = $result | Where-Object { $_.Name -eq 'Property2' }
        $prop2Diff.ReferenceValue | Should -BeNullOrEmpty
        $prop2Diff.DifferenceValue | Should -Be 'Value2'
        $prop2Diff.SideIndicator | Should -Be '=>'
    }
    It 'compares two objects and includes equal properties' {
        $result = Compare-ObjectProperty -ReferenceObject $obj1 -DifferenceObject $obj2 -IncludeEqual
        $result | Should -Not -BeNullOrEmpty
        $result.Count | Should -Be 5

        $nameDiff = $result | Where-Object { $_.Name -eq 'Name' }
        $nameDiff.ReferenceValue | Should -Be 'Alice'
        $nameDiff.DifferenceValue | Should -Be 'Alice'
        $nameDiff.SideIndicator | Should -Be '=='
    }
    It 'compares two objects with specified property list' {
        $result = Compare-ObjectProperty -ReferenceObject $obj1 -DifferenceObject $obj2 -PropertyList @('Name', 'Age')
        $result | Should -Not -BeNullOrEmpty
        $result.Count | Should -Be 1 -Because 'only Age is different in the specified property list'

        $result.Name | Should -Not -Contain 'City' -Because 'City is not in the specified property list'
        $result.Name | Should -Not -Contain 'Name' -Because 'Name is equal and not included without -IncludeEqual'

        $ageDiff = $result | Where-Object { $_.Name -eq 'Age' }
        $ageDiff.ReferenceValue | Should -Be 30
        $ageDiff.DifferenceValue | Should -Be 32
        $ageDiff.SideIndicator | Should -Be '<>'
    }
    It 'returns empty when no differences and no IncludeEqual' {
        $obj3 = [PSCustomObject]@{ Name = "Bob"; Age = 25 }
        $obj4 = [PSCustomObject]@{ Name = "Bob"; Age = 25 }

        $result = Compare-ObjectProperty -ReferenceObject $obj3 -DifferenceObject $obj4
        $result | Should -BeNullOrEmpty
    }
    It 'complex objects difference' {
        $obj5 = [PSCustomObject]@{ Name = "Charlie"; Details = [PSCustomObject]@{ Height = 180; Weight = 75 } }
        $obj6 = [PSCustomObject]@{ Name = "Charlie"; Details = [PSCustomObject]@{ Height = 182; Weight = 75 } }

        $result = Compare-ObjectProperty -ReferenceObject $obj5 -DifferenceObject $obj6
        $result | Should -Not -BeNullOrEmpty
        $result.Count | Should -Be 1

        $detailsDiff = $result | Where-Object { $_.Name -eq 'Details' }
        $detailsDiff.ReferenceValue | Should -Be $obj5.Details
        $detailsDiff.DifferenceValue | Should -Be $obj6.Details
        $detailsDiff.SideIndicator | Should -Be '<>'
    }
    It 'complex objects are property equal' {
        $obj7 = [PSCustomObject]@{ Name = "Diana"; Details = [PSCustomObject]@{ Height = 165; Weight = 60 } }
        $obj8 = [PSCustomObject]@{ Name = "Diana"; Details = [PSCustomObject]@{ Height = 165; Weight = 60 } }

        $result = Compare-ObjectProperty -ReferenceObject $obj7 -DifferenceObject $obj8 -IncludeEqual
        $result | Should -Not -BeNullOrEmpty
        $result.Count | Should -Be 2

        $detailsDiff = $result | Where-Object { $_.Name -eq 'Details' }
        $detailsDiff.ReferenceValue | Should -Be $obj7.Details
        $detailsDiff.DifferenceValue | Should -Be $obj8.Details
        $detailsDiff.SideIndicator | Should -Be '=='
    }
}