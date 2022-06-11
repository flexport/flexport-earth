Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Load global development settings
$GlobalDevelopmentSettings = Get-Content 'development-config.json' | ConvertFrom-Json
$DevelopmentToolsDirectory = $GlobalDevelopmentSettings.DevelopmentToolsDirectory

. "$DevelopmentToolsDirectory/local-config-manager.ps1"

$DeveloperEnvironmentSettings = Get-EnvironmentSettingsObject

Write-Information ""
Write-Information "Ensuring you're signed into the correct Azure Subscription..."
$ConfiguredAzureSubscriptionName = $DeveloperEnvironmentSettings.AzureSubscriptionName

$AzAccountShowResults = az account show

if (-Not ($AzAccountShowResults)) {
    Write-Information "Signing in as $ConfiguredAzureSubscriptionName..."
    ./azure/sign-in-as-service-principal.ps1 -AzureSubscriptionName $ConfiguredAzureSubscriptionName
}

$CurrentAzureSubscriptionName = (az account show | ConvertFrom-Json).name

if ($CurrentAzureSubscriptionName -ne $ConfiguredAzureSubscriptionName) {
    Write-Information "You're currently signed into $CurrentAzureSubscriptionName, but your configured Azure Subscription Name is $ConfiguredAzureSubscriptionName"

    $Answer = Read-Host "Do you want to sign into $ConfiguredAzureSubscriptionName ?"

    if ($Answer.ToLower() -eq 'y') {
        ./azure/sign-in-as-service-principal.ps1 -AzureSubscriptionName $ConfiguredAzureSubscriptionName
    }
}

Write-Information "You are signed into the $CurrentAzureSubscriptionName Azure Subscription."
