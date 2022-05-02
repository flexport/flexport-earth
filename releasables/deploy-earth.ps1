[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EnvironmentName,

    [Parameter(Mandatory=$true)]
    [String]
    $EarthWebsiteDomainName
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./dependencies/dependency-manager.ps1

# Load common configuration values
. ./earth-config.ps1

Write-Information "Deploying to $EnvironmentName environment..."

# Performs Create if doesn't exist.
function Update-SubscriptionBudget {
    process {
        az `
            deployment sub create `
            --location $EarthFrontendResourceGroupLocation `
            --template-file azure-subscription/subscription-budget.bicep `
            --parameters @azure-subscription/subscription-budget.parameters.json

        if (!$?) {
            Write-Error "Budget deployment failed."
            Exit 1
        }
    }
}

# Performs Create if doesn't exist.
function Update-FrontendResourceGroup {
    process {
        $Parameters = '{\"earthFrontendResourceGroupName\":{\"value\":\"' + $EarthFrontendResourceGroupName + '\"}, \"resourceGroupLocation\":{\"value\":\"' + $EarthFrontendResourceGroupLocation + '\"}}'

        az `
            deployment sub create `
            --location $EarthFrontendResourceGroupLocation `
            --template-file ./frontend/earth-frontend.bicep `
            --parameters $Parameters

        if (!$?) {
            Write-Error "Resource group deployment failed."
            Exit 1
        }
    }
}

# Performs Create if doesn't exist.
function Update-Frontend {
    [CmdletBinding()]
    Param(
        [string]$CustomDomainName
    )

    process {
        $CDNParameters = '{\"customDomainName\":{\"value\":\"' + $CustomDomainName.ToLower() + '\"}}'

        $CreateResponseJson = az deployment group create `
            --mode Complete `
            --resource-group $EarthFrontendResourceGroupName `
            --template-file ./frontend/cdn/main.bicep `
            --parameters $CDNParameters

        if (!$?) {
            Write-Error "CDN deployment failed."
            Exit 1
        }

        Write-Output $CreateResponseJson
        $CreateResponseJson | ConvertFrom-Json
        $CreateResponse = $CreateResponseJson | ConvertFrom-Json

        $CDNHostname = $CreateResponse.properties.outputs.frontDoorEndpointHostName.value
        $URLToTest = "https://$CDNHostname"

        Write-Information "CDN Hostname:    $CDNHostname"
        Write-Information "Custom Homename: ${CustomDomainName}"

        $Response = Invoke-WebRequest $URLToTest
        $ResponseContent = $Response.Content

        if (-Not ($ResponseContent.Contains("Welcome to Flexport Earth"))) {
            Write-Error "Did not receive expected response from $URLToTest, instead got: $ResponseContent"

            Exit 1
        }

        Write-Information "Received expected response from $URLToTest, test passed!"
        Write-Information ""
    }
}

Update-SubscriptionBudget
Update-FrontendResourceGroup
Update-Frontend -CustomDomainName $EarthWebsiteDomainName
