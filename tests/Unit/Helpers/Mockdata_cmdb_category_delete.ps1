<#
    1) This test (nd its data) is for one case only.
    All other cases are nearly the same, so there is no explicit test data for them.
    2) It mocks 2 endpoint methods cmdb.object.delete and cmdb.object.quick_purge.
#>

Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # check request values: All properties in the simulated request param (except apikey) should be in the request
    # returns the simulated response with the same id as the request
    $body = $body | ConvertFrom-Json
    $thisIdoitObject = $MockData_Cmdb_category_delete
    if ($null -ne $thisIdoitObject) {
        $thisIdoitObject.Response.id = $body.id
        $thisIdoitObject.Response
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'cmdb.category.delete'
}


$MockData_Cmdb_category_delete = [PSCustomObject] @{
    Endpoint = 'cmdb.category.delete';
    Request  = [PSCustomObject] @{
        params  = [PSCustomObject] @{
            objID    = 54766;
            category = 'C__CATG__MEMORY';
            id       = 12;
        };
        version = '2.0';
        method  = 'cmdb.category.delete';
        id      = '099c6add-2b2f-4c42-9545-81280fb940c4'
    };
    Response = [PSCustomObject] @{
        id      = '099c6add-2b2f-4c42-9545-81280fb940c4';
        jsonrpc = '2.0';
        result  = [PSCustomObject] @{
            success = 'True';
            message = "Category entry '12' successfully deleted"
        }
    };
    Time     = '2025-05-27 18:50:45'
}