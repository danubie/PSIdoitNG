$PersonMapped = [PSCustomObject] @{
    Name            = 'PersonMapped';
    PSType          = 'Person';
    IdoitObjectType = 'C__OBJTYPE__PERSON';
    Mapping         = [PSCustomObject] @{
        Category     = 'C__CATS__PERSON';
        PropertyList = @(
            [PSCustomObject] @{
                PSProperty  = 'Id';
                iProperty = 'Id'
                Update   = $false
            },
            [PSCustomObject] @{
                PSProperty  = 'FirstName';
                iProperty = 'first_name'
                Update   = $false
            },
            [PSCustomObject] @{
                PSProperty  = 'LastName';
                iProperty = 'last_name'
                Update   = $false
            }
        )
    }
}
$ServerMapped = [PSCustomObject] @{
    Name            = 'ServerMapped';
    IdoitObjectType = 'C__OBJTYPE__SERVER';
    Mapping         = @(
        [PSCustomObject] @{
            Category     = 'C__CATG__GLOBAL';
            PropertyList = @(
                [PSCustomObject] @{
                    PSProperty  = 'Id';
                    iProperty = 'Id'
                    Update    = $false
                },
                [PSCustomObject] @{
                    PSProperty  = 'Kommentar';
                    iProperty = 'title'
                    Update    = $false
                },
                [PSCustomObject] @{
                    PSProperty  = 'BeschreibungUndefined';
                    iProperty = 'description'
                    Update    = $true
                },
                [PSCustomObject] @{
                    PSProperty  = 'CDate';
                    iProperty = 'created'
                    Update    = $false
                },
                [PSCustomObject] @{
                    PSProperty  = 'EDate';
                    iProperty = 'changed'
                    Update    = $false
                }
            )
        },
        [PSCustomObject] @{
            Category     = 'C__CATG__MEMORY';
            PropertyList = @(
                [PSCustomObject] @{
                    PSProperty  = 'MemoryGB';
                    iProperty = 'capacity.title';
                    Update    = $false
                    Action    = 'sum'
                },
                [PSCustomObject] @{
                    PSProperty  = 'MemoryMBTitles';
                    iProperty = 'capacity.title'
                    Update    = $false
                },
                [PSCustomObject] @{
                    PSProperty  = 'NbMemorySticks';
                    iProperty = 'capacity';
                    Update    = $false
                    Action    = 'count'
                },
                [PSCustomObject] @{
                    PSProperty  = 'CategoryAsArray';
                    iProperty = '!category'
                },
                [PSCustomObject]@{
                    PSProperty = 'MemoryMBCapacity'
                    iProperty = '!category'
                    Update = $false
                    Action = 'ScriptAction'
                    ScriptAction = {
                        $tempresult = $args | Foreach-Object {
                            $idoitCategory = $_
                            switch ($idoitCategory.Unit.Title) {
                                'MB' { $idoitCategory.Capacity.Title; break }
                                'GB' { 1024 * $idoitCategory.Capacity.Title; break }
                                'TB' { 1024 * 1024 * $idoitCategory.Capacity.Title; break }
                                Default { Write-Error "Unknown unit $_" }     # Achtung Erroraction Continue gibt nichts aus
                            }
                        }
                        $tempresult | Measure-Object -Sum | Select-Object -ExpandProperty Sum
                    }
                }
                [PSCustomObject]@{
                    PSProperty = 'MemoryMBCapacityTitle'
                    iProperty = 'capacity.title'
                    Update = $false
                    Action = 'ScriptAction'
                    ScriptAction = {
                        $args | Foreach-Object {
                            $_ * 1024
                        } | Measure-Object -Sum | Select-Object -ExpandProperty Sum
                    }
                }
                [PSCustomObject]@{
                    PSProperty = 'MemoryMBFromUnits'
                    iProperty = '!category'
                    Update = 'ReadOnly'
                    Action = 'ScriptAction'
                    ScriptAction = {
                        $tempresult = $args | Foreach-Object {
                            $idoitCategory = $_
                            switch ($idoitCategory.Unit.Title) {
                                'MB' { $idoitCategory.Capacity.Title; break }
                                'GB' { 1024 * $idoitCategory.Capacity.Title; break }
                                'TB' { 1024 * 1024 * $idoitCategory.Capacity.Title; break }
                                Default { Write-Error "Unknown unit $_" }     # Achtung Erroraction Continue gibt nichts aus
                            }
                        }
                        $tempresult | Measure-Object -Sum | Select-Object -ExpandProperty Sum
                    }
                }
            )
        }
    )
}
$SampleConfig = [PSCustomObject]@{
}