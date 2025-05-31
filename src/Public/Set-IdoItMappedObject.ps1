function Set-IdoitMappedObject {
    <#
    .SYNOPSIS
    Set properties of an I-doit object based on a mapping.

    .DESCRIPTION
    This function updates properties of an I-doit object based on a provided mapping.

    Criterieas for update are:
    - I-doit attribute is not readonly
    - The mapping attribute "update" is set to true.
    - Idea for the future: The value in the input object is different from the current value in I-doit.
    - The value must be different from the current value in I-doit.
    Current limitations:
    - Multi-value categories are not supported yet.
    - Calculated properties are not supported in updates.
    - Scriptblock actions are not supported yet.

    .PARAMETER InputObject
    A PSObject containing the properties to be set in on the I-doit category values.
    The properties must match the properties defined in the mapping.
    The properties are defined in the mapping as PSProperty.

    .PARAMETER Id
    The ID of the I-doit object to be updated.

    .PARAMETER PropertyMap
    A mapping object that defines how the properties of the input object map to the I-doit categories.
    For a detailed description of the mapping, see the documentation TODO: link to documentation.

    .EXAMPLE
    Set-IdoitMappedObject -InputObject $inputObject -Id 12345 -PropertyMap $propertyMap
    This example updates the I-doit object with ID 12345 using the properties defined in $inputObject

    .NOTES
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Object] $InputObject,

        [Parameter(Mandatory = $true)]
        [Alias('ObjectId','objID')]
        [int] $Id,

        [Parameter(Mandatory = $true)]
        $PropertyMap
    )

    begin {
        # Set defualt properties, if they are not present
        if ($null -eq $PropertyMap.Update) {
            $PropertyMap | Add-Member -MemberType NoteProperty -Name 'Update' -Value $false
        }
    }

    process {
        $obj = Get-IdoItObject -Id $Id
        if ($null -eq $obj) {
            Write-Warning "Object creation is not supported yet. Please use Get-IdoItObject to get the object first"
            return
        }
        $objTypeCatList = Get-IdoItObjectTypeCategory -Type $obj.Objecttype
        if ($null -eq $objTypeCatList) {
            Throw "No categories found for object type $($obj.Objecttype)"
            return
        }
        $notfoundCatList = $PropertyMap.mapping.category | Where-Object { $_ -notin $objTypeCatList.const }
        if ($notfoundCatList) {
            Throw "Mapping categories $($notfoundCatList -join ', ') not found for object type $($obj.Objecttype)/$($obj.type_title)"
            return
        }
        # get those categories, which are used in the mapping
        $usedCatList = $objTypeCatList | Where-Object const -in $PropertyMap.mapping.category
        if ($null -eq $usedCatList) {
            Write-Warning "No categories found for object type $($obj.Objecttype)"
            return
        }
        # multi_value categories are not supported yet
        $multiValueCatList = $usedCatList | Where-Object { $_.multi_value -ne 0 }
        foreach ($mv in $multiValueCatList) {
            Write-Warning "Categories $($mv.const) is a multi value category. This is not supported yet."
            $usedCatList = $usedCatList | Where-Object { $_.const -ne $mv.const }
        }

        $srcObject = $InputObject
        $overallSucess = $true
        foreach ($propMap in $PropertyMap) {
            foreach ($thisMapping in $propMap.Mapping) {
                $thisCat = $usedCatList | Where-Object { $_.Const -eq $thisMapping.Category }
                if ($null -eq $thisCat) {
                    Continue            # unsupported category
                }
                $catValues = Get-IdoItCategory -Id $obj.Id -Category $thisMapping.Category
                if ($null -eq $catValues) {
                    Write-Warning "No categories found for object type $($thisMapping.Category)($($obj.Objecttype))"
                    continue
                }
                # if no action is defined, add the property. If the corresponding catvalue holds an array, the property is added as an array

                #### TODO **** hier geht's weiter. Die Attributwerte sind gelesen (in catValues)
                # Jetzt brauchen wir tatsächlich ein Input-Object, das die Werte hat, die wir setzen wollen
                # TODO: Multivalue categories are not supported yet
                foreach ($propListItem in ($thisMapping.PropertyList | Where-Object { $true -eq $_.Update -and [String]::IsNullOrEmpty($_.Action) })) {

                    if ($catValues.$($propListItem.iProperty) -is [System.Array]) {
                        $resultObj.Add($propListItem.PSProperty, @($catValues.$($propListItem.iProperty)))
                    } else {
                        # change only if the value is different; Case sensitive!
                        if ($catValues.$($propListItem.Property) -cne $srcObject.$($propListItem.PSProperty)) {
                            $changedProperty = [string]::Format("{0}.{1}. {2}->{3}", $thisMapping.Category, $propListItem.iProperty,
                            $catValues.$($propListItem.iProperty), $srcObject.$($propListItem.PSProperty))
                            if ($PSCmdlet.ShouldProcess($changedProperty, "Update property $($obj.Title)")) {
                                $result = Set-IdoItCategory -Id $obj.Id -Category $thisMapping.Category -Data @{
                                    $propListItem.iProperty = $srcObject.$($propListItem.PSProperty)
                                }
                                $overallSucess = $overallSucess -and $result.success
                            }
                        }
                    }
                }
                # TODO: Calculated properties are not supported in updates
                foreach ($propListItem in ($thisMapping.PropertyList | Where-Object { $_.Action -is [scriptblock] })) {
                    # scriptblock parameter: if iProperty if it is defined else the whole object is passed to the action
                    Throw "Scriptblock action is not supported yet"
                    if ([string]::IsNullOrEmpty($propListItem.iProperty)) {
                        $result = $propListItem.Action.InvokeReturnAsIs($propListItem.Action, $catValues)
                    } else {
                        $result = $propListItem.Action.InvokeReturnAsIs($propListItem.Action, $catValues.$($propListItem.iProperty))
                    }
                    $resultObj.Add($propListItem.PSProperty, $result)
                }
                # with action, the property is added as a single value depending on the action
                foreach ($propListItem in ($thisMapping.PropertyList | Where-Object { -not [String]::IsNullOrEmpty($_.Action) -and $_.Action -isnot [scriptblock] })) {
                    switch ($propListItem.Action) {
                        'Sum' {
                            Write-Warning "Calculated properties are not supported in updates"
                            break
                        }
                        'Count' {
                            Write-Warning "Calculated properties are not supported in updates"
                            break
                        }
                        Default {
                            Write-Verbose "Setting category $($propListItem.Iproperty) to [$(srcObject.$($propListItem.PSProperty))] for object $($obj.Id)"
                        }
                    }
                }
            }
        }
        Write-Output $overallSucess
    }

    end {

    }
}
