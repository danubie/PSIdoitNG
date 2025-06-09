---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Get-IdoItObjectType

## SYNOPSIS
Get-IdoItObjectType retrieves object types from i-doit.

## SYNTAX

```
Get-IdoItObjectType [[-TypeId] <Int32[]>] [[-Const] <String[]>] [-Enabled] [[-Skip] <Int32>] [[-Limit] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get-IdoItObjectType retrieves object types from i-doit.
You can specify the object type by its ID or title.

## EXAMPLES

### EXAMPLE 1
```
Get-IdoItObjectType -TypeId 1
Retrieves the object type with ID 1.^
```

### EXAMPLE 2
```
Get-IdoItObjectType -Const "C_OBJTYPE_SERVICE","C_OBJTYPE_SERVER"
Retrieves the object types with titles "C_OBJTYPE_SERVICE" and "C_OBJTYPE_SERVER".
```

### EXAMPLE 3
```
Get-IdoItObjectType -Enabled
Retrieves all enabled object types.
```

### EXAMPLE 4
```
Get-IdoItObjectType -Limit 20
Get-IdoItObjectType -Skip 20 -Limit 20
Retrieves the the first 20 object types and then the next 20 object types.
```

## PARAMETERS

### -TypeId
The ID of the object type to retrieve.
This parameter is mandatory.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Const
The title of the object type to retrieve.
This parameter is mandatory.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Title

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled
If specified, only enabled object types will be retrieved.

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

### -Skip
The number of object types to skip before returning results.
This is useful for pagination.
The default value is 0.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The maximum number of object types to return.
This is useful for pagination.
The default value is 100.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

## RELATED LINKS
