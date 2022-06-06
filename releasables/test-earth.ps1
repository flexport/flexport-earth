[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $BuildNumber,

    [Parameter(Mandatory=$true)]
    [String]
    $EarthWebsiteUrl
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./dependencies/dependency-manager.ps1

Write-Information ""
Write-Information "Testing Earth at $EarthWebsiteUrl"

try {
    Push-Location "testing/functional"

    Write-Information ""
    Write-Information "Running tests..."

    $CypressPath = "$(npm bin)/cypress"

    & $CypressPath run `
        --spec "cypress/integration/**/*" `
        --env BUILD_NUMBER=$BuildNumber,EARTH_WEBSITE_URL=$EarthWebsiteUrl

    if ($LastExitCode -ne 0) {
        Write-Error "Testing failed!"
    }

    Write-Information ""
    Write-Information "Testing completed!"
    Write-Information ""
}
finally {
    Pop-Location
}
