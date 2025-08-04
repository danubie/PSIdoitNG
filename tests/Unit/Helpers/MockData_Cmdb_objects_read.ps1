Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # check request values: All properties in the simulated request param (except apikey) should be in the request
    # returns the simulated response with the same id as the request
    # this one is differnt to the standard procedure
    #   1. we took the same data as in the MockData_Cmdb_object_read.ps1 -> but objecttype is returned as type here by the API
    #   2. for filtering, we just use the response data (normally the request data would be checked)
    $body = $body | ConvertFrom-Json
    # starting with all possible resources, then filtering by the request parameters
    $thisIdoitObject = $MockData_Cmdb_objects_read
    if ($null -ne $body.params.filter.ids) {
        $thisIdoitObject = $thisIdoitObject | Where-Object { $_.Response.result.id -in $body.params.filter.ids }
    }
    if ($null -ne $body.params.filter.type) {
        # testcase "All objects of type persons": C__OBJTYPE__PERSON, the mocked data has a type of 53 for persons
        if ($body.params.filter.type -eq 'C__OBJTYPE__PERSON' -or $body.params.filter.type -eq 53) {
            $thisIdoitObject = $thisIdoitObject | Where-Object { $_.Response.result.type_title -eq 'Persons' }
        }
        else {
            $thisIdoitObject = $thisIdoitObject | Where-Object { $_.Response.result.type -in $body.params.filter.type }
        }
    }
    if ($null -ne $body.params.filter.title) {
        $thisIdoitObject = $thisIdoitObject | Where-Object { $_.Response.result.title -eq $body.params.filter.title }
    }
    if ($null -ne $body.params.filter.type_title) {
        $thisIdoitObject = $thisIdoitObject | Where-Object { $_.Response.result.type_title -eq $body.params.filter.type_title }
    }
    if ($null -ne $body.params.filter.status) {
        $thisIdoitObject = $thisIdoitObject | Where-Object { $_.Response.result.status -eq $body.params.filter.status }
    }
    # in testcase title and requested category are set, so we have to check the category here for the object we've found
    # remeber: categories is not a filter, but a request parameter
    # if ($null -ne $body.params.categories) {
    #     $thisIdoitObject.Response.result | Add-Member -MemberType NoteProperty -Name 'categories' -Value ([PSCustomObject]@{}) -Force
    # }
    # foreach ($catName in $body.params.categories) {
    #     $catObj = $MockData_Cmdb_objects_read | Where-Object {
    #         $_.Response.result[0].id -eq $thisIdoitObject.Response.result[0].id -and
    #         $_.Response.result[0].categories[0].$catName -ne $null
    #     }
    #     if ($null -ne $catObj) {
    #         $thisIdoitObject.Response.result.categories | Add-Member -MemberType NoteProperty -Name $catName -Value $catObj.Response.result.categories[0].$catName -Force
    #     }
    # }

    if ($null -ne $thisIdoitObject) {
        [PSCustomObject] @{         # empty list
            id      = $body.id;
            jsonrpc = '2.0';
            result  = @($thisIdoitObject.Response.Result)       # objectreadS returns an array of objects
        }
    }
    else {
        [PSCustomObject] @{         # empty list
            id      = $body.id;
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{}
        }
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'cmdb.objects.read'
}

