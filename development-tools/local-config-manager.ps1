Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$ReleasablesPath = "./releasables"

# Run dependency management

. "$ReleasablesPath/dependencies/dependency-manager.ps1"

# Load Global Development Settings
$GlobalDevelopmentSettings = Get-Content 'development-config.json' | ConvertFrom-Json

$CacheDirectory = $GlobalDevelopmentSettings.CacheDirectory
$LocalSettingsPath = "$CacheDirectory/environment-settings.json"

# Configure the local developer settings if they are not yet configured.
if (-Not (Test-Path $LocalSettingsPath)) {
    Write-Information "Your local settings have not been configured yet at $LocalSettingsPath, let's configure them now..."
    Write-Information ""

    $AzureSubscriptionName        = Read-Host "What is the name of the Azure Subscription you'll deploy to?"
    $EnvironmentName              = (Read-Host "What is the name of the Environment to create within your Azure Subscription (short single words preferred)?").ToLower()
    $EarthWebsiteCustomDomainName = Read-Host "What custom domain name to use for the Earth Website, if any? (enter for none)"

    $LocalSettings = [PSCustomObject]@{
        AzureSubscriptionName        = $AzureSubscriptionName
        EnvironmentName              = $EnvironmentName
        EarthWebsiteCustomDomainName = $EarthWebsiteCustomDomainName
    }

    if (-Not (Test-Path $CacheDirectory)) {
        New-Item -ItemType Directory -Path $CacheDirectory
    }

    $LocalSettings | ConvertTo-Json | Set-Content -Path $LocalSettingsPath
}

$LocalSettingsJson = Get-Content $LocalSettingsPath

Write-Information "Local Settings Loaded:"
$LocalSettingsJson

$LocalSettings = $LocalSettingsJson | ConvertFrom-Json

Write-Information ""
Write-Information "Ensuring you're signed into the correct Azure Subscription..."

$ConfiguredAzureSubscriptionName = $LocalSettings.AzureSubscriptionName

$AzAccountShowResults = az account show

if (-Not ($AzAccountShowResults)) {
    Write-Information "Signing in as $ConfiguredAzureSubscriptionName..."
    ./azure/sign-in-as-service-principal.ps1 -AzureSubscriptionName $ConfiguredAzureSubscriptionName
}

$CurrentAzureSubscriptionName    = (az account show | ConvertFrom-Json).name

if ($CurrentAzureSubscriptionName -ne $ConfiguredAzureSubscriptionName) {
    Write-Information "You're currently signed into $CurrentAzureSubscriptionName, but your configured Azure Subscription Name is $ConfiguredAzureSubscriptionName"

    $Answer = Read-Host "Do you want to sign into $ConfiguredAzureSubscriptionName ?"

    if ($Answer.ToLower() -eq 'y') {
        ./azure/sign-in-as-service-principal.ps1 -AzureSubscriptionName $ConfiguredAzureSubscriptionName
    }
}

Write-Information "You are signed into the $CurrentAzureSubscriptionName Azure Subscription."