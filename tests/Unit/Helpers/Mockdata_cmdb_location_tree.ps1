Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # check request values: All properties in the simulated request param (except apikey) should be in the request
    # returns the simulated response with the same id as the request
    $body = $body | ConvertFrom-Json
    $thisIdoitObject = $MockData_Cmdb_location_tree
    if ($null -ne $thisIdoitObject) {
        $thisIdoitObject.Response.id = $body.id
        $thisIdoitObject.Response
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'cmdb.location_tree'
}
$MockData_Cmdb_location_tree = [PSCustomObject] @{
    Endpoint = 'cmdb.location_tree';
    Request  = [PSCustomObject] @{
        method  = 'cmdb.location_tree';
        id      = '41414563-1a4a-4e0d-9f68-e1d413c89c0d';
        params  = [PSCustomObject] @{
            id     = 1;
        };
        version = '2.0'
    };
    Response = [PSCustomObject] @{
        id      = '41414563-1a4a-4e0d-9f68-e1d413c89c0d';
        jsonrpc = '2.0';
        result  = @(
            [PSCustomObject] @{
                id                = 42638;
                title             = 'Azure';
                sysid             = 'SYSID_1744925000';
                type              = 84;
                type_title        = 'Country';
                status            = 2;
                cmdb_status       = 6;
                cmdb_status_title = 'in operation'
            },
            [PSCustomObject] @{
                id                = 42581;
                title             = 'Österreich';
                sysid             = 'SYSID_1744923360';
                type              = 84;
                type_title        = 'Country';
                status            = 2;
                cmdb_status       = 6;
                cmdb_status_title = 'in operation'
            }
        )
    };
    Time     = '2025-05-24 18:35:58'
}