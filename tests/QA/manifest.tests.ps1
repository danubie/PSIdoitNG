$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# Convert-path required for PS7 or Join-Path fails
$ProjectPath = "$here\..\.." | Convert-Path
$ProjectName = (Get-ChildItem $ProjectPath\*\*.psd1 | Where-Object {
    ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop }catch { $false }) }
).BaseName

$buildModuleFolder = Join-Path $ProjectPath -ChildPath "output\module\$ProjectName" -Resolve

$builtManifest = Get-ChildItem $buildModuleFolder -File `
    -Filter "$ProjectName.psd1" -Recurse `
    -ErrorAction SilentlyContinue

# Define test cases. The module manifest will be
# checked for the following settings.
$requiredSettings = @(
    @{ 'Setting' = 'Author'; 'Location' = 'root'; }
    @{ 'Setting' = 'CompanyName'; 'Location' = 'root'; }
    @{ 'Setting' = 'Copyright'; 'Location' = 'root'; }
    @{ 'Setting' = 'Description'; 'Location' = 'root'; }
    @{ 'Setting' = 'FunctionsToExport'; 'Location' = 'root'; }
    @{ 'Setting' = 'GUID'; 'Location' = 'root'; }
    @{ 'Setting' = 'ModuleVersion'; 'Location' = 'root'; }
    @{ 'Setting' = 'PowerShellVersion'; 'Location' = 'root'; }
    @{ 'Setting' = 'LicenseUri'; 'Location' = 'PrivateData.PSData'; }
    @{ 'Setting' = 'ProjectUri'; 'Location' = 'PrivateData.PSData'; }
    @{ 'Setting' = 'ReleaseNotes'; 'Location' = 'PrivateData.PSData'; }
    @{ 'Setting' = 'Tags'; 'Location' = 'PrivateData.PSData'; }
)

Describe 'Module Manifest' -Tag 'Manifest' {
    It 'Should exist.' {
        $builtManifest | Should -Not -BeNullOrEmpty
    }
    It 'Should be just one file.' {
        $builtManifest -is [Array] | Should -Be $false
    }
    It 'Should be a valid module manifest.' {
        Test-ModuleManifest -Path $builtManifest.FullName | Should -Be $true
    }
    Context 'Validate settings' {
        BeforeAll {
            $manifestData = Import-PowerShellDataFile $builtManifest.FullName
        }
        It "Should have setting: <Setting>." -TestCases $requiredSettings {
            param ($Setting, $Location)

            if ($Setting -eq 'ReleaseNotes') {
                $manifestData['PrivateData']['PSData'].ContainsKey($Setting) | Should -Be $true

            }
            else {

                if ($Location -eq 'root') {
                    $manifestData[$Setting] | Should -Not -BeNullOrEmpty

                }
                else {

                    $manifestData['PrivateData']['PSData'][$Setting] | Should -Not -BeNullOrEmpty
                }
            }
        }
    }
}