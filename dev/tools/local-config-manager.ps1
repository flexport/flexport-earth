Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

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
        $ConfigPrompt,

        [Parameter(Mandatory = $false)]
        [Switch]
        $AsSecureString
    )

    process {
        if ($PSCmdlet.ShouldProcess($ConfigName)) {

            $HasObjects = $false

            # Verify the properties are populated before trying to use them.
            $Settings.PSObject.Properties | ForEach-Object {
                $HasObjects = $true
            }

            $SettingExists = [Bool](
                $HasObjects -eq $true `
                -and `
                $Settings.PSObject.Properties.Name -Match $ConfigName
            )

            if (-Not ($SettingExists)) {
                if ($AsSecureString) {
                    $ConfigValue = (Read-Host $ConfigPrompt -AsSecureString) | ConvertFrom-SecureString
                } else {
                    $ConfigValue = Read-Host $ConfigPrompt
                }

                Add-Member `
                    -InputObject        $Settings `
                    -NotePropertyName   $ConfigName `
                    -NotePropertyValue  $ConfigValue

                $Settings | ConvertTo-Json | Set-Content -Path $SettingsFilePath
            }
        }
    }
}

# Gets settings that apply to everyone everywhere.
function Get-GlobalDevelopmentSettings {
    Get-Content 'dev/development-config.json' | ConvertFrom-Json
}

# Gets settings that are specific to you as a developer.
function Get-DeveloperEnvironmentSettings {
    $GlobalDevelopmentSettings  = Get-GlobalDevelopmentSettings
    $LocalSettingsPath          = "$($GlobalDevelopmentSettings.CacheDirectory)/environment-settings.json"

    if (-Not (Test-Path $GlobalDevelopmentSettings.CacheDirectory)) {
        Write-Information "
Hello, Earthling!

This appears to be the first time running the Earth Development scripts from this folder...

Let's do some one-time set up to get you up and running!
"

        New-Item -ItemType Directory -Path $GlobalDevelopmentSettings.CacheDirectory
        Write-Information "Created cache folder $($GlobalDevelopmentSettings.CacheDirectory) for your personal configuration values."
    }

    if (-Not (Test-Path $LocalSettingsPath)) {
        Set-Content -Path $LocalSettingsPath -Value "{}"
        Write-Information "Created settings file: $LocalSettingsPath"
        Write-Information ""
    }

    $LocalSettingsJson = Get-Content $LocalSettingsPath
    $LocalSettings     = $LocalSettingsJson | ConvertFrom-Json

    # Ensure all the expected settings are configured before returning.
    Set-ConfigValue `
        -Settings         $LocalSettings `
        -SettingsFilePath $LocalSettingsPath `
        -ConfigName       "AzureSubscriptionName" `
        -ConfigPrompt     "
What is the name of the Azure Subscription you'll deploy to?

Don't have an Azure Subscription?
- If you're a Flexport sanctioned developer, contact the Earth Dev Team to create a paid subscription for you.
- If not a Flexport sanctioned developer, you can create your own free Azure account yourself.

"

    Set-ConfigValue `
        -Settings         $LocalSettings `
        -SettingsFilePath $LocalSettingsPath `
        -ConfigName       "EnvironmentName" `
        -ConfigPrompt     "
What is the name of the Environment to create within your Azure Subscription?

You can make up any name you prefer, just keep it short (6 characters or less) and alphanumeric.

"

    Set-ConfigValue `
        -Settings         $LocalSettings `
        -SettingsFilePath $LocalSettingsPath `
        -ConfigName       "EarthWebsiteCustomDomainName" `
        -ConfigPrompt     "What custom domain name to use for the Earth Website, if any? (enter for none)?"

    Set-ConfigValue `
        -Settings         $LocalSettings `
        -SettingsFilePath $LocalSettingsPath `
        -ConfigName       "FlexportApiClientId" `
        -ConfigPrompt     "
What's your Flexport API Client ID?

Don't have a Flexport API Client ID?
- If you're a Flexport sanctioned developer, contact the Earth Dev Team to create one for you.
- If not a Flexport sanctioned developer, I'm afraid we cannot provide API credentials to you at this time.

"

    Set-ConfigValue `
        -Settings         $LocalSettings `
        -SettingsFilePath $LocalSettingsPath `
        -ConfigName       "FlexportApiClientSecret" `
        -ConfigPrompt     "What's your Flexport API Client Secret?" `
        -AsSecureString

    Set-ConfigValue `
        -Settings         $LocalSettings `
        -SettingsFilePath $LocalSettingsPath `
        -ConfigName       "GoogleAnalyticsMeasurementId" `
        -ConfigPrompt     "
What's your Google Analytics Measurement ID (G-XXXXXXXXXX)?

See docs here on how to set it up:
https://github.com/flexport/flexport-earth/tree/main/product/docs/administrative-features/reporting-and-analytics/google-analytics#how-to-provision-a-new-google-analytics-account-for-a-new-earth-environment

"

    Set-ConfigValue `
        -Settings         $LocalSettings `
        -SettingsFilePath $LocalSettingsPath `
        -ConfigName       "EarthEnvironmentOperatorsEmailAddress" `
        -ConfigPrompt     "What email address should be used for this environments Earth Environment Operators for things such as alert notifications?"

    $LocalSettings.FlexportApiClientSecret = $($LocalSettings.FlexportApiClientSecret) | ConvertTo-SecureString

    return $LocalSettings
}
