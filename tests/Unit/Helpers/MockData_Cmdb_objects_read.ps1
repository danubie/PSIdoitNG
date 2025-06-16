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
        # C__OBJTYPE__PERSON, the mocked data has a type of 53 for persons
        if ($body.params.filter.type -eq 'C__OBJTYPE__PERSON') {
            $thisIdoitObject = $thisIdoitObject | Where-Object { $_.Response.result.type_title -eq 'Persons' }
        } else {
            $thisIdoitObject = $thisIdoitObject | Where-Object { $_.Response.result.type -in $body.params.filter.type }
        }
    }
    if ($null -ne $body.params.filter.title) {
        $thisIdoitObject = $thisIdoitObject | Where-Object { $_.Response.result.title -eq $body.params.filter.title }
        # in testcase title and requested category are set, so we have to check the category here for the object we've found
        # remeber: categories is not a filter, but a request parameter
        if ($null -ne $body.params.categories) {
            $catObj = $MockData_Cmdb_category_read | Where-Object { $_.Response.result.objID -eq $thisIdoitObject.Response.result.id }
            if ( $null -ne $catObj ) {
                $thisIdoitObject.Response.result | Add-Member -MemberType NoteProperty -Name 'C__CATS__PERSON' -Value $catObj.Response.result
            }
        }
    }
    if ($null -ne $body.params.filter.type_title) {
        $thisIdoitObject = $thisIdoitObject | Where-Object { $_.Response.result.type_title -eq $body.params.filter.type_title }
    }
    if ($null -ne $body.params.filter.status) {
        $thisIdoitObject = $thisIdoitObject | Where-Object { $_.Response.result.status -eq $body.params.filter.status }
    }
    if ($null -ne $thisIdoitObject) {
        [PSCustomObject] @{         # empty list
            id      = $body.id;
            jsonrpc = '2.0';
            result  = @($thisIdoitObject.Response.Result)       # objectreadS returns an array of objects
        }
    } else {
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
    # region persons
    [PSCustomObject] @{
        Endpoint = 'cmdb.objects.read';
        Request  = [PSCustomObject]@{
            method = 'cmdb.objects.read'; id = '9e2a082e-66a2-42b7-b055-61d99266f9a4'; version = '2.0';
            params = [PSCustomObject] @{
                id = 37
            }
        };
        Response = [PSCustomObject]@{
            id      = '{0}';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                id                = 37;
                title             = 'userw@spambog.com';
                sysid             = 'SYSID_1733071461';
                type              = 53;                         # objectS.read returns type (not objecttype)
                type_title        = 'Persons';
                type_icon         = '/cmdb/object-type/image/53';
                status            = 2;
                cmdb_status       = 6;
                cmdb_status_title = 'in operation';
                created           = '2024-10-09 12:56:39';
                updated           = '2025-05-11 23:10:17';
                image             = '/cmdb/object/image/37'
            }
        };
        Time     = '2025-05-12 18:08:13'
    }
    [PSCustomObject] @{
        Endpoint = 'cmdb.objects.read';
        Request  = [PSCustomObject] @{ method = 'cmdb.objects.read'; id = '76b013a7-047f-4793-9356-33a761bed501'; version = '2.0'; params = [PSCustomObject] @{
                id = 28
            }
        };
        Response = [PSCustomObject]@{
            id      = '{0}';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                id                = 28;
                title             = 'User P';
                sysid             = 'SYSID_1728465262';
                type        = 53;
                type_title        = 'Persons';
                type_icon         = '/cmdb/object-type/image/53';
                status            = 2;
                cmdb_status       = 6;
                cmdb_status_title = 'in operation';
                created           = '2024-10-09 11:13:54';
                updated           = '2025-05-11 23:10:09';
                image             = '/cmdb/object/image/28'
            }
        };
        Time     = '2025-05-12 18:09:33'
    }
    #endregion persons

    #region server540
    [PSCustomObject] @{
        Endpoint = 'cmdb.objects.read';
        Request  = [PSCustomObject] @{ method = 'cmdb.objects.read'; id = '4a18bed9-6b9a-4725-a979-943ef85da4eb'; version = '2.0'; params = [PSCustomObject] @{
                id = 540
            }
        };
        Response = [PSCustomObject]@{
            id      = '4a18bed9-6b9a-4725-a979-943ef85da4eb';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                id                = 540;
                title             = 'server540';
                sysid             = 'SYSID_1730365404';
                type        = 5;
                type_title        = 'Server';
                type_icon         = '/cmdb/object-type/image/5';
                status            = 2;
                cmdb_status       = 6;
                cmdb_status_title = 'in operation';
                created           = '2024-10-31 09:54:24';
                updated           = '2025-05-04 18:18:12';
                image             = '/cmdb/object/image/540'
            }
        };
        Time     = '2025-05-12 18:32:11'
    }
    #endregion server540
    #region CustomObject 4675
    [PSCustomObject] @{
        Endpoint = 'cmdb.objects.read';
        Request  = [PSCustomObject] @{
            params  = [PSCustomObject] @{
                id     = 4675;
                apikey = '***'
            };
            version = '2.0';
            id      = '84df30b0-2b77-466f-bd4e-a29411940b83';
            method  = 'cmdb.objects.read'
        };
        Response = [PSCustomObject] @{
            id      = '84df30b0-2b77-466f-bd4e-a29411940b83';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                id                = 4675;
                title             = '042_eServicPortal_Housekeeper';
                sysid             = 'SYSID_1734102557';
                type        = 93;
                type_title        = 'Komponente';
                type_icon         = '/cmdb/object-type/image/93';
                status            = 2;
                cmdb_status       = 6;
                cmdb_status_title = 'in operation';
                created           = '2024-12-21 18:14:51';
                updated           = '2025-05-15 16:32:15';
                image             = '/cmdb/object/image/4675'
            }
        };
        Time     = '2025-05-29 10:46:31'
    }
    #endregion CustomObject 4675
)
