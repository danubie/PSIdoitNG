[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string] $Path
)
$content = Get-Content -Raw -Path $Path
$invalidChars = @()

foreach ($char in $content.ToCharArray()) {
    $UTF8GetBytes = [System.Text.Encoding]::UTF8.GetBytes($char)
    $ASCIIGetBytes = [System.Text.Encoding]::ASCII.GetBytes($char)
    if ($UTF8GetBytes.Count -ne $ASCIIGetBytes.Count) {
        $invalidChars += $char
    }
}

$invalidChars | ForEach-Object { Write-Output "Invalid character: $_" }
