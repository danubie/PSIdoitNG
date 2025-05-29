Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # check request values: All properties in the simulated request param (except apikey) should be in the request
    # returns the simulated response with the same id as the request
    # Special case: The API does not return any reference to the category name => this is added in the function
    #      so the simulation currently can only handle one call
    $body = $body | ConvertFrom-Json
    $thisIdoitObject = $MockData_Cmdb_category_info_read | Where-Object { $_.Request.params.category -eq $body.params.category }
    if ($null -ne $thisIdoitObject) {
        $thisIdoitObject.Response.id = $body.id
        $thisIdoitObject.Response
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
    [PSCustomObject] @{
        Endpoint = 'cmdb.category_info.read';
        Request  = [PSCustomObject] @{
            params  = [PSCustomObject] @{
                category = 'C__CATG__CUSTOM_FIELDS_KOMPONENTE';
                apikey   = '***'
            };
            version = '2.0';
            id      = 'aac3eb7e-0ca5-4de7-945c-dbd6c6dc3044';
            method  = 'cmdb.category_info.read'
        };
        Response = [PSCustomObject] @{
            id      = 'aac3eb7e-0ca5-4de7-945c-dbd6c6dc3044';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                f_popup_c_17289168067044910    = [PSCustomObject] @{
                    title  = 'Komponenten-Typ';
                    check  = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info   = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'dialog_plus';
                        backward      = 'False';
                        title         = 'Komponenten-Typ';
                        description   = 'f_popup'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'int';
                        readonly    = 'False';
                        index       = 'False';
                        field       = 'isys_catg_custom_fields_list__field_content';
                        field_alias = 'f_popup_c_17289168067044910';
                        references  = @(
                            'isys_dialog_plus_custom',
                            'isys_dialog_plus_custom__id'
                        );
                        select      = [PSCustomObject] @{

                        }
                    };
                    ui     = [PSCustomObject] @{
                        type   = 'popup';
                        params = [PSCustomObject] @{
                            p_nMaxLen      = 255;
                            type           = 'f_popup';
                            popup          = 'dialog_plus';
                            title          = 'Komponenten-Typ';
                            identifier     = 'Komponenten-Typ';
                            visibility     = 'visible';
                            show_in_list   = 'False';
                            show_inline    = 'False';
                            p_strTable     = 'isys_dialog_plus_custom';
                            condition      = 'isys_dialog_plus_custom__identifier = ''Komponenten-Typ''';
                            p_arData       = [PSCustomObject] @{

                            };
                            p_strPopupType = 'dialog_plus';
                            p_identifier   = 'Komponenten-Typ'
                        };
                        id     = 'c_17289168067044910'
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_global_custom_fields_export_helper',
                            'exportCustomFieldDialogPlus'
                        )
                    }
                };
                f_popup_c_17289128195752470    = [PSCustomObject] @{
                    title  = 'Technologie';
                    check  = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info   = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'multiselect';
                        backward      = 'False';
                        title         = 'Technologie';
                        description   = 'f_popup'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'int';
                        readonly    = 'False';
                        index       = 'False';
                        field       = 'isys_catg_custom_fields_list__field_content';
                        field_alias = 'f_popup_c_17289128195752470';
                        references  = @(
                            'isys_dialog_plus_custom',
                            'isys_dialog_plus_custom__id'
                        );
                        select      = [PSCustomObject] @{

                        }
                    };
                    ui     = [PSCustomObject] @{
                        type   = 'popup';
                        params = [PSCustomObject] @{
                            p_nMaxLen      = 255;
                            type           = 'f_popup';
                            popup          = 'dialog_plus';
                            title          = 'Technologie';
                            identifier     = 'Technologie';
                            multiselection = 1;
                            visibility     = 'visible';
                            show_in_list   = 'False';
                            show_inline    = 'False';
                            p_strTable     = 'isys_dialog_plus_custom';
                            condition      = 'isys_dialog_plus_custom__identifier = ''Technologie''';
                            p_arData       = [PSCustomObject] @{

                            };
                            p_strPopupType = 'dialog_plus';
                            p_identifier   = 'Technologie';
                            multiselect    = 'True'
                        };
                        id     = 'c_17289128195752470'
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_global_custom_fields_export_helper',
                            'exportCustomFieldDialogPlus'
                        )
                    }
                };
                f_text_c_17298533004299360     = [PSCustomObject] @{
                    title = 'URI';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'URI';
                        description   = 'f_text'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = 'False';
                        index       = 'False';
                        field       = 'isys_catg_custom_fields_list__field_content';
                        field_alias = 'f_text_c_17298533004299360';
                        select      = [PSCustomObject] @{

                        }
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen    = 255;
                            type         = 'f_text';
                            title        = 'URI';
                            visibility   = 'visible';
                            show_in_list = 'False';
                            show_inline  = 'False'
                        };
                        id     = 'c_17298533004299360'
                    }
                };
                f_popup_c_17298533887342620    = [PSCustomObject] @{
                    title  = 'Zugriff von';
                    check  = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info   = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'dialog_plus';
                        backward      = 'False';
                        title         = 'Zugriff von';
                        description   = 'f_popup'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'int';
                        readonly    = 'False';
                        index       = 'False';
                        field       = 'isys_catg_custom_fields_list__field_content';
                        field_alias = 'f_popup_c_17298533887342620';
                        references  = @(
                            'isys_dialog_plus_custom',
                            'isys_dialog_plus_custom__id'
                        );
                        select      = [PSCustomObject] @{

                        }
                    };
                    ui     = [PSCustomObject] @{
                        type   = 'popup';
                        params = [PSCustomObject] @{
                            p_nMaxLen      = 255;
                            type           = 'f_popup';
                            popup          = 'dialog_plus';
                            title          = 'Zugriff von';
                            identifier     = 'Zugriff_von';
                            visibility     = 'visible';
                            show_in_list   = 'False';
                            show_inline    = 'False';
                            p_strTable     = 'isys_dialog_plus_custom';
                            condition      = 'isys_dialog_plus_custom__identifier = ''Zugriff_von''';
                            p_arData       = [PSCustomObject] @{

                            };
                            p_strPopupType = 'dialog_plus';
                            p_identifier   = 'Zugriff_von'
                        };
                        id     = 'c_17298533887342620'
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_global_custom_fields_export_helper',
                            'exportCustomFieldDialogPlus'
                        )
                    }
                };
                f_popup_c_17298533461827010    = [PSCustomObject] @{
                    title  = 'FOO-relevant';
                    check  = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info   = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'dialog_plus';
                        backward      = 'False';
                        title         = 'FOO-relevant';
                        description   = 'f_popup'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'int';
                        readonly    = 'False';
                        index       = 'False';
                        field       = 'isys_catg_custom_fields_list__field_content';
                        field_alias = 'f_popup_c_17298533461827010';
                        references  = @(
                            'isys_dialog_plus_custom',
                            'isys_dialog_plus_custom__id'
                        );
                        select      = [PSCustomObject] @{

                        }
                    };
                    ui     = [PSCustomObject] @{
                        type   = 'popup';
                        params = [PSCustomObject] @{
                            p_nMaxLen      = 255;
                            type           = 'f_popup';
                            popup          = 'dialog_plus';
                            title          = 'FOO-relevant';
                            identifier     = 'FOO_relevant';
                            visibility     = 'visible';
                            show_in_list   = 'False';
                            show_inline    = 'False';
                            p_strTable     = 'isys_dialog_plus_custom';
                            condition      = 'isys_dialog_plus_custom__identifier = ''FOO_relevant''';
                            p_arData       = [PSCustomObject] @{

                            };
                            p_strPopupType = 'dialog_plus';
                            p_identifier   = 'FOO_relevant'
                        };
                        id     = 'c_17298533461827010'
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_global_custom_fields_export_helper',
                            'exportCustomFieldDialogPlus'
                        )
                    }
                };
                hr_c_17302711682246540         = [PSCustomObject] @{
                    title = 'Linie2';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'Linie2';
                        description   = 'hr'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = 'False';
                        index       = 'False';
                        field       = 'isys_catg_custom_fields_list__field_content';
                        field_alias = 'hr_c_17302711682246540';
                        select      = [PSCustomObject] @{

                        }
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'hr';
                        params = [PSCustomObject] @{
                            p_nMaxLen    = 255;
                            type         = 'hr';
                            title        = 'Linie2';
                            visibility   = 'visible';
                            show_in_list = 'False';
                            show_inline  = 'False'
                        };
                        id     = 'c_17302711682246540'
                    }
                };
                html_c_1730271199702280        = [PSCustomObject] @{
                    title = '<table class="contentTable p0">
    <tbody>
        <tr>
            <td class="key vat">
                <h1>Source Control</h1>
            </td>
            <td></td>
        </tr>
    </tbody>
</table>';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = '<table class="contentTable p0">
    <tbody>
        <tr>
            <td class="key vat">
                <h1>Source Control</h1>
            </td>
            <td></td>
        </tr>
    </tbody>
</table>';
                        description   = 'html'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = 'False';
                        index       = 'False';
                        field       = 'isys_catg_custom_fields_list__field_content';
                        field_alias = 'html_c_1730271199702280';
                        select      = [PSCustomObject] @{

                        }
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'html';
                        params = [PSCustomObject] @{
                            p_nMaxLen    = 255;
                            type         = 'html';
                            title        = '<table class="contentTable p0">
    <tbody>
        <tr>
            <td class="key vat">
                <h1>Source Control</h1>
            </td>
            <td></td>
        </tr>
    </tbody>
</table>';
                            visibility   = 'visible';
                            show_in_list = 'False';
                            show_inline  = 'False'
                        };
                        id     = 'c_1730271199702280'
                    }
                };
                f_text_c_17298537143787710     = [PSCustomObject] @{
                    title = 'TFS-Projekt';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'TFS-Projekt';
                        description   = 'f_text'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = 'False';
                        index       = 'False';
                        field       = 'isys_catg_custom_fields_list__field_content';
                        field_alias = 'f_text_c_17298537143787710';
                        select      = [PSCustomObject] @{

                        }
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen    = 255;
                            type         = 'f_text';
                            title        = 'TFS-Projekt';
                            visibility   = 'visible';
                            show_in_list = 'False';
                            show_inline  = 'False'
                        };
                        id     = 'c_17298537143787710'
                    }
                };
                f_text_c_17298537407435620     = [PSCustomObject] @{
                    title = 'Solution-Pfad';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'Solution-Pfad';
                        description   = 'f_text'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = 'False';
                        index       = 'False';
                        field       = 'isys_catg_custom_fields_list__field_content';
                        field_alias = 'f_text_c_17298537407435620';
                        select      = [PSCustomObject] @{

                        }
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_nMaxLen    = 255;
                            type         = 'f_text';
                            title        = 'Solution-Pfad';
                            visibility   = 'visible';
                            show_in_list = 'False';
                            show_inline  = 'False'
                        };
                        id     = 'c_17298537407435620'
                    }
                };
                f_popup_c_17298537697067600    = [PSCustomObject] @{
                    title  = 'Fremdentwicklung';
                    check  = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info   = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'dialog_plus';
                        backward      = 'False';
                        title         = 'Fremdentwicklung';
                        description   = 'f_popup'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'int';
                        readonly    = 'False';
                        index       = 'False';
                        field       = 'isys_catg_custom_fields_list__field_content';
                        field_alias = 'f_popup_c_17298537697067600';
                        references  = @(
                            'isys_dialog_plus_custom',
                            'isys_dialog_plus_custom__id'
                        );
                        select      = [PSCustomObject] @{

                        }
                    };
                    ui     = [PSCustomObject] @{
                        type   = 'popup';
                        params = [PSCustomObject] @{
                            p_nMaxLen      = 255;
                            type           = 'f_popup';
                            popup          = 'dialog_plus';
                            title          = 'Fremdentwicklung';
                            identifier     = 'Source_Control_Fremdentwicklung';
                            visibility     = 'visible';
                            show_in_list   = 'False';
                            show_inline    = 'False';
                            p_strTable     = 'isys_dialog_plus_custom';
                            condition      = 'isys_dialog_plus_custom__identifier = ''Source_Control_Fremdentwicklung''';
                            p_arData       = [PSCustomObject] @{

                            };
                            p_strPopupType = 'dialog_plus';
                            p_identifier   = 'Source_Control_Fremdentwicklung'
                        };
                        id     = 'c_17298537697067600'
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_global_custom_fields_export_helper',
                            'exportCustomFieldDialogPlus'
                        )
                    }
                };
                hr_c_17302928288173090         = [PSCustomObject] @{
                    title = 'Linie3';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'text';
                        backward      = 'False';
                        title         = 'Linie3';
                        description   = 'hr'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = 'False';
                        index       = 'False';
                        field       = 'isys_catg_custom_fields_list__field_content';
                        field_alias = 'hr_c_17302928288173090';
                        select      = [PSCustomObject] @{

                        }
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'hr';
                        params = [PSCustomObject] @{
                            p_nMaxLen    = 255;
                            type         = 'hr';
                            title        = 'Linie3';
                            visibility   = 'visible';
                            show_in_list = 'False';
                            show_inline  = 'False'
                        };
                        id     = 'c_17302928288173090'
                    }
                };
                f_textarea_c_17302904497397380 = [PSCustomObject] @{
                    title = 'Zusatzinfos';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'textarea';
                        backward      = 'False';
                        title         = 'Zusatzinfos';
                        description   = 'f_textarea'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text_area';
                        readonly    = 'False';
                        index       = 'False';
                        field       = 'isys_catg_custom_fields_list__field_content';
                        field_alias = 'f_textarea_c_17302904497397380';
                        select      = [PSCustomObject] @{

                        }
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'textarea';
                        params = [PSCustomObject] @{
                            p_nMaxLen    = 255;
                            type         = 'f_textarea';
                            title        = 'Zusatzinfos';
                            visibility   = 'visible';
                            show_in_list = 'False';
                            show_inline  = 'False'
                        };
                        id     = 'c_17302904497397380'
                    }
                };
                description                    = [PSCustomObject] @{
                    title = 'Description';
                    check = [PSCustomObject] @{
                        mandatory = 'False'
                    };
                    info  = [PSCustomObject] @{
                        primary_field = 'False';
                        type          = 'commentary';
                        backward      = 'False';
                        title         = 'LC__CMDB__LOGBOOK__DESCRIPTION';
                        description   = 'commentary'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text_area';
                        readonly    = 'False';
                        index       = 'False';
                        field       = 'isys_catg_custom_fields_list__field_content';
                        field_alias = 'C__CMDB__CAT__COMMENTARY_43';
                        select      = [PSCustomObject] @{

                        }
                    };
                    ui    = [PSCustomObject] @{
                        type = 'textarea';
                        id   = 'C__CMDB__CAT__COMMENTARY_43'
                    }
                };
                Category                       = 'C__CATG__CUSTOM_FIELDS_KOMPONENTE'
            }
        };
        Time     = '2025-05-29 10:31:04'
    }
)
