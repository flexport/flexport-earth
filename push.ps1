Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./releasables/dependencies/dependency-manager.ps1

# Make sure there's no pending changes.
$GitStatus = git status

$GitStatus

if (-Not ($GitStatus.Contains("nothing to commit"))) {
    Write-Error "You have pending changes that need to be committed."
}

# Make sure we're testing with latest from origin/main.
git fetch origin main

$CurrentBranchName = git rev-parse --abbrev-ref HEAD
$CommitsBehindOriginMain = git rev-list --count origin/main...$CurrentBranchName

if ($CommitsBehindOriginMain -gt 0) {
    Write-Error "The current branch is behind origin/main by $CommitsBehindOriginMain, please update it before continuing."
}

./build.ps1
./deploy.ps1
./destroy.ps1

git push
