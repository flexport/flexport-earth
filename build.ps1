Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./releasables/dependencies/dependency-manager.ps1

# Install required tools
./development-tools/install-development-tools.ps1

$Results = Invoke-ScriptAnalyzer -Path **

if ($Results) {
    $Results
    Write-Error "PowerShell lint issues detected, please fix and try again."
}
