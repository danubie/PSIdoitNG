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
            ($mapserver.Mapping | Where-Object category -eq C__CATG__GLOBAL).propertylist[1].Update = $true
            $prevValues.Kommentar = 'This is a test'
            $result = Set-IdoitMappedObject -Id $objId -InputObject $prevValues -PropertyMap $mapServer
            $result | Should -BeTrue
            # verify that a request was sent
            Assert-MockCalled -CommandName Invoke-RestMethod -ModuleName PSIdoitNG -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            } -Exactly 1 -Scope It
        }
    }
    Context 'Check Include/Exclude properties' {
        BeforeAll {
            Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
                $requestBody = $body | ConvertFrom-Json
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
            # Mark 2 properties as updateable
            $map = $mapServer.PSObject.copy()
            $map.Mapping[0].PropertyList[1].Update = $true      # Kommentar
            $map.Mapping[0].PropertyList[2].Update = $true      # BeschreibungUndefined
            # prepare the test object
            $objId = 540
            $prevValues = Get-IdoitMappedObject -Id $objId -PropertyMap $map
            $prevValues | Should -Not -BeNullOrEmpty
        }
        It 'Should Call Invoke-RestMethod 1 time (Update Kommentar)' {
            $prevValues.Kommentar = 'This is a test'
            $result = Set-IdoitMappedObject -Id $objId -InputObject $prevValues -PropertyMap $map
            $result | Should -BeTrue
            # verify that a request was sent
            Assert-MockCalled -CommandName Invoke-RestMethod -ModuleName PSIdoitNG -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            } -Exactly 1 -Scope It
        }
        It 'Should Call Invoke-RestMethod 2 times (Update Kommentar and BeschreibungUndefined)' {
            $prevValues.Kommentar = 'This is a test'
            $prevValues.BeschreibungUndefined = 'This is a test'
            $result = Set-IdoitMappedObject -Id $objId -InputObject $prevValues -PropertyMap $map
            $result | Should -BeTrue
            # verify that a request was sent
            Assert-MockCalled -CommandName Invoke-RestMethod -ModuleName PSIdoitNG -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            } -Exactly 2 -Scope It
        }
        It 'Should not call Invoke-RestMethod 1 times (Update Kommentar and BeschreibungUndefined, but exclude Kommentar)' {
            $prevValues.Kommentar = 'This is a test'
            $prevValues.BeschreibungUndefined = 'This is a test'
            $result = Set-IdoitMappedObject -Id $objId -InputObject $prevValues -PropertyMap $map -ExcludeProperty 'Kommentar'
            $result | Should -BeTrue
            # verify that no request was sent
            Assert-MockCalled -CommandName Invoke-RestMethod -ModuleName PSIdoitNG -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            } -Exactly 1 -Scope It
        }
        It 'Should not call Invoke-RestMethod 2 times (Update Kommentar, include CDate (but is readonly), exclude BeschreibungUndefined)' {
            $prevValues.Kommentar = 'This is a test'
            $prevValues.BeschreibungUndefined = 'This is a test, but should not be updated'
            $prevValues.CDate = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
            $splatSet = @{
                Id           = $objId
                InputObject  = $prevValues
                PropertyMap  = $map
                IncludeProperty = 'CDate'
                ExcludeProperty = 'BeschreibungUndefined'
            }
            $result = Set-IdoitMappedObject @splatSet
            $result | Should -BeTrue
            # verify that a request was sent
            Assert-MockCalled -CommandName Invoke-RestMethod -ModuleName PSIdoitNG -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            } -Exactly 1 -Scope It
        }
        It 'Should allow update of arrays type "dialog" or "dialog_plus"' {
            $path = Join-Path -Path $testHelpersPath -ChildPath 'ObjectWithCustomCatageory.yaml'
            $mapComponent = ConvertFrom-MappingFile -Path $path
            $mapComponent | Should -Not -BeNullOrEmpty

            $objId = 4675
            $prevObj = Get-IdoitMappedObject -Id $objId -PropertyMap $mapComponent
            $prevObj.JobName | Should -Be 'server540'
            $prevObj.KomponentenTyp | Should -Be @('Job / Schnittstelle')
            $prevObj.Technologie | Should -Be @('SQL Server','Biztalk')

            # allow update of "Technologie" which is a dialog_plus type
            $mapUpdate = $mapComponent.PSObject.copy()
            $prevObj.Technologie = @('SQL Server','Biztalk','Openshift')
            $splatWarnOff = @{
                WarningAction = 'SilentlyContinue'  # suppress warnings
                WarningVariable = 'warn'
            }
            $result = Set-IdoitMappedObject -Id $objId -InputObject $prevObj -PropertyMap $mapUpdate -IncludeProperty Technologie @splatWarnOff
            $result | Should -BeTrue
            $warn | Should -Be 'No categories found for object type C__CATG__CONTACT(93)'
            # verify that a request was sent
            Assert-MockCalled -CommandName Invoke-RestMethod -ModuleName PSIdoitNG -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            } -Exactly 1 -Scope It

            # check if the object was updated - returns OK in Only working in integration environment
            # Warning: There is currently no mocked data for CONTACT object type
            $result = Get-IdoitMappedObject -Id $objId -PropertyMap $mapComponent
            $result         | Should -Not -BeNullOrEmpty
            $result.JobName | Should -Be 'server540'
            $result.KomponentenTyp | Should -Be @('Job / Schnittstelle')
            $result.Technologie | Should -Be @('SQL Server','Biztalk')
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
            Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
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
            $objId = 37
            $prevValues = Get-IdoitMappedObject -Id $objId -PropertyMap $mapUser
            $prevValues | Should -Not -BeNullOrEmpty
            $prevValues.FirstName = 'Gustav'
            $prevValues.LastName = 'Gans'
            $result = Set-IdoitMappedObject -Id $objId -InputObject $prevValues -PropertyMap $mapUser -WhatIf
            $result | Should -BeTrue
            # verify that no request was sent
            Assert-MockCalled -CommandName Invoke-RestMethod -ModuleName PSIdoitNG -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            } -Exactly 0 -Scope It
        }
    }
}