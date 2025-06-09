---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Register-IdoitCategoryMap

## SYNOPSIS
Registers a mapping of Idoit categories from a YAML file or directory.

## SYNTAX

```
Register-IdoitCategoryMap [-Path] <String[]> [-Recurse] [-Force] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function reads a YAML file or all YAML files in a specified directory to register for Idoit category mappings.

## EXAMPLES

### EXAMPLE 1
```
Register-IdoitCategoryMap -Path 'C:\Path\To\MappingFile.yaml'
Registers the mapping from the specified YAML file.
```

### EXAMPLE 2
```
Register-IdoitCategoryMap -Path 'C:\Path\To\MappingDirectory' -Recurse
Registers all YAML mapping files found in the specified directory and its subdirectories.
```

### EXAMPLE 3
```
Register-IdoitCategoryMap -Path 'C:\Path\To\MappingFile.yaml' -Force
Registers the mapping from the specified YAML file, overwriting any existing mapping with the same name.
```

## PARAMETERS

### -Path
The path to the YAML file or directory containing mapping files.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurse
Indicates whether to search subdirectories for YAML files.

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

### -Force
Indicates whether to overwrite existing mappings.

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
