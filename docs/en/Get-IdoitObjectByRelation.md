---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Get-IdoitObjectByRelation

## SYNOPSIS
Get objects related to a given object.

## SYNTAX

```
Get-IdoitObjectByRelation [-ObjId] <String> [[-RelationType] <String[]>] [-AsArray]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves objects that are related to a specified object ID.

## EXAMPLES

### EXAMPLE 1
```
Get-IdoitObjectByRelation -ObjId 540
Retrieves all objects related to the object with ID 540.
```

### EXAMPLE 2
```
Get-IdoitObjectByRelation -ObjId 540 -RelationType 1
Retrieves all objects related to the object with ID 540 and relation type 1.
```

### EXAMPLE 3
```
Get-IdoitObjectByRelation -ObjId 540 -AsArray
Retrieves all objects related to the object with ID 540 and returns them as an array of
relation objects.
```

## PARAMETERS

### -ObjId
The ID of the object for which related objects are to be retrieved.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RelationType
Specifies the type of relation to filter the results.
This can be a numeric ID or a string representing the relation category type.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: RelationCategoryType

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsArray
If specified, the function returns the results as an array of relation objects instead of a PSCustomObject.

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
