# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Load global development settings
$GlobalDevelopmentSettings = Get-Content 'development-config.json' | ConvertFrom-Json
$ReleasablesPath           = $GlobalDevelopmentSettings.ReleasablesDirectory

# Run dependency management
. "$ReleasablesPath/dependencies/dependency-manager.ps1"

# Make sure there's no pending changes.
$GitStatus = git status

if (-Not ($GitStatus -like "*nothing to commit*")) {
    Write-Error "You have pending changes that need to be committed."
}

# Make sure we're testing with latest from origin/main.
git fetch origin main

$CurrentBranchName       = git rev-parse --abbrev-ref HEAD
$DiffCounts              = ((git rev-list --left-right --count origin/main...$CurrentBranchName) -split '\t')
$CommitsBehindOriginMain = $DiffCounts[0]

if ($CommitsBehindOriginMain -gt 0) {
    Write-Error "The current branch is behind origin/main by $CommitsBehindOriginMain, please update it before continuing."
}

./dev-build.ps1
./dev-deploy.ps1
./dev-destroy.ps1

git push --set-upstream origin $CurrentBranchName
