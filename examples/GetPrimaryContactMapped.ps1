<#
    GetPrimaryContact.ps1
    Returns an object of a given type with the primary contact of the object.
#>
$null = Connect-Idoit -Uri $uri -Credential $credIdoit -ApiKey (ConvertFrom-SecureString $apikey -AsPlainText)
$objId = 4675
$path = "$PSScriptRoot/MapPrimaryContact.yaml"
$map = ConvertFrom-MappingFile -Path $path
$obj = Get-IdoitMappedObject -Id $objId -PropertyMap $map

Write-Host "Combined output ------"
$obj | Out-Host