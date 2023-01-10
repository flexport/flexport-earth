[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EnvironmentName,

    [Parameter(Mandatory=$true)]
    [String]
    $EarthWebsiteUrl,

    [Parameter(Mandatory=$true)]
    [String]
    $BuildNumber,

    [Parameter(Mandatory=$true)]
    [String]
    $EarthEnvironmentOperatorsEmailAddress,

    [Parameter(Mandatory=$true)]
    [SecureString]
    $EarthEnvironmentOperatorsGmailApiClientId,

    [Parameter(Mandatory=$true)]
    [SecureString]
    $EarthEnvironmentOperatorsGmailApiClientSecret,

    [Parameter(Mandatory=$true)]
    [SecureString]
    $EarthEnvironmentOperatorsGmailApiRefreshToken,

    [Parameter(Mandatory=$false)]
    [Int16]
    $MaxTries = 1,

    [Parameter(Mandatory=$false)]
    [Switch]
    $OpenTestUI = $false
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

    $Specs              = ""
    $CypressMode        = "run"
    $ReporterOptions    = ""

    if ($OpenTestUI) {
        $CypressMode = "open"
        $MaxTries    = 1
    } else {
        $Specs              = '--spec "cypress/integration/**/*"'
        $ReporterOptions    = '--reporter junit --reporter-options ""mochaFile=results/cypress.xml""'
    }

    $EarthEnvironmentOperatorsGmailApiClientIdPlain      = $($EarthEnvironmentOperatorsGmailApiClientId     | ConvertFrom-SecureString -AsPlainText)
    $EarthEnvironmentOperatorsGmailApiClientSecretPlain  = $($EarthEnvironmentOperatorsGmailApiClientSecret | ConvertFrom-SecureString -AsPlainText)
    $EarthEnvironmentOperatorsGmailApiRefreshTokenPlain  = $($EarthEnvironmentOperatorsGmailApiRefreshToken | ConvertFrom-SecureString -AsPlainText)

    $CypressCommand = "$(npm bin)/cypress $CypressMode $Specs --env EARTH_ENVIRONMENT_NAME=$EnvironmentName,EARTH_ENV_OPS_EMAIL=$EarthEnvironmentOperatorsEmailAddress,EARTH_ENV_OPS_GMAIL_CLIENT_ID=$EarthEnvironmentOperatorsGmailApiClientIdPlain,EARTH_ENV_OPS_GMAIL_CLIENT_SECRET=$EarthEnvironmentOperatorsGmailApiClientSecretPlain,EARTH_ENV_OPS_GMAIL_REFRESH_TOKEN=$EarthEnvironmentOperatorsGmailApiRefreshTokenPlain,BUILD_NUMBER=$BuildNumber,EARTH_WEBSITE_URL=$EarthWebsiteUrl --browser chrome $ReporterOptions"

    for ($i = 1; $i -le $MaxTries; $i++) {
        try {
            if (Test-Path $TestResultsDirectory) {
                Remove-Item $TestResultsDirectory -Force -Recurse
            }

            Write-Information ""
            Write-Information "Running tests..."

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
