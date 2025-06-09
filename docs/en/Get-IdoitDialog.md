---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Get-IdoitDialog

## SYNOPSIS
Get the dialog for a specific category and property from i-doit.

## SYNTAX

### Default (Default)
```
Get-IdoitDialog -Category <String> -Property <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ByParams
```
Get-IdoitDialog -params <Hashtable> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves the dialog for a specific category and property.
It returns a list of options available for the specified category and property.

## EXAMPLES

### EXAMPLE 1
```
Get-IdoitDialog -params @{ category='C__CATG__CPU'; property='manufacturer' }
Retrieves the dialog options for the CPU category and manufacturer property.
```

## PARAMETERS

### -Category
The category name (title) for which the dialog is requested.
Example: 'C__CATG__CPU'

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property
The property name (title) for which the dialog is requested.
Example: 'manufacturer'

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -params
A hashtable containing the parameters for the dialog.
The hashtable should contain at least the keys 'category' and 'property'.
Example: @{ category='C__CATG__CPU'; property='manufacturer' }

```yaml
Type: Hashtable
Parameter Sets: ByParams
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
