---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Show-IdoitObjectTree

## SYNOPSIS
Displays the full object tree for a given i-doit object ID or input object on the console.

## SYNTAX

### ObjId (Default)
```
Show-IdoitObjectTree [-ObjId] <Int32> [-Style <String>] [-ExcludeCategory <String[]>] [-IncludeEmptyCategories]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### InputObject
```
Show-IdoitObjectTree [-InputObject] <PSObject> [-Style <String>] [-ExcludeCategory <String[]>]
 [-IncludeEmptyCategories] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet retrieves and displays the object tree for a specified i-doit object ID or input object, including its categories and properties.
It formats the output based on the specified style, which can be a table, JSON, or Spectre JSON format.

If you have installed the module "PwshSpectreConsole", you can get a nice view of the results by using:
Format-SpectreJson -Data (Show-IdoitObjectTree -ObjId 37) -Depth 5

## EXAMPLES

### EXAMPLE 1
```
Show-IdoitObjectTree -ObjId 37
Displays the object tree for the i-doit object with ID 37 in a formatted table.
```

### EXAMPLE 2
```
$object = Get-IdoitObject -ObjId 37
Show-IdoitObjectTree -InputObject $object -Style Json
Displays the object tree for the i-doit object with ID 37 in JSON format.
```

### EXAMPLE 3
```
Show-IdoitObjectTree -ObjId 37 -Style SpectreJson
Displays the object tree for the i-doit object with ID 37 in Spectre JSON format, if the Spectre module is available. Falls back to JSON if not.
```

## PARAMETERS

### -ObjId
The ID of the i-doit object for which to retrieve the tree.
This parameter is used when the input is an object ID.

```yaml
Type: Int32
Parameter Sets: ObjId
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -InputObject
The object already containing the full tree.

```yaml
Type: PSObject
Parameter Sets: InputObject
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Style
The style in which to display the object tree.
Options are 'FormatTable', 'Json', or 'SpectreJson'.
Default is 'FormatTable'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: FormatTable
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeCategory
An array of category constants to exclude from the results.
Default is 'C__CATG__LOGBOOK'.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: C__CATG__LOGBOOK
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeEmptyCategories
A switch to include empty categories in the output.

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
