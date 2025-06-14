function Get-IdoitObject {
    <#
      .SYNOPSIS
      Get-IdoitObject returns an object from the i-doit API or $null.

      .DESCRIPTION
      Get-IdoitObject returns an object or $null.

      .EXAMPLE
      Get-IdoitObject -ObjId 540

      .PARAMETER ObjId
       The id of the object you want to retrieve from the i-doit API.
      #>
    [cmdletBinding(ConfirmImpact = 'Low')]
    [OutputType([Object])]
    param
    (
        # [Alias('Id')]
        [int[]] $ObjId,             # List of object IDs to retrieve

        [string[]] $ObjectType,     # List of object types

        [string] $Title,            # The API allows only one title, so we use a string here

        [Alias('Type_Title')]
        [string] $TypeTitle,        # The API allows only one type title, so we use a string here

        [ValidateSet('C__RECORD_STATUS__BIRTH', 'C__RECORD_STATUS__NORMAL', 'C__RECORD_STATUS__ARCHIVED', 'C__RECORD_STATUS__DELETED', 'C__RECORD_STATUS__TEMPLATE', 'C__RECORD_STATUS__MASS_CHANGES_TEMPLATE')]
        [string] $Status,

        [int] $Limit,               # Limit the number of objects returned

        [string[]] $Category        # List of categories that should be returned for each object found
    )

    process {
        # first check, if it is a single object and no filter and category is set
        if ($ObjId.Count -eq 1 -and $PSBoundParameters.Keys -notin @('ObjectType', 'Title', 'TypeTitle', 'Status', 'Limit', 'Category')) {
            # this is a single object request, so we can use the 'cmdb.object.read' method
            $params = @{ id = $ObjId[0] }
            $apiResult = Invoke-Idoit -Method 'cmdb.object.read' -Params $params
            if ($null -eq $apiResult.id) {          # is it a null object?
                Write-Error -Message "Object not found with ID $($ObjId[0])." -Category ObjectNotFound
                return
            }
            $apiResult.PSObject.TypeNames.Insert(0, 'Idoit.Object')
            $apiResult | Add-Member -MemberType NoteProperty -Name 'ObjId' -Value $apiResult.Id -Force
            $apiResult | Add-Member -MemberType NoteProperty -Name 'TypeId' -Value $apiResult.objecttype -Force
            # I don't like it. But to stay compatible with 'cmdb.objects.read' we have to add it as objecttype as well.
            $apiResult | Add-Member -MemberType NoteProperty -Name 'type' -Value $apiResult.objecttype -Force
            Write-Output $apiResult
            return
        }

        # this is the way to filter objects by several parameters
        $params = @{ filter = @{} }
        if ($PSBoundParameters.ContainsKey('Limit')) { $params.limit = $Limit }
        if ($PSBoundParameters.ContainsKey('Category')) {
            $params.categories = @($Category)           # categories we want to retrieve are always an array
        }

        # add filters
        if ($ObjId.Count -gt 0) { $params.filter += @{ ids = @($ObjId) } }
        if ($ObjectType.Count -gt 0) { $params.filter += @{ type = @($ObjectType) } }
        if ($Title) { $params.filter += @{ title = $Title } }
        if ($TypeTitle) { $params.filter += @{ type_title = $TypeTitle } }
        if ($Status) { $params.filter += @{ status = $Status } }

        $apiResult = Invoke-Idoit -Method 'cmdb.objects.read' -Params $params
        if ($null -eq $apiResult.id) {          # is it a null array?
            return
        }
        foreach ($obj in $apiResult) {
            $obj.PSObject.TypeNames.Insert(0, 'Idoit.Object')
            $obj | Add-Member -MemberType NoteProperty -Name 'ObjId' -Value $obj.Id -Force
            $obj | Add-Member -MemberType NoteProperty -Name 'TypeId' -Value $obj.type -Force
            # I don't like it. But to stay compatible with 'cmdb.object.read' we have to add it as objecttype as well.
            $obj | Add-Member -MemberType NoteProperty -Name 'objecttype' -Value $obj.type -Force
            $obj
        }
    }
}

