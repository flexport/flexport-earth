# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

. ./development-tools/local-config-manager.ps1

try {
    Push-Location $ReleasablesPath

    # Generate a random build number for local builds.
    $BuildNumber = [guid]::NewGuid()

    ./deploy-earth.ps1 `
        -BuildNumber                  $BuildNumber `
        -EnvironmentName              $LocalSettings.EnvironmentName `
        -EarthWebsiteCustomDomainName $LocalSettings.EarthWebsiteCustomDomainName
}
finally {
    Pop-Location
}
