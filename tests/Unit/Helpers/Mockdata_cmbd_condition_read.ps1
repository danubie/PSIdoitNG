Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # in this test case, we only only check the first condition
    $body = $body | ConvertFrom-Json
    $thisIdoitObject = $Mockdata_cmbd_condition_read | Where-Object { $_.Request.params.conditions[0].value -eq $body.params.conditions[0].value }
    if ($null -ne $thisIdoitObject) {
        $thisIdoitObject.Response.id = $body.id
        $thisIdoitObject.Response
    }
    else {
        [PSCustomObject] @{
            id = $body.id;
            jsonrpc = '2.0';
            result=@()
        }
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'cmdb.condition.read'
}


$Mockdata_cmbd_condition_read = [PSCustomObject] @{
    Endpoint = 'cmdb.condition.read';
    Request  = [PSCustomObject] @{
        params  = [PSCustomObject] @{
            apikey     = '***';
            conditions = @(
                [PSCustomObject] @{
                    property   = 'C__CATG__GLOBAL-title';
                    value      = '*r540*';
                    comparison = 'like'
                },
                [PSCustomObject] @{
                    property   = 'C__CATG__GLOBAL-type';
                    value      = '5';
                    comparison = '='
                }
            )
        };
        version = '2.0';
        method  = 'cmdb.condition.read';
        id      = 'd75b60d2-2018-4d98-92fa-40791c739799'
    };
    Response = [PSCustomObject] @{
        id      = 'd75b60d2-2018-4d98-92fa-40791c739799';
        jsonrpc = '2.0';
        result  = @(
            [PSCustomObject] @{
                id                = 540;
                title             = 'server540';
                sysid             = 'SYSID_1730365404';
                type              = 5;
                created           = '2024-10-31 09:54:24';
                updated           = '2025-05-15 16:05:08';
                type_title        = 'Server';
                type_icon         = '/cmdb/object-type/image/5';
                type_group_title  = '';
                status            = 2;
                cmdb_status       = 6;
                cmdb_status_title = 'in operation'
            }
        )
    };
    Time     = '2025-05-18 07:49:24'
}