# cleanup leftovers from a previous run
$obj = Search-IdoItObject -Conditions @{"property" = "C__CATG__GLOBAL-title"; "comparison" = "like"; "value" = "Pester*"} -ErrorAction SilentlyContinue
$obj | Foreach-Object {
    Write-Verbose "Removing leftover object with Id: $($_.ObjId) and title: $($_.Title)"
    Remove-IdoitObject -ObjId $_.ObjId -Method Purge
}