# get-sampledata.ps1
$Params = @{
    categories = @('C__CATG__CUSTOM_FIELDS_KOMPONENTE')
    # filter = @{ type = 'C__OBJTYPE__PERSON' }
    filter = @{ ids = @(4675) }
}
Invoke-IdoIt -Method 'cmdb.objects.read' -Params $Params