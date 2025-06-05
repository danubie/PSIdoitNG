Function Set-IdoItCategory {
    <#
        .SYNOPSIS
        Set category properties and values for a given object id and category.

        .DESCRIPTION
        Set-IdoItCategory sets all category properties and values for a given object id and category.

        .PARAMETER InputObject
        An object that contains the properties to be set in the category.
        If this is used, *all* properties are set to their respective values.

        .PARAMETER ObjId
        The object id of the object for which you want to set category properties and values.
        Alias: Id

        .PARAMETER Category
        The category constant name for which you want to set properties and values.
        Alias: Const
        This is a dynamic parameter and will be set based on the objects type.

        .PARAMETER Data
        A hashtable containing the data to be set in the category.
        The keys of the hashtable should match the property names of the category.

        .EXAMPLE
        PS> Set-IdoItCategory -ObjId 12345 -Category 'C__CATG__CPU' -Data @{title = 'New Title'; status = 1}
    #>
    [CmdletBinding( SupportsShouldProcess = $True, DefaultParameterSetName = 'Id' )]
    Param (
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'InputObject' )]
        [PSObject] $InputObject,

        [Parameter( Mandatory = $True, ValueFromPipelineByPropertyName = $True, Position = 0, ParameterSetName = 'Id' )]
        [ValidateNotNullOrEmpty()]
        [Alias( 'Id' )]
        [Int] $ObjId,

        # dynamic parameter
        # [String] $Category,

        [Parameter( Mandatory = $True, ParameterSetName = 'Id' )]
        [Hashtable] $Data
    )
    DynamicParam {
        #region Category: if user has entered an Id, try to get defined categories for this object
        if ($ObjId -gt 0) {
            $obj = Get-IdoitObject -ObjId $ObjId -ErrorAction SilentlyContinue
            if ($null -eq $obj) { return }
            $objCategoryList = Get-IdoitObjectTypeCategory -Type $obj.objecttype -ErrorAction SilentlyContinue
            if ($null -eq $objCategoryList) { return }
            $validCatConstList = $objCategoryList | Select-Object -ExpandProperty const
            if ($null -eq $validCatConstList) { return }
        } else {
            $validCatConstList = (Get-IdoItConstant | Where-Object Type -in ('GlobalCategory','SpecificCategory','CustomCategory')).Name
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
        $Category = $PSBoundParameters['Category']
        if ($InputObject) {
            $ObjId = $InputObject.objId
            $Category = $InputObject.Category
            if ($null -eq $ObjId) {
                Write-Error "InputObject does not have a valid Id property."
                return
            }
            # now convert each property in the InputObject to a hashtable entry
            $Data = @{}
            foreach ($property in $InputObject.PSObject.Properties) {
                if ($property.Name -in 'Id','ObjId','psid_custom','Category') { continue }  # skip those
                if ($null -ne $InputObject.psid_custom) {           # do we have to translage the property names?
                    if ($InputObject.psid_custom.containsKey($property.Name)) {
                        $Data[$InputObject.psid_custom[$property.Name]] = $property.Value   # # convert to i-doit custom field name
                    } else {
                        $Data[$property.Name] = $property.Value
                    }
                } else {
                    $Data[$property.Name] = $property.Value
                }
            }
        }
        $params = @{
            object   = $ObjId              # you wouldn't believe it, here object id must be passed as "object" (not objId!)
            category = $Category
            data     = $Data
        }
        # Validate the properties (now that they are tranlated to i-doit names)
        $params.data = ValidateProperties -Category $params.category -Properties $params.data -ErrorAction Stop
        if ($null -eq $params.data.keys) {
            $errResponse = [PSCustomObject]@{
                Success = $false
                Error   = "No valid properties found for category '$($params.category)'."
            }
            Write-Output $errResponse
            Write-Error $errResponse.Error
            return
        }
        # if at the end there are no properties to update, we can return a success message
        # (this is the case if all properties are read-only or not valid for this category)
        if ($params.data.keys.Count -eq 0) {
            $errResponse = [PSCustomObject]@{
                Success = $true
                Message = "No properties to update for category '$($params.category)'."
            }
            Write-Output $errResponse
            return
        }

        # if the category has multi_value=1, then we need to get an entry id, otherwise we can set the values directly
        $cat = $objCategoryList | Where-Object { $_.const -eq $params.category }
        if ($cat.multi_value -eq 1 -and $Entry -eq 0) {
            $errResponse = [PSCustomObject]@{
                Success = $false
                Error  = "Category '$($params.category)' is a multi-value category. Currently(?) entry id is mandatory here."
            }
            Write-Output $errResponse
            Write-Error $errResponse
            return
        } elseif ($cat.multi_value -eq 0 -and $Data.Entry -gt 0) {
            $errResponse = [PSCustomObject]@{
                Success = $false
                Error  = "Category '$($params.category)' is a single-value category. Please do not specify an entry id."
            }
            Write-Output $errResponse
            Write-Error $errResponse
            return
        }

        If ($PSCmdlet.ShouldProcess("Updating category on object $ObjId")) {
            $result = Invoke-IdoIt -Method "cmdb.category.save" -Params $params
            return $result
        }
    }
}
