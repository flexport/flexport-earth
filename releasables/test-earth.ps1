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

    $NpmBinPath = $(npm bin)

    ls -la $NpmBinPath

    Write-Information "Restoring Symlinks..."
    Write-Information "First, remove broken links from $NpmBinPath"
    Push-Location $NpmBinPath
    rm *.*
    Write-Information "Done!"
    Write-Information "Recreate symlinks..."
    ln -s ../cypress/bin/cypress cypress
    ln -s ../extract-zip/cli.js extract-zip
    ln -s ../is-ci/bin.js is-ci
    ln -s ../which/bin/node-which node-which
    ln -s ../rimraf/bin.js rimraf
    ln -s ../semver/bin/semver.js semver
    ln -s ../sshpk/bin/sshpk-conv sshpk-conv
    ln -s ../sshpk/bin/sshpk-sign sshpk-sign
    ln -s ../sshpk/bin/sshpk-verify sshpk-verify
    ln -s ../uuid/dist/bin/uuid uuid
    Pop-Location
    Write-Information "Done!"
    
    Write-Information ""
    ls -la $NpmBinPath
    Write-Information ""

    Write-Information "Node Version:    $(node --version)"
    Write-Information "npm Version:     $(npm --version)"
    Write-Information "cypress Version: $(& $NpmBinPath/cypress --version)"
    
    Invoke-Expression "$NpmBinPath/cypress run --spec ""cypress/integration/**/*"" --env BUILD_NUMBER=$BuildNumber,EARTH_WEBSITE_URL=$EarthWebsiteUrl --reporter junit --reporter-options ""mochaFile=results/cypress.xml"""

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
