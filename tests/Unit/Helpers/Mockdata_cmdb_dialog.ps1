Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # check request values: All properties in the simulated request param (except apikey) should be in the request
    # returns the simulated response with the same id as the request
    $body = $body | ConvertFrom-Json
    $thisIdoitObject = $MockData_Cmdb_dialog | Where-Object { $_.Request.params.id -eq $body.id -or ($_.Request.params.property -eq $body.params.property -and $_.Request.params.category -eq $body.params.category) }
    if ($null -ne $thisIdoitObject) {
        $thisIdoitObject.Response.id = $body.id
        $thisIdoitObject.Response
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'cmdb.dialog'
}
$MockData_Cmdb_dialog = @(
    #region C__CATG__CPU
    [PSCustomObject] @{
        Endpoint = 'cmdb.dialog';
        Request  = [PSCustomObject] @{
            method  = 'cmdb.dialog';
            id      = '41414563-1a4a-4e0d-9f68-e1d413c89c0d';
            params  = [PSCustomObject] @{
                property = 'manufacturer';
                category = 'C__CATG__CPU'
            };
            version = '2.0'
        };
        Response = [PSCustomObject] @{
            id      = '41414563-1a4a-4e0d-9f68-e1d413c89c0d';
            jsonrpc = '2.0';
            result  = @(
                [PSCustomObject] @{
                    id    = 1;
                    const = '';
                    title = 'AMD';
                },
                [PSCustomObject] @{
                    id    = 2;
                    const = '';
                    title = 'Intel';
                },
                [PSCustomObject] @{
                    id    = 3;
                    const = '';
                    title = 'IBM';
                },
                [PSCustomObject] @{
                    id    = 4;
                    const = '';
                    title = 'Motorla';
                }
            )
        };
        Time     = '2025-05-24 18:35:58'
    }
    #endregion
    #region C__CATG__MEMORY
    [PSCustomObject] @{
        Endpoint = 'cmdb.dialog';
        Request  = [PSCustomObject] @{
            method  = 'cmdb.dialog';
            id      = '4de7ea1b-071b-4fc9-8a94-e98445310d33';
            params  = [PSCustomObject] @{
                apikey   = '*****';
                property = 'title';
                category = 'C__CATG__MEMORY'
            };
            version = '2.0'
        };
        Response = [PSCustomObject] @{
            id      = '4de7ea1b-071b-4fc9-8a94-e98445310d33';
            jsonrpc = '2.0';
            result  = @(
                [PSCustomObject] @{
                    id    = 1;
                    const = '';
                    title = 'DDRAM'
                },
                [PSCustomObject] @{
                    id    = 2;
                    const = '';
                    title = 'SDRAM'
                },
                [PSCustomObject] @{
                    id    = 3;
                    const = '';
                    title = 'Flash'
                },
                [PSCustomObject] @{
                    id    = 4;
                    const = '';
                    title = 'MemoryStick'
                },
                [PSCustomObject] @{
                    id    = 5;
                    const = '';
                    title = 'NVRAM'
                }
            )
        };
        Time     = '2025-05-30 05:21:14'
    }
    [PSCustomObject] @{
        Endpoint = 'cmdb.dialog';
        Request  = [PSCustomObject] @{
            method  = 'cmdb.dialog';
            id      = 'eb85e88e-5ba5-49e1-b335-a2fcc1dd3bbd';
            params  = [PSCustomObject] @{
                apikey   = '*****';
                property = 'manufacturer';
                category = 'C__CATG__MEMORY'
            };
            version = '2.0'
        };
        Response = [PSCustomObject] @{
            id      = 'eb85e88e-5ba5-49e1-b335-a2fcc1dd3bbd';
            jsonrpc = '2.0';
            result  = @(
                [PSCustomObject] @{
                    id    = 1;
                    const = '';
                    title = 'Kingston'
                },
                [PSCustomObject] @{
                    id    = 2;
                    const = '';
                    title = 'Infineon'
                },
                [PSCustomObject] @{
                    id    = 3;
                    const = '';
                    title = 'Transcend'
                },
                [PSCustomObject] @{
                    id    = 4;
                    const = '';
                    title = 'Samsung'
                }
            )
        };
        Time     = '2025-05-30 05:21:14'
    }
    [PSCustomObject] @{
        Endpoint = 'cmdb.dialog';
        Request  = [PSCustomObject] @{
            method  = 'cmdb.dialog';
            id      = 'ae5d4215-6600-44b8-add7-beb88c653241';
            params  = [PSCustomObject] @{
                apikey   = '*****';
                property = 'type';
                category = 'C__CATG__MEMORY'
            };
            version = '2.0'
        };
        Response = [PSCustomObject] @{
            id      = 'ae5d4215-6600-44b8-add7-beb88c653241';
            jsonrpc = '2.0';
            result  = @(
                [PSCustomObject] @{
                    id    = 1;
                    const = '';
                    title = 'DDR'
                },
                [PSCustomObject] @{
                    id    = 2;
                    const = '';
                    title = 'DDR2'
                },
                [PSCustomObject] @{
                    id    = 3;
                    const = '';
                    title = 'DDR3'
                },
                [PSCustomObject] @{
                    id    = 4;
                    const = '';
                    title = 'SDRAM'
                },
                [PSCustomObject] @{
                    id    = 5;
                    const = '';
                    title = 'ECC Registered (RDIM)'
                },
                [PSCustomObject] @{
                    id    = 6;
                    const = '';
                    title = 'ECC Load Reducing (LRDIMM)'
                }
            )
        };
        Time     = '2025-05-30 05:21:14'
    }
    [PSCustomObject] @{
        Endpoint = 'cmdb.dialog';
        Request  = [PSCustomObject] @{
            method  = 'cmdb.dialog';
            id      = 'df0406e5-67a2-49dd-a603-a2ba5a2fd278';
            params  = [PSCustomObject] @{
                apikey   = '*****';
                property = 'unit';
                category = 'C__CATG__MEMORY'
            };
            version = '2.0'
        };
        Response = [PSCustomObject] @{
            id      = 'df0406e5-67a2-49dd-a603-a2ba5a2fd278';
            jsonrpc = '2.0';
            result  = @(
                [PSCustomObject] @{
                    id    = 1;
                    const = 'C__MEMORY_UNIT__KB';
                    title = 'KB'
                },
                [PSCustomObject] @{
                    id    = 2;
                    const = 'C__MEMORY_UNIT__MB';
                    title = 'MB'
                },
                [PSCustomObject] @{
                    id    = 3;
                    const = 'C__MEMORY_UNIT__GB';
                    title = 'GB'
                },
                [PSCustomObject] @{
                    id    = 4;
                    const = 'C__MEMORY_UNIT__TB';
                    title = 'TB'
                },
                [PSCustomObject] @{
                    id    = 1000;
                    const = 'C__MEMORY_UNIT__B';
                    title = 'B'
                }
            )
        };
        Time     = '2025-05-30 05:21:15'
    }
    #endregion
    #region C__CATS__PERSON
    [PSCustomObject] @{
        Endpoint = 'cmdb.category_info.read';
        Request  = [PSCustomObject] @{
            method  = 'cmdb.category_info.read';
            id      = 'f99d708a-f321-47f2-bfe3-edb8e1e1fa86';
            params  = [PSCustomObject] @{
                category = 'C__CATS__PERSON';
                apikey   = '*****'
            };
            version = '2.0'
        };
        Response = [PSCustomObject] @{
            id      = 'f99d708a-f321-47f2-bfe3-edb8e1e1fa86';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                title               = [PSCustomObject] @{
                    title = 'Title';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CMDB__LOGBOOK__TITLE';
                        description   = 'Title'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__title'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CMDB__CATS__PERSON_MASTER__TITLE'
                    }
                };
                salutation          = [PSCustomObject] @{
                    title  = 'Salutation';
                    check  = [PSCustomObject] @{

                    };
                    info   = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'dialog';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_SALUTATION';
                        description   = 'Salutation'
                    };
                    data   = [PSCustomObject] @{
                        type     = 'int';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__salutation';
                        select   = [PSCustomObject] @{

                        };
                        join     = @(
                            [PSCustomObject] @{

                            }
                        )
                    };
                    ui     = [PSCustomObject] @{
                        type    = 'dialog';
                        params  = [PSCustomObject] @{
                            p_strTable     = '';
                            p_strPopupType = 'dialog';
                            p_arData       = [PSCustomObject] @{

                            }
                        };
                        default = '-1';
                        id      = 'C__CONTACT__PERSON_SALUTATION'
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'dialog'
                        )
                    }
                };
                first_name          = [PSCustomObject] @{
                    title = 'First name';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_FIRST_NAME';
                        description   = 'First name'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'True';
                        field    = 'isys_cats_person_list__first_name'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_FIRST_NAME'
                    }
                };
                last_name           = [PSCustomObject] @{
                    title = 'Last name';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_LAST_NAME';
                        description   = 'Last name'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'True';
                        field    = 'isys_cats_person_list__last_name'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_LAST_NAME'
                    }
                };
                academic_degree     = [PSCustomObject] @{
                    title = 'Academic degree';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_ACADEMIC_DEGREE';
                        description   = 'Academic degree'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__academic_degree'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_ACADEMIC_DEGREE'
                    }
                };
                function            = [PSCustomObject] @{
                    title = 'Function';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_FUNKTION';
                        description   = 'Function'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__function'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_FUNKTION'
                    }
                };
                service_designation = [PSCustomObject] @{
                    title = 'Service designation';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_SERVICE_DESIGNATION';
                        description   = 'Service designation'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__service_designation'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_SERVICE_DESIGNATION'
                    }
                };
                street              = [PSCustomObject] @{
                    title = 'Street';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_STEET';
                        description   = 'Street'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__street'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_STREET'
                    }
                };
                city                = [PSCustomObject] @{
                    title = 'City';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_CITY';
                        description   = 'City'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__city'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_CITY'
                    }
                };
                zip_code            = [PSCustomObject] @{
                    title = 'ZIP-Code';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_ZIP_CODE';
                        description   = 'Zip-Code'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__zip_code'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_ZIP_CODE'
                    }
                };
                mail                = [PSCustomObject] @{
                    title = 'E-mail address';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_MAIL_ADDRESS';
                        description   = 'E-mail address'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_catg_mail_addresses_list__title';
                        select   = [PSCustomObject] @{

                        };
                        join     = @(
                            [PSCustomObject] @{

                            }
                        )
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_MAIL_ADDRESS'
                    }
                };
                phone_company       = [PSCustomObject] @{
                    title = 'Telephone company';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_TELEPHONE_COMPANY';
                        description   = 'Telephone company'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__phone_company'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_PHONE_COMPANY'
                    }
                };
                phone_home          = [PSCustomObject] @{
                    title = 'Telephone home';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_TELEPHONE_HOME';
                        description   = 'Telephone home'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__phone_home'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_PHONE_HOME'
                    }
                };
                phone_mobile        = [PSCustomObject] @{
                    title = 'Cellphone';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_TELEPHONE_MOBILE';
                        description   = 'Cellphone'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__phone_mobile'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_PHONE_MOBILE'
                    }
                };
                fax                 = [PSCustomObject] @{
                    title = 'Fax';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_FAX';
                        description   = 'Fax'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__fax'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_FAX'
                    }
                };
                pager               = [PSCustomObject] @{
                    title = 'Pager';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_PAGER';
                        description   = 'Pager'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__pager'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_PAGER'
                    }
                };
                personnel_number    = [PSCustomObject] @{
                    title = 'Personnel number';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_PERSONNEL_NUMBER';
                        description   = 'Personnel number'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__personnel_number'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_PERSONNEL_NUMBER'
                    }
                };
                department          = [PSCustomObject] @{
                    title = 'Department';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CONTACT__PERSON_DEPARTMENT';
                        description   = 'Department'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__department'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__PERSON_DEPARTMENT'
                    }
                };
                organization        = [PSCustomObject] @{
                    title  = 'Organisation';
                    check  = [PSCustomObject] @{

                    };
                    info   = [PSCustomObject] @{
                        primary_field    = 'False';
                        type             = 'object_browser';
                        backward         = 'False';
                        title            = 'LC__CONTACT__PERSON_ASSIGNED_ORGANISATION';
                        description      = 'Organisation';
                        backwardProperty = 'isys_cmdb_dao_category_s_organization_person::object'
                    };
                    data   = [PSCustomObject] @{
                        type             = 'int';
                        readonly         = 'False';
                        index            = 'False';
                        field            = 'isys_cats_person_list__isys_connection__id';
                        relation_type    = 29;
                        relation_handler = [PSCustomObject] @{

                        };
                        references       = @(
                            'isys_connection',
                            'isys_connection__id'
                        );
                        select           = [PSCustomObject] @{

                        };
                        join             = @(
                            [PSCustomObject] @{

                            },
                            [PSCustomObject] @{

                            },
                            [PSCustomObject] @{

                            }
                        )
                    };
                    ui     = [PSCustomObject] @{
                        type   = 'popup';
                        params = [PSCustomObject] @{
                            p_strPopupType = 'browser_object_ng';
                            title          = 'LC__POPUP__BROWSER__ORGANISATION';
                            catFilter      = 'C__CATS__ORGANIZATION;C__CATS__ORGANIZATION_MASTER_DATA;C__CATS__ORGANIZATION_PERSONS'
                        };
                        id     = 'C__CONTACT__PERSON_ASSIGNED_ORGANISATION'
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'connection'
                        )
                    }
                };
                ldap_id             = [PSCustomObject] @{
                    title  = 'ID';
                    check  = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info   = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__UNIVERSAL__ID';
                        description   = 'ID'
                    };
                    data   = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__isys_ldap__id'
                    };
                    ui     = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = ''
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'person_property_ldap_id'
                        )
                    }
                };
                ldap_dn             = [PSCustomObject] @{
                    title = 'DN';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'DN';
                        description   = 'DN'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__ldap_dn'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = ''
                    }
                };
                description         = [PSCustomObject] @{
                    title = 'Description';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'commentary';
                        backward      = 'False';
                        title         = 'LC__CMDB__LOGBOOK__DESCRIPTION';
                        description   = 'Description'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text_area';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__description'
                    };
                    ui    = [PSCustomObject] @{
                        type = 'textarea';
                        id   = 'C__CMDB__CAT__COMMENTARY_148'
                    }
                };
                custom_1            = [PSCustomObject] @{
                    title = 'Custom 1';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'Custom 1';
                        description   = 'Custom property 1'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__custom1'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__CUSTOM1'
                    }
                };
                custom_2            = [PSCustomObject] @{
                    title = 'Custom 2';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'Custom 2';
                        description   = 'Custom property 2'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__custom2'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__CUSTOM2'
                    }
                };
                custom_3            = [PSCustomObject] @{
                    title = 'Custom 3';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'Custom 3';
                        description   = 'Custom property 3'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__custom3'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__CUSTOM3'
                    }
                };
                custom_4            = [PSCustomObject] @{
                    title = 'Custom 4';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'Custom 4';
                        description   = 'Custom property 4'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__custom4'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__CUSTOM4'
                    }
                };
                custom_5            = [PSCustomObject] @{
                    title = 'Custom 5';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'Custom 5';
                        description   = 'Custom property 5'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__custom5'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__CUSTOM5'
                    }
                };
                custom_6            = [PSCustomObject] @{
                    title = 'Custom 6';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'Custom 6';
                        description   = 'Custom property 6'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__custom6'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__CUSTOM6'
                    }
                };
                custom_7            = [PSCustomObject] @{
                    title = 'Custom 7';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'Custom 7';
                        description   = 'Custom property 7'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__custom7'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__CUSTOM7'
                    }
                };
                custom_8            = [PSCustomObject] @{
                    title = 'Custom 8';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'Custom 8';
                        description   = 'Custom property 8'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = 'False';
                        index    = 'False';
                        field    = 'isys_cats_person_list__custom8'
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen = 255
                        };
                        id     = 'C__CONTACT__CUSTOM8'
                    }
                };
                Category            = 'C__CATS__PERSON'
            }
        };
        Time     = '2025-05-30 04:44:50'
    }
    #endregion
    #region custom fields C__CATG__CUSTOM_FIELDS_KOMPONENTE -> f_popup_c_17289168067044910
    [PSCustomObject] @{
        Endpoint = 'cmdb.dialog';
        Request  = [PSCustomObject] @{
            params  = [PSCustomObject] @{
                apikey   = '****';
                property = 'f_popup_c_17289168067044910';
                category = 'C__CATG__CUSTOM_FIELDS_KOMPONENTE'
            };
            version = '2.0';
            id      = 'eb68239e-c02a-4ea6-a333-fbab12c7a2d6';
            method  = 'cmdb.dialog'
        };
        Response = [PSCustomObject] @{
            id      = 'eb68239e-c02a-4ea6-a333-fbab12c7a2d6';
            jsonrpc = '2.0';
            result  = @(
                [PSCustomObject] @{
                    id    = 84;
                    const = '';
                    title = 'Coreservice'
                },
                [PSCustomObject] @{
                    id    = 85;
                    const = '';
                    title = 'Job / Schnittstelle'
                },
                [PSCustomObject] @{
                    id    = 86;
                    const = '';
                    title = 'Modul'
                },
                [PSCustomObject] @{
                    id    = 87;
                    const = '';
                    title = 'Desktop-Applikation'
                },
                [PSCustomObject] @{
                    id    = 88;
                    const = '';
                    title = 'Web-Applikation'
                },
                [PSCustomObject] @{
                    id    = 89;
                    const = '';
                    title = 'Mobile App'
                },
                [PSCustomObject] @{
                    id    = 90;
                    const = '';
                    title = 'Webservice'
                },
                [PSCustomObject] @{
                    id    = 132;
                    const = '';
                    title = 'REST-Service'
                },
                [PSCustomObject] @{
                    id    = 133;
                    const = '';
                    title = 'SOAP-Service'
                },
                [PSCustomObject] @{
                    id    = 134;
                    const = '';
                    title = 'Windows-Service'
                },
                [PSCustomObject] @{
                    id    = 200;
                    const = '';
                    title = ''
                },
                [PSCustomObject] @{
                    id    = 216;
                    const = '';
                    title = 'jahu'
                }
            )
        };
        Time     = '2025-05-29 18:32:22'
    }
    #endregion
    #region custom fields C__CATG__CUSTOM_FIELDS_KOMPONENTE -> f_popup_c_17289128195752470
    [PSCustomObject] @{
        Endpoint = 'cmdb.dialog';
        Request  = [PSCustomObject] @{
            id      = 'bb92a800-3fe4-4e0e-a230-018a40419a30';
            version = '2.0';
            params  = [PSCustomObject] @{
                property = 'f_popup_c_17289128195752470';
                apikey   = '*****';
                category = 'C__CATG__CUSTOM_FIELDS_KOMPONENTE'
            };
            method  = 'cmdb.dialog'
        };
        Response = [PSCustomObject] @{
            id      = 'bb92a800-3fe4-4e0e-a230-018a40419a30';
            jsonrpc = '2.0';
            result  = @(
                [PSCustomObject] @{
                    id    = 12;
                    const = '';
                    title = '.NET'
                },
                [PSCustomObject] @{
                    id    = 26;
                    const = '';
                    title = 'Access DB'
                },
                [PSCustomObject] @{
                    id    = 27;
                    const = '';
                    title = 'Firestart'
                },
                [PSCustomObject] @{
                    id    = 30;
                    const = '';
                    title = 'ActiveDirectory'
                },
                [PSCustomObject] @{
                    id    = 31;
                    const = '';
                    title = 'AgilePoint'
                },
                [PSCustomObject] @{
                    id    = 32;
                    const = '';
                    title = 'ASP.NET MVC'
                },
                [PSCustomObject] @{
                    id    = 33;
                    const = '';
                    title = 'Biztalk'
                },
                [PSCustomObject] @{
                    id    = 38;
                    const = '';
                    title = 'FTP'
                },
                [PSCustomObject] @{
                    id    = 41;
                    const = '';
                    title = 'Java/Blue Framework'
                },
                [PSCustomObject] @{
                    id    = 42;
                    const = '';
                    title = 'Mail'
                },
                [PSCustomObject] @{
                    id    = 43;
                    const = '';
                    title = 'Mailworx'
                },
                [PSCustomObject] @{
                    id    = 45;
                    const = '';
                    title = 'Nagios'
                },
                [PSCustomObject] @{
                    id    = 47;
                    const = '';
                    title = 'SSAS'
                },
                [PSCustomObject] @{
                    id    = 49;
                    const = '';
                    title = 'PHP'
                },
                [PSCustomObject] @{
                    id    = 50;
                    const = '';
                    title = 'Progress DB'
                },
                [PSCustomObject] @{
                    id    = 51;
                    const = '';
                    title = 'SSRS'
                },
                [PSCustomObject] @{
                    id    = 52;
                    const = '';
                    title = 'SSIS'
                },
                [PSCustomObject] @{
                    id    = 53;
                    const = '';
                    title = 'SAP ABAP'
                },
                [PSCustomObject] @{
                    id    = 54;
                    const = '';
                    title = 'SAP Business Objects'
                },
                [PSCustomObject] @{
                    id    = 55;
                    const = '';
                    title = 'SAP Java'
                },
                [PSCustomObject] @{
                    id    = 56;
                    const = '';
                    title = 'SAP Netweaver'
                },
                [PSCustomObject] @{
                    id    = 57;
                    const = '';
                    title = 'SAP RFC'
                },
                [PSCustomObject] @{
                    id    = 58;
                    const = '';
                    title = 'SAP Workflow'
                },
                [PSCustomObject] @{
                    id    = 59;
                    const = '';
                    title = 'Saperion'
                },
                [PSCustomObject] @{
                    id    = 60;
                    const = '';
                    title = 'SharePoint on-premise'
                },
                [PSCustomObject] @{
                    id    = 61;
                    const = '';
                    title = 'SQL Server'
                },
                [PSCustomObject] @{
                    id    = 64;
                    const = '';
                    title = 'WKIS'
                },
                [PSCustomObject] @{
                    id    = 120;
                    const = '';
                    title = 'CKEditor'
                },
                [PSCustomObject] @{
                    id    = 121;
                    const = '';
                    title = 'SFTP'
                },
                [PSCustomObject] @{
                    id    = 122;
                    const = '';
                    title = 'Inhouse-Framework'
                },
                [PSCustomObject] @{
                    id    = 123;
                    const = '';
                    title = 'Titan-Framework'
                },
                [PSCustomObject] @{
                    id    = 124;
                    const = '';
                    title = 'Hyparchiv'
                },
                [PSCustomObject] @{
                    id    = 125;
                    const = '';
                    title = 'Infinica'
                },
                [PSCustomObject] @{
                    id    = 126;
                    const = '';
                    title = 'PowerBI'
                },
                [PSCustomObject] @{
                    id    = 127;
                    const = '';
                    title = 'SAP BW'
                },
                [PSCustomObject] @{
                    id    = 128;
                    const = '';
                    title = 'SharePoint online'
                },
                [PSCustomObject] @{
                    id    = 129;
                    const = '';
                    title = 'Mongo DB'
                },
                [PSCustomObject] @{
                    id    = 130;
                    const = '';
                    title = 'Maria DB'
                },
                [PSCustomObject] @{
                    id    = 131;
                    const = '';
                    title = 'Message Broker'
                },
                [PSCustomObject] @{
                    id    = 215;
                    const = '';
                    title = 'Openshift'
                }
            )
        };
        Time     = '2025-05-29 19:58:14'
    }
    #endregion
)