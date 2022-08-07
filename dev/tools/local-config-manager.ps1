Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Load Global Development Settings
$GlobalDevelopmentSettings = Get-Content 'dev/development-config.json' | ConvertFrom-Json

$ReleasablesDirectory = $GlobalDevelopmentSettings.ReleasablesDirectory
$CacheDirectory       = $GlobalDevelopmentSettings.CacheDirectory

# Run dependency management
. "$ReleasablesDirectory/dependencies/dependency-manager.ps1"

function Set-ConfigValue {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory = $true)]
        [PSCustomObject]
        $Settings,

        [Parameter(Mandatory = $true)]
        [String]
        $SettingsFilePath,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigName,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigPrompt
    )

    process {
        if ($PSCmdlet.ShouldProcess($ConfigName)) {
            $SettingExists = [Bool]($Settings.PSObject.Properties.Name -Match $ConfigName)

            if (-Not ($SettingExists)) {
                $ConfigValue = Read-Host $ConfigPrompt
                Add-Member -InputObject $Settings -NotePropertyName $ConfigName -NotePropertyValue $ConfigValue
                $Settings | ConvertTo-Json | Set-Content -Path $SettingsFilePath
            }
        }
    }
}

function Get-EnvironmentSettingsObject {
    $LocalSettingsPath = "$CacheDirectory/environment-settings.json"

    if (-Not (Test-Path $LocalSettingsPath)) {
        Set-Content -Path $LocalSettingsPath -Value "{}"
        Write-Information "Created settings file: $LocalSettingsPath"
    }

    $LocalSettingsJson = Get-Content $LocalSettingsPath
    $LocalSettings     = $LocalSettingsJson | ConvertFrom-Json

    # Ensure all the expected settings are configured before returning.
    Set-ConfigValue `
        -Settings         $LocalSettings `
        -SettingsFilePath $LocalSettingsPath `
        -ConfigName       "AzureSubscriptionName" `
        -ConfigPrompt     "What is the name of the Azure Subscription you'll deploy to?"

    Set-ConfigValue `
        -Settings         $LocalSettings `
        -SettingsFilePath $LocalSettingsPath `
        -ConfigName       "EnvironmentName" `
        -ConfigPrompt     "What is the name of the Environment to create within your Azure Subscription (short single word)?"

    Set-ConfigValue `
        -Settings         $LocalSettings `
        -SettingsFilePath $LocalSettingsPath `
        -ConfigName       "EarthWebsiteCustomDomainName" `
        -ConfigPrompt     "What custom domain name to use for the Earth Website, if any? (enter for none)?"

    Set-ConfigValue `
        -Settings         $LocalSettings `
        -SettingsFilePath $LocalSettingsPath `
        -ConfigName       "FlexportApiClientId" `
        -ConfigPrompt     "What's your Flexport API Client ID?"

    Set-ConfigValue `
        -Settings         $LocalSettings `
        -SettingsFilePath $LocalSettingsPath `
        -ConfigName       "FlexportApiClientSecret" `
        -ConfigPrompt     "What's your Flexport API Client Secret?"

    return $LocalSettings
}

# $LocalSettingsPath = "$CacheDirectory/environment-settings.json"

# # Configure the local developer settings if they are not yet configured.
# if (-Not (Test-Path $LocalSettingsPath)) {
#     Write-Information "Your local settings have not been configured yet at $LocalSettingsPath, let's configure them now..."
#     Write-Information ""

#     $AzureSubscriptionName        = Read-Host "What is the name of the Azure Subscription you'll deploy to?"
#     $EnvironmentName              = (Read-Host "What is the name of the Environment to create within your Azure Subscription (short single words preferred)?").ToLower()
#     $EarthWebsiteCustomDomainName = Read-Host "What custom domain name to use for the Earth Website, if any? (enter for none)"

#     $LocalSettings = [PSCustomObject]@{
#         AzureSubscriptionName        = $AzureSubscriptionName
#         EnvironmentName              = $EnvironmentName
#         EarthWebsiteCustomDomainName = $EarthWebsiteCustomDomainName
#     }

#     if (-Not (Test-Path $CacheDirectory)) {
#         New-Item -ItemType Directory -Path $CacheDirectory
#     }

#     $LocalSettings | ConvertTo-Json | Set-Content -Path $LocalSettingsPath
# }

# $LocalSettingsJson = Get-Content $LocalSettingsPath

# Write-Information "Local Settings Loaded:"
# $LocalSettingsJson

# $LocalSettings = $LocalSettingsJson | ConvertFrom-Json

