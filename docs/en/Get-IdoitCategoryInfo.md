---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Get-IdoitCategoryInfo

## SYNOPSIS
Get-IdoitCategoryInfo

## SYNTAX

### Category
```
Get-IdoitCategoryInfo -Category <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### CatgId
```
Get-IdoitCategoryInfo -CatgId <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### CatsId
```
Get-IdoitCategoryInfo -CatsId <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get-IdoItCategoryInfo lets you discover all available category properties for a given category id.
The list corresponds to the properties you will receive for each returned object after calling the cmdb.category.read method.

## EXAMPLES

### EXAMPLE 1
```
Get-IdoitCategoryInfo -Category 'C__CATG__CPU'
Gives you detailed Info about every possible categaory value of this object.
E.g. for 'C__CATG__CPU' you get title, manifacturer, type, frequency, cores, etc.
... cores: @{title=CPU cores; check=; info=; data=; ui=}
           @{
                title = 'CPU cores';
                check = @{ mandatory = 'False' };
                info  = @{ primary_field = 'False'; type = 'int'; backward = 'False'; title = 'LC__CMDB__CATG__CPU_CORES'; description = 'CPU cores' };
                data  = @{ type = 'int'; readonly = 'False'; index = 'False'; field = 'isys_catg_cpu_list__cores' };
                ui    = @{ type = 'text'; params  = @{ p_strPlaceholder = 0; default = 0; p_strClass = 'input-mini' }; default = 1; id = 'C__CATG__CPU_CORES' }
            };
```

## PARAMETERS

### -Category
Look for category info by category name.
This is the most common way to get category info.

```yaml
Type: String
Parameter Sets: Category
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CatgId
Look for category info by category id of a global category.

```yaml
Type: Int32
Parameter Sets: CatgId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CatsId
Look for category info by category id of a s(?) category.

```yaml
Type: Int32
Parameter Sets: CatsId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
One more example of the incosistency of the i-doit API:
Searching by category name does return the name as well.
Searching for the same category by id does not return the name.

## RELATED LINKS
