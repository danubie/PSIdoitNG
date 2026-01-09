# Changelog for PSIdoitNG

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## Fixed
- ConvertTo-ObjectCategoryForUpdate inconsistent in -Includeproperty '*'
- ConvertTo-ObjectCategoryForUpdate made private
- unused code comments in test files

## Changed
- Allow API key as securestring [#48](https://github.com/danubie/PSIdoitNG/issues/48)
- Disable changelog_pr and changelog checks in QA-module.test.ps1

## [0.4.1] - 2025-10-29

## Fixed
- New-IdoitObject accepts array of hashtables to allow several categories while creating
- fix update (set) of dialog properties
- Reduce API calls when creating or updating a mapped object

## Changed
- Add -AllowDuplicates to be able to create objects with name that already exists
- add func ConvertTo-IdoitObjectCategory
- Better content check of config yaml

### [0.3.2] - 2025-06-09
- Fixes to speed up Get-IdoitObjectTree
- New func 'Get-IdoitObjectByRelation' to get references to related objects
- 'New-IdoitMappedObecjt' removed param IncludeProperty
- Cleanup code of unused variables

### [0.3.1] - 2025-06-09

## Added
- New-IdoitMappedObject
- Get-IdoitMappedObjectFromTemplate
- Get-IdoitObject added Filters
- Search-IdoitObject added parameter -Status

### [0.3.0] - 2025-05-30

## Added

- New feature: Mapped objects

## Fixed

- Standardize ObjId, TypeId properties in objects

### [0.2.2] - 2025-05-29

### Changed

- Better experience with custom categories (Get/Set-IdoitCategory)
  Parameter ```-UseLocalTitle``` replaces syntetic property names with the title in the UI
- Validate popup stype properties ourselfs (Set-IdiotCategory)

### [0.2.1] - 2025-05-29

### Added

- New functions
  - Remove-IdoitCategory, Remove-IdoitObject
- New helper functions
  - Get-IdoitObjectTree, Show-IdoitObjectTree

### Changed

- Invoke-Idoit does not Throw on any error (leave handling on behalf of the caller)
  This allows to handle cases like handling virtual categories in Get-IdoItCategory

## Fixed

- Get-IdoItCategory ignores error if category is a virtual one
- Search-IdoItObject: using -Query has invalid request param #11
- Get-IdoitCategoryInfo: if Id is used to query -> Category is empty #1
- fix inconsistent filenames for mocked data

### [0.2.0] - 2025-05-27

### Added

- New functions
  - New-IdoitObject, Set-IdoitCategory
  - Get-Dialog, Get-LocationTree
  - Search-IdoitObject

## [0.0.1] - 2025-05-24

### Added

- Initial setup
- Add Functions
  - Invoke-Idoit, Connect-Idoit, Disconnect-Idoit
  - Get-IdoitCategory, Get-IdoitCategoryInfo
  - Get-IdoitConstant
  - Get-IdoitObject, Get-IdoitObjectType, Get-IdoitObjectTypeCategory, Get-IdoitObjectTypeGroup
  - Get-IdoitVersion
  - Start-IdoitApiTrace, Stop-IdoitApiTrace

