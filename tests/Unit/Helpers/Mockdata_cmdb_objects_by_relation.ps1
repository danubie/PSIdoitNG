Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # check request values: All properties in the simulated request param (except apikey) should be in the request
    # returns the simulated response with the same id as the request
    # Special case: The API does not return any reference to the category name => this is added in the function
    #      so the simulation currently can only handle one call
    $body = $body | ConvertFrom-Json
    $thisIdoitObject = $MockData_Cmdb_objects_by_relation | Where-Object { $_.Request.params.Id -eq $body.params.Id }
    if ($null -ne $body.params.relation_type) {
        switch -Regex ($body.params.relation_type) {
            '53|Persons' {              # setting to $null is not really correct, but should fit for tests
                $thisIdoitObject.Response.result =[PSCustomObject] @{
                    561 = $thisIdoitObject.Response.result.561
                    562 = $thisIdoitObject.Response.result.562
                }
            }
            '93|Komponente' {
                $thisIdoitObject.Response.result.561 = $null
                $thisIdoitObject.Response.result.562 = $null
            }
            Default { $thisIdoitObject = $null }
        }
    }
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
                message = "Mock: Invalid parameters: Id '$($body.params.Id)' or relation_type '$($body.params.relation_type)' not found."
            }
        }
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'cmdb.objects_by_relation'
}


$MockData_Cmdb_objects_by_relation = @(

    [PSCustomObject] @{
        Endpoint = 'cmdb.objects_by_relation';
        Request  = [PSCustomObject] @{
            params  = [PSCustomObject] @{
                apikey = '*****';
                id     = '540'
            };
            version = '2.0';
            id      = '48d349fd-30fd-43cc-83b4-f79b51e40819';
            method  = 'cmdb.objects_by_relation'
        };
        Response = [PSCustomObject] @{
            id      = '48d349fd-30fd-43cc-83b4-f79b51e40819';
            jsonrpc = '2.0';
            result  = [PSCustomObject] @{
                561 = [PSCustomObject] @{
                    data     = [PSCustomObject] @{
                        id                        = 561;
                        title                     = 'User W administriert server540';
                        cmdb_status_title         = '';
                        related_object            = 37;
                        related_title             = 'userw@spambog.com';
                        related_type              = 53;
                        related_type_title        = 'Persons';
                        related_cmdb_status_title = 'in operation';
                        master                    = 37;
                        slave                     = 540;
                        type                      = 60;
                        type_title                = 'Relation'
                    };
                    children = $false
                };
                562 = [PSCustomObject] @{       # useually, there would be a different person. This is just for unit tests
                    data     = [PSCustomObject] @{
                        id                        = 562;
                        title                     = 'User W administriert server540';
                        cmdb_status_title         = '';
                        related_object            = 37;
                        related_title             = 'userw@spambog.com';
                        related_type              = 53;
                        related_type_title        = 'Persons';
                        related_cmdb_status_title = 'in operation';
                        master                    = 37;
                        slave                     = 540;
                        type                      = 60;
                        type_title                = 'Relation'
                    };
                    children = $false
                };
                541 = [PSCustomObject] @{
                    data     = [PSCustomObject] @{
                        id                        = 541;
                        title                     = 'Komponente läuft auf';
                        cmdb_status_title         = '';
                        related_object            = 4675;
                        related_title             = 'Title4675';
                        related_type              = 93;
                        related_type_title        = 'Komponente';
                        related_cmdb_status_title = 'in operation';
                        master                    = 4675;
                        slave                     = 540;
                        type                      = 60;
                        type_title                = 'Relation'
                    };
                    children = $false
                };
            }
        };
        Time     = '2025-07-05 18:10:37'
    }
)
