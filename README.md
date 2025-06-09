# PSIdoitNG
Next generation of a Powershell interface for I-doit-API (by Synetics)

| :warning:  This module is in an early stage of development!   |
|-|

## Why a new module?
The modules found at day of writing did not work with our release if i-doit API.
The projects found where stale for years and had some initial problems (espacially when using PS7).
## Goals
- Nothing without Pester tests
- Simple API trace option (to gather Pester input from it)
- Minimum setup on functions to connect and read objects
- Hopefully have time enough for more

# Implemented functions
The core functions implement a one-on-one interface to the I-doit API (BTW reflects the flexibility of the content representation, but is terrible to handle). Currently the functions we guess to need are implemented, missing will be done on occasion.

For more details see [documentation](./docs/en/PSIdoitNG.md)

Future enhanced functions should ease the pain of handling "real" Powershell objects to their internal representation in I-doit.
## List of core functions
| About | Functions | Implements or represents |
|-----|-------|-|
| Connection | Connect, Disconnect | A session connecting the API |
| Category | Get, Set, Remove | A section in webinterface when viewing an object (e.g. General, Form factor, Host address) |
| CategoryInfo | Get | What properties are defined for a category (e.g. first_name, last_name for person objects)
| Constants | Get | Retrieve I-doit defined constants |
| Dialog | Get | "ValidateSet" for attribute values |
| LocationTree | Get | Information about the definition of the tree view of objects |
| Object | Get, New, Remove, Search | The base of an object in the database |
| ObjectTypeGroup | Get | Top navigation in the I-doit application (e.g. Software, Infrastructure, Contact ,...) |
| ObjectType | Get | A trunk in the tree of a type group (e.g. application/service in Software or rack/server in Infrastructure) |
| ObjectTypeCategory | Get | What categories are defined for an object type |
| Version | Get | API version retrieval |
## Special add-ons
| About | Functions | Implements or represents |
|-----|-------|-|
| MappedObject | Get, Set | Mapping of I-doit category&attributes to "flattened" PSObjects
> [!Note]
> See detailed documentation [mapped objects](docs/MappedObjects.md)

## List of helper functions
| About | Functions | Implements or represents |
|-----|-------|-|
| ObjectTree | Get, Show | Objects including all of it's categories and those properties |
| ApiTrace | Start, Stop | For debugging purposes, API request & response can be traced |
| PesterTestObject | ConvertTo | Help to get object for mocks to create test cases; Not part of the module (in tests/Unit/Helpers) |

# Get-Category of custom category
Get-Catagory, when used with custom categories, returns syntetic property names.
There is an optional parameter ```-UseCustomTitle``` to generate more readable names from the fields UI title.
| :zap: If a title is changed for the UI, then the name of the property would change as well |
|-|

## Thanks!
My special thanks are going to @gaelcolas for creating module [sampler](https://github.com/gaelcolas/Sampler) and @phbits for his [Sampler tutorial](https://gist.github.com/phbits/854343e658c4911bcbe6cec1b19a2f53).