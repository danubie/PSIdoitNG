---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Get-IdoitObjectTree

## SYNOPSIS
Retrieves the full object tree for a given i-doit object ID.

## SYNTAX

```
Get-IdoitObjectTree [-ObjId] <Int32> [[-ExcludeCategory] <String[]>] [-IncludeEmptyCategories]
 [-CategoriesAsProperties] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet retrieves the object tree for a specified i-doit object ID, including its categories and properties.
It excludes categories specified in the \`ExcludeCategory\` parameter.

If you have installed the module "PwshSpectreConsole" you can get a nice view of the results by using:
Format-SpectreJson -Data (Get-IdoitObjectTree -ObjId 37) -Depth 5

## EXAMPLES

### EXAMPLE 1
```
Get-IdoitObjectTree -ObjId 37
Id Title           ObjectType Categories
-- -----           ---------- ----------
37 This Title              53 {@{Category=C__CATG__OVERVIEW; Properties=}, @{Category=C__CATG__RELATION; Properties=System.Object[]}, @{Category=C__CATG__M...
```

### EXAMPLE 2
```
Get-IdoitObjectTree -ObjId 37 -ExcludeCategory 'C__CATG__RELATION'
Returns the object tree for the i-doit object with ID 37 (Person) excluding the 'C__CATG__RELATION' category.
```

### EXAMPLE 3
```
Get-IdoitObjectTree -ObjId 37 -CategoriesAsProperties | Select-Object Categories
Returns the object tree for the i-doit object with ID 37 (Person) with categories kept as properties (in extracted form).
C__CATG__MAIL_ADDRESSES            : {@{id=353; objID=37; title=some@somewhere; primary_mail=some@somewhere; primary=; description=}}
C__CATG__GLOBAL                    : @{id=37; objID=37; title=thisTitle; status=; created=2024-10-09 12:56:39; }
...
```

### EXAMPLE 4
```
Get-IdoitObjectTree -Id 37 | Select-Object -Expanded Categories
--------                           ----------
C__CATG__OVERVIEW                  @{id=4; objID=37}
C__CATG__RELATION                  {@{id=15; objID=53; object1=; object2=; relation_type=; weighting=; itservice=; description=}, @{id=63; objID=156; objec...
C__CATG__MAIL_ADDRESSES            @{id=353; objID=37; title=thisTitle@somewhere; primary_mail=thisTitle@somewhere; primary=; descrip...
C__CATG__GLOBAL                    @{id=37; objID=37; title=thisTitle; status=; created=2024-10-09 12:56:39; created_by=SomeBody; changed=2025-05-...
C__CATS__PERSON                    @{id=11; objID=37; title=thisTitle@somewhere; salutation=; first_name=First; last_name=Last; academic_de...
```

$x.Categories\[3\].Properties
id          : 37
objID       : 37
title       : This Title
status      : @{id=2; title=Normal; const=; title_lang=LC__CMDB__RECORD_STATUS__NORMAL}
created     : 2024-10-09 12:56:39
created_by  : SomeBody
changed     : 2025-05-27 23:10:18
changed_by  : automation
purpose     :
category    :
sysid       : SYSID_1733071461
cmdb_status : @{id=6; title=in operation; const=C__CMDB_STATUS__IN_OPERATION; title_lang=LC__CMDB_STATUS__IN_OPERATION}
type        : @{id=53; title=Persons; const=C__OBJTYPE__PERSON; title_lang=LC__CONTACT__TREE__PERSON}
tag         :
description :

## PARAMETERS

### -ObjId
The ID of the i-doit object for which to retrieve the tree.

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

### -ExcludeCategory
An array of category constants to exclude from the results.
Default is 'C__CATG__LOGBOOK'.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

### -CategoriesAsProperties
A switch to keep categories as properties instead of converting them to an array of objects.

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
