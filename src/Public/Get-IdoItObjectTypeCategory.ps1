Function Get-IdoItObjectTypeCategory {
    <#
    .SYNOPSIS
    Get-IdoItObjectTypeCategory

    .DESCRIPTION
    Gets all the categories that the specified object type is constructed of.

    .PARAMETER ObjId
    Object ID for which the categories should be returned. If this parameter is specified, the type of the object will be determined first.

    .PARAMETER TypeId
    Object type for which the categories should be returned. This can be a string or an integer.

    .OUTPUTS
    Returns a collection of IdoIt.ObjectTypeCategory objects. Each object represents a category.

    .EXAMPLE
    PS> Get-IdoItObjectTypeCategory -Type 'C__OBJTYPE__SERVER'

    This will get all categories that are assigned to the ObjectType 'Server'
    [PSCustomObject] @{ id = 31; title = 'Overview page'; const = 'C__CATG__OVERVIEW'; multi_value  = 0; source_table = 'isys_catg_overview' }
    [PSCustomObject] @{ id = 42; title = 'Drive'; const = 'C__CATG__DRIVE'; multi_value  = 1; source_table = 'isys_catg_drive' }
    ...

    .EXAMPLE
    PS> Get-IdoItObjectTypeCategory -Type 1
    This will get all categories that are assigned to the ObjectType with ID 1.

    .EXAMPLE
    PS> Get-IdoItObjectTypeCategory -ObjId 540
    This will get all categories for that object id (Server with ID 540).

    .NOTES
    #>
    [CmdletBinding(DefaultParameterSetName = 'ObjectType')]
    [OutputType([System.Object[]])]
    Param (
        [Parameter (Mandatory = $false, ValueFromPipelineByPropertyName = $True, ParameterSetName = 'ObjectId')]
        [ValidateNotNullOrEmpty()]
        [int] $ObjId,

        [Parameter (Mandatory = $True, ValueFromPipeline = $True, ParameterSetName = 'ObjectType')]
        [ValidateNotNullOrEmpty()]
        # [Alias('TypeId','Id')]
        $TypeId
    )

    Process {
        $params = @{}
        switch ($PSCmdlet.ParameterSetName) {
            'ObjectId' {
                # if we have an object id, we need to get the type first
                $obj = Get-IdoItObject -ObjId $ObjId
                if ($null -eq $obj) {
                    Write-Error -Message "Object not found with ID $ObjId"
                    return
                }
                $TypeId = $obj.TypeId
            }
            'ObjectType' {
                # do nothing, type is already set
            }
        }
        $params.Add("type", $TypeId)

        $result = Invoke-IdoIt -Method "cmdb.object_type_categories.read" -Params $params

        #idoit delivers two arrays, depending of global or specific categories. From a PowerShell
        #point of view this is ugly - so we flatten the result into one PSObject.

        ForEach ($thisProperty In $result.PSObject.Properties) {
            ForEach ($subProperty In $result.($thisProperty.Name)) {
                if ([string]::IsNullOrEmpty($subProperty.type)) {
                    # older API version seems not to deliver the type?
                    $subProperty | Add-Member -MemberType NoteProperty -Name "type" -Value $thisProperty.Name
                }
                $subProperty.PsObject.TypeNames.Insert(0,'IdoIt.ObjectTypeCategory')
                $subProperty
            }
        }
    }
}