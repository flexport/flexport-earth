[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
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

$TestRootPath = "testing/functional"

try {
    Push-Location $TestRootPath

    Write-Information ""
    Write-Information "pwd: $(Get-Location)"
    Write-Information ""

    $TestResultsDirectory = "results"

    Write-Information ""
    Write-Information "Running tests..."

    if (Test-Path $TestResultsDirectory) {
        Remove-Item $TestResultsDirectory -Force -Recurse
    }

    $CypressBinPath = "node_modules/cypress/bin/cypress"

    Write-Information "Getting cypress version"
    & $CypressBinPath --version
    Write-Information "Done!"

    Invoke-Expression "$CypressBinPath run --spec ""cypress/integration/**/*"" --env BUILD_NUMBER=$BuildNumber,EARTH_WEBSITE_URL=$EarthWebsiteUrl --reporter junit --reporter-options ""mochaFile=results/cypress.xml"""

    if ($LastExitCode -ne 0) {
        Write-Error "Testing failed!"
    }

    if (-Not (Test-Path $TestResultsDirectory)) {
        Write-Error "No test results found in $TestRootPath/$TestResultsDirectory. Something went wrong!"
    }

    Write-Information ""
    Write-Information "Testing completed!"
    Write-Information ""
}
finally {
    Pop-Location
}
