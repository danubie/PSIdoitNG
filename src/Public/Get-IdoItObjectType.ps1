function Get-IdoItObjectType {
    <#
    .SYNOPSIS
        Get-IdoItObjectType retrieves object types from i-doit.

    .DESCRIPTION
        Get-IdoItObjectType retrieves object types from i-doit. You can specify the object type by its ID or title.

    .PARAMETER TypeId
        The ID of the object type to retrieve. This parameter is mandatory.

    .PARAMETER Const
        The title of the object type to retrieve. This parameter is mandatory.

    .PARAMETER Enabled
        If specified, only enabled object types will be retrieved.

    .PARAMETER Skip
        The number of object types to skip before returning results. This is useful for pagination.
        The default value is 0.

    .PARAMETER Limit
        The maximum number of object types to return. This is useful for pagination.
        The default value is 100.

    .EXAMPLE
        Get-IdoItObjectType -TypeId 1
        Retrieves the object type with ID 1.^

    .EXAMPLE
        Get-IdoItObjectType -Const "C_OBJTYPE_SERVICE","C_OBJTYPE_SERVER"
        Retrieves the object types with titles "C_OBJTYPE_SERVICE" and "C_OBJTYPE_SERVER".

    .EXAMPLE
        Get-IdoItObjectType -Enabled
        Retrieves all enabled object types.

    .EXAMPLE
        Get-IdoItObjectType -Limit 20
        Get-IdoItObjectType -Skip 20 -Limit 20
        Retrieves the the first 20 object types and then the next 20 object types.

    .DESCRIPTION
        Get-IdoItObjectType retrieves object types from i-doit. You can specify the object type by its ID or title.
    #>
    [CmdletBinding()]
    Param (
        [Alias('Id')]
        [Int[]] $TypeId,

        [Alias('Title')]
        [string[]] $Const,

        [Switch] $Enabled,

        [int] $Skip,
        [Int] $Limit
    )

    #checkCmdbConnection

    Process {
        $params= @{}
        $filter = @{}

        foreach ($PSBoundParameter in $PSBoundParameters.Keys) {
            switch ($PSBoundParameter) {
                "TypeId" {
                        $filter.Add("ids", @($TypeId))
                    break
                }
                "Const" {
                    $filter.Add("titles", @($Const))        # sadly: the API param is title, searched are const strings
                    break
                }
                "Enabled" {
                    $filter.Add("enabled", 1)
                    break
                }
                "Limit" {
                    if ($Skip -gt 0) {
                        $params.Add("limit", "$Skip,$Limit")
                    } else {
                        $params.Add("limit", $Limit)
                    }
                    break
                }
            }
        }
        $params.Add("filter", $filter)

        $result = Invoke-IdoIt -Method "cmdb.object_types.read" -Params $params
        $result | ForEach-Object {
            $_ | Add-Member -MemberType NoteProperty -Name "TypeId" -Value $_.id -Force
            $_.PSObject.TypeNames.Add('Idoit.ObjectType')
        }
        Return $result
    }
}