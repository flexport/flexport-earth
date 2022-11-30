[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
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

Write-Information ""
Write-Information "Testing Earth (build $BuildNumber) at $EarthWebsiteUrl"
Write-Information ""

$E2ETestRootPath        = "cypress.io"
$TestResultsDirectory   = "results"

try {
    Push-Location $E2ETestRootPath

    Write-Information "Installing dependencies..."
    npm install
    Write-Information "Dependencies installed!"

    for ($i = 1; $i -le $MaxTries; $i++) {
        try {
            if (Test-Path $TestResultsDirectory) {
                Remove-Item $TestResultsDirectory -Force -Recurse
            }

            Write-Information ""
            Write-Information "Running tests..."

            $CypressCommand = "$(npm bin)/cypress run --spec ""cypress/integration/**/*"" --env BUILD_NUMBER=$BuildNumber,EARTH_WEBSITE_URL=$EarthWebsiteUrl --reporter junit --reporter-options ""mochaFile=results/cypress.xml"""

            Write-Information ""
            Write-Information "Command: $CypressCommand"
            Write-Information ""

            Invoke-Expression $CypressCommand

            if ($LastExitCode -ne 0) {
                Write-Error "Testing failed with exit code: $LastExitCode"
            }

            if (-Not (Test-Path $TestResultsDirectory)) {
                Write-Error "No test results found in $TestRootPath/$TestResultsDirectory. Something went wrong!"
            }

            Write-Information ""
            Write-Information "Testing completed!"
            Write-Information ""

            # Break the retry loop if last test run was successful.
            break
        }
        catch {
            Write-Information ""
            Write-Information "($i / $MaxTries) E2E tests failed!"
            Write-Information ""
            Write-Information "Exception Details:"
            Write-Information $_
            Write-Information ""

            if ($i -ge $MaxTries) {
                Write-Error "E2E tests could not pass after $MaxTries retries, giving up..."
            }

            Write-Information "Retrying..."
        }
    }
}
finally {
    Pop-Location
}
