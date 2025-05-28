<#
    Remark: This test (nd its data) is for one case only.
    All other cases are nearly the same, so there is no explicit test data for them.
#>

Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # check request values: All properties in the simulated request param (except apikey) should be in the request
    # returns the simulated response with the same id as the request
    $body = $body | ConvertFrom-Json
    $thisIdoitObject = $MockData_Cmdb_object_delete
    if ($null -ne $thisIdoitObject) {
        $thisIdoitObject.Response.id = $body.id
        $thisIdoitObject.Response
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'cmdb.object.delete'
}

Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # check request values: All properties in the simulated request param (except apikey) should be in the request
    # returns the simulated response with the same id as the request
    $body = $body | ConvertFrom-Json
    $thisIdoitObject = $MockData_Cmdb_object_delete
    if ($null -ne $thisIdoitObject) {
        $thisIdoitObject.Response.id = $body.id
        $thisIdoitObject.Response
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'cmdb.object.quick_purge'
}

$MockData_Cmdb_object_delete = [PSCustomObject] @{
    Endpoint = 'cmdb.object.delete';
    Request  = [PSCustomObject] @{
        version = '2.0';
        params  = [PSCustomObject] @{
            status = 'C__RECORD_STATUS__PURGE';
            id     = 54767
        };
        method  = 'cmdb.object.delete';
        id      = '592e3467-59ba-4fb3-b44d-c212167a45fb'
    };
    Response = [PSCustomObject] @{
        id      = '592e3467-59ba-4fb3-b44d-c212167a45fb';
        jsonrpc = '2.0';
        result  = [PSCustomObject] @{
            success = 'True';
            message = 'Object 54767 has been purged.'
        }
    };
    Time     = '2025-05-27 17:06:09'
}