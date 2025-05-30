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
    . $testHelpersPath/MockData_Cmdb_dialog.ps1
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
                    entry = $body.params.data.Entry
                }
            }
        } -ParameterFilter {
            (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
        }
        Start-IdoitApiTrace
    }
    AfterAll {
        Stop-IdoitApiTrace
    }
    Context "Single value" {
        BeforeAll {
            $obj = Get-IdoItObject -Id 37
            $obj | Should -Not -BeNullOrEmpty
            $objCatList = Get-IdoItCategory -Id $obj.Id -Category 'C__CATS__PERSON'
            $objCatList | Should -Not -BeNullOrEmpty
        }
        BeforeEach {
            # reset the global variable
            $Global:IdoitApiTrace = @()
        }
        It "should set a single value" {
            # change one value
            $objCatList[0].title = 'Test'
            $ret = Set-IdoItCategory -Id $obj.Id -Category 'C__CATS__PERSON' -Data @{title = 'Test'}
            # check API call
            $reqParams = $Global:IdoitApiTrace[-1].Request.params
            $reqParams.object | Should -Be 37               # remember: this time the object id is passed as "object" (not objId!)
            $reqParams.data.title | Should -Be 'Test'
            # check return value
            $ret.Success | Should -BeTrue
        }
        It "should set multiple values" {
            # change one value
            $objCatList[0].title = 'Test'
            $ret = Set-IdoItCategory -Id $obj.Id -Category 'C__CATS__PERSON' -Data @{title = 'TestTitle'; first_name = 'first_name'; last_name = 'last_name'}
            # check API call
            $reqParams = $Global:IdoitApiTrace[-1].Request.params
            $reqParams.object | Should -Be 37
            $reqParams.data.title | Should -Be 'TestTitle'
            $reqParams.data.first_name | Should -Be 'first_name'
            $reqParams.data.last_name | Should -Be 'last_name'
            # check return value
            $ret | Should -Not -BeNullOrEmpty
        }
        It 'Should fail to set a "base" category if entry is set' {
            # change one value
            $objCatList[0].title = 'Test'
            $ret = Set-IdoItCategory -Id $obj.Id -Category 'C__CATS__PERSON' -Data @{title = 'TestTitle'; Entry = 1 } -ErrorAction SilentlyContinue -ErrorVariable err
            $err | Should -Not -BeNullOrEmpty
            $ret.Success | Should -BeFalse
        }
        It 'Should fail to set a "base" category if entry is set and throw error' {
            # change one value
            $objCatList[0].title = 'Test'
            { Set-IdoItCategory -Id $obj.Id -Category 'C__CATS__PERSON' -Data @{title = 'TestTitle'; Entry = 1 } -ErrorAction Stop } | Should -Throw
        }
    }
    Context "Multi value" {
        It "should set mutlivalue attribute" {
            $obj = Get-IdoItObject -id 540
            $obj | Should -Not -BeNullOrEmpty
            $objCatList = Get-IdoItCategory -Id $obj.Id -Category 'C__CATG__MEMORY'
            $objCatList | Should -Not -BeNullOrEmpty

            Set-IdoItCategory -Id $obj.Id -Category 'C__CATG__MEMORY' -Data @{ title = 'SDRAM'; Entry = 1 }
            $reqParams = $Global:IdoitApiTrace[-1].Request.params
            $reqParams.object | Should -Be 540
            $reqParams.data.title | Should -Be 'SDRAM'
            $reqParams.data.entry | Should -Be 1
        }
    }
    Context "Using InputObject" {
        It "should set all properties by using InputObject" {
            $obj = Get-IdoItObject -Id 37
            $obj | Should -Not -BeNullOrEmpty
            $objCatList = Get-IdoItCategory -Id $obj.Id -Category 'C__CATS__PERSON'
            $objCatList | Should -Not -BeNullOrEmpty

            # change one value
            $objCatList[0].title = 'TestTitle2'
            $ret = Set-IdoItCategory -InputObject $objCatList[0] -Category 'C__CATS__PERSON'
            # check API call
            $reqParams = $Global:IdoitApiTrace[-1].Request.params
            $reqParams.object | Should -Be 37               # remember: this time the object id is passed as "object" (not objId!)
            $reqParams.data.title | Should -Be 'TestTitle2'
            $reqParams.data.first_name | Should -Be $objCatList.first_name
            $reqParams.data.last_name | Should -Be $objCatList.last_name
            # check return value
            $ret.Success | Should -BeTrue
        }
        It 'Should set all properties when using custom object' {
            $obj = Get-IdoItObject -Id 4675
            $obj | Should -Not -BeNullOrEmpty
            $objCatList = Get-IdoItCategory -Id $obj.Id -Category 'C__CATG__CUSTOM_FIELDS_KOMPONENTE' -UseCustomTitle
            $objCatList | Should -Not -BeNullOrEmpty

            # change one value
            $objCatList[0].Komponenten_Typ = 'Windows-Service'
            $ret = Set-IdoItCategory -InputObject $objCatList[0] -Category 'C__CATG__CUSTOM_FIELDS_KOMPONENTE'
            # check API call
            $reqParams = $Global:IdoitApiTrace[-1].Request.params
            $reqParams.object | Should -Be 4675
            $reqParams.data.f_popup_c_17289168067044910 | Should -Be 'Windows-Service'
            $reqParams.data.f_popup_c_17289128195752470 | Should -Be $objCatList[0].Technologie
        }
        It 'Should fail if property value is invalid using custom object' {
            $obj = Get-IdoItObject -Id 4675
            $obj | Should -Not -BeNullOrEmpty
            $objCatList = Get-IdoItCategory -Id $obj.Id -Category 'C__CATG__CUSTOM_FIELDS_KOMPONENTE' -UseCustomTitle
            $objCatList | Should -Not -BeNullOrEmpty

            # change one value
            $objCatList[0].Komponenten_Typ = 'something invalid'
            {
                Set-IdoItCategory -InputObject $objCatList[0] -Category 'C__CATG__CUSTOM_FIELDS_KOMPONENTE' -ErrorAction Stop -WarningAction SilentlyContinue -WarningVariable warn
                $warn | Should -Not -BeNullOrEmpty
            } | Should -Throw "One or more properties failed*"
            # check API call
            Assert-MockCalled Invoke-RestMethod -Exactly 0 -ModuleName $Script:moduleName -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.category.save'
            } -Scope It
        }
    }
}
