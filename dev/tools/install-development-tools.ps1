$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

Write-Information ""
Write-Information "Installing git hooks..."

Copy-Item -Path ./dev/tools/git-hooks/** -Destination ./.git/hooks

Write-Information "Git hooks installed!"
Write-Information ""

if (-Not (Get-InstalledModule -Name PSScriptAnalyzer)) {
    Write-Information "Installing PSScriptAnalyzer..."
    Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
    Write-Information "PSScriptAnalyzer installed!"
}
