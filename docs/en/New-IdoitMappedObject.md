---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# New-IdoitMappedObject

## SYNOPSIS
Creates a new Idoit object based on the specified mapping.

## SYNTAX

```
New-IdoitMappedObject [-InputObject] <PSObject> [-MappingName] <String> [[-IncludeProperty] <String[]>]
 [[-ExcludeProperty] <String[]>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function creates a new Idoit object of the type specified in the mapping.
It uses the provided input object to set the properties of the new object according to the mapping.
The mapping must be registered using \`Register-IdoitCategoryMap\` before calling this function.

## EXAMPLES

### EXAMPLE 1
```
New-IdoitMappedObject -InputObject $inputObject -MappingName 'MyMapping' -IncludeProperty 'Name', 'Description' -ExcludeProperty 'Tags'
Creates a new Idoit object using the specified mapping, including only the 'Name' and 'Description' properties,
and excluding the 'Tags' property from the input object.
```

## PARAMETERS

### -InputObject
The input object containing the properties to be set on the new Idoit object.
This object should match the structure defined in the mapping.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MappingName
The name of the mapping to use for creating the new Idoit object.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeProperty
An array of property names to include when creating the new object.
This is useful, if properties are set only on creation and not on update.
attributes/properties which are defined as updatetable in the mapping will be set, even if not included here.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeProperty
An array of property names to exclude when creating the new object.
This is useful, if you want to skip certain properties that are not relevant for the new object.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
This function requires the mapping to be registered using \`Register-IdoitCategoryMap\`.

## RELATED LINKS
