# This mock simply returns the object type groups
Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # in this test case, we only only check the first condition
    $body = $body | ConvertFrom-Json
    $thisIdoitObject = $Mockdata_object_type_groups_read
    if ($null -ne $thisIdoitObject) {
        $thisIdoitObject.Response.id = $body.id
        $thisIdoitObject.Response
    }
    else {
        Throw "Mock for cmdb.object_type_groups.read should not reach this point"
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'cmdb.object_type_groups.read'
}


$Mockdata_object_type_groups_read =[PSCustomObject] @{
    Endpoint = 'cmdb.object_type_groups.read';
    Request  = [PSCustomObject] @{
        params  = [PSCustomObject] @{
            apikey = '****'
        };
        version = '2.0';
        method  = 'cmdb.object_type_groups.read';
        id      = 'bae420c2-8681-4b36-a781-94b66ea2bfd9'
    };
    Response = [PSCustomObject] @{
        id      = 'bae420c2-8681-4b36-a781-94b66ea2bfd9';
        jsonrpc = '2.0';
        result  = @(
            [PSCustomObject] @{
                id     = 1;
                title  = 'Software';
                const  = 'C__OBJTYPE_GROUP__SOFTWARE';
                status = 2
            },
            [PSCustomObject] @{
                id     = 2;
                title  = 'Infrastructure';
                const  = 'C__OBJTYPE_GROUP__INFRASTRUCTURE';
                status = 2
            },
            [PSCustomObject] @{
                id     = 3;
                title  = 'Other';
                const  = 'C__OBJTYPE_GROUP__OTHER';
                status = 2
            },
            [PSCustomObject] @{
                id     = 4;
                title  = 'Orphaned object types';
                const  = 'C__OBJTYPE_GROUP__ORPHANED';
                status = 2
            },
            [PSCustomObject] @{
                id     = 1000;
                title  = 'Contact';
                const  = 'C__OBJTYPE_GROUP__CONTACT';
                status = 2
            }
        )
    };
    Time     = '2025-05-18 08:32:34'
}