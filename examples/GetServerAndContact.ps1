<#
    GetPrimaryContact.ps1
    Returns an object of a given type with the primary contact of the object.
#>
$null = Connect-Idoit -Uri $uri -Credential $credIdoit -ApiKey (ConvertFrom-SecureString $apikey -AsPlainText)
$objId = 41259
$path = "$PSScriptRoot/MapServerAndContact.yaml"
Register-IdoitCategoryMap -Path $path -Force
$obj = Get-IdoitMappedObject -ObjId $objId -MappingName 'MapServerAndContact'

Write-Host "Combined output ------"
<#
Name           PrimaryContact  ObjId ContactEmails
----           --------------  ----- -------------
server2.domain Primary Name    41259 {email1@spambog.com, email2@spambog.com}
#>


$obj | Out-Host