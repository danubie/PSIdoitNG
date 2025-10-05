---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Set-IdoItCategory

## SYNOPSIS
Set category properties and values for a given object id and category.

## SYNTAX

### Id (Default)
```
Set-IdoItCategory [-ObjId] <Int32> -Data <Hashtable> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 -Category <String> [<CommonParameters>]
```

### InputObject
```
Set-IdoItCategory -InputObject <PSObject> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 -Category <String> [<CommonParameters>]
```

## DESCRIPTION
Set-IdoItCategory sets all category properties and values for a given object id and category.

## EXAMPLES

### EXAMPLE 1
```
Set-IdoItCategory -ObjId 12345 -Category 'C__CATG__CPU' -Data @{title = 'New Title'; status = 1}
```

## PARAMETERS

### -InputObject
An object that contains the properties to be set in the category.
If this is used, *all* properties are set to their respective values.

```yaml
Type: PSObject
Parameter Sets: InputObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ObjId
The object id of the object for which you want to set category properties and values.
Alias: Id

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Data
A hashtable containing the data to be set in the category.
The keys of the hashtable should match the property names of the category.

```yaml
Type: Hashtable
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Category
{{ Fill Category Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
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
