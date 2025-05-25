Function Set-IdoItCategory {
    <#
        .SYNOPSIS
        Set category properties and values for a given object id and category.

        .DESCRIPTION
        Set-IdoItCategory sets all category properties and values for a given object id and category.

        .PARAMETER Id
        The object id of the object for which you want to set category properties and values.
        Alias: ObjId

        .PARAMETER Category
        The category constant name for which you want to set properties and values.
        Alias: Const
        This is a dynamic parameter and will be set based on the objects type.

        .PARAMETER Data
        A hashtable containing the data to be set in the category.

        .EXAMPLE
        PS> Set-IdoItCategory -Id 12345 -Category 'C__CATG__CPU' -Data @{title = 'New Title'; status = 1}
    #>
    [CmdletBinding( SupportsShouldProcess = $True, DefaultParameterSetName = 'Update' )]
    Param (
        [Parameter( Mandatory = $True, ValueFromPipelineByPropertyName = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias( 'ObjId' )]
        [Int] $Id,

        # dynamic parameter
        # [String] $Category,

        [Parameter( Mandatory = $True )]
        [Hashtable] $Data
    )
    DynamicParam {
        #region Category: if user has entered an Id, try to get defined categories for this object
        if ($Id -gt 0) {
            $obj = Get-IdoItObject -Id $Id -ErrorAction SilentlyContinue
            if ($null -eq $obj) { return }
            $objCategoryList = Get-IdoitObjectTypeCategory -Type $obj.objecttype -ErrorAction SilentlyContinue
            if ($null -eq $objCategoryList) { return }
            $validCatConstList = $objCategoryList | Select-Object -ExpandProperty const
            if ($null -eq $validCatConstList) { return }
        } else {
            $validCatConstList = (Get-IdoItConstant | Where-Object Type -in ('GlobalCategory','SpecificCategory')).Name
        }
        $dynParamCategory = NewDynamicParameter -Name 'Category' -ParameterType 'System.String' -ValidateSet $validCatConstList -Mandatory $true

        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $RuntimeParameterDictionary.Add('Category', $dynParamCategory)
        #endregion
        return $RuntimeParameterDictionary
    }
    begin {
        # Initialize the parameters
        $params = @{}
    }
    process {
        $params = @{
            object   = $Id                # you wouldn't believe it, here object id must be passed as "object" (not objId!)
            category = $PSBoundParameters['Category']
            data     = $Data
        }
        # if the category has multi_value=1, then we need to get an entry id, otherwise we can set the values directly
        $cat = $objCategoryList | Where-Object { $_.const -eq $params.category }
        if ($cat.multi_value -eq 1 -and $Entry -eq 0) {
            $errResonse = [PSCustomObject]@{
                Success = $false
                Error  = "Category '$($params.category)' is a multi-value category. Currently(?) entry id is mandatory here."
            }
            Write-Output $errResonse
            Write-Error $errResonse
            return
        } elseif ($cat.multi_value -eq 0 -and $Data.Entry -gt 0) {
            $errResonse = [PSCustomObject]@{
                Success = $false
                Error  = "Category '$($params.category)' is a single-value category. Please do not specify an entry id."
            }
            Write-Output $errResonse
            Write-Error $errResonse
            return
        }

        If ($PSCmdlet.ShouldProcess("Updating category on object $Id")) {
            $result = Invoke-IdoIt -Method "cmdb.category.save" -Params $params
            return $result
        }
    }
}
