---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Get-IdoItCategory

## SYNOPSIS
Get category properties and values for a given object id and category.

## SYNTAX

```
Get-IdoItCategory [-ObjId] <Int32> [[-Status] <Int32>] [-UseCustomTitle] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get-IdoItCategory retrieves all category properties and values for a given object id and category.
Custom properties can be converted to a more user-friendly format (except if RawCustomCategory is set).

## EXAMPLES

### EXAMPLE 1
```
Get-IdoItCategory -ObjId 12345 -Category 'C__CATG__CPU'
Retrieves a list of items of the category 'C__CATG__CPU' and its values for the object with id 12345.
```

## PARAMETERS

### -ObjId
The object id of the object for which you want to retrieve category properties and values.
Alias: Id

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Status
The status of the category.
Default is 2 (active).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 2
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseCustomTitle
If this switch is set, the custom category will be converted to a more user-friendly format.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

## RELATED LINKS
