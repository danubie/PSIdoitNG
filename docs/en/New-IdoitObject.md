---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# New-IdoitObject

## SYNOPSIS
Create a new i-doit object.

## SYNTAX

```
New-IdoitObject [-Name] <String> -ObjectType <String> [-Category <Hashtable>] [-Purpose <String>]
 [-Status <String>] [-Description <String>] [-AllowDuplicates] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function creates a new object in i-doit with the specified name, type, category, purpose, status, and description.
It checks if an object with the same name already exists, and if so, it throws an error unless the \`-AllowDuplicates\` switch is set.

## EXAMPLES

### EXAMPLE 1
```
New-IdoitObject -Name "New Server" -ObjectType "C__OBJTYPE__SERVER" -Category "C__CATG__GLOBAL" -Purpose "In production" -Status 'C__CMDB_STATUS__IN_OPERATION' -Description "This is a new server object."
This command creates a new server object in i-doit with the specified name, type, category, purpose, status, and description.
```

## PARAMETERS

### -Name
The name of the object to create.
This is a mandatory parameter.
Alias: Title

```yaml
Type: String
Parameter Sets: (All)
Aliases: Title

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ObjectType
The type of the object to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Category
An array of categories to assign to the object.
This is optional.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @{}
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Purpose
The purpose of the object.
Valid entries can be found in the i-doit documentation.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Status
The status of the object.
Valid entries can be found in the i-doit documentation.

```yaml
Type: String
Parameter Sets: (All)
Aliases: cmdb_status

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
A description for the object.
This is optional.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AllowDuplicates
A switch to allow creating an object with the same name as an existing object.
If this switch is not set, the function will throw an error if an object with the same name already exists.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
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
The function is intended to create *new* object of a specific type.
If you want to create an object with the same name as an existing object, use the \`-AllowDuplicates\` switch.
If you want to update an existing object, use the \`Set-IdoitObject\` function instead.

## RELATED LINKS
