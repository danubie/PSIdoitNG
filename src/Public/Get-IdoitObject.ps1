function Get-IdoitObject {
    <#
        .SYNOPSIS
        Get-IdoitObject returns an object from the i-doit API or $null.

        .DESCRIPTION
        Get-IdoitObject returns an object(s) or $null.
        It allows to filter by ObjId, ObjectType, Title, TypeTitle and Status.
        Additionally, it can return categories of the object(s) found.
        If just a single object id is given, it will use the 'cmdb.object.read' method (returing just the basic object data).
        if multiple objects or filters are given, it will use the 'cmdb.objects.read' method (returning an array of objects).

        .PARAMETER ObjId
        The id of the object you want to retrieve from the i-doit API.
        Single object requests are done by using the 'cmdb.object.read' method.
        An array will use the "filter" variante of this function.

        .PARAMETER ObjectType
        An array of types of the object you want to retrieve from the i-doit API. By name or by id.

        .PARAMETER Title
        The title of the object you want to retrieve from the i-doit API. This is a string, not an array.

        .PARAMETER TypeTitle
        The type title of the object you want to retrieve from the i-doit API. This is a string, not an array.

        .PARAMETER Status
        The status of the object you want to retrieve from the i-doit API. This is a string, not an array.

        .PARAMETER Limit
        The maximum number of objects to return. This is useful for filtering large result sets.

        .PARAMETER Category
        An array of categories that should be returned for each object found. This is useful to get additional information about the objects.
        Each category is returned in a seperate property of the object.

        .EXAMPLE
        Get-IdoitObject -ObjId 540

        .EXAMPLE
        Get-IdoitObject -ObjectType 'C__OBJTYPE__PERSON'

        .EXAMPLE
        Get-IdoitObject -Title 'Server 540'

        .EXAMPLE
        Get-IdoitObject -ObjectType 'C__OBJTYPE__PERSON' -Category 'C__CATG__GLOBAL', 'C__CATS__PERSON_MASTER' -Limit 2
        This will return the first two person objects including the categories 'C__CATG__GLOBAL' and 'C__CATS__PERSON_MASTER' each as a separate property.

        .NOTES
        If you request a single object by ObjId and the object is not found, an error will be thrown.
        If you request multiple objects or use filters, the function will return an empty array if no objects are found.
      #>
    [cmdletBinding(ConfirmImpact = 'Low')]
    [OutputType([Object])]
    param
    (
        # [Alias('Id')]
        [int[]] $ObjId, # List of object IDs to retrieve

        [string[]] $ObjectType, # List of object types

        [string] $Title, # The API allows only one title, so we use a string here

        [Alias('Type_Title')]
        [string] $TypeTitle, # The API allows only one type title, so we use a string here

        [ValidateSet('C__RECORD_STATUS__BIRTH', 'C__RECORD_STATUS__NORMAL', 'C__RECORD_STATUS__ARCHIVED', 'C__RECORD_STATUS__DELETED', 'C__RECORD_STATUS__TEMPLATE', 'C__RECORD_STATUS__MASS_CHANGES_TEMPLATE')]
        [string] $Status,

        [int] $Limit, # Limit the number of objects returned

        [string[]] $Category        # List of categories that should be returned for each object found
    )

    process {
        # # first check, if it is a single object and no filter and category is set
        # if ($ObjId.Count -eq 1 -and $PSBoundParameters.Keys -notin @('ObjectType', 'Title', 'TypeTitle', 'Status', 'Limit', 'Category')) {
        #     # this is a single object request, so we can use the 'cmdb.object.read' method
        #     $params = @{ id = $ObjId[0] }
        #     $apiResult = Invoke-Idoit -Method 'cmdb.object.read' -Params $params
        #     if ($null -eq $apiResult.id) {
        #         # is it a null object?
        #         Write-Error -Message "Object not found with ID $($ObjId[0])." -Category ObjectNotFound
        #         return
        #     }
        #     $apiResult.PSObject.TypeNames.Insert(0, 'Idoit.Object')
        #     $apiResult | Add-Member -MemberType NoteProperty -Name 'ObjId' -Value $apiResult.Id -Force
        #     $apiResult | Add-Member -MemberType NoteProperty -Name 'TypeId' -Value $apiResult.objecttype -Force
        #     # I don't like it. But to stay compatible with 'cmdb.objects.read' we have to add it as objecttype as well.
        #     $apiResult | Add-Member -MemberType NoteProperty -Name 'type' -Value $apiResult.objecttype -Force
        #     Write-Output $apiResult
        #     return
        # }

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
        if ($null -eq $apiResult.id) {
            # is it a null array?
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

