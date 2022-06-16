# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Load global development settings
$GlobalDevelopmentSettings = Get-Content 'development-config.json' | ConvertFrom-Json
$DevelopmentToolsDirectory = $GlobalDevelopmentSettings.DevelopmentToolsDirectory
$ReleasablesPath           = $GlobalDevelopmentSettings.ReleasablesDirectory

. "$DevelopmentToolsDirectory/local-config-manager.ps1"
. "$DevelopmentToolsDirectory/sign-into-azure.ps1"
. "$DevelopmentToolsDirectory/build-number.ps1"

# Read the build number that we're deploying
$BuildNumber                  = Get-BuildNumber
$DeveloperEnvironmentSettings = Get-EnvironmentSettingsObject

try {
    Push-Location $ReleasablesPath

    ./deploy-earth.ps1 `
        -BuildNumber                  $BuildNumber `
        -EnvironmentName              $DeveloperEnvironmentSettings.EnvironmentName `
        -EarthWebsiteCustomDomainName $DeveloperEnvironmentSettings.EarthWebsiteCustomDomainName `
        -FlexportApiClientId          $DeveloperEnvironmentSettings.FlexportApiClientId `
        -FlexportApiClientSecret      $DeveloperEnvironmentSettings.FlexportApiClientSecret
}
finally {
    Pop-Location
}
