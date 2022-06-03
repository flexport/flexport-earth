# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

. ./development-tools/local-config-manager.ps1

try {
    ./build.ps1

    Push-Location $ReleasablesPath/frontend/website-content

    npm run dev
}
finally {
    Pop-Location
}
