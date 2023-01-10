[CmdletBinding()]
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
    [Securestring]
    $EarthEnvironmentOperatorsGmailApiClientId,

    [Parameter(Mandatory=$true)]
    [SecureString]
    $EarthEnvironmentOperatorsGmailApiClientSecret,

    [Parameter(Mandatory=$true)]
    [SecureString]
    $EarthEnvironmentOperatorsGmailApiRefreshToken,

    [Parameter(Mandatory=$false)]
    [Int16]
    $MaxTries = 1
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./dependencies/dependency-manager.ps1

try {
    Push-Location "testing/e2e"

    ./run-e2e-tests.ps1 `
        -EnvironmentName                                $EnvironmentName `
        -EarthWebsiteUrl                                $EarthWebsiteUrl `
        -BuildNumber                                    $BuildNumber `
        -EarthEnvironmentOperatorsEmailAddress          $EarthEnvironmentOperatorsEmailAddress `
        -EarthEnvironmentOperatorsGmailApiClientId      $EarthEnvironmentOperatorsGmailApiClientId `
        -EarthEnvironmentOperatorsGmailApiClientSecret  $EarthEnvironmentOperatorsGmailApiClientSecret `
        -EarthEnvironmentOperatorsGmailApiRefreshToken  $EarthEnvironmentOperatorsGmailApiRefreshToken `
        -MaxTries                                       $MaxTries
}
finally {
    Pop-Location
}
