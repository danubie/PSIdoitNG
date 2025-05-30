$PersonMapped = [PSCustomObject] @{
    Name            = 'PersonMapped';
    PSType          = 'Person';
    IdoitObjectType = 'C__OBJTYPE__PERSON';
    Mapping         = [PSCustomObject] @{
        Category     = 'C__CATS__PERSON';
        PropertyList = @(
            [PSCustomObject] @{
                Property  = 'Id';
                Attribute = 'Id'
            },
            [PSCustomObject] @{
                Property  = 'FirstName';
                Attribute = 'first_name'
            },
            [PSCustomObject] @{
                Property  = 'LastName';
                Attribute = 'last_name'
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
                    Attribute = 'Id'
                },
                [PSCustomObject] @{
                    Property  = 'Kommentar';
                    Attribute = 'title'
                },
                [PSCustomObject] @{
                    Property  = 'CDate';
                    Attribute = 'created'
                },
                [PSCustomObject] @{
                    Property  = 'EDate';
                    Attribute = 'changed'
                }
            )
        },
        [PSCustomObject] @{
            Category     = 'C__CATG__MEMORY';
            PropertyList = @(
                [PSCustomObject] @{
                    Property  = 'MemoryGB';
                    Attribute = 'capacity.title';
                    Action    = 'sum'
                },
                [PSCustomObject] @{
                    Property  = 'MemoryMBTitles';
                    Attribute = 'capacity.title'
                },
                [PSCustomObject] @{
                    Property  = 'NbMemorySticks';
                    Attribute = 'capacity';
                    Action    = 'count'
                },
                [PSCustomObject] @{
                    Property  = 'CategoryAsArray';
                    Attribute = '!category'
                }
                [PSCustomObject]@{
                    Property = 'MemoryMBCapacity'
                    Attribute = '!category'
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
                    Attribute = 'capacity.title'
                    Action = 'ScriptAction'
                    ScriptAction = {
                        $args | Foreach-Object {
                            $_ * 1024
                        } | Measure-Object -Sum | Select-Object -ExpandProperty Sum
                    }
                }
                [PSCustomObject]@{
                    Property = 'MemoryMBFromUnits'
                    Attribute = '!category'
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