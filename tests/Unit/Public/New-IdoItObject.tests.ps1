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
    # . $testHelpersPath/Mockdata_cmdb_objects_read.ps1
    . $testHelpersPath/MockData_Cmdb_objects_read.ps1
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

Describe "New-IdoItObject" {
    BeforeAll {
        Start-IdoitApiTrace
    }
    AfterAll {
        Stop-IdoitApiTrace
    }
    Context "Create new Object" {
        BeforeAll {
            Mock Search-IdoItObject -ModuleName $script:moduleName -MockWith {
                # return nothing, so no object with this name exists
            }
        }
        It "Should create an object with the given name and type" {
            Mock Invoke-RestMethod -ModuleName $script:moduleName -MockWith {
                $body = $body | ConvertFrom-Json
                [PSCustomObject] @{
                    id      = $body.id
                    jsonrpc = '2.0'
                    result  = [PSCustomObject]@{
                        id      = 1234
                        success = 'True'
                        message = "Object successfully saved."
                    }
                }
            } -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.object.create'
            }

            $ret = New-IdoItObject -Name 'Test Object' -ObjectType 'C__OBJTYPE__SERVER' -ErrorAction SilentlyContinue
            $ret | Should -Not -BeNullOrEmpty
            $ret.ObjId | Should -Be 1234

            $apiRequest = $Global:IdoitApiTrace[-1].Request
            $apiRequest.method | Should -Be 'cmdb.object.create'
            $apiRequest.params.type | Should -Be 'C__OBJTYPE__SERVER'
            $apiRequest.params.title | Should -Be 'Test Object'
            $apiRequest.params.keys | Should -Not -Contain 'category'
            $apiRequest.params.keys | Should -Not -Contain 'categories'
        }
        It "Should create an object with the given name, type and 2 categories" {
            Mock Invoke-RestMethod -ModuleName $script:moduleName -MockWith {
                $body = $body | ConvertFrom-Json
                [PSCustomObject] @{
                    id      = $body.id
                    jsonrpc = '2.0'
                    result  = [PSCustomObject]@{
                        id      = 1234
                        success = 'True'
                        message = "Object successfully saved."
                    }
                }
            } -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.object.create'
            }

            $ret = New-IdoItObject -Name 'Test Object' -ObjectType 'C__OBJTYPE__SERVER' -Category @{
                'C__CATG__GLOBAL' = @{Type = 'General'}
                'C__CATG__GLOBAL-type' = @{Type = 'Type'}
            } -ErrorAction SilentlyContinue
            $ret | Should -Not -BeNullOrEmpty
            $ret.ObjId | Should -Be 1234

            $apiRequest = $Global:IdoitApiTrace[-1].Request
            $apiRequest.method | Should -Be 'cmdb.object.create'
            $apiRequest.params.type | Should -Be 'C__OBJTYPE__SERVER'
            $apiRequest.params.title | Should -Be 'Test Object'
            $apiRequest.params.keys | Should -Contain 'categories'
            $apiRequest.params.categories.'C__CATG__GLOBAL' | Should -Not -BeNullOrEmpty
            $apiRequest.params.categories.'C__CATG__GLOBAL'.Type | Should -Be 'General'
            $apiRequest.params.categories.'C__CATG__GLOBAL-type' | Should -Not -BeNullOrEmpty
            $apiRequest.params.categories.'C__CATG__GLOBAL-type'.Type | Should -Be 'Type'
        }
    }
    Context "Duplicate Object Name" {
        BeforeAll {
            Mock Search-IdoItObject -ModuleName $script:moduleName -MockWith {
                $Mockdata_cmdb_objects_read[0].Response          # don't care about the content, just return the first object is enough
            }
        }
        It "Should not create an object" {
            Mock Invoke-IdoIt -ModuleName $script:moduleName -MockWith {} -ParameterFilter {
                $method -eq 'cmdb.object.create'
            }

            # Mock SearchIdiotObject to return an object -> this should trigger the error
            $ret = New-IdoItObject -Name 'Test Object' -ObjectType 'C__OBJTYPE__SERVER' -ErrorAction SilentlyContinue
            $ret | Should -BeNullOrEmpty

            { New-IdoItObject -Name 'Test Object' -ObjectType 'C__OBJTYPE__SERVER' -ErrorAction Stop } | Should -Throw "*already exists*"
            # till now, no create object call should be made
            Assert-MockCalled -ModuleName $script:moduleName -CommandName 'Invoke-IdoIt' -Exactly 0 -ParameterFilter {
                $method -eq 'cmdb.object.create'
            }
        }
        It "Should create an object, because AllowDuplicates is set" {
            Mock Invoke-RestMethod -ModuleName $script:moduleName -MockWith {
                $body = $body | ConvertFrom-Json
                [PSCustomObject] @{
                    id      = $body.id
                    jsonrpc = '2.0'
                    result  = [PSCustomObject]@{
                        id      = 1234
                        success = 'True'
                        message = "Object successfully saved."
                    }
                }
            } -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.object.create'
            }

            $ret = New-IdoItObject -Name 'Test Object' -ObjectType 'C__OBJTYPE__SERVER' -AllowDuplicates
            $ret | Should -Not -BeNullOrEmpty
            Assert-MockCalled -ModuleName $script:moduleName -CommandName 'Invoke-RestMethod' -Exactly 1 -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.object.create'
            }
        }
    }
}
