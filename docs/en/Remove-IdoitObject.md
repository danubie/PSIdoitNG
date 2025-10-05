---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Remove-IdoitObject

## SYNOPSIS
Removes an IdoIT object.

## SYNTAX

```
Remove-IdoitObject [-ObjId] <Int32> [[-Method] <String>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function removes an IdoIT object by its ID and specified method.
The used method must correspond to the objects current state (see I-doit documentation).

## EXAMPLES

### EXAMPLE 1
```
Remove-IdoitObject -ObjId 12345 -Method 'Archive'
This command will archive the object with ID 12345.
```

### EXAMPLE 2
```
Remove-IdoitObject -ObjId 12345 -Method 'Purge'.
This command will purge the object with ID 12345.
```

## PARAMETERS

### -ObjId
The ID of the object to be removed.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
The method to use for removing the object.
Valid values are 'Archive', 'Delete', 'Purge'.
Default is 'Archive'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Archive
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
