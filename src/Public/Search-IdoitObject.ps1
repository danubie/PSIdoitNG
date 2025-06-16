function Search-IdoItObject {
    <#
    .SYNOPSIS
    Searches for objects in the i-doit CMDB based on specified conditions.

    .DESCRIPTION
    This cmdlet allows you to search for objects in the i-doit CMDB by providing an array of conditions.
    The conditions are passed as an array of hashtable entries.

    Against the usual naming of the functions, it implements "cmdb.condition.read".

    .PARAMETER Conditions
    An array of hashtable entries defining the search conditions. Each hashtable should include keys like
    "property", "operator", and "value".

    .PARAMETER Status
    A string representing the status of the objects to be searched. It can be one of the following:
    - 'C__RECORD_STATUS__NORMAL' (default),
    - 'C__RECORD_STATUS__ARCHIVED',
    - 'C__RECORD_STATUS__DELETED',
    - 'ALL'

    .PARAMETER Query
    A string representing the a simple search query. It will find all objects that match the query.
    This might be used to get a quick overview of objects in the i-doit CMDB.

    .EXAMPLE
    PS> Search-IdoItObject -Conditions @(
         @{ "property" = "C__CATG__GLOBAL-title"; "comparison" = "like"; "value" = "*r540*" },
         @{ "property" = "C__CATG__GLOBAL-type"; "comparison" = "="; "value" = "5" }
     )

    This will search for objects where the title contains "Server" and the type is "Server".

     id title           sysid       type created             updated             type_title type_icon                 type_group_title status
     -- -----           -----       ---- -------             -------             ---------- ---------                 ---------------- ------
    540 server540 SYSID_1730365404     5 2024-10-31 09:54:24 2025-05-15 16:05:08 Server     /cmdb/object-type/image/5                       2

    .NOTES
    API version 33 behaviour (or some other?)

    Be aware that some files are case sensitive! I know, that this is not the best practice, but I don't know who designed this.
    not case sensitive (title): Search-IdoItObject -Conditions @{"property" = "C__CATG__GLOBAL-title"; "comparison" = "="; "value" = "yOuR-Server"}
        returns records
    but case sensitive (type) : Search-IdoItObject -Conditions @{"property" = "C__CATG__GLOBAL-type"; "comparison" = "="; "value" = "C__OBJTYPE__SERVER"}
        does not return records

    Receiving error message like "Failed to execute the search: Error code -32099 ..."
    This might happen, if you want to select a field, which is not part of the database table your (implicit) searching.
    E.g.
    Search-IdoItObject -Conditions @{"property" = "C__CATG__GLOBAL-type"; "comparison" = "="; "value" = "5"} | ft
    returns the field type_title
    id title           sysid            type created             updated             type_title type_icon                        type_group_title status
    -- -----           -----            ---- -------             -------             ---------- ---------                        ---------------- ------
    540 server540      SYSID_1730365404    5 2024-10-31 09:54:24 2025-04-27 06:52:30 Server     /cmdb/object-type/image/5                       2

    Sorry, it seems not possible to search for a field of this name
    Search-IdoItObject -Conditions @{"property" = "C__CATG__GLOBAL-type_title"; "comparison" = "="; "value" = "Server"} | ft
    returns an error message like this:
    Exception: C:\Users\wagnerw\Lokal\Github\psidoit\psidoit\Public\Search-IdoItObject.ps1:49:17
    Line |
    49 |                  Throw "Failed to execute the search: $_"
        |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        | Failed to execute the search: Error code -32099 - i-doit system error: You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use
        | near ')' at line 7 -


    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ParameterSetName='Conditions')]
        [hashtable[]] $Conditions,

        [Parameter(Mandatory=$false, ParameterSetName='Conditions')]
        [ValidateSet('C__RECORD_STATUS__NORMAL', 'C__RECORD_STATUS__ARCHIVED', 'C__RECORD_STATUS__DELETED', 'ALL')]
        [string] $Status = 'C__RECORD_STATUS__NORMAL',

        [Parameter(Mandatory=$true, ParameterSetName='Query')]
        [string]$Query
    )

    process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                'Conditions' {
                    if ($status -ne 'ALL') {
                        $conditions += @{ property = 'C__CATG__GLOBAL-status'; comparison = '='; value = $Status }
                    }
                    $result = Invoke-IdoIt -Endpoint 'cmdb.condition.read' -Params @{ conditions = $Conditions }
                    $result = $result | ForEach-Object {
                        $_ | Add-Member -MemberType NoteProperty -Name 'objId' -Value $_.id -Force
                        $_ | Add-Member -MemberType NoteProperty -Name 'TypeId' -Value $_.type -Force
                        $_.PSObject.TypeNames.Insert(0, 'IdoIt.ConditionalSearchResult')
                        $_
                    }
                    Write-Output $result
                }
                'Query' {
                    $result = Invoke-IdoIt -Endpoint 'idoit.search' -Params @{ q = $Query }
                    $result = $result | ForEach-Object {
                        $_ | Add-Member -MemberType NoteProperty -Name 'objId' -Value $_.documentId -Force
                        $_.PSObject.TypeNames.Insert(0, 'IdoIt.QuerySearchResult')
                        $_
                    }
                    Write-Output $result
                }
            }
        } catch {
            Write-Error "Failed to execute the search: $_"
        }
    }
}