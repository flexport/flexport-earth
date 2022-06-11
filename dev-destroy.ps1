# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Load global development settings
$GlobalDevelopmentSettings = Get-Content 'development-config.json' | ConvertFrom-Json
$DevelopmentToolsDirectory = $GlobalDevelopmentSettings.DevelopmentToolsDirectory

. "$DevelopmentToolsDirectory/local-config-manager.ps1"
. "$DevelopmentToolsDirectory/sign-in-to-azure.ps1"

try {
    Push-Location $ReleasablesPath

    ./destroy-earth.ps1 `
        -EnvironmentName $LocalSettings.EnvironmentName
}
finally {
    Pop-Location
}
