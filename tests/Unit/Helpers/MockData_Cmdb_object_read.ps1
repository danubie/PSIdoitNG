$MockData_Cmdb_object_read = @(
    # region persons
    [PSCustomObject] @{
        Endpoint = 'cmdb.object.read';
        Request  = [PSCustomObject]@{
            method = 'cmdb.object.read'; id = '9e2a082e-66a2-42b7-b055-61d99266f9a4'; version = '2.0';
            params = [PSCustomObject] @{
                id     = 37
            }
        };
        Response = [PSCustomObject]@{
            id      = '{0}';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                id                = 37;
                title             = 'Wolfgang Wagner';
                sysid             = 'SYSID_1733071461';
                objecttype        = 53;
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
        Endpoint = 'cmdb.object.read';
        Request  = [PSCustomObject] @{ method = 'cmdb.object.read'; id = '76b013a7-047f-4793-9356-33a761bed501'; version = '2.0'; params = [PSCustomObject] @{
                id     = 28
            }
        };
        Response = [PSCustomObject]@{
            id      = '{0}';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                id                = 28;
                title             = 'User P';
                sysid             = 'SYSID_1728465262';
                objecttype        = 53;
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
        Endpoint = 'cmdb.object.read';
        Request  = [PSCustomObject] @{ method = 'cmdb.object.read'; id = '4a18bed9-6b9a-4725-a979-943ef85da4eb'; version = '2.0'; params = [PSCustomObject] @{
                id     = 540
            }
        };
        Response = [PSCustomObject]@{
            id      = '4a18bed9-6b9a-4725-a979-943ef85da4eb';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                id                = 540;
                title             = 'server540';
                sysid             = 'SYSID_1730365404';
                objecttype        = 5;
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
)
Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # check request values: All properties in the simulated request param (except apikey) should be in the request
    # returns the simulated response with the same id as the request
    $thisIdoitObject = $MockData_Cmdb_object_read | Where-Object { $_.Request.params.id -eq ($body | ConvertFrom-Json).params.id }
    if ($null -ne $thisIdoitObject) {
        $thisIdoitObject.Response.id = ($body | ConvertFrom-Json).id
        $thisIdoitObject.Response
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'cmdb.object.read'
}