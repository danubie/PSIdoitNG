$SampleConfig = [PSCustomObject]@{
    PersonMapped = [PSCustomObject]@{
        IdoitObjectType = 'C__OBJTYPE__PERSON'
        Category = @(
            [PSCustomObject]@{
                'C__CATS__PERSON' = [PSCustomObject]@{
                    Id = $null
                    FirstName = [PSCustomObject]@{ Attribute = 'first_name' }
                    LastName = [PSCustomObject]@{ Attribute = 'last_name' }
                }
            }
        )
    }
    ServerMapped = [PSCustomObject]@{
        IdoitObjectType = 'C__OBJTYPE__SERVER'
        Category = @(
            [PSCustomObject]@{
                'C__CATG__GLOBAL' = [PSCustomObject]@{
                    Id = $null
                    Kommentar = [PSCustomObject]@{ Attribute = 'title' }
                    CDate = [PSCustomObject]@{ Attribute = 'created' }
                    EDate = [PSCustomObject]@{ Attribute = 'changed' }
                }
            },
            [PSCustomObject]@{
                'C__CATG__MEMORY' = [PSCustomObject]@{
                    MemoryGB = [PSCustomObject]@{ Attribute = 'capacity.title'; Action = 'Sum' }
                    MemoryMB = [PSCustomObject]@{ Attribute = 'capacity.title' }
                    NbMemorySticks = [PSCustomObject]@{ Attribute = 'capacity'; Action = 'Count' }
                }
            }
        )
    }
}