---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# ConvertTo-IdoitObjectCategory

## SYNOPSIS
Converts a Mapped Object to an I-doit object based on the provided mapping.

## SYNTAX

```
ConvertTo-IdoitObjectCategory -InputObject <Object> -MappingName <String> [-ExcludeProperty <String[]>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function takes a mapped InputObject and converts it to an I-doit object based on the provided mapping.
It compares the properties of the input object with the properties of the I-doit object.
The returned object does have the structure of an object returned by Get-IdoItObject (including categories).

## EXAMPLES

### EXAMPLE 1
```
ConvertTo-IdoitObjectCategory -InputObject $inputObject -MappingName 'MyMapping'
This example converts the input object to an I-doit object using the mapping defined by 'MyMapping'.
```

### EXAMPLE 2
```
ConvertTo-IdoitObjectCategory -InputObject $inputObject -MappingName 'MyMapping' -ExcludeProperty 'Password'
This example converts the input object to an I-doit object using the properties defined in $inputObject except the 'Password' property.
```

## PARAMETERS

### -InputObject
A PSObject structured according to the mapping.
The properties must match the properties defined in the mapping.
The properties are defined in the mapping as PSProperty.
Object properties which are not defined in the mapping will be ignored.

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

### -MappingName
The name of the mapping to be used for the update.
This is a name of a mapping registered with Register-IdoitCategoryMap.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeProperty
An array of properties to exclude from the conversion.
This might be useful to prepare an object for a specific update, where some properties should not be updated later on.

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
