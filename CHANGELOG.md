# Changelog for PSIdoitNG

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### v0.4.0
- New feature: Mapped objects
- Standardize ObjId, TypeId properties in objects


### v0.2.2

### Enhancements
- Better experience with custom categories (Get/Set-IdoitCategory)
  Parameter ```-UseLocalTitle``` replaces syntetic property names with the title in the UI
- Validate popup stype properties ourselfs (Set-IdiotCategory)

### v0.2.1

### Added
- New functions
  - Remove-IdoitCategory, Remove-IdoitObject
- New helper functions
  - Get-IdoitObjectTree, Show-IdoitObjectTree

### Changes
- Invoke-Idoit does not Throw on any error (leave handling on behalf of the caller)
  This allows to handle cases like handling virtual categories in Get-IdoItCategory

### Fixes
- Get-IdoItCategory ignores error if category is a virtual one
- Search-IdoItObject: using -Query has invalid request param #11
- Get-IdoitCategoryInfo: if Id is used to query -> Category is empty #1
- fix inconsistent filenames for mocked data

### v0.2.0

### Added

- New functions
  - New-IdoitObject, Set-IdoitCategory
  - Get-Dialog, Get-LocationTree
  - Search-IdoitObject

## v0.0.1

### Added
- Initial setup
- Add Functions
  - Invoke-Idoit, Connect-Idoit, Disconnect-Idoit
  - Get-IdoitCategory, Get-IdoitCategoryInfo
  - Get-IdoitConstant
  - Get-IdoitObject, Get-IdoitObjectType, Get-IdoitObjectTypeCategory, Get-IdoitObjectTypeGroup
  - Get-IdoitVersion
  - Start-IdoitApiTrace, Stop-IdoitApiTrace

