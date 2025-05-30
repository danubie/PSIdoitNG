Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # returns the simulated response with the same id as the request
    # in this case, we only can search for the type id (not the name)
    $body = $body | ConvertFrom-Json
    $thisIdoitObject = $MockData_Cmbd_type_categories_read | Where-Object { $_.Request.params.type -eq $body.params.type }
    if ($null -ne $thisIdoitObject) {
        $thisIdoitObject.Response.id = $body.id
        $thisIdoitObject.Response
    }
    else {
        [PSCustomObject] @{
            id      = '47450e73-a953-4519-9fc4-3d64633fba26';
            jsonrpc = '2.0';
            error   = [PSCustomObject] @{
                code    = -32099;
                message = 'i-doit system error: Object type not found.'
            }
        }
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'cmdb.object_type_categories.read'
}

$MockData_Cmbd_type_categories_read = @(
    [PSCustomObject] @{
        Endpoint = 'cmdb.object_type_categories.read';
        Request  = [PSCustomObject] @{
            params  = [PSCustomObject] @{
                type = 53; # persons
            };
            version = '2.0';
            method  = 'cmdb.object_type_categories.read';
            id      = '6c87be4b-e75a-4036-807a-624131a8476d'
        };
        Response = [PSCustomObject] @{
            id      = '6c87be4b-e75a-4036-807a-624131a8476d';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                catg = @(
                    [PSCustomObject] @{
                        id          = 31;
                        title       = 'Overview page';
                        const       = 'C__CATG__OVERVIEW';
                        multi_value = 0
                    }, [PSCustomObject] @{
                        id          = 80;
                        title       = 'Service assignment';
                        const       = 'C__CATG__IT_SERVICE';
                        multi_value = 1
                    }, [PSCustomObject] @{
                        id          = 82;
                        title       = 'Relationship';
                        const       = 'C__CATG__RELATION';
                        multi_value = 1
                    }, [PSCustomObject] @{
                        id          = 89;
                        title       = 'Status-Planning';
                        const       = 'C__CATG__PLANNING';
                        multi_value = 1
                    }, [PSCustomObject] @{
                        id          = 99;
                        title       = 'Assigned Workplaces';
                        const       = 'C__CATG__PERSON_ASSIGNED_WORKSTATION';
                        multi_value = 0
                    }, [PSCustomObject] @{
                        id          = 104;
                        title       = 'E-Mail addresses';
                        const       = 'C__CATG__MAIL_ADDRESSES';
                        multi_value = 1
                    }, [PSCustomObject] @{
                        id          = 114;
                        title       = 'Access permissions';
                        const       = 'C__CATG__VIRTUAL_AUTH';
                        multi_value = 0
                    }, [PSCustomObject] @{
                        id          = 185;
                        title       = 'Assigned Subscriptions';
                        const       = 'C__CATG__ASSIGNED_SUBSCRIPTIONS';
                        multi_value = 1
                    }, [PSCustomObject] @{
                        id          = 1;
                        title       = 'General';
                        const       = 'C__CATG__GLOBAL';
                        multi_value = 0
                    }, [PSCustomObject] @{
                        id          = 22;
                        title       = 'Logbook';
                        const       = 'C__CATG__LOGBOOK';
                        multi_value = 1
                    }, [PSCustomObject] @{
                        id          = 27;
                        title       = 'Object picture';
                        const       = 'C__CATG__IMAGE';
                        multi_value = 0
                    }
                );
                cats = @(
                    [PSCustomObject] @{
                        id          = 48;
                        title       = 'Persons';
                        const       = 'C__CATS__PERSON';
                        multi_value = 0
                    }, [PSCustomObject] @{
                        id          = 49;
                        title       = 'Master Data';
                        const       = 'C__CATS__PERSON_MASTER';
                        parent      = 48;
                        multi_value = 0
                    }, [PSCustomObject] @{
                        id          = 50;
                        title       = 'Login';
                        const       = 'C__CATS__PERSON_LOGIN';
                        parent      = 48;
                        multi_value = 0
                    }, [PSCustomObject] @{
                        id          = 51;
                        title       = 'Person group memberships';
                        const       = 'C__CATS__PERSON_ASSIGNED_GROUPS';
                        parent      = 48;
                        multi_value = 1
                    }, [PSCustomObject] @{
                        id          = 56;
                        title       = 'Assigned objects (Person)';
                        const       = 'C__CATS__PERSON_CONTACT_ASSIGNMENT';
                        parent      = 48;
                        multi_value = 1
                    }, [PSCustomObject] @{
                        id          = 90;
                        title       = 'Authorization config';
                        const       = 'C__CATS__BASIC_AUTH';
                        parent      = 52;
                        multi_value = 0
                    }
                )
            }
        };
        Time     = '2025-05-14 05:56:53'
    }
    [PSCustomObject] @{
        Endpoint = 'cmdb.object_type_categories.read';
        Request  = [PSCustomObject] @{
            version = '2.0';
            params  = [PSCustomObject] @{
                type = 5              # server
            };
            method  = 'cmdb.object_type_categories.read';
            id      = 'c0ea3fec-54b5-4727-9495-5ded4c1deaaf'
        };
        Response = [PSCustomObject] @{
            id      = 'c0ea3fec-54b5-4727-9495-5ded4c1deaaf';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                catg = @(
                    [PSCustomObject] @{
                        id          = 31;
                        title       = 'Overview page';
                        const       = 'C__CATG__OVERVIEW';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 42;
                        title       = 'Drive';
                        const       = 'C__CATG__DRIVE';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 50;
                        title       = 'Connectors';
                        const       = 'C__CATG__CONNECTOR';
                        parent      = 49;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 80;
                        title       = 'Service assignment';
                        const       = 'C__CATG__IT_SERVICE';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 82;
                        title       = 'Relationship';
                        const       = 'C__CATG__RELATION';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 89;
                        title       = 'Status-Planning';
                        const       = 'C__CATG__PLANNING';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 10;
                        title       = 'Interface';
                        const       = 'C__CATG__UNIVERSAL_INTERFACE';
                        parent      = 49;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 43;
                        title       = 'Device';
                        const       = 'C__CATG__STORAGE_DEVICE';
                        parent      = 8;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 56;
                        title       = 'Logical devices (LDEV Server)';
                        const       = 'C__CATG__LDEV_SERVER';
                        parent      = 46;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 57;
                        title       = 'Logical devices (Client)';
                        const       = 'C__CATG__LDEV_CLIENT';
                        parent      = 46;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 45;
                        title       = 'FC port';
                        const       = 'C__CATG__CONTROLLER_FC_PORT';
                        parent      = 46;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 58;
                        title       = 'Host Bus Adapter (HBA)';
                        const       = 'C__CATG__HBA';
                        parent      = 46;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 38;
                        title       = 'Accounting';
                        const       = 'C__CATG__ACCOUNTING';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 46;
                        title       = 'Storage Area Network';
                        const       = 'C__CATG__SANPOOL';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 65;
                        title       = 'Cluster memberships';
                        const       = 'C__CATG__CLUSTER_MEMBERSHIPS';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 69;
                        title       = 'Virtual host';
                        const       = 'C__CATG__VIRTUAL_HOST_ROOT';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 70;
                        title       = 'Virtual host';
                        const       = 'C__CATG__VIRTUAL_HOST';
                        parent      = 69;
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 71;
                        title       = 'Guest systems';
                        const       = 'C__CATG__GUEST_SYSTEMS';
                        parent      = 69;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 73;
                        title       = 'Virtual Switches';
                        const       = 'C__CATG__VIRTUAL_SWITCH';
                        parent      = 69;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 74;
                        title       = 'Virtual devices';
                        const       = 'C__CATG__VIRTUAL_DEVICE';
                        parent      = 72;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 76;
                        title       = 'Backup (assigned Objects)';
                        const       = 'C__CATG__BACKUP__ASSIGNED_OBJECTS';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 77;
                        title       = 'Group memberships';
                        const       = 'C__CATG__GROUP_MEMBERSHIPS';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 100;
                        title       = 'Contract assignment';
                        const       = 'C__CATG__CONTRACT_ASSIGNMENT';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 109;
                        title       = 'Share Access';
                        const       = 'C__CATG__SHARE_ACCESS';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 114;
                        title       = 'Access permissions';
                        const       = 'C__CATG__VIRTUAL_AUTH';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 139;
                        title       = 'Network listener';
                        const       = 'C__CATG__NET_CONNECTIONS_FOLDER';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 140;
                        title       = 'Listener';
                        const       = 'C__CATG__NET_LISTENER';
                        parent      = 139;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 141;
                        title       = 'Network connections';
                        const       = 'C__CATG__NET_CONNECTOR';
                        parent      = 139;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 154;
                        title       = 'Operating system';
                        const       = 'C__CATG__OPERATING_SYSTEM';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 161;
                        title       = 'Remote Management Controller';
                        const       = 'C__CATG__RM_CONTROLLER';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 177;
                        title       = 'Database hierarchy';
                        const       = 'C__CATG__DATABASE_FOLDER';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 178;
                        title       = 'DBMS information';
                        const       = 'C__CATG__DATABASE';
                        parent      = 177;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 179;
                        title       = 'Database tables';
                        const       = 'C__CATG__DATABASE_TABLE';
                        parent      = 177;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 180;
                        title       = 'Databases';
                        const       = 'C__CATG__DATABASE_SA';
                        parent      = 177;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 55;
                        title       = 'Raid-Array';
                        const       = 'C__CATG__RAID';
                        parent      = 8;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 81;
                        title       = 'Object vitality';
                        const       = 'C__CATG__OBJECT_VITALITY';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 72;
                        title       = 'Virtual machine';
                        const       = 'C__CATG__VIRTUAL_MACHINE__ROOT';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 1;
                        title       = 'General';
                        const       = 'C__CATG__GLOBAL';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 36;
                        title       = 'Virtual machine';
                        const       = 'C__CATG__VIRTUAL_MACHINE';
                        parent      = 72;
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 21;
                        title       = 'Contact assignment';
                        const       = 'C__CATG__CONTACT';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 26;
                        title       = 'Location';
                        const       = 'C__CATG__LOCATION';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 35;
                        title       = 'Graphic card';
                        const       = 'C__CATG__GRAPHIC';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 2;
                        title       = 'Model';
                        const       = 'C__CATG__MODEL';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 61;
                        title       = 'Shares';
                        const       = 'C__CATG__SHARES';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 3;
                        title       = 'Form factor';
                        const       = 'C__CATG__FORMFACTOR';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 33;
                        title       = 'Sound card';
                        const       = 'C__CATG__SOUND';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 4;
                        title       = 'CPU';
                        const       = 'C__CATG__CPU';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 25;
                        title       = 'Controller';
                        const       = 'C__CATG__CONTROLLER';
                        parent      = 8;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 5;
                        title       = 'Memory';
                        const       = 'C__CATG__MEMORY';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 9;
                        title       = 'Power consumer';
                        const       = 'C__CATG__POWER_CONSUMER';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 40;
                        title       = 'Network-Interface';
                        const       = 'C__CATG__NETWORK_INTERFACE';
                        parent      = 7;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 7;
                        title       = 'Network';
                        const       = 'C__CATG__NETWORK';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 39;
                        title       = 'Port';
                        const       = 'C__CATG__NETWORK_PORT';
                        parent      = 7;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 94;
                        title       = 'Port overview';
                        const       = 'C__CATG__NETWORK_PORT_OVERVIEW';
                        parent      = 7;
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 8;
                        title       = 'Direct Attached Storage';
                        const       = 'C__CATG__STORAGE';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 41;
                        title       = 'logical Ports';
                        const       = 'C__CATG__NETWORK_LOG_PORT';
                        parent      = 7;
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 28;
                        title       = 'Manual assignment';
                        const       = 'C__CATG__MANUAL';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 18;
                        title       = 'Emergency plan assignment';
                        const       = 'C__CATG__EMERGENCY_PLAN';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 47;
                        title       = 'Host address';
                        const       = 'C__CATG__IP';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 20;
                        title       = 'File assignment';
                        const       = 'C__CATG__FILE';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 12;
                        title       = 'Software assignment';
                        const       = 'C__CATG__APPLICATION';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 22;
                        title       = 'Logbook';
                        const       = 'C__CATG__LOGBOOK';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 14;
                        title       = 'Access';
                        const       = 'C__CATG__ACCESS';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 15;
                        title       = 'Backup';
                        const       = 'C__CATG__BACKUP';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 27;
                        title       = 'Object picture';
                        const       = 'C__CATG__IMAGE';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 167;
                        title       = 'VRRP membership';
                        const       = 'C__CATG__VRRP_VIEW';
                        parent      = 7;
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 51;
                        title       = 'Invoice';
                        const       = 'C__CATG__INVOICE';
                        multi_value = 1;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 49;
                        title       = 'Cabling';
                        const       = 'C__CATG__CABLING';
                        multi_value = 0;
                        type        = 'catg'
                    }, [PSCustomObject] @{
                        id          = 188;
                        title       = 'Connection endpoint';
                        const       = 'C__CATG__CONNECTION_ENDPOINT';
                        parent      = 7;
                        multi_value = 1;
                        type        = 'catg'
                    }
                )
            }
        };
        Time     = '2025-05-15 11:33:04'
    }
    [PSCustomObject] @{
        Endpoint = 'cmdb.object_type_categories.read';
        Request  = [PSCustomObject] @{
            params  = [PSCustomObject] @{
                type   = 93;
                apikey = '****'
            };
            version = '2.0';
            id      = '80d693b4-2930-4d72-a586-1a15dc9564c4';
            method  = 'cmdb.object_type_categories.read'
        };
        Response = [PSCustomObject] @{
            id      = '80d693b4-2930-4d72-a586-1a15dc9564c4';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                catg   = @(
                    [PSCustomObject] @{
                        id          = 82;
                        title       = 'Relationship';
                        const       = 'C__CATG__RELATION';
                        multi_value = 1;
                        type        = 'catg'
                    },
                    [PSCustomObject] @{
                        id          = 89;
                        title       = 'Status-Planning';
                        const       = 'C__CATG__PLANNING';
                        multi_value = 1;
                        type        = 'catg'
                    },
                    [PSCustomObject] @{
                        id          = 114;
                        title       = 'Access permissions';
                        const       = 'C__CATG__VIRTUAL_AUTH';
                        multi_value = 0;
                        type        = 'catg'
                    },
                    [PSCustomObject] @{
                        id          = 1;
                        title       = 'General';
                        const       = 'C__CATG__GLOBAL';
                        multi_value = 0;
                        type        = 'catg'
                    },
                    [PSCustomObject] @{
                        id          = 98;
                        title       = 'All Tickets';
                        const       = 'C__CATG__VIRTUAL_TICKETS';
                        multi_value = 0;
                        type        = 'catg'
                    },
                    [PSCustomObject] @{
                        id          = 176;
                        title       = 'Listedit';
                        const       = 'C__CATG__MULTIEDIT';
                        multi_value = 0;
                        type        = 'catg'
                    },
                    [PSCustomObject] @{
                        id          = 21;
                        title       = 'Contact assignment';
                        const       = 'C__CATG__CONTACT';
                        multi_value = 1;
                        type        = 'catg'
                    },
                    [PSCustomObject] @{
                        id          = 22;
                        title       = 'Logbook';
                        const       = 'C__CATG__LOGBOOK';
                        multi_value = 1;
                        type        = 'catg'
                    }
                );
                cats   = @(
                    [PSCustomObject] @{
                        id          = 20;
                        title       = 'Applications';
                        const       = 'C__CATS__APPLICATION';
                        parent      = 62;
                        multi_value = 0;
                        type        = 'cats'
                    },
                    [PSCustomObject] @{
                        id          = 73;
                        title       = 'Installation';
                        const       = 'C__CATS__APPLICATION_ASSIGNED_OBJ';
                        parent      = 20;
                        multi_value = 1;
                        type        = 'cats'
                    },
                    [PSCustomObject] @{
                        id          = 89;
                        title       = 'Variants';
                        const       = 'C__CATS__APPLICATION_VARIANT';
                        multi_value = 1;
                        type        = 'cats'
                    }
                );
                custom = @(
                    [PSCustomObject] @{
                        id          = 2;
                        title       = 'Komponente von';
                        const       = 'C__CATG__CUSTOM_FIELDS_VERWENDUNG_IN_APPLIKATIONEN';
                        parent      = 0;
                        multi_value = 0;
                        type        = 'custom'
                    },
                    [PSCustomObject] @{
                        id          = 9;
                        title       = 'Verlinkungen';
                        const       = 'C__CATG__CUSTOM_FIELDS_VERLINKUNGEN_NEU';
                        parent      = 0;
                        multi_value = 1;
                        type        = 'custom'
                    },
                    [PSCustomObject] @{
                        id          = 10;
                        title       = 'Zugriff URLs';
                        const       = 'C__CATG__CUSTOM_FIELDS_ZUGRIFF_URLS_NEU';
                        parent      = 0;
                        multi_value = 1;
                        type        = 'custom'
                    },
                    [PSCustomObject] @{
                        id          = 3;
                        title       = 'Detailinfos Komponente';
                        const       = 'C__CATG__CUSTOM_FIELDS_KOMPONENTE';
                        parent      = 0;
                        multi_value = 0;
                        type        = 'custom'
                    }
                )
            }
        };
        Time     = '2025-05-29 10:59:55'
    }

)
