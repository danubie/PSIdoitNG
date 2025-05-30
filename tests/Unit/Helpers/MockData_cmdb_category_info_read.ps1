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
    }
    else {
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
    #region Category: C__CATG__GLOBAL
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'int';
                        backward      = $false;
                        title         = 'ID';
                        description   = 'ID'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'int';
                        readonly    = $false;
                        index       = $true;
                        field       = 'isys_obj__id';
                        table_alias = 'isys_obj'
                    }
                };
                title       = [PSCustomObject] @{
                    title  = 'Title';
                    check  = [PSCustomObject] @{
                        mandatory = $false
                    };
                    info   = [PSCustomObject] @{
                        title              = 'LC__UNIVERSAL__TITLE';
                        type               = 'text';
                        primaryField       = $false;
                        backwardCompatible = $false
                    };
                    data   = [PSCustomObject] @{
                        type        = 'text';
                        field       = 'isys_obj__title';
                        sourceTable = 'isys_obj';
                        readOnly    = $false;
                        index       = $true;
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
                        primaryField       = $false;
                        backwardCompatible = $false
                    };
                    data   = [PSCustomObject] @{
                        type        = 'int';
                        field       = 'isys_obj__status';
                        sourceTable = 'isys_obj';
                        readOnly    = $true;
                        index       = $true;
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
                        mandatory = $false
                    };
                    info   = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'datetime';
                        backward      = $false;
                        title         = 'LC__TASK__DETAIL__WORKORDER__CREATION_DATE';
                        description   = 'Created'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'date_time';
                        readonly    = $true;
                        index       = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__UNIVERSAL__CREATED_BY';
                        description   = 'Created by'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = $true;
                        index       = $false;
                        field       = 'isys_obj__created_by';
                        table_alias = 'isys_obj'
                    }
                };
                changed     = [PSCustomObject] @{
                    title  = 'Last change';
                    check  = [PSCustomObject] @{
                        mandatory = $false
                    };
                    info   = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'datetime';
                        backward      = $false;
                        title         = 'LC__CMDB__LAST_CHANGE';
                        description   = 'Changed'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'date_time';
                        readonly    = $true;
                        index       = $true;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CMDB__LAST_CHANGE_BY';
                        description   = 'Changed'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = $true;
                        index       = $false;
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
                        primary_field = $false;
                        type          = 'dialog_plus';
                        backward      = $false;
                        title         = 'LC__CMDB__CATG__GLOBAL_PURPOSE';
                        description   = 'Purpose'
                    };
                    data   = [PSCustomObject] @{
                        type       = 'int';
                        readonly   = $false;
                        index      = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CMDB__CATG__GLOBAL_SYSID';
                        description   = 'SYSID'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = $false;
                        index       = $true;
                        field       = 'isys_obj__sysid';
                        table_alias = 'isys_obj'
                    }
                };
                cmdb_status = [PSCustomObject] @{
                    title  = 'CMDB status';
                    check  = [PSCustomObject] @{

                    };
                    info   = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'dialog';
                        backward      = $false;
                        title         = 'LC__UNIVERSAL__CMDB_STATUS';
                        description   = 'CMDB status'
                    };
                    data   = [PSCustomObject] @{
                        type       = 'int';
                        readonly   = $false;
                        index      = $false;
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
                        primary_field = $false;
                        type          = 'dialog';
                        backward      = $false;
                        title         = 'LC__REPORT__FORM__OBJECT_TYPE';
                        description   = 'Object-Type'
                    };
                    data   = [PSCustomObject] @{
                        type       = 'int';
                        readonly   = $false;
                        index      = $true;
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
                        mandatory = $false
                    };
                    info   = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'multiselect';
                        backward      = $false;
                        title         = 'LC__CMDB__CATG__GLOBAL_TAG';
                        description   = 'Tag'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'int';
                        readonly    = $false;
                        index       = $true;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'commentary';
                        backward      = $false;
                        title         = 'LC__CMDB__LOGBOOK__DESCRIPTION';
                        description   = 'Description'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text_area';
                        readonly    = $false;
                        index       = $false;
                        field       = 'isys_obj__description';
                        table_alias = 'isys_obj'
                    }
                };
                Category    = 'C__CATG__GLOBAL'
            }
        };
        Time     = '2025-05-17 14:26:31'
    }
    #endregion
    #region Category: C__CATG__CUSTOM_FIELDS_KOMPONENTE
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
                        mandatory = $false
                    };
                    info   = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'dialog_plus';
                        backward      = $false;
                        title         = 'Komponenten-Typ';
                        description   = 'f_popup'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'int';
                        readonly    = $false;
                        index       = $false;
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
                            show_in_list   = $false;
                            show_inline    = $false;
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
                        mandatory = $false
                    };
                    info   = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'multiselect';
                        backward      = $false;
                        title         = 'Technologie';
                        description   = 'f_popup'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'int';
                        readonly    = $false;
                        index       = $false;
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
                            show_in_list   = $false;
                            show_inline    = $false;
                            p_strTable     = 'isys_dialog_plus_custom';
                            condition      = 'isys_dialog_plus_custom__identifier = ''Technologie''';
                            p_arData       = [PSCustomObject] @{

                            };
                            p_strPopupType = 'dialog_plus';
                            p_identifier   = 'Technologie';
                            multiselect    = $true
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'URI';
                        description   = 'f_text'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = $false;
                        index       = $false;
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
                            show_in_list = $false;
                            show_inline  = $false
                        };
                        id     = 'c_17298533004299360'
                    }
                };
                f_popup_c_17298533887342620    = [PSCustomObject] @{
                    title  = 'Zugriff von';
                    check  = [PSCustomObject] @{
                        mandatory = $false
                    };
                    info   = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'dialog_plus';
                        backward      = $false;
                        title         = 'Zugriff von';
                        description   = 'f_popup'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'int';
                        readonly    = $false;
                        index       = $false;
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
                            show_in_list   = $false;
                            show_inline    = $false;
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
                        mandatory = $false
                    };
                    info   = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'dialog_plus';
                        backward      = $false;
                        title         = 'FOO-relevant';
                        description   = 'f_popup'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'int';
                        readonly    = $false;
                        index       = $false;
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
                            show_in_list   = $false;
                            show_inline    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'Linie2';
                        description   = 'hr'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = $false;
                        index       = $false;
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
                            show_in_list = $false;
                            show_inline  = $false
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
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
                        readonly    = $false;
                        index       = $false;
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
                            show_in_list = $false;
                            show_inline  = $false
                        };
                        id     = 'c_1730271199702280'
                    }
                };
                f_text_c_17298537143787710     = [PSCustomObject] @{
                    title = 'TFS-Projekt';
                    check = [PSCustomObject] @{
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'TFS-Projekt';
                        description   = 'f_text'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = $false;
                        index       = $false;
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
                            show_in_list = $false;
                            show_inline  = $false
                        };
                        id     = 'c_17298537143787710'
                    }
                };
                f_text_c_17298537407435620     = [PSCustomObject] @{
                    title = 'Solution-Pfad';
                    check = [PSCustomObject] @{
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'Solution-Pfad';
                        description   = 'f_text'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = $false;
                        index       = $false;
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
                            show_in_list = $false;
                            show_inline  = $false
                        };
                        id     = 'c_17298537407435620'
                    }
                };
                f_popup_c_17298537697067600    = [PSCustomObject] @{
                    title  = 'Fremdentwicklung';
                    check  = [PSCustomObject] @{
                        mandatory = $false
                    };
                    info   = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'dialog_plus';
                        backward      = $false;
                        title         = 'Fremdentwicklung';
                        description   = 'f_popup'
                    };
                    data   = [PSCustomObject] @{
                        type        = 'int';
                        readonly    = $false;
                        index       = $false;
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
                            show_in_list   = $false;
                            show_inline    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'Linie3';
                        description   = 'hr'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text';
                        readonly    = $false;
                        index       = $false;
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
                            show_in_list = $false;
                            show_inline  = $false
                        };
                        id     = 'c_17302928288173090'
                    }
                };
                f_textarea_c_17302904497397380 = [PSCustomObject] @{
                    title = 'Zusatzinfos';
                    check = [PSCustomObject] @{
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'textarea';
                        backward      = $false;
                        title         = 'Zusatzinfos';
                        description   = 'f_textarea'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text_area';
                        readonly    = $false;
                        index       = $false;
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
                            show_in_list = $false;
                            show_inline  = $false
                        };
                        id     = 'c_17302904497397380'
                    }
                };
                description                    = [PSCustomObject] @{
                    title = 'Description';
                    check = [PSCustomObject] @{
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'commentary';
                        backward      = $false;
                        title         = 'LC__CMDB__LOGBOOK__DESCRIPTION';
                        description   = 'commentary'
                    };
                    data  = [PSCustomObject] @{
                        type        = 'text_area';
                        readonly    = $false;
                        index       = $false;
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
    #endregion
    #region Category: C__CATG__MEMORY
    [PSCustomObject] @{
        Endpoint = 'cmdb.category_info.read';
        Request  = [PSCustomObject] @{
            method  = 'cmdb.category_info.read';
            id      = '17afc7b7-8e04-41a5-a4ea-6597aca2f1e5';
            params  = [PSCustomObject] @{
                category = 'C__CATG__MEMORY';
                apikey   = '****'
            };
            version = '2.0'
        };
        Response = [PSCustomObject] @{
            id      = '17afc7b7-8e04-41a5-a4ea-6597aca2f1e5';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                quantity = [PSCustomObject] @{
                    title = 'Quantity';
                    check = [PSCustomObject] @{
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        title              = 'LC__CMDB_CATG__MEMORY_QUANTITY';
                        type               = 'int';
                        primaryField       = $false;
                        backwardCompatible = $false;
                        alwaysInLogbook    = $false
                    };
                    data  = [PSCustomObject] @{
                        type        = 'int';
                        field       = 'isys_catg_memory_list__quantity';
                        sourceTable = 'isys_catg_memory_list';
                        readOnly    = $false;
                        joins       = @(
                            [PSCustomObject] @{

                            }
                        );
                        index       = $false;
                        select      = [PSCustomObject] @{

                        };
                        encrypt     = $false
                    };
                    ui    = [PSCustomObject] @{
                        id      = 'C__CATG__MEMORY_QUANTITY';
                        type    = 'text';
                        default = 1;
                        params  = [PSCustomObject] @{
                            p_onChange = 'idoit.callbackManager.triggerCallback(''memory__calc_capacity'');';
                            p_strClass = 'input-mini'
                        }
                    };
                    format=@(

                    )
                };
                title=[PSCustomObject] @{
                    title  = 'Title';
                    check  = [PSCustomObject] @{

                    };
                    info   = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'dialog_plus';
                        backward      = $false;
                        title         = 'LC__CMDB__CATG__TITLE';
                        description   = 'Title'
                    };
                    data   = [PSCustomObject] @{
                        type       = 'int';
                        readonly   = $false;
                        index      = $false;
                        field      = 'isys_catg_memory_list__isys_memory_title__id';
                        references = @(
                            'isys_memory_title',
                            'isys_memory_title__id'
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
                    ui     = [PSCustomObject] @{
                        type    = 'popup';
                        params  = [PSCustomObject] @{
                            p_strPopupType = 'dialog_plus';
                            p_strTable     = 'isys_memory_title';
                            p_bDbFieldNN   = 0
                        };
                        default = '-1';
                        id      = 'C__CATG__MEMORY_TITLE_ID'
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'dialog_plus',
                            'isys_memory_title'
                        )
                    }
                };
                manufacturer=[PSCustomObject] @{
                    title  = 'Manufacturer';
                    check  = [PSCustomObject] @{

                    };
                    info   = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'dialog_plus';
                        backward      = $false;
                        title         = 'LC__CMDB_CATG__MEMORY_MANUFACTURER';
                        description   = 'Manufacturer'
                    };
                    data   = [PSCustomObject] @{
                        type       = 'int';
                        readonly   = $false;
                        index      = $false;
                        field      = 'isys_catg_memory_list__isys_memory_manufacturer__id';
                        references = @(
                            'isys_memory_manufacturer',
                            'isys_memory_manufacturer__id'
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
                    ui     = [PSCustomObject] @{
                        type    = 'popup';
                        params  = [PSCustomObject] @{
                            p_strPopupType = 'dialog_plus';
                            p_strTable     = 'isys_memory_manufacturer';
                            p_bDbFieldNN   = 0
                        };
                        default = '-1';
                        id      = 'C__CATG__MEMORY_MANUFACTURER'
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'dialog_plus',
                            'isys_memory_manufacturer'
                        )
                    }
                };
                type=[PSCustomObject] @{
                    title  = 'Type';
                    check  = [PSCustomObject] @{

                    };
                    info   = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'dialog_plus';
                        backward      = $false;
                        title         = 'LC__CMDB_CATG__MEMORY_TYPE';
                        description   = 'Type'
                    };
                    data   = [PSCustomObject] @{
                        type       = 'int';
                        readonly   = $false;
                        index      = $false;
                        field      = 'isys_catg_memory_list__isys_memory_type__id';
                        references = @(
                            'isys_memory_type',
                            'isys_memory_type__id'
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
                    ui     = [PSCustomObject] @{
                        type    = 'popup';
                        params  = [PSCustomObject] @{
                            p_strPopupType = 'dialog_plus';
                            p_strTable     = 'isys_memory_type';
                            p_bDbFieldNN   = 0
                        };
                        default = '-1';
                        id      = 'C__CATG__MEMORY_TYPE'
                    };
                    format = [PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'dialog_plus',
                            'isys_memory_type'
                        )
                    }
                };
                total_capacity=[PSCustomObject] @{
                    title = 'Total capacity';
                    check = [PSCustomObject] @{
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        title              = 'LC__CATG__CMDB_MEMORY_TOTALCAPACITY';
                        type               = 'float';
                        primaryField       = $false;
                        backwardCompatible = $false;
                        alwaysInLogbook    = $false
                    };
                    data  = [PSCustomObject] @{
                        type        = 'float';
                        field       = 'isys_catg_memory_list__capacity';
                        sourceTable = 'isys_catg_memory_list';
                        readOnly    = $false;
                        joins       = @(
                            [PSCustomObject] @{

                            }
                        );
                        index       = $false;
                        select      = [PSCustomObject] @{

                        };
                        encrypt     = $false
                    };
                    ui    = [PSCustomObject] @{
                        id     = 'C__CATG__MEMORY_CAPACITY';
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_strClass       = 'input-medium';
                            p_strPlaceholder = '0.00';
                            p_onChange       = 'idoit.callbackManager.triggerCallback(''memory__calc_capacity'');';
                            p_onKeyUp = 'idoit.callbackManager.triggerCallback(''memory__calc_capacity'');'
                        }
                    };
                    format=@(

                    )
                };
                capacity=[PSCustomObject] @{
                    title = 'Capacity';
                    check = [PSCustomObject] @{
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'float';
                        backward      = $false;
                        title         = 'LC__CMDB_CATG__MEMORY_CAPACITY';
                        description   = 'Capacity'
                    };
                    data  = [PSCustomObject] @{
                        type      = 'float';
                        readonly  = $false;
                        index     = $false;
                        field     = 'isys_catg_memory_list__capacity';
                        select    = [PSCustomObject] @{

                        };
                        join      = @(
                            [PSCustomObject] @{

                            },
                            [PSCustomObject] @{

                            }
                        );
                        condition = [PSCustomObject] @{

                        }
                    };
                    ui    = [PSCustomObject] @{
                        type   = 'text';
                        params = [PSCustomObject] @{
                            p_strPlaceholder = '0.00';
                            p_onChange       = 'idoit.callbackManager.triggerCallback(''memory__calc_capacity'');';
                            p_onKeyUp = 'idoit.callbackManager.triggerCallback(''memory__calc_capacity'');';
                            p_strClass = 'input-medium'
                        };
                        id = 'C__CATG__MEMORY_CAPACITY'
                    };
                    format=[PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'convert',
                            'memory'
                        );
                        unit     = 'unit'
                    }
                };
                unit=[PSCustomObject] @{
                    title = 'Memory unit';
                    check = [PSCustomObject] @{

                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'dialog';
                        backward      = $false;
                        title         = 'LC__CATG__MEMORY_UNIT';
                        description   = 'Unit'
                    };
                    data  = [PSCustomObject] @{
                        type       = 'int';
                        readonly   = $false;
                        index      = $false;
                        field      = 'isys_catg_memory_list__isys_memory_unit__id';
                        references = @(
                            'isys_memory_unit',
                            'isys_memory_unit__id'
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
                    ui    = [PSCustomObject] @{
                        type   = 'dialog';
                        params = [PSCustomObject] @{
                            p_strTable   = 'isys_memory_unit';
                            p_strClass   = 'input-mini';
                            p_bDbFieldNN = 0;
                            p_onChange   = 'idoit.callbackManager.triggerCallback(''memory__calc_capacity'');'
                        };
                        default = '-1';
                        id = 'C__CATG__MEMORY_UNIT'
                    };
                    format=[PSCustomObject] @{
                        callback = @(
                            'isys_export_helper',
                            'dialog_plus'
                        )
                    }
                };
                description=[PSCustomObject] @{
                    title = 'Description';
                    check = [PSCustomObject] @{
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'commentary';
                        backward      = $false;
                        title         = 'LC__CMDB__LOGBOOK__DESCRIPTION';
                        description   = 'Description'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text_area';
                        readonly = $false;
                        index    = $false;
                        field    = 'isys_catg_memory_list__description';
                        select   = [PSCustomObject] @{

                        }
                    };
                    ui    = [PSCustomObject] @{
                        type = 'textarea';
                        id   = 'C__CMDB__CAT__COMMENTARY_05'
                    }
                };
                Category = 'C__CATG__MEMORY'
            }
        };
        Time = '2025-05-30 04:35:18'

    }
    #endregion
    #region Category: C__CATS__PERSON
    [PSCustomObject] @{
        Endpoint = 'cmdb.category_info.read';
        Request  = [PSCustomObject] @{
            method  = 'cmdb.category_info.read';
            id      = '1e9862d7-a338-43c4-8a5c-66a8674546c3';
            params  = [PSCustomObject] @{
                category = 'C__CATS__PERSON';
                apikey   = '****'
            };
            version = '2.0'
        };
        Response = [PSCustomObject] @{
            id      = '1e9862d7-a338-43c4-8a5c-66a8674546c3';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                title               = [PSCustomObject] @{
                    title = 'Title';
                    check = [PSCustomObject] @{
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CMDB__LOGBOOK__TITLE';
                        description   = 'Title'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        primary_field = $false;
                        type          = 'dialog';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_SALUTATION';
                        description   = 'Salutation'
                    };
                    data   = [PSCustomObject] @{
                        type     = 'int';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_FIRST_NAME';
                        description   = 'First name'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $true;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_LAST_NAME';
                        description   = 'Last name'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $true;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_ACADEMIC_DEGREE';
                        description   = 'Academic degree'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_FUNKTION';
                        description   = 'Function'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_SERVICE_DESIGNATION';
                        description   = 'Service designation'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_STEET';
                        description   = 'Street'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_CITY';
                        description   = 'City'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_ZIP_CODE';
                        description   = 'Zip-Code'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_MAIL_ADDRESS';
                        description   = 'E-mail address'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_TELEPHONE_COMPANY';
                        description   = 'Telephone company'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_TELEPHONE_HOME';
                        description   = 'Telephone home'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_TELEPHONE_MOBILE';
                        description   = 'Cellphone'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_FAX';
                        description   = 'Fax'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_PAGER';
                        description   = 'Pager'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_PERSONNEL_NUMBER';
                        description   = 'Personnel number'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__CONTACT__PERSON_DEPARTMENT';
                        description   = 'Department'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        primary_field    = $false;
                        type             = 'object_browser';
                        backward         = $false;
                        title            = 'LC__CONTACT__PERSON_ASSIGNED_ORGANISATION';
                        description      = 'Organisation';
                        backwardProperty = 'isys_cmdb_dao_category_s_organization_person::object'
                    };
                    data   = [PSCustomObject] @{
                        type             = 'int';
                        readonly         = $false;
                        index            = $false;
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
                        mandatory = $false
                    };
                    info   = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'LC__UNIVERSAL__ID';
                        description   = 'ID'
                    };
                    data   = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'DN';
                        description   = 'DN'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'commentary';
                        backward      = $false;
                        title         = 'LC__CMDB__LOGBOOK__DESCRIPTION';
                        description   = 'Description'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text_area';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'Custom 1';
                        description   = 'Custom property 1'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'Custom 2';
                        description   = 'Custom property 2'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'Custom 3';
                        description   = 'Custom property 3'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'Custom 4';
                        description   = 'Custom property 4'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'Custom 5';
                        description   = 'Custom property 5'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'Custom 6';
                        description   = 'Custom property 6'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'Custom 7';
                        description   = 'Custom property 7'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
                        mandatory = $false
                    };
                    info  = [PSCustomObject] @{
                        primary_field = $false;
                        type          = 'text';
                        backward      = $false;
                        title         = 'Custom 8';
                        description   = 'Custom property 8'
                    };
                    data  = [PSCustomObject] @{
                        type     = 'text';
                        readonly = $false;
                        index    = $false;
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
        Time     = '2025-05-30 04:34:27'
    }
    #endregion
)