$MockData_Cmdb_objects_read = @(
    #region persons id=37
    [PSCustomObject] @{
        Endpoint = 'cmdb.objects.read';
        Request  = [PSCustomObject] @{
            id      = 'b5affabf-d0dd-45b0-8fdc-e51001b4c5f0';
            version = '2.0';
            method  = 'cmdb.objects.read';
            params  = [PSCustomObject] @{
                filter     = [PSCustomObject] @{
                    ids = 37
                };
                categories = @(
                    'C__CATS__PERSON'
                )
            }
        };
        Response = [PSCustomObject] @{
            id      = 'b5affabf-d0dd-45b0-8fdc-e51001b4c5f0';
            jsonrpc = '2.0';
            result  = @(
                [PSCustomObject] @{
                    id                = 37;
                    title             = 'userw@spambog.com';
                    sysid             = 'SYSID_1733071461';
                    type              = 53;
                    created           = '2024-10-09 12:12:12';
                    updated           = '2025-06-16 23:10:16';
                    type_title        = 'Persons';
                    type_group_title  = 'Contact';
                    status            = 2;
                    cmdb_status       = 6;
                    cmdb_status_title = 'in operation';
                    image             = '/cmdb/object/image/37';
                    categories        = [PSCustomObject] @{
                        C__CATS__PERSON = @(
                            [PSCustomObject] @{
                                id           = 11;
                                objID        = 37;
                                title        = 'userw@spambog.com';
                                first_name   = 'User';
                                last_name    = 'W';
                                organization = [PSCustomObject] @{
                                    title         = 'MyOrg';
                                    id            = 47;
                                    connection_id = 14;
                                    type          = 'C__OBJTYPE__ORGANIZATION';
                                    type_title    = 'Organization';
                                    sysid         = 'SYSID_1728910505'
                                };
                            }
                        )
                    }
                }
            )
        };
        Time     = '2025-06-17 05:09:02'
    }
    #endregion persons

    #region server540
    [PSCustomObject] @{
        Endpoint = 'cmdb.objects.read';
        Request  = [PSCustomObject] @{
            id      = '25760cfe-42f3-4f15-a6de-492857a6b3f1';
            version = '2.0';
            method  = 'cmdb.objects.read';
            params  = [PSCustomObject] @{
                filter     = [PSCustomObject] @{
                    ids = 540
                };
                categories = @(
                    'C__CATG__GLOBAL',
                    'C__CATG__MEMORY'
                )
            }
        };
        Response = [PSCustomObject] @{
            id      = '25760cfe-42f3-4f15-a6de-492857a6b3f1';
            jsonrpc = '2.0';
            result  = @(
                [PSCustomObject] @{
                    id                = 540;
                    title             = 'server540';
                    sysid             = 'SYSID_1730365404';
                    type              = 5;
                    created           = '2024-10-31 09:54:24';
                    updated           = '2025-06-03 06:18:27';
                    type_title        = 'Server';
                    type_group_title  = 'Infrastructure';
                    status            = 2;
                    cmdb_status       = 6;
                    cmdb_status_title = 'in operation';
                    image             = '/cmdb/object/image/540';
                    categories        = [PSCustomObject] @{
                        C__CATG__GLOBAL = @(
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
                                created_by  = 'x';
                                changed     = '2025-06-03 06:18:27';
                                changed_by  = 'y';
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
                                tag         = @(
                                    [PSCustomObject] @{
                                        id    = 9;
                                        title = 'PRD'
                                    }
                                );
                                description = $null
                            }
                        );
                        C__CATG__MEMORY = @(
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
                                id          = 2;
                                objID       = 540;
                                capacity    = [PSCustomObject] @{
                                    title = 64
                                };
                                unit        = [PSCustomObject] @{
                                    id         = 3;
                                    title      = 'GB';
                                    const      = 'C__MEMORY_UNIT__GB';
                                    title_lang = 'GB'
                                };
                                description = ''
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
                    }
                }
            )
        };
        Time     = '2025-06-17 05:12:11'
    }
    #endregion server540

    #region CustomObject 4675
    [PSCustomObject] @{
        Endpoint = 'cmdb.objects.read';
        Request  = [PSCustomObject] @{
            id      = '5d8b282e-2526-4320-a250-a588a6bbae11';
            method  = 'cmdb.objects.read';
            version = '2.0';
            params  = [PSCustomObject] @{
                apikey     = '*****';
                categories = @(
                    'C__CATG__CUSTOM_FIELDS_KOMPONENTE'
                );
                filter     = [PSCustomObject] @{
                    ids = @(
                        4675
                    )
                }
            }
        };
        Response = [PSCustomObject] @{
            id      = '5d8b282e-2526-4320-a250-a588a6bbae11';
            jsonrpc = '2.0';
            result  = @(
                [PSCustomObject] @{
                    id                = 4675;
                    title             = 'Title4675';
                    sysid             = 'SYSID_1734102557';
                    type              = 93;
                    created           = '2024-12-21 18:14:51';
                    updated           = '2025-06-09 16:49:03';
                    type_title        = 'Komponente';
                    type_group_title  = 'Software';
                    status            = 2;
                    cmdb_status       = 6;
                    cmdb_status_title = 'in operation';
                    image             = '/cmdb/object/image/4675';
                    categories        = [PSCustomObject] @{
                        C__CATG__GLOBAL                   = @(
                            [PSCustomObject] @{
                                id          = 4675;
                                objID       = 4675;
                                title       = 'title4675';
                                status      = [PSCustomObject] @{
                                    id         = 2;
                                    title      = 'Normal';
                                    const      = '';
                                    title_lang = 'LC__CMDB__RECORD_STATUS__NORMAL'
                                };
                                cmdb_status = [PSCustomObject] @{
                                    id         = 6;
                                    title      = 'in operation';
                                    const      = 'C__CMDB_STATUS__IN_OPERATION';
                                    title_lang = 'LC__CMDB_STATUS__IN_OPERATION'
                                };
                                type        = [PSCustomObject] @{
                                    id         = 93;
                                    title      = 'Komponente';
                                    const      = 'C__COMPONENT';
                                    title_lang = 'Komponente'
                                };
                                tag         = @(
                                    [PSCustomObject] @{
                                        id    = 9;
                                        title = 'PRD'
                                    },
                                    [PSCustomObject] @{
                                        id    = 10;
                                        title = 'SQL-Job'
                                    }
                                );
                                description = 'Tell what it is'
                            }
                        );
                        C__CATG__CUSTOM_FIELDS_KOMPONENTE = @(
                            [PSCustomObject] @{
                                id                          = 33;
                                objID                       = 4675;
                                f_popup_c_17289168067044910 = [PSCustomObject] @{
                                    id         = 85;
                                    title      = 'Job / Schnittstelle';
                                    title_lang = 'Job / Schnittstelle';
                                    identifier = 'Komponenten-Typ'
                                };
                                f_popup_c_17289128195752470 = @(
                                    [PSCustomObject] @{
                                        id             = 61;
                                        title          = 'SQL Server';
                                        title_lang     = 'SQL Server';
                                        identifier     = 'Technologie';
                                        multiselection = 1
                                    },
                                    [PSCustomObject] @{
                                        id             = 33;
                                        title          = 'Biztalk';
                                        title_lang     = 'Biztalk';
                                        identifier     = 'Technologie';
                                        multiselection = 1
                                    }
                                );
                                description                 = ''
                            }
                        )
                    };
                    Time              = '2025-06-17 07:03:26'
                }
                #endregion CustomObject 4675
            )
        }
    }

    # $MockData_Cmdb_objects_read = @(
    #     # region persons
    #     [PSCustomObject] @{
    #         Endpoint = 'cmdb.objects.read';
    #         Request  = [PSCustomObject]@{
    #             method = 'cmdb.objects.read'; id = '9e2a082e-66a2-42b7-b055-61d99266f9a4'; version = '2.0';
    #             params = [PSCustomObject] @{
    #                 id = 37
    #             }
    #         };
    #         Response = [PSCustomObject]@{
    #             id      = '{0}';
    #             jsonrpc = '2.0';
    #             result  = [PSCustomObject] @{
    #                 id                = 37;
    #                 title             = 'userw@spambog.com';
    #                 sysid             = 'SYSID_1733071461';
    #                 type              = 53;                         # objectS.read returns type (not objecttype)
    #                 type_title        = 'Persons';
    #                 type_icon         = '/cmdb/object-type/image/53';
    #                 status            = 2;
    #                 cmdb_status       = 6;
    #                 cmdb_status_title = 'in operation';
    #                 created           = '2024-10-09 12:56:39';
    #                 updated           = '2025-05-11 23:10:17';
    #                 image             = '/cmdb/object/image/37'
    #             }
    #         };
    #         Time     = '2025-05-12 18:08:13'
    #     }
    #     [PSCustomObject] @{
    #         Endpoint = 'cmdb.objects.read';
    #         Request  = [PSCustomObject] @{ method = 'cmdb.objects.read'; id = '76b013a7-047f-4793-9356-33a761bed501'; version = '2.0'; params = [PSCustomObject] @{
    #                 id = 28
    #             }
    #         };
    #         Response = [PSCustomObject]@{
    #             id      = '{0}';
    #             jsonrpc = '2.0';
    #             result  = [PSCustomObject] @{
    #                 id                = 28;
    #                 title             = 'User P';
    #                 sysid             = 'SYSID_1728465262';
    #                 type        = 53;
    #                 type_title        = 'Persons';
    #                 type_icon         = '/cmdb/object-type/image/53';
    #                 status            = 2;
    #                 cmdb_status       = 6;
    #                 cmdb_status_title = 'in operation';
    #                 created           = '2024-10-09 11:13:54';
    #                 updated           = '2025-05-11 23:10:09';
    #                 image             = '/cmdb/object/image/28'
    #             }
    #         };
    #         Time     = '2025-05-12 18:09:33'
    #     }
    #     #endregion persons

    #     #region server540
    #     [PSCustomObject] @{
    #         Endpoint = 'cmdb.objects.read';
    #         Request  = [PSCustomObject] @{ method = 'cmdb.objects.read'; id = '4a18bed9-6b9a-4725-a979-943ef85da4eb'; version = '2.0'; params = [PSCustomObject] @{
    #                 id = 540
    #             }
    #         };
    #         Response = [PSCustomObject]@{
    #             id      = '4a18bed9-6b9a-4725-a979-943ef85da4eb';
    #             jsonrpc = '2.0';
    #             result  = [PSCustomObject] @{
    #                 id                = 540;
    #                 title             = 'server540';
    #                 sysid             = 'SYSID_1730365404';
    #                 type        = 5;
    #                 type_title        = 'Server';
    #                 type_icon         = '/cmdb/object-type/image/5';
    #                 status            = 2;
    #                 cmdb_status       = 6;
    #                 cmdb_status_title = 'in operation';
    #                 created           = '2024-10-31 09:54:24';
    #                 updated           = '2025-05-04 18:18:12';
    #                 image             = '/cmdb/object/image/540'
    #             }
    #         };
    #         Time     = '2025-05-12 18:32:11'
    #     }
    #     #endregion server540
    #     #region CustomObject 4675
    #     [PSCustomObject] @{
    #         Endpoint = 'cmdb.objects.read';
    #         Request  = [PSCustomObject] @{
    #             params  = [PSCustomObject] @{
    #                 id     = 4675;
    #                 apikey = '***'
    #             };
    #             version = '2.0';
    #             id      = '84df30b0-2b77-466f-bd4e-a29411940b83';
    #             method  = 'cmdb.objects.read'
    #         };
    #         Response = [PSCustomObject] @{
    #             id      = '84df30b0-2b77-466f-bd4e-a29411940b83';
    #             jsonrpc = '2.0';
    #             result  = [PSCustomObject] @{
    #                 id                = 4675;
    #                 title             = '042_eServicPortal_Housekeeper';
    #                 sysid             = 'SYSID_1734102557';
    #                 type        = 93;
    #                 type_title        = 'Komponente';
    #                 type_icon         = '/cmdb/object-type/image/93';
    #                 status            = 2;
    #                 cmdb_status       = 6;
    #                 cmdb_status_title = 'in operation';
    #                 created           = '2024-12-21 18:14:51';
    #                 updated           = '2025-05-15 16:32:15';
    #                 image             = '/cmdb/object/image/4675'
    #             }
    #         };
    #         Time     = '2025-05-29 10:46:31'
    #     }
    #     #endregion CustomObject 4675
    # )
)