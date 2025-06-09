---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Get-IdoItObjectTypeCategory

## SYNOPSIS
Get-IdoItObjectTypeCategory

## SYNTAX

### ObjectType (Default)
```
Get-IdoItObjectTypeCategory -TypeId <Object> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ObjectId
```
Get-IdoItObjectTypeCategory [-ObjId <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Gets all the categories that the specified object type is constructed of.

## EXAMPLES

### EXAMPLE 1
```
Get-IdoItObjectTypeCategory -Type 'C__OBJTYPE__SERVER'
```

This will get all categories that are assigned to the ObjectType 'Server'
\[PSCustomObject\] @{ id = 31; title = 'Overview page'; const = 'C__CATG__OVERVIEW'; multi_value  = 0; source_table = 'isys_catg_overview' }
\[PSCustomObject\] @{ id = 42; title = 'Drive'; const = 'C__CATG__DRIVE'; multi_value  = 1; source_table = 'isys_catg_drive' }
...

### EXAMPLE 2
```
Get-IdoItObjectTypeCategory -Type 1
This will get all categories that are assigned to the ObjectType with ID 1.
```

### EXAMPLE 3
```
Get-IdoItObjectTypeCategory -ObjId 540
This will get all categories for that object id (Server with ID 540).
```

## PARAMETERS

### -ObjId
Object ID for which the categories should be returned.
If this parameter is specified, the type of the object will be determined first.

```yaml
Type: Int32
Parameter Sets: ObjectId
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TypeId
Object type for which the categories should be returned.
This can be a string or an integer.

```yaml
Type: Object
Parameter Sets: ObjectType
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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

### Returns a collection of IdoIt.ObjectTypeCategory objects. Each object represents a category.
## NOTES

## RELATED LINKS
