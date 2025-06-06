$PersonMapped = [PSCustomObject] @{
    Name            = 'PersonMapped';
    PSType          = 'Person';
    IdoitObjectType = 'C__OBJTYPE__PERSON';
    Mapping         = [PSCustomObject] @{
        Category     = 'C__CATS__PERSON';
        PropertyList = @(
            [PSCustomObject] @{
                PSProperty  = 'Id';
                iAttribute = 'Id'
                Update   = $false
            },
            [PSCustomObject] @{
                PSProperty  = 'FirstName';
                iAttribute = 'first_name'
                Update   = $false
            },
            [PSCustomObject] @{
                PSProperty  = 'LastName';
                iAttribute = 'last_name'
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
                    iAttribute = 'Id'
                    Update    = $false
                },
                [PSCustomObject] @{
                    PSProperty  = 'Kommentar';
                    iAttribute = 'title'
                    Update    = $false
                },
                [PSCustomObject] @{
                    PSProperty  = 'BeschreibungUndefined';
                    iAttribute = 'description'
                    Update    = $true
                },
                [PSCustomObject] @{
                    PSProperty  = 'CDate';
                    iAttribute = 'created'
                    Update    = $false
                },
                [PSCustomObject] @{
                    PSProperty  = 'EDate';
                    iAttribute = 'changed'
                    Update    = $false
                }
            )
        },
        [PSCustomObject] @{
            Category     = 'C__CATG__MEMORY';
            PropertyList = @(
                [PSCustomObject] @{
                    PSProperty  = 'MemoryGB';
                    iAttribute = 'capacity.title';
                    Update    = $false
                    Action    = 'sum'
                },
                [PSCustomObject] @{
                    PSProperty  = 'MemoryMBTitles';
                    iAttribute = 'capacity.title'
                    Update    = $false
                },
                [PSCustomObject] @{
                    PSProperty  = 'NbMemorySticks';
                    iAttribute = 'capacity';
                    Update    = $false
                    Action    = 'count'
                },
                [PSCustomObject] @{
                    PSProperty  = 'CategoryAsArray';
                    iAttribute = '!category'
                },
                [PSCustomObject]@{
                    PSProperty = 'MemoryMBCapacity'
                    iAttribute = '!category'
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
                    iAttribute = 'capacity.title'
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
                    iAttribute = '!category'
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