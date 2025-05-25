Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # check request values: All properties in the simulated request param (except apikey) should be in the request
    # returns the simulated response with the same id as the request
    $body = $body | ConvertFrom-Json
    $thisIdoitObject = $MockData_Cmdb_dialog
    if ($null -ne $thisIdoitObject) {
        $thisIdoitObject.Response.id = $body.id
        $thisIdoitObject.Response
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'cmdb.dialog'
}
$MockData_Cmdb_dialog = [PSCustomObject] @{
    Endpoint = 'cmdb.dialog';
    Request  = [PSCustomObject] @{
        method  = 'cmdb.dialog';
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
                id                = 1;
                const              = '';
                title             = 'AMD';
            },
            [PSCustomObject] @{
                id                = 2;
                const              = '';
                title             = 'Intel';
            },
            [PSCustomObject] @{
                id                = 3;
                const              = '';
                title             = 'IBM';
            },
            [PSCustomObject] @{
                id                = 4;
                const              = '';
                title             = 'Motorla';
            }
        )
    };
    Time     = '2025-05-24 18:35:58'
}