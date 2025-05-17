$MockData_Cmdb_category_read = @(
    #region persons37
    [PSCustomObject] @{
        Endpoint = 'cmdb.category.read';
        Request  = [PSCustomObject] @{
            params  = [PSCustomObject] @{
                category = 'C__CATS__PERSON';
                status   = 2;
                objID    = 37
            };
            method  = 'cmdb.category.read';
            version = '2.0';
            id      = 'eb7593c3-78f9-426a-87c2-e6934174ef2f'
        };
        Response = [PSCustomObject] @{
            id      = 'eb7593c3-78f9-426a-87c2-e6934174ef2f';
            jsonrpc = '2.0';
            result  = @(
                [PSCustomObject] @{
                    id                  = 11;
                    objID               = 37;
                    title               = 'userw@spambog.com';
                    first_name          = 'User';
                    last_name           = 'W';
                    mail                = 'userw@spambog.com';
                    personnel_number    = '52b320bc-0c77-489f-9d81-6e8a10aacf85';
                    department          = 'Department | Sub-Department';
                    organization        = [PSCustomObject] @{
                        title         = 'Company IdoIt';
                        id            = 47;
                        connection_id = 14;
                        type          = 'C__OBJTYPE__ORGANIZATION';
                        type_title    = 'Organization';
                        sysid         = 'SYSID_1728910505'
                    };
                    custom_1            = '';
                    custom_2            = '';
                    custom_3            = '';
                    custom_4            = '';
                    custom_5            = '';
                    custom_6            = '';
                    custom_7            = '';
                    custom_8            = ''
                }
            )
        };
        Time     = '2025-05-13 15:14:32'
    }
    #endregion persons37
    #region server540
    [PSCustomObject] @{
        Endpoint = 'cmdb.category.read';
        Request  = [PSCustomObject] @{
            params  = [PSCustomObject] @{
                category = 'C__CATG__GLOBAL';
                status   = 2;
                objID    = 540
            };
            method  = 'cmdb.category.read';
            version = '2.0';
            id      = '2ebac6f8-4bfe-457b-b915-572ded523913'
        };
        Response = [PSCustomObject] @{
            id      = '2ebac6f8-4bfe-457b-b915-572ded523913';
            jsonrpc = '2.0';
            result  = @(
                [PSCustomObject] @{
                    id          = 540;
                    objID       = 540;
                    title       = 'server540';
                    status      = [PSCustomObject] @{
                        id         = 2;
                        title      = 'Normal';
                        const      = '';
                        title_lang = 'LC__CMDB__RECORD_STATUS__NORMAL'
                    };
                    created     = '2024-10-31 09:54:24';
                    created_by  = 'UserA';
                    changed     = '2025-05-04 18:18:12';
                    changed_by  = 'UserW';
                    sysid       = 'SYSID_1730365404';
                    cmdb_status = [PSCustomObject] @{
                        id         = 6;
                        title      = 'in operation';
                        const      = 'C__CMDB_STATUS__IN_OPERATION';
                        title_lang = 'LC__CMDB_STATUS__IN_OPERATION'
                    };
                    type        = [PSCustomObject] @{
                        id         = 5;
                        title      = 'Server';
                        const      = 'C__OBJTYPE__SERVER';
                        title_lang = 'LC__CMDB__OBJTYPE__SERVER'
                    };
                    description = 'forward'
                }
            )
        };
        Time     = '2025-05-13 12:04:41'
    }
    [PSCustomObject] @{
        Endpoint = 'cmdb.category.read';
        Request  = [PSCustomObject] @{
            params  = [PSCustomObject] @{
                category = 'C__CATG__MEMORY';
                status   = 2;
                objID    = 540
            };
            method  = 'cmdb.category.read';
            version = '2.0';
            id      = 'ebca165a-a5db-4631-a5b0-60719d2976f4'
        };
        Response = [PSCustomObject] @{
            id      = 'ebca165a-a5db-4631-a5b0-60719d2976f4';
            jsonrpc = '2.0';
            result  = @(
                [PSCustomObject] @{     # the first item contains all category properties; the others are just what I currently need
                    id             = 1;
                    objID          = 540;
                    title          = [PSCustomObject] @{
                        id         = 1;
                        title      = 'DDRAM';
                        title_lang = 'DDRAM'
                    };
                    manufacturer   = [PSCustomObject] @{
                        id         = 1;
                        title      = 'Kingston';
                        title_lang = 'Kingston'
                    };
                    type           = [PSCustomObject] @{
                        id         = 6;
                        title      = 'ECC Load Reducing (LRDIMM)';
                        title_lang = 'ECC Load Reducing (LRDIMM)'
                    };
                    total_capacity = 68719476736;
                    capacity       = [PSCustomObject] @{
                        title = 64
                    };
                    unit           = [PSCustomObject] @{
                        id         = 3;
                        title      = 'GB';
                        const      = 'C__MEMORY_UNIT__GB';
                        title_lang = 'GB'
                    };
                    description    = ''
                }, [PSCustomObject] @{
                    id             = 2;
                    objID          = 540;
                    capacity       = [PSCustomObject] @{
                        title = 64
                    };
                    unit           = [PSCustomObject] @{
                        id         = 3;
                        title      = 'GB';
                        const      = 'C__MEMORY_UNIT__GB';
                        title_lang = 'GB'
                    };
                    description    = ''
                }, [PSCustomObject] @{
                    id             = 3;
                    objID          = 540;
                    total_capacity = 68719476736;
                    capacity       = [PSCustomObject] @{
                        title = 64
                    };
                    unit           = [PSCustomObject] @{
                        id         = 3;
                        title      = 'GB';
                        const      = 'C__MEMORY_UNIT__GB';
                        title_lang = 'GB'
                    };
                    description    = ''
                }, [PSCustomObject] @{
                    id             = 4;
                    objID          = 540;
                    total_capacity = 68719476736;
                    capacity       = [PSCustomObject] @{
                        title = 64
                    };
                    unit           = [PSCustomObject] @{
                        id         = 3;
                        title      = 'GB';
                        const      = 'C__MEMORY_UNIT__GB';
                        title_lang = 'GB'
                    };
                    description    = ''
                }
            )
        };
        Time     = '2025-05-13 12:04:41'
    }
    #endregion server540
)
Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # check request values: All properties in the simulated request param (except apikey) should be in the request
    # returns the simulated response with the same id as the request
    $requestBody = $body | ConvertFrom-Json
    $thisIdoitObject = $MockData_Cmdb_category_read | Where-Object { $_.Request.params.id -eq $requestBody.params.id }
    if ($null -ne $requestBody.params.category) {
        $thisIdoitObject = $thisIdoitObject | Where-Object { $_.Request.params.category -eq $requestBody.params.category }
    }
    if ($null -ne $thisIdoitObject) {
        $thisIdoitObject.Response.id = $requestBody.id
        $thisIdoitObject.Response
    } else {
        Write-Warning "No mock data found for request: $($requestBody.method); $body)"
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'cmdb.category.read'
}
