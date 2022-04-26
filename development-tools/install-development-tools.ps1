$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

Write-Information ""
Write-Information "Installing git hooks..."

Copy-Item -Verbose -Path ./git-hooks/** -Destination ../.git/hooks

Write-Information "Git hooks installed!"
