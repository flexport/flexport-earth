# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$GlobalDevelopmentSettings = Get-Content 'development-config.json' | ConvertFrom-Json
$DevelopmentToolsDirectory = $GlobalDevelopmentSettings.DevelopmentToolsDirectory
$SourceDirectory           = $GlobalDevelopmentSettings.SourceDirectory

. "$DevelopmentToolsDirectory/local-config-manager.ps1"
$DeveloperEnvironmentSettings = Get-EnvironmentSettingsObject

try {
    Push-Location $SourceDirectory

    ./build.ps1 `
        -BuildNumber             $([Guid]::NewGuid()) `
        -FlexportApiClientID     $DeveloperEnvironmentSettings.FlexportApiClientID `
        -FlexportApiClientSecret $DeveloperEnvironmentSettings.FlexportApiClientSecret
}
finally {
    Pop-Location
}