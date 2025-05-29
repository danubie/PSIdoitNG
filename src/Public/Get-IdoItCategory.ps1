function Get-IdoItCategory {
    <#
        .SYNOPSIS
        Get category properties and values for a given object id and category.

        .DESCRIPTION
        Get-IdoItCategory retrieves all category properties and values for a given object id and category.
        Custom properties are converted to a more user-friendly format (except if RawCustomCategory is set).

        .PARAMETER Id
        The object id of the object for which you want to retrieve category properties and values.
        Alias: ObjId

        .PARAMETER Category
        The category constant name for which you want to retrieve properties and values.
        Alias: Const
        This parameter is dynamic and will be populated based on the object type of the specified Id.
        If the Id is not specified, all available categories will be returned.
        If an Id is used, where no object type is defined, the parameter will not be populated.

        .PARAMETER Status
        The status of the category. Default is 2 (active).

        .PARAMETER RawCustomCategory
        If this switch is set, the custom category will not be converted to a more user-friendly format.

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
        [int] $Status = 2,

        [Switch] $RawCustomCategory
    )
    DynamicParam {
        #region Category: if user has entered an Id, try to get defined categories for this object
        if ($Id -gt 0) {
            $obj = Get-IdoItObject -Id $Id -ErrorAction SilentlyContinue
            if ($null -ne $obj) {
                $objCategoryList = Get-IdoitObjectTypeCategory -Type $obj.objecttype -ErrorAction SilentlyContinue
            }
            if ($null -ne $objCategoryList) {
                $validCatConstList = $objCategoryList | Select-Object -ExpandProperty const
            }
        } else {
            if ($null -eq $validCatConstList) {             # default: deliver all constants
                $validCatConstList = (Get-IdoItConstant | Where-Object Type -in ('GlobalCategory','SpecificCategory')).Name
            }
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
        Try {
            $result = Invoke-Idoit -Method 'cmdb.category.read' -Params $params
        } Catch {
            $ex = $_
            if ($ex.Exception.Message -match 'Virtual category') {
                # Write-Warning "Skipping virtual category: $($params.category)"
                return
            }
            Throw $_
        }
        # This one more wierd things of the i-doit API:
        # If the category is not defined for the object, it returns an empty array with only the objId and id properties.
        # But sometimes it returns an empty object without any properties.
        # If the category is defined, it returns an array with the properties of the category.

        # We will normalize the two "empty" result in returning $null
        # I really hate this solution, but didnt find a better way to handle this.
        if ( @($result).Count -eq 0 ) {
            $result = $null
        }
        if ( @($result.PSObject.Properties).count -le 2 ) {
            # if the result has max two properties, it is an empty category
            $result = $null
        }
        if ($null -ne $result) {
            foreach ($item in $result) {
                if (-not $RawCustomCategory) {
                    # is it a custom category?
                    # TODO: It is not very efficient to do all the stuff for each object. Check that later.
                    $objTypeCatList = Get-IdoitObjectTypeCategory -ObjId $Id -ErrorAction Stop
                    $objTypeCat = $objTypeCatList | Where-Object { $_.const -eq $params.category }
                    if ($null -eq $objTypeCat) {
                        Write-Error "ObjectTypeCategory '$($params.category)' not found for object with ID $Id."
                        return
                    }
                    $isCustom = $objTypeCat.type -eq 'custom'
                    if ($isCustom) {
                        $item = ConvertFrom-CustomCategory -InputObject $item -CategoryObject $objTypeCat
                    }
                }
                $item.PSObject.TypeNames.Insert(0, 'Idoit.Category')
                $item | Add-Member -MemberType NoteProperty -Name 'Category' -Value $params.category -Force
                $item
            }
        }
    }

    end {

    }
}