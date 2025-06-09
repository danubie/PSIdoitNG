# You need to be connected to the API
Register-IdoitCategoryMap -Path "$PSScriptRoot/DocsServer4YamlDocs.yaml" -Force
Get-IdoitMappedObject -ObjId 59352 -MappingName 'Server4YamlDocumentation' | Out-Host