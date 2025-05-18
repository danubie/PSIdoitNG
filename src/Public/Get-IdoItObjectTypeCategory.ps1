Function Get-IdoItObjectTypeCategory {
    <#
    .SYNOPSIS
    Get-IdoItObjectTypeCategory

    .DESCRIPTION
    Gets all the categories that the specified object type is constructed of.

    .PARAMETER Type
    Object type for which the categories should be returned. This can be a string or an integer.

    .OUTPUTS
    Returns a collection of IdoIt.ObjectTypeCategory objects. Each object represents a category.

    .EXAMPLE
    PS> Get-IdoItObjectTypeCategory -Type 'C__OBJTYPE__SERVER'

    This will get all categories that are assigned to the ObjectType 'Server'
    [PSCustomObject] @{ id = 31; title = 'Overview page'; const = 'C__CATG__OVERVIEW'; multi_value  = 0; source_table = 'isys_catg_overview' }
    [PSCustomObject] @{ id = 42; title = 'Drive'; const = 'C__CATG__DRIVE'; multi_value  = 1; source_table = 'isys_catg_drive' }
    ...

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    Param (
        [Parameter (Mandatory = $True, ValueFromPipeline = $True)]
        [Alias('TypeId','Id')]
        $Type
    )

    Process {
        $params = @{}
        $params.Add("type", $Type)

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