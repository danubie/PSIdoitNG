$PersonMapped = [PSCustomObject] @{
    Name            = 'PersonMapped';
    PSType          = 'Person';
    IdoitObjectType = 'C__OBJTYPE__PERSON';
    Mapping         = [PSCustomObject] @{
        Category     = 'C__CATS__PERSON';
        PropertyList = @(
            [PSCustomObject] @{
                Property  = 'Id';
                PSProperty = 'Id'
            },
            [PSCustomObject] @{
                Property  = 'FirstName';
                PSProperty = 'first_name'
            },
            [PSCustomObject] @{
                Property  = 'LastName';
                PSProperty = 'last_name'
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
                    Property  = 'Id';
                    PSProperty = 'Id'
                },
                [PSCustomObject] @{
                    Property  = 'Kommentar';
                    PSProperty = 'title'
                },
                [PSCustomObject] @{
                    Property  = 'CDate';
                    PSProperty = 'created'
                },
                [PSCustomObject] @{
                    Property  = 'EDate';
                    PSProperty = 'changed'
                }
            )
        },
        [PSCustomObject] @{
            Category     = 'C__CATG__MEMORY';
            PropertyList = @(
                [PSCustomObject] @{
                    Property  = 'MemoryGB';
                    PSProperty = 'capacity.title';
                    Action    = 'sum'
                },
                [PSCustomObject] @{
                    Property  = 'MemoryMBTitles';
                    PSProperty = 'capacity.title'
                },
                [PSCustomObject] @{
                    Property  = 'NbMemorySticks';
                    PSProperty = 'capacity';
                    Action    = 'count'
                },
                [PSCustomObject] @{
                    Property  = 'CategoryAsArray';
                    PSProperty = '!category'
                }
                [PSCustomObject]@{
                    Property = 'MemoryMBCapacity'
                    PSProperty = '!category'
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
                    Property = 'MemoryMBCapacityTitle'
                    PSProperty = 'capacity.title'
                    Action = 'ScriptAction'
                    ScriptAction = {
                        $args | Foreach-Object {
                            $_ * 1024
                        } | Measure-Object -Sum | Select-Object -ExpandProperty Sum
                    }
                }
                [PSCustomObject]@{
                    Property = 'MemoryMBFromUnits'
                    PSProperty = '!category'
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