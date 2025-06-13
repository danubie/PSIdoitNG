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
    . $testHelpersPath/MockData_cmdb_category_info_read.ps1
    . $testHelpersPath/MockData_cmdb_dialog.ps1
    . $testHelpersPath/MockData_idoit_constants_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}
AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe 'New-IdoitMappedObject' {
    BeforeEach {
        InModuleScope -ModuleName $script:moduleName {
            $Script:IdoitCategoryMaps = @{}
        }
    }

    It 'Creates a new Idoit object with the specified mapping' {
        Mock Invoke-RestMethod -ModuleName $script:moduleName -MockWith {
            $body = $body | ConvertFrom-Json
            [PSCustomObject] @{
                id      = $body.id
                jsonrpc = '2.0'
                result  = [PSCustomObject]@{
                    id      = 28            # new object ID: Return the one we have a mock for
                    success = 'True'
                    message = "Object successfully saved."
                }
            }
        } -ParameterFilter {
            (($body | ConvertFrom-Json).method) -eq 'cmdb.object.create'
        }
        Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
            # check request values: All properties in the simulated request param (except apikey) should be in the request
            # returns the simulated response with the same id as the request
            $requestBody = $body | ConvertFrom-Json
            $requestBody.params.object | Should -Be 28
            $requestBody.params.category | Should -Be 'C__CATS__PERSON'
            $requestBody.params.data.id | Should -Be $null           # because readonly
            $oneOfThemIsPresent = $requestBody.params.data.first_name -eq 'Max' -or $requestBody.params.data.last_name -eq 'Mustermann'
            $oneOfThemIsPresent | Should -Be $true
            # if we are here -> return response
            $simResponse = [PSCustomObject]@{
                id      = $requestBody.id
                jsonrpc = '2.0'
                result  = @{
                    success = 'True'
                    message = "Category entry successfully saved. [This method is deprecated and will be removed in a feature release. Use 'cmdb.category.save' instead.]"
                }
            }
            $simResponse
        } -ParameterFilter {
            $objBody = $body | ConvertFrom-Json
            Write-Output ($objBody.method -eq 'cmdb.category.save')
        }

        $mappingName = 'PersonMapped'
        $yamlPath = Join-Path $testHelpersPath 'SampleMapping.yaml'
        Register-IdoitCategoryMap -Path $yamlPath -Force

        $defaultObject = Get-IdoitMappedObjectFromTemplate -MappingName $mappingName
        $defaultObject.PSObject.Properties.Name | Should -Contain 'objId'
        $defaultObject.PSObject.Properties.Name | Should -Contain 'Firstname'
        $defaultObject.PSObject.Properties.Name | Should -Contain 'Lastname'

        $defaultObject.Firstname = 'Max'
        $defaultObject.Lastname = 'Mustermann'
        # we have to suppress the warning. The current Mocked object does not have an object with ID 1234
        $splatNewMappedObject = @{
            InputObject     = $defaultObject
            MappingName     = $mappingName
            IncludeProperty = @('Firstname', 'Lastname') # only these properties are set on creation
            WarningAction   = 'SilentlyContinue'
            WarningVariable = 'warn'
        }
        $newObject = New-IdoitMappedObject @splatNewMappedObject
        $newObject | Should -Not -BeNullOrEmpty
        # instead of checking the return value, we check the API request
        # 1 x create object, 2 x save (because currently I only can update 1 category attribute at a time)
        Assert-MockCalled -ModuleName $script:moduleName -CommandName 'Invoke-RestMethod' -ParameterFilter {
            $objBody = $body | ConvertFrom-Json
            Write-Output ($objBody.method -eq 'cmdb.object.create')
        } -Exactly 1 -Scope It
        Assert-MockCalled -ModuleName $script:moduleName -CommandName 'Invoke-RestMethod' -ParameterFilter {
            $objBody = $body | ConvertFrom-Json
            Write-Output ($objBody.method -eq 'cmdb.category.save')
        } -Exactly 2 -Scope It
    }
}