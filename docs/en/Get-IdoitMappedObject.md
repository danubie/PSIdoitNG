---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Get-IdoitMappedObject

## SYNOPSIS
Get an object that is created based on a iAttribute map.

## SYNTAX

### ByObjIdMappingName (Default)
```
Get-IdoitMappedObject -ObjId <Int32[]> -MappingName <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### ByObjIdPropertyMap
```
Get-IdoitMappedObject -ObjId <Int32[]> -PropertyMap <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### ByTitlePropertyMap
```
Get-IdoitMappedObject -Title <String> -PropertyMap <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### ByTitleMappingName
```
Get-IdoitMappedObject -Title <String> -MappingName <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### ByObjectTypePropertyMap
```
Get-IdoitMappedObject -MappingName <Object> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get an object that is created based on a iAttribute map.
The mapping is defined in the property map.
This allows to construct Powershell objects combining different I-doit categories and their values.

## EXAMPLES

### EXAMPLE 1
```
Assume that 37 is the Id of a persons object.
$propertyMap = @{
    PSType  = 'MyUser'
    IdoitObjectType = 'C__OBJTYPE__PERSON'
    Mapping = @(
        @{
            Category     = 'C__CATS__PERSON';
            PropertyList = @(
                @{ Property = 'Id'; iAttribute = 'Id' },
                @{ Property = 'Name'; iAttribute = 'Title' }
            )
        }
    )
}
$result = Get-IdoitMappedObject -ObjId 37 -PropertyMap $propertyMap
```

### EXAMPLE 2
```
Register-IdoitCategoryMap -Path 'C:\Path\To\Your\Mapping.yaml'
$result = Get-IdoitMappedObject -Title 'Your title' -MappingName 'PersonMapped'
This example retrieves an I-doit object by its title using a predefined mapping named 'PersonMapped'.
```

## PARAMETERS

### -ObjId
The object ID of the I-doit object.

```yaml
Type: Int32[]
Parameter Sets: ByObjIdMappingName, ByObjIdPropertyMap
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
The title (or name) of the I-doit object you want to filter.
This must be a unique title in I-doit.

```yaml
Type: String
Parameter Sets: ByTitlePropertyMap, ByTitleMappingName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MappingName
The name of the mapping to be used for the object creation.
This is a name of a mapping registered with Register-IdoitCategoryMap.

```yaml
Type: Object
Parameter Sets: ByObjIdMappingName, ByTitleMappingName, ByObjectTypePropertyMap
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyMap
The property map that defines how the I-doit categories and their values should be mapped to the properties of the resulting object.

```yaml
Type: Object
Parameter Sets: ByObjIdPropertyMap, ByTitlePropertyMap
Aliases:

Required: True
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

### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS
