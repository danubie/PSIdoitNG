---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Set-IdoitMappedObject

## SYNOPSIS
Set properties of an I-doit object based on a mapping.

## SYNTAX

### MappingName (Default)
```
Set-IdoitMappedObject -InputObject <Object> [-ObjId <Int32>] -MappingName <String>
 [-IncludeProperty <String[]>] [-ExcludeProperty <String[]>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### PropertyMap
```
Set-IdoitMappedObject -InputObject <Object> [-ObjId <Int32>] -PropertyMap <Object>
 [-IncludeProperty <String[]>] [-ExcludeProperty <String[]>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function updates properties of an I-doit object based on a provided mapping.

Criterieas for update are:
- I-doit attribute is not readonly
- The mapping attribute "update" is set to true.
- Idea for the future: The value in the input object is different from the current value in I-doit.
- The value must be different from the current value in I-doit.
Current limitations:
- Multi-value categories are not supported yet.
- Calculated properties are not supported in updates.
- Scriptblock actions are not supported yet.

## EXAMPLES

### EXAMPLE 1
```
Set-IdoitMappedObject -InputObject $inputObject -ObjId 12345 -MappingName 'MyMapping'
This example updates the I-doit object with ID 12345 using the mapping defined by 'MyMapping'.
```

### EXAMPLE 2
```
Set-IdoitMappedObject -InputObject $inputObject -ObjId 12345 -PropertyMap $propertyMap
This example updates the I-doit object with ID 12345 using the properties defined in $inputObject
```

## PARAMETERS

### -InputObject
A PSObject containing the properties to be set in on the I-doit category values.
The properties must match the properties defined in the mapping.
The properties are defined in the mapping as PSProperty.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ObjId
The ID of the I-doit object to be updated.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $InputObject.objId
Accept pipeline input: False
Accept wildcard characters: False
```

### -MappingName
The name of the mapping to be used for the update.
This is a name of a mapping registered with Register-IdoitCategoryMap.

```yaml
Type: String
Parameter Sets: MappingName
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyMap
A mapping object that defines how the properties of the input object map to the I-doit categories.
For a detailed description of the mapping, see the documentation TODO: link to documentation.

```yaml
Type: Object
Parameter Sets: PropertyMap
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeProperty
An array of properties to include in the update.
This is in Addition to the updateable properties defined in the mapping.
i.e.
if a property is not marked as updateable in the mapping, it can be included here to be updated.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeProperty
An array of properties to exclude from the update.
This is in Addition to the updateable properties defined in the mapping.
i.e.
if a property is marked as updateable in the mapping, it can be excluded here to not be updated.
Excluding a property has a higher priority than including a property.
If a property is both included and excluded, it will be excluded.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @()
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
