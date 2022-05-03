Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./releasables/dependencies/dependency-manager.ps1

git fetch origin main

$CurrentBranchName = git rev-parse --abbrev-ref HEAD
$CommitsBehindOriginMain = git rev-list --count origin/main...$CurrentBranchName

if ($CommitsBehindOriginMain -gt 0) {
    Write-Error "The current branch is behind origin/main by $CommitsBehindOriginMain, please update it before continuing."
}

./build.ps1
