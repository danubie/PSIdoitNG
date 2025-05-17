task Print_PS_Version_Table {
    Write-Host '[Print_PS_Version_Table] Starting.' -ForeGroundColor Green -BackgroundColor Black
    Write-Host "[Print_PS_Version_Table] `n$(($PSVersionTable | Out-String).Trim())" -ForeGroundColor Green -BackgroundColor Black
    Write-Host '[Print_PS_Version_Table] Finished.' -ForeGroundColor Green -BackgroundColor Black
}