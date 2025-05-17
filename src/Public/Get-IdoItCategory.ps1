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
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "Id", ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('ObjId')]
        [int] $Id,

        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "Id", ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Const')]
        [string] $Category,

        [Parameter(Position = 2, ParameterSetName = "Id")]
        [int] $Status = 2
    )

    begin {

    }

    process {
        $params = @{
            objID = $Id
            category = $category
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