# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$GlobalDevelopmentSettings      = Get-Content 'development-config.json' | ConvertFrom-Json
$DevelopmentToolsDirectory      = $GlobalDevelopmentSettings.DevelopmentToolsDirectory
$RelesablesDirectory            = $GlobalDevelopmentSettings.ReleasablesDirectory

. "$DevelopmentToolsDirectory/build-number.ps1"

$BuildNumber = Get-BuildNumber

try {
    Push-Location "$RelesablesDirectory"

    ./test-earth.ps1 -EarthWebsiteUrl http://localhost:3000 -BuildNumber $BuildNumber
}
finally {
    Pop-Location
}
