function Get-IdoitMappedObject {
    <#
        .SYNOPSIS
        Get an object that is created based on a iAttribute map.

        .DESCRIPTION
        Get an object that is created based on a iAttribute map. The mapping is defined in the property map.
        This allows to construct Powershell objects combining different I-doit categories and their values.

        .PARAMETER Id
        The object ID of the I-doit object.

        .PARAMETER PropertyMap
        The property map that defines how the I-doit categories and their values should be mapped to the properties of the resulting object.

        .EXAMPLE
        Assume that 37 is the Id of a persons object.
        $propertyMap = @{
            PSType  = 'MyUser'
            IdoitObjectType = 'C__OBJTYPE__PERSON'
            Mapping = @(
                @{
                    Category     = 'C__CATS__PERSON';
                    PropertyList = @(
                        @{ Property = 'Id'; iAttribute = 'Id' },
                        @{ Property = 'Name'; iAttribute = 'Title' }
                    )
                }
            )
        }
        $result = Get-IdoitMappedObject -Id 37 -PropertyMap $propertyMap
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('ObjectId','objID')]
        [int] $Id,
        [Parameter(Mandatory = $true)]
        $PropertyMap
    )

    begin {

    }

    process {
        $obj = Get-IdoItObject -Id $Id
        if ($null -eq $obj) { return }

        $resultObj = @{
            ObjId = $obj.Id
            PSTypeName = 'Idoit.MappedObject'
        }
        foreach ($propMap in $PropertyMap) {
            foreach ($thisMapping in $propMap.Mapping) {
                $catValues = Get-IdoItCategory -Id $obj.Id -Category $thisMapping.Category
                if ($null -eq $catValues) {
                    Write-Verbose "No values found for category $($thisMapping.Category) in object $($obj.Id)."
                }
                foreach ($propListItem in $thisMapping.PropertyList) {
                    # I-doit iAttribute values can be simpley types or a hashtable with keys depending on the iAttribute it is representing
                    # For the later once, the if the iAttribute "name" has to be 'iAttribute.field'. This is the "deep key" to get the value
                    $attr, $field, $index = $propListItem.iAttribute -split '\.'
                    if ($attr -eq '!Category') {
                        # pass the whole category object
                        # char & would bei nicer, but would collide with merge key support of powershell-yaml
                        $thisCatValue = $catValues
                    } elseif (-not [string]::IsNullOrEmpty($field)) {
                        # if the iAttribute is a deep key, the value is extracted from the hashtable
                        $thisCatValue = $catValues.$attr.$field
                    } else {
                        # if the iAttribute is a simple key, the value is extracted from the hashtable
                        $thisCatValue = $catValues.$attr
                    }
                    # manage simple values
                    if ([string]::IsNullOrEmpty($propListItem.Action)) {
                        if ($thisCatValue -is [System.Array]) {
                            $resultObj.Add($propListItem.PSProperty, @($thisCatValue))
                        } else {
                            $resultObj.Add($propListItem.PSProperty, $thisCatValue)
                        }
                        continue
                    }
                    # manage scriptblock actions
                    # if ($propListItem.ScriptAction) {
                    #     # scriptblock parameter: if iAttribute if it is defined else the whole object is passed to the action
                    #     $result = $propListItem.ScriptAction.InvokeReturnAsIs($propListItem.ScriptActionAction, @($thisCatValue))
                    #     $resultObj.Add($propListItem.PSProperty, $result)
                    #     continue
                    # }
                    # manage predefined actions
                    if ($propListItem.Action -is [string]) {
                        switch ($propListItem.Action) {
                            'Sum' {
                                $resultObj.Add($propListItem.PSProperty, ( $thisCatValue |Measure-Object -Sum | Select-Object -ExpandProperty Sum))
                                break
                            }
                            'Count' {
                                $resultObj.Add($propListItem.PSProperty, ($thisCatValue | Measure-Object).Count)
                                break
                            }
                            'ScriptAction' {
                                if (-not $propListItem.ScriptAction) {
                                    Write-Warning "No script action defined for property $($propListItem.PSProperty) in mapping $($thisMapping.Category)"
                                    continue
                                }
                                # scriptblock parameter: if iAttribute if it is defined else the whole object is passed to the action
                                Try {
                                    $result = $propListItem.ScriptAction.InvokeReturnAsIs(@($thisCatValue))
                                } catch {
                                    $result = $_ | Out-String
                                }
                                $resultObj.Add($propListItem.PSProperty, $result)
                                continue
                            }
                            Default {
                                $resultObj.Add($propListItem.PSProperty, $thisCatValue)
                            }
                        }
                        continue
                    }
                }


                # # if no action is defined, add the property. If the corresponding catvalue holds an array, the property is added as an array
                # foreach ($propListItem in ($thisMapping.PropertyList | Where-Object { [String]::IsNullOrEmpty($_.Action) })) {
                #     $attr, $field = $propListItem.iAttribute -split '\.'
                #     if ($null -ne $field) {
                #         $thisCatValue = $catValues.$attr.$field
                #     } else {
                #         $thisCatValue = $catValues.$attr
                #     }
                # }
                # foreach ($propListItem in ($thisMapping.PropertyList | Where-Object { $_.Action -is [scriptblock] })) {
                #     # scriptblokc oarameter: if iAttribute if it is defined else the whole object is passed to the action
                #     if ([string]::IsNullOrEmpty($propListItem.iAttribute)) {
                #         $result = $propListItem.Action.InvokeReturnAsIs($propListItem.Action, @($catValues))
                #     } else {
                #         $result = $propListItem.Action.InvokeReturnAsIs($propListItem.Action, @($catValues.$($propListItem.iAttribute)))
                #     }
                #     $resultObj.Add($propListItem.Property, $result)
                # }
                # # with action, the property is added as a single value depending on the action
                # foreach ($propListItem in ($thisMapping.PropertyList | Where-Object { -not [String]::IsNullOrEmpty($_.Action) -and $_.Action -isnot [scriptblock] })) {
                #     switch ($propListItem.Action) {
                #         'Sum' {
                #             $values = $catValues.$($propListItem.iAttribute).$($propListItem.IPropertyField)
                #             $resultObj.Add($propListItem.Property, ( $values |Measure-Object -Sum | Select-Object -ExpandProperty Sum))
                #             break
                #         }
                #         'Count' {
                #             $resultObj.Add($propListItem.Property, ($catValues | Measure-Object).Count)
                #             break
                #         }
                #         Default {
                #             $resultObj.Add($propListItem.Property, $catValues.$($propListItem.iAttribute))
                #         }
                #     }
                # }
            }
        }
        $result = ([PSCustomObject]$resultObj)[0]     # casting to [PSObject] returns an arraylist, but we want a single object
        if ($null -ne $PropertyMap.PSType) {
            $result.PSObject.TypeNames.Insert(0, $PropertyMap.PSType)
        }

        $result
    }

    end {
    }
}
