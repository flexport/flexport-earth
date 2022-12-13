Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Load global development settings
$GlobalDevelopmentSettings = Get-Content 'dev/development-config.json' | ConvertFrom-Json

$CacheDirectory             = $GlobalDevelopmentSettings.CachedAzureCredsDirectory
$DevelopmentToolsDirectory  = $GlobalDevelopmentSettings.DevelopmentToolsDirectory

. "$DevelopmentToolsDirectory/local-config-manager.ps1"

$DeveloperEnvironmentSettings = Get-EnvironmentSettingsObject

$CurrentAzureSubscriptionName = $DeveloperEnvironmentSettings.AzureSubscriptionName

. ./src/releasables/earth-runtime-config.ps1

$EarthRuntimeConfig = Get-EarthRuntimeConfig -EnvironmentName $DeveloperEnvironmentSettings.EnvironmentName
$EarthDeployerServicePrincipalName = $EarthRuntimeConfig.EarthDeployerServicePrincipalName

Write-Information ""
Write-Information "Signing into Azure as the Deployer Service Principal $EarthDeployerServicePrincipalName..."

$DeployerCredentials = Get-Content -Path $CacheDirectory/$EarthDeployerServicePrincipalName.json | ConvertFrom-Json

az login `
    --service-principal `
    --username  $DeployerCredentials.appId `
    --password  $DeployerCredentials.password `
    --tenant    $DeployerCredentials.tenant

if (!$?) {
    Write-Error "Failed to sign in as $EarthDeployerServicePrincipalName."
}

$AccountInfo = az account show | ConvertFrom-Json

if (!$?) {
    Write-Error "Failed get account information!"
}

$CurrentLoggedInUsername = $AccountInfo.user.name

if ($CurrentLoggedInUsername -ne $DeployerCredentials.appId) {
    Write-Error "Not logged in as the intended user: $DeployerCredentials.appId. Logged in as $CurrentLoggedInUsername something went wrong!"
}

Write-Information "You are signed into the $CurrentAzureSubscriptionName Azure Subscription as $EarthDeployerServicePrincipalName."
