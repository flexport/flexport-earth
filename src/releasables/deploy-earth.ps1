﻿[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $BuildNumber,

    [Parameter(Mandatory = $true)]
    [String]
    $EnvironmentName,

    [Parameter(Mandatory = $false)]
    [String]
    $EarthWebsiteCustomDomainName,

    [Parameter(Mandatory = $true)]
    [String]
    $FlexportApiClientId,

    [Parameter(Mandatory = $true)]
    [String]
    $FlexportApiClientSecret,

    [Parameter(Mandatory = $true)]
    [String]
    $GoogleAnalyticsMeasurementId,

    [Parameter(Mandatory = $false)]
    [String]
    $ContainerSourceRegistryServerAddress,

    [Parameter(Mandatory = $false)]
    [String]
    $ContainerSourceRegistryServicePrincipalUsername,

    [Parameter(Mandatory = $false)]
    [SecureString]
    $ContainerSourceRegistryServicePrincipalPassword,

    [Parameter(Mandatory = $true)]
    [String]
    $ContainerTargetRegistryTenant,

    [Parameter(Mandatory = $true)]
    [String]
    $ContainerTargetRegistryUsername,

    [Parameter(Mandatory = $true)]
    [SecureString]
    $ContainerTargetRegistryPassword,

    [Parameter(Mandatory = $true)]
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
    $EarthEnvironmentOperatorsGmailApiRefreshToken
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$ScriptStartTime = Get-Date

. ./dependencies/dependency-manager.ps1

$LowerEnvironmentContainerRegistry = @{
    RegistryServerAddress            = $ContainerSourceRegistryServerAddress
    RegistryServicePrincipalUsername = $ContainerSourceRegistryServicePrincipalUsername
    RegistryServicePrincipalPassword = $ContainerSourceRegistryServicePrincipalPassword
}

Write-Information ""
Write-Information "Deploying Earth build $BuildNumber to $EnvironmentName environment..."
Write-Information ""

#Update-SubscriptionBudget

$LogAnalyticsWorkspaceId = $null

try {
    Push-Location "./shared-infrastructure/log-analytics"

    $LogAnalyticsWorkspaceId = ./deploy-log-analytics.ps1 -EnvironmentName $EnvironmentName
}
finally {
    Pop-Location
}

try {
    Push-Location "./shared-infrastructure/containers"

    ./deploy-container-infrastructure.ps1 -EnvironmentName $EnvironmentName
}
finally {
    Pop-Location
}

$EarthWebsiteUrl = ""

try {
    Push-Location "./frontend"

    $EarthWebsiteUrl = ./deploy-frontend.ps1 `
        -EnvironmentName                        $EnvironmentName `
        -BuildNumber                            $BuildNumber `
        -EarthWebsiteCustomDomainName           $EarthWebsiteCustomDomainName `
        -FlexportApiClientId                    $FlexportApiClientId `
        -FlexportApiClientSecret                $FlexportApiClientSecret `
        -GoogleAnalyticsMeasurementId           $GoogleAnalyticsMeasurementId `
        -LogAnalyticsWorkspaceId                $LogAnalyticsWorkspaceId `
        -EarthEnvironmentOperatorsEmailAddress  $EarthEnvironmentOperatorsEmailAddress
}
finally {
    Pop-Location
}

# Run E2E tests, with multiple retries as sometimes
# they fail with transient errors instead of real issues.
# The retries avoid doing full deployments and also avoid
# blocking CD pipeline waiting for someone to manually retry.
./test-earth.ps1 `
    -EnvironmentName                                $EnvironmentName `
    -BuildNumber                                    $BuildNumber `
    -EarthWebsiteUrl                                $EarthWebsiteUrl `
    -EarthEnvironmentOperatorsEmailAddress          $EarthEnvironmentOperatorsEmailAddress `
    -EarthEnvironmentOperatorsGmailApiClientId      $EarthEnvironmentOperatorsGmailApiClientId `
    -EarthEnvironmentOperatorsGmailApiClientSecret  $EarthEnvironmentOperatorsGmailApiClientSecret `
    -EarthEnvironmentOperatorsGmailApiRefreshToken  $EarthEnvironmentOperatorsGmailApiRefreshToken `
    -MaxTries                                       3

# Once we've confirmed the latest application and tests are working successfully,
# deploy the E2E Monitor for continuously running the tests against the environment
# to catch any issues that occur between deployments.

. ./shared-infrastructure/containers/container-infra-config.ps1

$ContainerInfraConfig = Get-ContainerInfraConfig -EnvironmentName $EnvironmentName

$ContainerRegistry = @{
    RegistryName                     = $ContainerInfraConfig.ContainerRegistryName
    RegistryServerAddress            = $ContainerInfraConfig.ContainerRegistryServerAddress
    RegistryTenant                   = $ContainerTargetRegistryTenant
    RegistryServicePrincipalUsername = $ContainerTargetRegistryUsername
    RegistryServicePrincipalPassword = $ContainerTargetRegistryPassword
}

try {
    Push-Location "./testing/e2e/monitor"

    ./deploy-e2e-monitor.ps1 `
        -EnvironmentName                    $EnvironmentName `
        -BuildNumber                        $BuildNumber `
        -EarthWebsiteBaseUrl                $EarthWebsiteUrl `
        -LowerEnvironmentContainerRegistry  $LowerEnvironmentContainerRegistry `
        -ContainerRegistry                  $ContainerRegistry
}
finally {
    Pop-Location
}

$Duration = New-TimeSpan `
    -Start $ScriptStartTime `
    -End   $(Get-Date)

Write-Information "Earth deployment completed in $Duration"
