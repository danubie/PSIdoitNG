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
    . $testHelpersPath/MockData_cmbd_category_read.ps1
    . $testHelpersPath/MockData_idoit_constants_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue
}

Describe "Set-IdoItCategory" {
    BeforeAll {
        # return API call success
        Mock Invoke-RestMethod -ModuleName $Script:moduleName -MockWith {
            $body = $body | ConvertFrom-Json
            [PSCustomObject] @{
                id      = $body.id
                jsonrpc = '2.0'
                result  = @{
                    success = 'True'
                    message = "Category entry successfully saved. [This method is deprecated and will be removed in a feature release. Use 'cmdb.category.save' instead.]"
                }
            }
        } -ParameterFilter {
            (($body | ConvertFrom-Json).method) -eq 'cmdb.category.update'
        }
    }
    Context "Single value" {
        BeforeEach {
            Start-IdoitApiTrace
        }
        AfterAll {
            Stop-IdoitApiTrace
        }
        It "should set a single value" {
            $obj = Get-IdoItObject -Id 37
            $obj | Should -Not -BeNullOrEmpty
            $objTypeCatList = Get-IdoItObjectTypeCategory -Type $obj.Objecttype
            $objTypeCatList | Should -Not -BeNullOrEmpty
            $objCatList = Get-IdoItCategory -Id $obj.Id -Category 'C__CATS__PERSON'
            $objCatList | Should -Not -BeNullOrEmpty

            # change one value
            $objCatList[0].title = 'Test'
            $ret = Set-IdoItCategory -Id $obj.Id -Category 'C__CATS__PERSON' -Data @{title = 'Test'}
            # check API call
            $apiParams = $Global:IdoitApiTrace[-1].Request.params
            $apiParams.objId | Should -Be 37
            $apiParams.data.title | Should -Be 'Test'
            # check return value
            $ret | Should -Not -BeNullOrEmpty
        }
        It "should set multiple values" {
            $obj = Get-IdoItObject -Id 37
            $obj | Should -Not -BeNullOrEmpty
            $objTypeCatList = Get-IdoItObjectTypeCategory -Type $obj.Objecttype
            $objTypeCatList | Should -Not -BeNullOrEmpty
            $objCatList = Get-IdoItCategory -Id $obj.Id -Category 'C__CATS__PERSON'
            $objCatList | Should -Not -BeNullOrEmpty

            # change one value
            $objCatList[0].title = 'Test'
            $ret = Set-IdoItCategory -Id $obj.Id -Category 'C__CATS__PERSON' -Data @{title = 'TestTitle'; first_name = 'first_name'; last_name = 'last_name'}
            # check API call
            $apiParams = $Global:IdoitApiTrace[-1].Request.params
            $apiParams.objId | Should -Be 37
            $apiParams.data.title | Should -Be 'TestTitle'
            $apiParams.data.first_name | Should -Be 'first_name'
            $apiParams.data.last_name | Should -Be 'last_name'
            # check return value
            $ret | Should -Not -BeNullOrEmpty
        }
        It "should set mutlivalue attribute" {
            $obj = Get-IdoItObject -id 540
            $obj | Should -Not -BeNullOrEmpty
            $objTypeCatList = Get-IdoItObjectTypeCategory -Type $obj.Objecttype
            $objTypeCatList | Should -Not -BeNullOrEmpty
            $objCatList = Get-IdoItCategory -Id $obj.Id -Category 'C__CATG__MEMORY'
            $objCatList | Should -Not -BeNullOrEmpty
        }
    }
}
