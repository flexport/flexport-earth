# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$GlobalDevelopmentSettings = Get-Content 'development-config.json' | ConvertFrom-Json
$DevelopmentToolsDirectory = $GlobalDevelopmentSettings.DevelopmentToolsDirectory
$WebsiteContentDirectory   = $GlobalDevelopmentSettings.WebsiteContentSourceDirectory

. "$DevelopmentToolsDirectory/local-config-manager.ps1"

./dev-build.ps1

try {
    Push-Location $WebsiteContentDirectory
    npm run dev
}
finally {
    Pop-Location
}
