Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

function Invoke-AuthFlexportApi {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $FlexportApiClientId,

        [Parameter(Mandatory = $true)]
        [String]
        $FlexportApiClientSecret
    )

    $headers = @{
        'Content-Type'='application/json'
    }

    $body = @{
        'client_id'    = $FlexportApiClientId
        'client_secret'= $FlexportApiClientSecret
        'audience'     = 'https://api.flexport.com'
        'grant_type'   = 'client_credentials'
    }

    $bodyJson = $body | ConvertTo-Json

    $response = Invoke-WebRequest `
        -Method     Post `
        -Uri        https://api.flexport.com/oauth/token `
        -Headers    $headers `
        -Body       $bodyJson

    $jsonContent            = $response.Content
    $content                = $jsonContent | ConvertFrom-Json
    $flexportApiAccessToken = $content.access_token

    return $flexportApiAccessToken
}

function Invoke-GetPorts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $FlexportApiAccessToken,

        [Parameter(Mandatory = $false)]
        [String]
        $Types
    )

    $headers = @{
        'Flexport-Version'='1'
        'Authorization'   ="Bearer $FlexportApiAccessToken"
    }

    $queryString = ''

    if ($Types) {
        $queryString = "types=$Types"
    }

    $response = Invoke-WebRequest `
        -Method     Get `
        -Uri        "https://api.flexport.com/places/ports?$queryString" `
        -Headers    $headers

    $jsonContent            = $response.Content
    $content                = $jsonContent | ConvertFrom-Json

    $content
}

# Load some configuration values...
$GlobalDevelopmentSettings = Get-Content 'dev/development-config.json' | ConvertFrom-Json

$DevelopmentToolsDirectory = $GlobalDevelopmentSettings.DevelopmentToolsDirectory
. "$DevelopmentToolsDirectory/local-config-manager.ps1"
$DeveloperEnvironmentSettings = Get-EnvironmentSettingsObject

$FlexportApiAccessToken = Invoke-AuthFlexportApi `
    -FlexportApiClientId        $DeveloperEnvironmentSettings.FlexportApiClientId `
    -FlexportApiClientSecret    $DeveloperEnvironmentSettings.FlexportApiClientSecret

Invoke-GetPorts -FlexportApiAccessToken $FlexportApiAccessToken -Types 'SEAPORT'
