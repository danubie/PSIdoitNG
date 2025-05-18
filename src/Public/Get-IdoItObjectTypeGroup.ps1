Function Get-IdoItObjectTypeGroup {
    <#
    .SYNOPSIS
    Get-IdoItObjectTypeGroup

    .DESCRIPTION
    Gets all the object type groups that are available in the i-doit CMDB.

    .EXAMPLE
    Get-IdoItObjectTypeGroup
    Return all object type groups.

    .NOTES
    #>
    [CmdletBinding()]
    Param ()

    $result = Invoke-IdoIt -Method "cmdb.object_type_groups.read"
    $result | ForEach-Object {
        $_.PSObject.TypeNames.Insert(0, 'IdoIt.ObjectTypeGroup')
    }
    Write-Output $result
}
