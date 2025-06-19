---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Get-IdoitObject

## SYNOPSIS
Get-IdoitObject returns an object from the i-doit API or $null.

## SYNTAX

```
Get-IdoitObject [[-ObjId] <Int32[]>] [[-ObjectType] <String[]>] [[-Title] <String>] [[-TypeTitle] <String>]
 [[-Status] <String>] [[-Limit] <Int32>] [[-Category] <String[]>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get-IdoitObject returns an object(s) or $null.
It allows to filter by ObjId, ObjectType, Title, TypeTitle and Status.
Additionally, it can return categories of the object(s) found.
If just a single object id is given, it will use the 'cmdb.object.read' method (returing just the basic object data).
if multiple objects or filters are given, it will use the 'cmdb.objects.read' method (returning an array of objects).

## EXAMPLES

### EXAMPLE 1
```
Get-IdoitObject -ObjId 540
```

### EXAMPLE 2
```
Get-IdoitObject -ObjectType 'C__OBJTYPE__PERSON'
```

### EXAMPLE 3
```
Get-IdoitObject -Title 'Server 540'
```

### EXAMPLE 4
```
Get-IdoitObject -ObjectType 'C__OBJTYPE__PERSON' -Category 'C__CATG__GLOBAL', 'C__CATS__PERSON_MASTER' -Limit 2
This will return the first two person objects including the categories 'C__CATG__GLOBAL' and 'C__CATS__PERSON_MASTER' each as a separate property.
```

## PARAMETERS

### -ObjId
The id of the object you want to retrieve from the i-doit API.
Single object requests are done by using the 'cmdb.object.read' method.
An array will use the "filter" variante of this function.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ObjectType
An array of types of the object you want to retrieve from the i-doit API.
By name or by id.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
The title of the object you want to retrieve from the i-doit API.
This is a string, not an array.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeTitle
The type title of the object you want to retrieve from the i-doit API.
This is a string, not an array.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Type_Title

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
The status of the object you want to retrieve from the i-doit API.
This is a string, not an array.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The maximum number of objects to return.
This is useful for filtering large result sets.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Category
An array of categories that should be returned for each object found.
This is useful to get additional information about the objects.
Each category is returned in a seperate property of the object.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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

### System.Object
## NOTES
If you request a single object by ObjId and the object is not found, an error will be thrown.
If you request multiple objects or use filters, the function will return an empty array if no objects are found.

## RELATED LINKS
