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
    . $testHelpersPath/MockData_idoit_constants_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}
AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe 'Set-IdoitMappedObject' {
    BeforeAll {
        . $testHelpersPath/SampleMapping.ps1
        $mapUser = $PersonMapped
        $mapServer = $ServerMapped
    }
    Context 'MyUser' {
        It 'Should change nothing MyUser' {
            Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
            } -ParameterFilter {
            (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            }

            $objId = 37
            $prevValues = Get-IdoitMappedObject -Id $objId -PropertyMap $mapUser
            $prevValues | Should -Not -BeNullOrEmpty

            $result = Set-IdoitMappedObject -Id $ObjId -InputObject $prevValues -PropertyMap $mapUser
            $result | Should -BeTrue
            # verify that no request was sent
            Assert-MockCalled -CommandName Invoke-RestMethod -ModuleName PSIdoitNG -ParameterFilter {
            (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            } -Exactly 0 -Scope It
        }
        It 'Should update MyUser:Name but notnot changed MyUser:Admin; Id is readonly' {
            Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
                # check request values: All properties in the simulated request param (except apikey) should be in the request
                # returns the simulated response with the same id as the request
                $requestBody = $body | ConvertFrom-Json
                $requestBody.params.object | Should -Be 37
                $requestBody.params.category | Should -Be 'C__CATS__PERSON'
                $requestBody.params.data.first_name | Should -Be 'Donald'
                $requestBody.params.data.last_name | Should -Be $null            # because readonly
                $requestBody.params.data.title | Should -Be $null                # because readonly
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
            (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            }

            $thisMap = $mapUser.PSObject.copy()
            $thisMap.Mapping[0].PropertyList[1].Update = $true      # Firstname
            $thisMap.Mapping[0].PropertyList[2].Update = $false     # Lastname
            $objId = 37
            $prevValues = Get-IdoitMappedObject -Id $objId -PropertyMap $mapUser
            $prevValues | Should -Not -BeNullOrEmpty

            $prevValues.FirstName = 'Donald'
            $prevValues.LastName = 'Duck'

            $result = Set-IdoitMappedObject -Id $objId -InputObject $prevValues -PropertyMap $mapUser
            $result | Should -BeTrue
            # verify that a request was sent
            Assert-MockCalled -CommandName Invoke-RestMethod -ModuleName PSIdoitNG -ParameterFilter {
            (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            } -Exactly 1 -Scope It
        }
        It 'Should update MyUser:Name+Admin; Id is readonly' {
            Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
                # check request values: All properties in the simulated request param (except apikey) should be in the request
                # returns the simulated response with the same id as the request
                $requestBody = $body | ConvertFrom-Json
                $requestBody.params.object | Should -Be 37
                $requestBody.params.category | Should -Be 'C__CATS__PERSON'
                $requestBody.params.data.id | Should -Be $null           # because readonly
                $oneOfThemIsPresent = $requestBody.params.data.first_name -eq 'Gustav' -or $requestBody.params.data.last_name -eq 'Gans'
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
            (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            }

            $thisMap = $mapUser.PSObject.copy()
            $thisMap.Mapping[0].PropertyList[1].Update = $true      # first_name is updateable
            $thisMap.Mapping[0].PropertyList[2].Update = $true      # last_name is updateable
            $objId = 37
            $prevValues = Get-IdoitMappedObject -Id $objId -PropertyMap $mapUser
            $prevValues | Should -Not -BeNullOrEmpty

            $prevValues.FirstName = 'Gustav'
            $prevValues.LastName = 'Gans'

            $result = Set-IdoitMappedObject -Id $objId -InputObject $prevValues -PropertyMap $mapUser
            $result | Should -Not -BeNullOrEmpty
            # verify that a request was sent
            Assert-MockCalled -CommandName Invoke-RestMethod -ModuleName PSIdoitNG -ParameterFilter {
            (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            } -Exactly 2 -Scope It
        }
    }
    Context 'MyServer' {
        BeforeAll {
            $Global:ApiTraceVariable = @()
            Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
                $body = $body | ConvertFrom-Json
                $response = [PSCustomObject]@{
                    id      = $body.id
                    jsonrpc = '2.0'
                    result  = @{
                        success = 'True'
                        message = "Category entry successfully saved. [This method is deprecated and will be removed in a feature release. Use 'cmdb.category.save' instead.]"
                    }
                }
                $response
            } -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
                }
        }
        AfterAll {
            $Global:ApiTraceVariable = $null
        }
        It 'Should set object mapped MyServer' {
            $objId = 540
            $prevValues = Get-IdoitMappedObject -Id $objId -PropertyMap $mapServer
            $result = Set-IdoitMappedObject -Id $objId -InputObject $prevValues -PropertyMap $mapServer
            $result | Should -BeTrue
            # verify that nothing hat changed, so no request was sent
            Assert-MockCalled -CommandName Invoke-RestMethod -ModuleName PSIdoitNG -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            } -Exactly 0 -Scope It

            # enable update of property "Kommentar" and set a value
            ($mapserver.Mapping | ? category -eq C__CATG__GLOBAL).propertylist[1].Update = $true
            $prevValues.Kommentar = 'This is a test'
            $result = Set-IdoitMappedObject -Id $objId -InputObject $prevValues -PropertyMap $mapServer
            $result | Should -BeTrue
            # verify that a request was sent
            Assert-MockCalled -CommandName Invoke-RestMethod -ModuleName PSIdoitNG -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            } -Exactly 1 -Scope It
        }
    }
    <#
        Testcaseses to be done
        - Test with a non-existing object
        - Test with a non-existing object type
        - Test with a non-existing category
        - Test with a non-existing property
        - Test with readonly property (default is readonly)
        - Test with a updateable property
        - Test with a calculated property
        - Test with a calculated property with a scriptblock
    #>
    Context 'Special cases' {
        It '-Whatif should not call Update' {
            Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {} -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            }
            $objId = 37
            $prevValues = Get-IdoitMappedObject -Id $objId -PropertyMap $mapUser
            $prevValues | Should -Not -BeNullOrEmpty
            $prevValues.Name = 'Donald Duck'
            $prevValues.Admin = 'Someone'
            $result = Set-IdoitMappedObject -Id $objId -InputObject $prevValues -PropertyMap $mapUser -WhatIf
            $result | Should -BeTrue
            # verify that no request was sent
            Assert-MockCalled -CommandName Invoke-RestMethod -ModuleName PSIdoitNG -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            } -Exactly 0 -Scope It
        }
    }
}