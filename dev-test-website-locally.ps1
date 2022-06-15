# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$GlobalDevelopmentSettings      = Get-Content 'development-config.json' | ConvertFrom-Json
$DevelopmentToolsDirectory      = $GlobalDevelopmentSettings.DevelopmentToolsDirectory
$RelesablesDirectory            = $GlobalDevelopmentSettings.ReleasablesDirectory
$WebsiteContentSourceDirectory  = $GlobalDevelopmentSettings.WebsiteContentSourceDirectory

. "$DevelopmentToolsDirectory/local-config-manager.ps1"

# Read the build number that we're deploying
$BuildNumberFilePath = "$WebsiteContentSourceDirectory/public/build-number.css"
$BuildNumberCSS      = Get-Content -Path $BuildNumberFilePath
$MatchFound          = $BuildNumberCSS -match 'content:\s"(.+)"'

if (-Not $MatchFound) {
    Write-Error "Build number not found."
}

$BuildNumber = $Matches[1]

try {
    Push-Location "$RelesablesDirectory"

    ./test-earth.ps1 -EarthWebsiteUrl http://localhost:3000 -BuildNumber $BuildNumber
}
finally {
    Pop-Location
}
