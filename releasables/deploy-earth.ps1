[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EnvironmentName,

    [Parameter(Mandatory=$false)]
    [String]
    $EarthWebsiteCustomDomainName
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./dependencies/dependency-manager.ps1

# Load common configuration values
. ./earth-config.ps1

Write-Information ""
Write-Information "Deploying to $EnvironmentName environment..."

# Performs Create if doesn't exist.
function Update-SubscriptionBudget {
    [CmdletBinding(SupportsShouldProcess)]
    Param()

    process {
        if($PSCmdlet.ShouldProcess($EarthFrontendResourceGroupLocation)) {
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
}

# Performs Create if doesn't exist.
function Update-FrontendResourceGroup {
    [CmdletBinding(SupportsShouldProcess)]
    Param()

    process {
        if($PSCmdlet.ShouldProcess($EarthFrontendResourceGroupName)) {
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
}

# Performs Create if doesn't exist.
function Update-Frontend {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory=$true)]
        [String]
        $EnvironmentName,

        [Parameter(Mandatory=$false)]
        [String]
        [string]$CustomDomainName
    )

    process {       
        if($PSCmdlet.ShouldProcess($CustomDomainName)) {
            $URLToTest = $null

            if (-Not ($CustomDomainName)) {
                # If no custom domain was specified to be used,
                # generate a fake one for the sake of configuring the CDN in a way 
                # that is consistent with production.

                # But fall back to using the CDNs domain name for actual testing.
                $CustomDomainName = "$EnvironmentName-flexport-earth.com"
            } else {
                $URLToTest = "https://$CustomDomainName"
            }

            $CDNParameters = '{\"customDomainName\":{\"value\":\"' + $CustomDomainName.ToLower() + '\"}}'

            $CreateResponseJson = az deployment group create `
                --mode Complete `
                --resource-group $EarthFrontendResourceGroupName `
                --template-file ./frontend/cdn/main.bicep `
                --parameters $CDNParameters

            if (!$?) {
                Write-Error "CDN deployment failed."
            }

            $CreateResponse = $CreateResponseJson | ConvertFrom-Json

            $CDNHostname = $CreateResponse.properties.outputs.frontDoorEndpointHostName.value

            if (-Not ($URLToTest)) {
                $URLToTest = "https://$CDNHostname"
            }

            Write-Information "CDN Hostname:    $CDNHostname"
            Write-Information "Custom Homename: ${CustomDomainName}"

            $Response = Invoke-WebRequest $URLToTest
            $ResponseContent = $Response.Content

            if (-Not ($ResponseContent.Contains("Welcome to Flexport Earth"))) {
                Write-Error "Did not receive expected response from $URLToTest, instead got: $ResponseContent"
            }

            Write-Information ""
            Write-Information "Received 200 response from $URLToTest, website is alive!"
            Write-Information ""

            Return $URLToTest
        }
    }
}

Update-SubscriptionBudget
Update-FrontendResourceGroup

$EarthWebsiteUrl = Update-Frontend `
    -EnvironmentName  $EnvironmentName `
    -CustomDomainName $EarthWebsiteCustomDomainName

./test-earth.ps1 `
    -EarthWebsiteUrl $EarthWebsiteUrl
