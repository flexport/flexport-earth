$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

Write-Information "Installing git hooks..."

Copy-Item -Verbose -Path ./development-tools/git-hooks/** -Destination .git/hooks

Write-Information "Git hooks installed!"
