<#
    GetPrimaryContact.ps1
    Returns an object of a given type with the primary contact of the object.
#>
Connect-Idoit -Uri $uri -Credential $credIdoit -ApiKey (ConvertFrom-SecureString $apikey -AsPlainText)
$objId = 4675
$objGlobal = Get-IdoitCategory -Id $objId -Category 'C__CATG__GLOBAL'

$objContacts = Get-IdoitCategory -Id $objId -Category 'C__CATG__CONTACT'
$objPrimaryContact = $objContacts | Where-Object {
    $_.Primary.value -eq 1
}
$objPrimaryContact | Out-Host
$objPrimaryContact

Write-Host "Combined output ------"
[PSCustomObject]@{
    Id      = $objId
    Name    = $objGlobal.Title
    PrimaryContact = $objPrimaryContact.contact.Title
} | Out-Host