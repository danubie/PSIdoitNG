BeforeDiscovery {
    Import-Module -Name (Get-SamplerProjectName .) -Force
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
    . $testHelpersPath/MockConnectIdoit.ps1
    . $testHelpersPath/MockData_Cmdb_object_read.ps1
    . $testHelpersPath/MockData_Cmdb_object_types_read.ps1
    . $testHelpersPath/MockDefaultMockAtEnd.ps1
}
    # . $PSScriptRoot\..\..\Helpers\CreateMockConnectIdoIt.ps1
    # . $PSScriptRoot\..\..\Helpers\MockData_Cmdb_object_read.ps1
    # . $PSScriptRoot\..\..\Helpers\MockData_Cmdb_object_types_read.ps1
    # . $PSScriptRoot\..\..\Helpers\MockData_cmdb_category_read.ps1
    # . $PSScriptRoot\..\..\Helpers\MockData_cmdb_object_type_categories_read.ps1
    # . $PSScriptRoot\..\..\Helpers\MockDefaultMockAtEnd.ps1
AfterAll {
    Remove-Variable -Name ApiTraceVariable -Scope Global -ErrorAction SilentlyContinue
    Get-Module -Name (Get-SamplerProjectName .) -All | Remove-Module -Force
}

Describe 'Get-IdoItObjectType' {
    Context 'By different ways of Id' {
        It 'by parameter' {
            $result = Get-IdoItObjectType -Id 1
            $result | Should -HaveCount 1
            $result.id | Should -Be 1
            $result.const | Should -Be 'C__OBJTYPE__SERVICE'
            $result.PSObject.TypeNames | Should -Contain 'Idoit.ObjectType'
        }

        It 'by position with Id' {
            $result = Get-IdoItObjectType 5
            $result | Should -HaveCount 1
            $result.id | Should -Be 5
            $result.const | Should -Be 'C__OBJTYPE__SERVER'
        }

        # Prepare for pipeline support
        # It 'by pipeline with Id' {
        #     $result = 1 | Get-IdoItObjectType
        #     $result | Should -HaveCount 1
        #     $result.id | Should -Be 1
        #     $result.const | Should -Be 'C__OBJTYPE__SERVICE'
        # }

        # It 'by pipeline multiple with Id' {
        #     $result = 1, 2 | Get-IdoItObjectType
        #     $result | Should -HaveCount 2
        #     $result[0].id | Should -Be 1
        #     $result[0].const | Should -Be 'C__OBJTYPE__SERVICE'
        #     $result[1].id | Should -Be 2
        #     $result[1].const | Should -Be 'C__OBJTYPE__APPLICATION'
        # }
    }

    Context 'By different ways of Const' {
        BeforeAll {
            Mock Invoke-RestMethod -ModuleName 'PSIdoitNG' -MockWith {
                # check request values: All properties in the simulated request param (except apikey) should be in the request
                # returns the simulated response with the same id as the request
                $body = $body | ConvertFrom-Json
                $thisIdoitResults = $MockData_cmdb_object_types_read.Response.result | Where-Object { $_.const -in $body.params.filter.titles -or $_.const -eq $body.params.filter.title }
                if ($null -ne $thisIdoitResults) {
                    $response = [PSCustomObject]@{
                        id      = $body.id
                        jsonrpc = '2.0'
                        result  = $thisIdoitResults
                    }
                    $response
                }
            } -ParameterFilter {
                (($body | ConvertFrom-Json).method) -eq 'cmdb.object_types.read'
            }
        }

        It 'by parameter' {
            $result = Get-IdoItObjectType -Const 'C__OBJTYPE__OPERATING_SYSTEM'
            $result | Should -HaveCount 1
            $result.id | Should -Be 35
            $result.const | Should -Be 'C__OBJTYPE__OPERATING_SYSTEM'
            $result.PSObject.TypeNames | Should -Contain 'Idoit.ObjectType'
        }
        # prepare for pipeline support
        # It 'by position with Const' {
        #     $result = Get-IdoItObjectType 'C__OBJTYPE__OPERATING_SYSTEM'
        #     $result | Should -HaveCount 1
        #     $result.id | Should -Be 35
        #     $result.const | Should -Be 'C__OBJTYPE__OPERATING_SYSTEM'
        # }

        # It 'by pipeline with Const' {
        #     $result = 'C__OBJTYPE__OPERATING_SYSTEM' | Get-IdoItObjectType
        #     $result | Should -HaveCount 1
        #     $result.id | Should -Be 35
        #     $result.const | Should -Be 'C__OBJTYPE__OPERATING_SYSTEM'
        # }

        # It 'by pipeline multiple with Const' {
        #     $result = 'C__OBJTYPE__OPERATING_SYSTEM', 'C__OBJTYPE__APPLICATION' | Get-IdoItObjectType
        #     $result | Should -HaveCount 2
        #     $result[0].id | Should -Be 35
        #     $result[0].const | Should -Be 'C__OBJTYPE__OPERATING_SYSTEM'
        #     $result[1].id | Should -Be 2
        #     $result[1].const | Should -Be 'C__OBJTYPE__APPLICATION'
        # }

        # It 'by pipeline and property name' {
        #     $result  = [PSCustomObject]@{
        #         Const = 'C__OBJTYPE__OPERATING_SYSTEM'
        #     } | Get-IdoItObjectType
        #     $result | Should -HaveCount 1
        #     $result.const | Should -Be 'C__OBJTYPE__OPERATING_SYSTEM'
        #     # now using Alias
        #     $result  = [PSCustomObject]@{
        #         Title = 'C__OBJTYPE__OPERATING_SYSTEM'
        #     } | Get-IdoItObjectType
        #     $result | Should -HaveCount 1
        #     $result.const | Should -Be 'C__OBJTYPE__OPERATING_SYSTEM'
        # }
    }
}