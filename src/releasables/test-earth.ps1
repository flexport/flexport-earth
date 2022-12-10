[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EarthWebsiteUrl,

    [Parameter(Mandatory=$true)]
    [String]
    $BuildNumber,

    [Parameter(Mandatory=$false)]
    [Int16]
    $MaxTries = 1
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./dependencies/dependency-manager.ps1

Write-Information ""
Write-Information "Testing Earth (build $BuildNumber) at $EarthWebsiteUrl"
Write-Information ""

try {
    Push-Location "testing/e2e"

    ./run-e2e-tests.ps1 `
        -EarthWebsiteUrl $EarthWebsiteUrl `
        -BuildNumber     $BuildNumber `
        -MaxTries        $MaxTries
}
finally {
    Pop-Location
}
