---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Get-IdoitLocationTree

## SYNOPSIS
Get the next location tree from i-doit

## SYNTAX

```
Get-IdoitLocationTree [[-Id] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves the location tree from i-doit.
The root location is returned if no Id is specified.

## EXAMPLES

### EXAMPLE 1
```
Get-IdoitLocationTree -Id 0
Retrieves the root location.
```

### EXAMPLE 2
```
Get-IdoitLocationTree -Id 1
Retrieves the location tree starting from the location with Id 1 (root).
```

\>

## PARAMETERS

### -Id
The Id of the location to retrieve the tree from.
If 0 is specified, the root location is returned.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
