﻿# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Load global development settings
$GlobalDevelopmentSettings = Get-Content 'development-config.json' | ConvertFrom-Json

$WebsiteContentSourceDirectory = $GlobalDevelopmentSettings.WebsiteContentSourceDirectory
$DevelopmentToolsDirectory     = $GlobalDevelopmentSettings.DevelopmentToolsDirectory
$ReleasablesPath               = $GlobalDevelopmentSettings.ReleasablesDirectory

. "$DevelopmentToolsDirectory/local-config-manager.ps1"
. "$DevelopmentToolsDirectory/sign-into-azure.ps1"

# Read the build number that we're deploying
$BuildNumberFilePath = "$WebsiteContentSourceDirectory/styles/build-number.css"
$BuildNumberCSS      = Get-Content -Path $BuildNumberFilePath
$MatchFound          = $BuildNumberCSS -match 'content:\s"(.+)"'

if (-Not $MatchFound) {
    Write-Error "Build number not found."
}

$BuildNumber                  = $Matches[1]
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