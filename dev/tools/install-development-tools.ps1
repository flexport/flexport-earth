Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

Copy-Item -Path ./dev/tools/git-hooks/** -Destination ./.git/hooks

if (-Not (Get-InstalledModule -Name PSScriptAnalyzer)) {
    Write-Information "Installing PSScriptAnalyzer..."
    Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
    Write-Information "PSScriptAnalyzer installed!"
}
