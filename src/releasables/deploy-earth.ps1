[CmdletBinding()]
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
    $GoogleAnalyticsMeasurementId
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$ScriptStartTime = Get-Date

# Run dependency management
. ./dependencies/dependency-manager.ps1

# Load common configuration values
. ./earth-runtime-config.ps1

Write-Information ""
Write-Information "Deploying Earth build $BuildNumber to $EnvironmentName environment..."

# Performs Create if doesn't exist.
function Update-SubscriptionBudget {
    [CmdletBinding(SupportsShouldProcess)]
    Param()

    process {
        if ($PSCmdlet.ShouldProcess($EarthFrontendResourceGroupLocation)) {
            $StartDate = (Get-Date).ToString("yyyy-MM-01")
            $EndDate = (Get-Date).AddYears(2).ToString("yyyy-MM-dd")

            $Parameters = [PSCustomObject]@{
                budgetName = @{ value = "$EnvironmentName-subscription-budget" }
                startDate  = @{ value = "$StartDate" }
                endDate    = @{ value = "$EndDate" }
            }

            $ParametersJson = $Parameters | ConvertTo-Json
            $ParametersJson = $ParametersJson.Replace('"', '\"')

            az `
                deployment sub create `
                --location $EarthFrontendResourceGroupLocation `
                --template-file azure-subscription/subscription-budget.bicep `
                --parameters @azure-subscription/subscription-budget.parameters.json `
                --parameters $ParametersJson

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
        if ($PSCmdlet.ShouldProcess($EarthFrontendResourceGroupName)) {
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
        [Parameter(Mandatory = $true)]
        [String]
        $EnvironmentName,

        [Parameter(Mandatory = $false)]
        [String]
        $CustomDomainName,

        [Parameter(Mandatory = $true)]
        [String]
        $FlexportApiClientId,

        [Parameter(Mandatory = $true)]
        [String]
        $FlexportApiClientSecret,

        [Parameter(Mandatory = $true)]
        [String]
        $GoogleAnalyticsMeasurementId
    )

    process {
        if ($PSCmdlet.ShouldProcess($CustomDomainName)) {
            $URLToTest = $null

            if (-Not ($CustomDomainName)) {
                # If no custom domain was specified to be used,
                # generate a fake one for the sake of configuring the CDN in a way
                # that is consistent with production.

                # But fall back to using the CDNs domain name for actual testing.
                $CustomDomainName = "$EnvironmentName-flexport-earth.com"
            }
            else {
                $URLToTest = "https://www.$CustomDomainName"
            }

            $FrontendParameters = [PSCustomObject]@{
                environmentShortName = @{ value = $EnvironmentName.ToLower() }
                customDomainName     = @{ value = $CustomDomainName.ToLower() }
            }

            $FrontendParametersJson = $FrontendParameters | ConvertTo-Json
            $FrontendParametersJson = $FrontendParametersJson.Replace('"', '\"')

            $CreateResponseJson = az deployment group create `
                --mode Complete `
                --resource-group $EarthFrontendResourceGroupName `
                --template-file ./frontend/infrastructure/main.bicep `
                --parameters $FrontendParametersJson

            if (!$?) {
                Write-Error "Frontend infra deployment failed."
            }

            $CreateResponse = $CreateResponseJson | ConvertFrom-Json

            $CDNHostname            = $CreateResponse.properties.outputs.frontDoorEndpointHostName.value
            $EndpointResourceName   = $CreateResponse.properties.outputs.frontDoorEndpointName.value
            $WebsiteName            = $CreateResponse.properties.outputs.websiteName.value

            Write-Information ""
            Write-Information "Confguring website..."
            $Output = az webapp config appsettings set `
                --resource-group $EarthFrontendResourceGroupName `
                --name $WebsiteName `
                --settings `
                    "WEBSITE_RUN_FROM_PACKAGE=1" `
                    "FLEXPORT_API_CLIENT_ID=$FlexportApiClientId" `
                    "FLEXPORT_API_CLIENT_SECRET=$FlexportApiClientSecret" `
                    "NEXT_PUBLIC_GOOGLE_ANALYTICS_MEASUREMENT_ID=$GoogleAnalyticsMeasurementId"
            if (!$?) {
                Write-Information $Output
                Write-Information ""
                Write-Error "Configuring website failed."
            }
            Write-Information "Website configured!"
            Write-Information ""

            Write-Information "Deploying website content..."
            $Output = az webapp deployment source config-zip `
                --resource-group $EarthFrontendResourceGroupName `
                --name $WebsiteName `
                --src ./frontend/content/website.zip
            if (!$?) {
                Write-Information $Output
                Write-Information ""
                Write-Error "Frontend infra deployment failed."
            }
            Write-Information "Content deployed!"
            Write-Information ""

            if (-Not ($URLToTest)) {
                $URLToTest = "https://$CDNHostname"
            }

            Write-Information "Purging CDN cache!"
            $Output = az afd endpoint purge `
                --resource-group $EarthFrontendResourceGroupName `
                --profile-name 'EarthFrontDoor' `
                --endpoint-name $EndpointResourceName `
                --content-paths '/*'
            if (!$?) {
                Write-Information $Output
                Write-Information ""
                Write-Error "CDN cache purged failed."
            }
            Write-Information "CDN cache purged!"
            Write-Information ""

            Write-Information ""
            Write-Information "=================================================================="
            Write-Information "CDN Hostname:    $CDNHostname"
            Write-Information "Custom Hostname: $CustomDomainName"
            Write-Information "URL to Test:     $URLToTest"
            Write-Information "=================================================================="
            Write-Information ""

            # When the CDN infrastructure is first deployed, the content isn't immediately available
            # and so the first few initial requests will fail. Perform the livliness test in a loop
            # to give the CDN a chance to start up.
            $WebsiteIsAlive = $false

            $BuildNumberUrl = "$URLToTest/build-number.css"

            for ($i = 0; $i -lt 25; $i++) {
                try {
                    $Response            = Invoke-WebRequest $BuildNumberUrl
                    $StatusCode          = $Response.StatusCode
                    $Content             = $Response.Content
                    $ContainsBuildNumber = $Content.Contains($BuildNumber)

                    Write-Information "$i : Received HTTP Status Code: $StatusCode, ContainsBuildNumber: $ContainsBuildNumber"

                    if ($StatusCode -eq 200 -and $ContainsBuildNumber -eq $true) {
                        Write-Information ""
                        Write-Information "Received successful response from $BuildNumberUrl, build $BuildNumber is live!"
                        Write-Information ""
                        Write-Information "Response Content:"
                        Write-Information $Content

                        $WebsiteIsAlive = $true
                        break
                    }
                }
                catch {
                    Write-Information "Invoke-WebRequest failed:"
                    Write-Information $_
                }

                Start-Sleep -Seconds 5
            }

            if ($WebsiteIsAlive -eq $false) {
                Write-Error "$BuildNumberUrl failed to respond successfully after many attempts."
            }

            Return $URLToTest
        }
    }
}

#Update-SubscriptionBudget
Update-FrontendResourceGroup

$EarthWebsiteUrl = Update-Frontend `
    -EnvironmentName                $EnvironmentName `
    -CustomDomainName               $EarthWebsiteCustomDomainName `
    -FlexportApiClientId            $FlexportApiClientId `
    -FlexportApiClientSecret        $FlexportApiClientSecret `
    -GoogleAnalyticsMeasurementId   $GoogleAnalyticsMeasurementId

# Run E2E tests, with multiple retries as sometimes
# they fail with transient errors instead of real issues.

# The retries avoid doing full deployments and also avoid
# blocking CD pipeline waiting for someone to manually retry.
./test-earth.ps1 `
    -BuildNumber        $BuildNumber `
    -EarthWebsiteUrl    $EarthWebsiteUrl `
    -MaxTries           3

$Duration = New-TimeSpan -Start $ScriptStartTime -End $(Get-Date)
Write-Information "Script completed in $Duration"
