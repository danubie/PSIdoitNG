# Seaching and Filtering objects
The I-Idoit API offers some methods to search or filter objects in the CMDB. This section will give you a guide, which are implemented and how the results of the API should be interpreted.<br>
Currently there are three options to filter or search
- [Search-IdoitObject -Query](SearchingAndFiltering.md#search-idoitobject--query)
- [Search-IdoitObject -Condition](SearchingAndFiltering.md#search-idoitobject--conditions)
- [Get-IdoitObject <filter>](SearchingAndFiltering.md#get-idoitobject-filtering)

## Search-IdoItObject -Query <query>
It implements a simple text search by I-doit API method [idoit.search](https://kb.i-doit.com/de/i-doit-add-ons/api/methoden/v1/idoit.html#idoitsearch).
The main properties are
| Property | Description
|-|-|
| objId | The id of the object found |
| key  | Represents the path in the web application, where the string was found.<br> e.g. "Persons > General > Tags" is the way to click you through the web interface to find the attribite where the text was found
| value | The value of the attribute the text was found in
| score | A rank, I-doit API gives the search result. Max seems to be 100
| documentId | The object id (name returned by API.)<br>To stay compatible with the API docs, this one is kept

```powershell
I ♥ PS Github\PSIdoitNG> search-IdoItObject -q 'PRD' | ft documentId, score, key, value

objId score key                                 value
----- ----- ----- ---                           -----
 847   100 Application > URLs                   MyApp: PRD
 540   100 Server > General > Tags              MyServer: PRD
 905    93 Application > Access > Title         _Applikation A [DEMO]: PRD-System
```

## Search-IdoitObject -Conditions
This is the second APIs option to search for objects.<br>
- Here you have to present a list of conditions (expressed as Hashtable). All the conditions are ANDed to give the result.
- You will get list of objects like in [Get-Object](en/Get-IdoitObject.md) back.<br>
Additionally the objects id will be returned in ObjId
- Searches are case sensitive
- When using the 'like' operator, use '*' for placeholder
- By default (and by consistency with other API )

> :zap:
> If you specify a wrong condition - you might get back *all* obejcts in the CMDB

### Get all objects of type server
```powershell
# Searching for all server objects
$condition = @(
    @{ "property" = "C__CATG__GLOBAL-type"; "comparison" = "="; "value" = "C__OBJTYPE__SERVER" }
)
Search-IdoItObject -Conditions $condition | ft

objId title                               type type_title status    Id
----- -----                               ---- ---------- ------ -----
  540 server540                              5 Server          2   540
54765 My first scripted server               5 Server          2 54765
59352 SampleServer                           5 Server          2 59352
```
### Searching for a server by name (Attention: This search is case sensitive!)
```powershell
# search for all Servers *Serv*; Type can be the int value as well
Github\PSIdoitNG> $condition = @(
    @{ "property" = "C__CATG__GLOBAL-title"; "comparison" = "like"; "value" = "*Serv*" },
    @{ "property" = "C__CATG__GLOBAL-type"; "comparison" = "="; "value" = "5" }
)

objId title        type typeid type_title status
----- -----        ---- ------ ---------- ------
59352 SampleServer    5        Server          2
```
### Searching for tags (multiselect) or dropdown selections
In this case, you (sadly) can not search for text values (which you would selsect in the web interface).<br>
You have to use the int representation. The value can be retrieved using [Get-Dialog](en/Get-IdoitDialog.md)<br>
```powershell
# searching for servers having tag 'PRD' set
I ♥ PS Github\PSIdoitNG> Get-IdoitDialog -params @{ category = 'C__CATG__GLOBAL'; property = 'tag' }

id const title    ParentId
-- ----- -----    --------
 7       DEV
 8       QA
 9       PRD

# now use the int value to search the tag
$condition = @(
    @{"property" = "C__CATG__GLOBAL-type"; "comparison" = "="; "value" = "C__OBJTYPE__SERVER"}
    @{"property" = "C__CATG__GLOBAL-tag"; "comparison" = "="; "value" = "9"}
)

I ♥ PS Github\PSIdoitNG> Search-IdoItObject -Conditions $condition | ft objId, title, type, typeid, type_title, status

objId title                               type typeid type_title status
----- -----                               ---- ------ ---------- ------
54764 My first scripted server               5        Server          2
54766 Wolles erstes Object                   5        Server          2
```
## Get-IdoitObject filtering
Another way of searching for objects is unsing [`Get-IdoitObject`](en/Get-IdoitObject.md) and add filter parameters
- Returns a list of objects like in [Get-Object](en/Get-IdoitObject.md) back.<br>
- (Not a filter) Specify which categories and values should be retrieved
- You can add filters some attributes (see table)
- No wild cards!

| Attribute | Array or single value | type |
|-|-|-|
| Object Id | array | int
| Object type | single | int
| Title | single | string |
| Object type title | single | string |
| Status | single  | int or string |
### Get a server by (exact) name
```powershell
# You know the exact name?
Get-IdoitObject -Title 'My first scripted server'
# You can get attributes as well
Get-IdoitObject -Title 'My first scripted server' -Category 'C__CATG__GLOBAL',''

```