function Get-IdoItCategory {
    <#
        .SYNOPSIS
        Get category properties and values for a given object id and category.

        .DESCRIPTION
        Get-IdoItCategory retrieves all category properties and values for a given object id and category.

        .PARAMETER Id
        The object id of the object for which you want to retrieve category properties and values.
        Alias: ObjId

        .PARAMETER Category
        The category constant name for which you want to retrieve properties and values.
        Alias: Const

        .PARAMETER Status
        The status of the category. Default is 2 (active).

        .EXAMPLE
        PS> Get-IdoItCategory -Id 12345 -Category 'C__CATG__CPU'
        Retrieves a list of items of the category 'C__CATG__CPU' and its values for the object with id 12345.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('ObjId')]
        [int] $Id,

        # dynamic parameter
        # [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        # [Alias('Const')]
        # [string] $Category,

        [Parameter(Position = 2, ParameterSetName = "Id")]
        [int] $Status = 2
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

    }

    process {
        $params = @{
            objID = $Id
            category = $PSBoundParameters['Category']
            status = $Status
        }
        $result = Invoke-Idoit -Method 'cmdb.category.read' -Params $params
        if ($null -ne $result) {
            foreach ($item in $result) {
                $item.PSObject.TypeNames.Insert(0, 'Idoit.Category')
                $item
            }
        }
    }

    end {

    }
}