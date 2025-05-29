Mock Invoke-RestMethod -ModuleName PSIdoitNG -MockWith {
    # in this test case, we only only check the first condition
    $body = $body | ConvertFrom-Json
    $body.params.q | Should -Not -BeNullOrEmpty -Because 'Search query should not be empty'
    $thisIdoitObject = $Mockdata_idoit_search_read | Where-Object { $_.Request.params.q -eq $body.params.q -or $_.Request.params.q -like $body.params.q}
    if ($null -ne $thisIdoitObject) {
        $thisIdoitObject.Response.id = $body.id
        $thisIdoitObject.Response
    }
    else {
        [PSCustomObject] @{
            id      = $body.id;
            jsonrpc = '2.0';
            result  = @()
        }
    }
} -ParameterFilter {
    (($body | ConvertFrom-Json).method) -eq 'idoit.search'
}


$Mockdata_idoit_search_read = [PSCustomObject] @{
    Endpoint = 'idoit.search';
    Request  = [PSCustomObject] @{
        params  = [PSCustomObject] @{
            q      = '*540*';
            apikey = '****'
        };
        version = '2.0';
        id      = '051c4bd1-b380-4d97-a026-b096c2c91ac3';
        method  = 'idoit.search'
    };
    Response = [PSCustomObject] @{
        id      = '051c4bd1-b380-4d97-a026-b096c2c91ac3';
        jsonrpc = '2.0';
        result  = @(
            [PSCustomObject] @{
                documentId = 540;
                key        = 'Server > Host address > Domain';
                value      = 'server540: some.dom';
                type       = 'cmdb';
                link       = '/?objID=540&catgID=47&cateID=3&highlight=%2Abkp%2A';
                score      = 92;
                status     = 'Normal'
            },
            [PSCustomObject] @{
                documentId = 540;
                key        = 'Server > General > Title';
                value      = 'server540';
                type       = 'cmdb';
                link       = '/?objID=540&catgID=1&cateID=540&highlight=%2Abkp%2A';
                score      = 88;
                status     = 'Normal'
            },
            [PSCustomObject] @{
                documentId = 540;
                key        = 'Server > Host address > Hostname';
                value      = 'server540: server540.some.dom';
                type       = 'cmdb';
                link       = '/?objID=540&catgID=47&cateID=3&highlight=%2Abkp%2A';
                score      = 79;
                status     = 'Normal'
            }
        )
    };
    Time     = '2025-05-29 06:28:31'
}