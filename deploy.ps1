# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Load global development settings
$GlobalDevelopmentSettings = Get-Content 'development-config.json' | ConvertFrom-Json

$WebsiteContentSourceDirectory = $GlobalDevelopmentSettings.WebsiteContentSourceDirectory

. ./development-tools/local-config-manager.ps1

# Read the build number that we're deploying
$BuildNumberFilePath = "$WebsiteContentSourceDirectory/styles/build-number.css"
$BuildNumberCSS = Get-Content -Path $BuildNumberFilePath
$MatchFound = $BuildNumberCSS -match 'content:\s"(.+)"'

if (-Not $MatchFound) {
    Write-Error "Build number not found."
}

$BuildNumber = $Matches[1]

# Read API configs from NextJs .env file.
$NextJsEnvFilePath = "$WebsiteContentSourceDirectory/.env"

if (-Not (Test-Path $NextJsEnvFilePath)) {
    Write-Error "$NextJsEnvFilePath not found. Create this file with the following content and try again:`r`nFLEXPORT_API_CLIENT_ID=<ADD CLIENT ID HERE>`r`nFLEXPORT_API_CLIENT_SECRET=<ADD CLIENT SECRET HERE>"
}

$NextJsEnvContent = Get-Content $NextJsEnvFilePath

$MatchFound = $NextJsEnvContent -match 'FLEXPORT_API_CLIENT_ID=(.+)'

if (-Not $MatchFound) {
    Write-Error "FLEXPORT_API_CLIENT_ID setting not found.  Please add it and try again."
}

$FlexportApiClientId = $Matches[1]

$MatchFound = $NextJsEnvContent -match 'FLEXPORT_API_CLIENT_SECRET=(.+)'

if (-Not $MatchFound) {
    Write-Error "FLEXPORT_API_CLIENT_SECRET setting not found.  Please add it and try again."
}

$FlexportApiClientSecret = $Matches[1]

try {
    Push-Location $ReleasablesPath

    ./deploy-earth.ps1 `
        -BuildNumber                  $BuildNumber `
        -EnvironmentName              $LocalSettings.EnvironmentName `
        -EarthWebsiteCustomDomainName $LocalSettings.EarthWebsiteCustomDomainName `
        -FlexportApiClientId          $FlexportApiClientId `
        -FlexportApiClientSecret      $FlexportApiClientSecret
}
finally {
    Pop-Location
}
