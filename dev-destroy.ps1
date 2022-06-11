# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Load global development settings
$GlobalDevelopmentSettings = Get-Content 'development-config.json' | ConvertFrom-Json
$DevelopmentToolsDirectory = $GlobalDevelopmentSettings.DevelopmentToolsDirectory
$RelesablesDirectory       = $GlobalDevelopmentSettings.ReleasablesDirectory

. "$DevelopmentToolsDirectory/local-config-manager.ps1"
. "$DevelopmentToolsDirectory/sign-into-azure.ps1"

$DeveloperEnvironmentSettings = Get-EnvironmentSettingsObject

try {
    Push-Location $RelesablesDirectory

    ./destroy-earth.ps1 `
        -EnvironmentName $DeveloperEnvironmentSettings.EnvironmentName
}
finally {
    Pop-Location
}
