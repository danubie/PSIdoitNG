---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Search-IdoItObject

## SYNOPSIS
Searches for objects in the i-doit CMDB based on specified conditions.

## SYNTAX

### Conditions
```
Search-IdoItObject -Conditions <Hashtable[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Query
```
Search-IdoItObject -Query <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet allows you to search for objects in the i-doit CMDB by providing an array of conditions.
The conditions are passed as an array of hashtable entries.

Against the usual naming of the functions, it implements "cmdb.condition.read".

## EXAMPLES

### EXAMPLE 1
```
Search-IdoItObject -Conditions @(
     @{ "property" = "C__CATG__GLOBAL-title"; "comparison" = "like"; "value" = "*r540*" },
     @{ "property" = "C__CATG__GLOBAL-type"; "comparison" = "="; "value" = "5" }
 )
```

This will search for objects where the title contains "Server" and the type is "Server".

 id title           sysid       type created             updated             type_title type_icon                 type_group_title status
 -- -----           -----       ---- -------             -------             ---------- ---------                 ---------------- ------
540 server540 SYSID_1730365404     5 2024-10-31 09:54:24 2025-05-15 16:05:08 Server     /cmdb/object-type/image/5                       2

## PARAMETERS

### -Conditions
An array of hashtable entries defining the search conditions.
Each hashtable should include keys like
"property", "operator", and "value".

```yaml
Type: Hashtable[]
Parameter Sets: Conditions
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Query
A string representing the a simple search query.
It will find all objects that match the query.
This might be used to get a quick overview of objects in the i-doit CMDB.

```yaml
Type: String
Parameter Sets: Query
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

## NOTES
API version 33 behaviour (or some other?)

Be aware that some files are case sensitive!
I know, that this is not the best practice, but I don't know who designed this.
not case sensitive (title): Search-IdoItObject -Conditions @{"property" = "C__CATG__GLOBAL-title"; "comparison" = "="; "value" = "yOuR-Server"}
    returns records
but case sensitive (type) : Search-IdoItObject -Conditions @{"property" = "C__CATG__GLOBAL-type"; "comparison" = "="; "value" = "C__OBJTYPE__SERVER"}
    does not return records

Receiving error message like "Failed to execute the search: Error code -32099 ..."
This might happen, if you want to select a field, which is not part of the database table your (implicit) searching.
E.g.
Search-IdoItObject -Conditions @{"property" = "C__CATG__GLOBAL-type"; "comparison" = "="; "value" = "5"} | ft
returns the field type_title
id title           sysid            type created             updated             type_title type_icon                        type_group_title status
-- -----           -----            ---- -------             -------             ---------- ---------                        ---------------- ------
540 server540      SYSID_1730365404    5 2024-10-31 09:54:24 2025-04-27 06:52:30 Server     /cmdb/object-type/image/5                       2

Sorry, it seems not possible to search for a field of this name
Search-IdoItObject -Conditions @{"property" = "C__CATG__GLOBAL-type_title"; "comparison" = "="; "value" = "Server"} | ft
returns an error message like this:
Exception: C:\Users\wagnerw\Lokal\Github\psidoit\psidoit\Public\Search-IdoItObject.ps1:49:17
Line |
49 |                  Throw "Failed to execute the search: $_"
    |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    | Failed to execute the search: Error code -32099 - i-doit system error: You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use
    | near ')' at line 7 -

## RELATED LINKS
