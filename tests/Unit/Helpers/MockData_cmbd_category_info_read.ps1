Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # check request values: All properties in the simulated request param (except apikey) should be in the request
    # returns the simulated response with the same id as the request
    # Special case: The API does not return any reference to the category name => this is added in the function
    #      so the simulation currently can only handle one call
    $body = $body | ConvertFrom-Json
    if ($body.params.category -eq 'C__CATG__GLOBAL') {
        $thisIdoitObject = $MockData_Cmdb_category_info_read
        if ($null -ne $thisIdoitObject) {
            $thisIdoitObject.Response.id = $body.id
            $thisIdoitObject.Response
        }
    } else {
        [PSCustomObject] @{
            id      = 'f39b13be-b0ca-40f5-b643-8fa65932e871';
            jsonrpc = '2.0';
            error   = [PSCustomObject] @{
                code    = -32602;
                message = 'Invalid parameters: Category "InvalidCategory" not found. Delete your i-doit cache if you are sure it exists.'
            }
        }
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'cmdb.category_info.read'
}


$MockData_Cmdb_category_info_read = @(
    [PSCustomObject] @{
        Endpoint = 'cmdb.category_info.read';
        Request  = [PSCustomObject] @{
            params  = [PSCustomObject] @{
                category = 'C__CATG__GLOBAL'
            };
            method  = 'cmdb.category_info.read';
            id      = '9b673b2e-7ff0-43fd-9189-39629672abee';
            version = '2.0'
        };
        Response = [PSCustomObject] @{
            id      = '9b673b2e-7ff0-43fd-9189-39629672abee';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                id          = [PSCustomObject] @{
                    title = 'ID';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'int';
                        backward      = 'False';
                        title         = 'ID';
                        description   = 'ID'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'int';
                        readonly    = 'False';
                        index       = 'True';
                        field       = 'isys_obj__id';
                        table_alias = 'isys_obj'
                    }
                };
                title       = [PSCustomObject] @{
                    title  = 'Title';
                    check  = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info   = [PSCustomObject] @{
                        title              = 'LC__UNIVERSAL__TITLE';
                        type               = 'text';
                        primaryField       = 'False';
                        backwardCompatible = 'False'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'text';
                        field       = 'isys_obj__title';
                        sourceTable = 'isys_obj';
                        readOnly    = 'False';
                        index       = 'True';
                        select      = [PSCustomObject] @{

                        }
                    };
                    format = @(

                    )
                };
                status      = [PSCustomObject] @{
                    title  = 'Condition';
                    check  = [PSCustomObject] @{

                    };
                    info   = [PSCustomObject] @{
                        title              = 'LC__UNIVERSAL__CONDITION';
                        type               = 'dialog';
                        primaryField       = 'False';
                        backwardCompatible = 'False'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'int';
                        field       = 'isys_obj__status';
                        sourceTable = 'isys_obj';
                        readOnly    = 'True';
                        index       = 'True';
                        select      = [PSCustomObject] @{

                        }
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'dialog'
                        )
                    }
                };
                created     = [PSCustomObject] @{
                    title  = 'Creation date';
                    check  = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info   = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'datetime';
                        backward      = 'False';
                        title         = 'LC__TASK__DETAIL__WORKORDER__CREATION_DATE';
                        description   = 'Created'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'date_time';
                        readonly    = 'True';
                        index       = 'False';
                        field       = 'isys_obj__created';
                        table_alias = 'isys_obj';
                        select      = [PSCustomObject] @{

                        };
                        sort_alias  = 'obj_main.isys_obj__created'
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'datetime'
                        )
                    }
                };
                created_by  = [PSCustomObject] @{
                    title = 'Created by';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__UNIVERSAL__CREATED_BY';
                        description   = 'Created by'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = 'True';
                        index       = 'False';
                        field       = 'isys_obj__created_by';
                        table_alias = 'isys_obj'
                    }
                };
                changed     = [PSCustomObject] @{
                    title  = 'Last change';
                    check  = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info   = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'datetime';
                        backward      = 'False';
                        title         = 'LC__CMDB__LAST_CHANGE';
                        description   = 'Changed'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'date_time';
                        readonly    = 'True';
                        index       = 'True';
                        sort_alias  = 'isys_obj__updated';
                        field       = 'isys_obj__updated';
                        table_alias = 'isys_obj';
                        select      = [PSCustomObject] @{

                        }
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'datetime'
                        )
                    }
                };
                changed_by  = [PSCustomObject] @{
                    title = 'Last change by';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CMDB__LAST_CHANGE_BY';
                        description   = 'Changed'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = 'True';
                        index       = 'False';
                        sort_alias  = 'isys_obj__updated_by';
                        field       = 'isys_obj__updated_by';
                        table_alias = 'isys_obj'
                    }
                };
                purpose     = [PSCustomObject] @{
                    title  = 'Purpose';
                    check  = [PSCustomObject] @{

                    };
                    info   = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'dialog_plus';
                        backward      = 'False';
                        title         = 'LC__CMDB__CATG__GLOBAL_PURPOSE';
                        description   = 'Purpose'
                    };
                    data   = [PSCustomObject] @{
                        type       = 'int';
                        readonly   = 'False';
                        index      = 'False';
                        field      = 'isys_catg_global_list__isys_purpose__id';
                        references = @(
                            'isys_purpose',
                            'isys_purpose__id'
                        );
                        select     = [PSCustomObject] @{

                        };
                        join       = @(
                            [PSCustomObject] @{

                            },
                            [PSCustomObject] @{

                            }
                        )
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'dialog_plus'
                        )
                    }
                };
                sysid       = [PSCustomObject] @{
                    title = 'SYSID';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'LC__CMDB__CATG__GLOBAL_SYSID';
                        description   = 'SYSID'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = 'False';
                        index       = 'True';
                        field       = 'isys_obj__sysid';
                        table_alias = 'isys_obj'
                    }
                };
                cmdb_status = [PSCustomObject] @{
                    title  = 'CMDB status';
                    check  = [PSCustomObject] @{

                    };
                    info   = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'dialog';
                        backward      = 'False';
                        title         = 'LC__UNIVERSAL__CMDB_STATUS';
                        description   = 'CMDB status'
                    };
                    data   = [PSCustomObject] @{
                        type       = 'int';
                        readonly   = 'False';
                        index      = 'False';
                        field      = 'isys_obj__isys_cmdb_status__id';
                        references = @(
                            'isys_cmdb_status',
                            'isys_cmdb_status__id'
                        );
                        select     = [PSCustomObject] @{

                        }
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'dialog'
                        )
                    }
                };
                type        = [PSCustomObject] @{
                    title  = 'Object type';
                    check  = [PSCustomObject] @{

                    };
                    info   = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'dialog';
                        backward      = 'False';
                        title         = 'LC__REPORT__FORM__OBJECT_TYPE';
                        description   = 'Object-Type'
                    };
                    data   = [PSCustomObject] @{
                        type       = 'int';
                        readonly   = 'False';
                        index      = 'True';
                        field      = 'isys_obj__isys_obj_type__id';
                        references = @(
                            'isys_obj_type',
                            'isys_obj_type__id'
                        );
                        select     = [PSCustomObject] @{

                        }
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'dialog'
                        )
                    }
                };
                tag         = [PSCustomObject] @{
                    title  = 'Tags';
                    check  = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info   = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'multiselect';
                        backward      = 'False';
                        title         = 'LC__CMDB__CATG__GLOBAL_TAG';
                        description   = 'Tag'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'int';
                        readonly    = 'False';
                        index       = 'True';
                        field       = 'isys_obj__id';
                        table_alias = 'global_tag';
                        references  = @(
                            'isys_tag_2_isys_obj',
                            'isys_obj__id'
                        );
                        select      = [PSCustomObject] @{

                        }
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'dialog_multiselect'
                        )
                    }
                };
                description = [PSCustomObject] @{
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
                        type        = 'text_area';
                        readonly    = 'False';
                        index       = 'False';
                        field       = 'isys_obj__description';
                        table_alias = 'isys_obj'
                    }
                };
                Category    = 'C__CATG__GLOBAL'
            }
        };
        Time     = '2025-05-17 14:26:31'
    }
)
