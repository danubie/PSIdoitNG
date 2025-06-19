---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Get-IdoitMappedObjectFromTemplate

## SYNOPSIS
Retrieves a mapped object constructed from a registered Idoit category mapping.

## SYNTAX

```
Get-IdoitMappedObjectFromTemplate [-MappingName] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function retrieves a mapping of Idoit categories by name and constructs a PSObject based on the registered mapping.
It checks if the mapping exists in the global script variable \`$Script:IdoitCategoryMaps\`.
The returned object will have properties defined in the mapping with 'PSProperty' key, which can be used to create or update Idoit objects.

## EXAMPLES

### EXAMPLE 1
```
Get-IdoitMappedObjectFromTemplate -MappingName 'MyMapping'
Retrieves the mapping for 'MyMapping' and constructs a PSObject based on the registered mapping.
```

## PARAMETERS

### -MappingName
The name of the mapping to retrieve.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
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
