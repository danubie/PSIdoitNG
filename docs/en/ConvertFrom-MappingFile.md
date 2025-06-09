---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# ConvertFrom-MappingFile

## SYNOPSIS
Convert a file containing a mapping of I-doit categories to a PSObject

## SYNTAX

```
ConvertFrom-MappingFile [-Path] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The content of the file and convert it to a PSObject for later use as mapping between I-doit categories and PowerShell objects.
Allowed file formats are yaml and JSON.
For converting yaml files, the module 'powershell-yaml' is required.

## EXAMPLES

### EXAMPLE 1
```
ConvertFrom-MappingFile -Path 'C:\path\to\mapping.yaml'
Returns an object with the mapping defined in the file.
```

### EXAMPLE 2
```
ConvertFrom-MappingFile -Path 'C:\path\to\mapping.json'
Returns an object with the mapping defined in the file.
```

## PARAMETERS

### -Path
The path to the file containing the mapping.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### PCustomObject
## NOTES

## RELATED LINKS
