[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EnvironmentName,

    [Parameter(Mandatory=$true)]
    [String]
    $BuildNumber,

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

    [Parameter(Mandatory = $true)]
    [String]
    $LogAnalyticsWorkspaceId,

    [Parameter(Mandatory = $true)]
    [String]
    $EarthEnvironmentOperatorsEmailAddress
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

function Update-FrontendInfrastructure {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory = $true)]
        [String]
        $EnvironmentName,

        [Parameter(Mandatory = $true)]
        [String]
        $EarthFrontendResourceGroupName,

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
        $GoogleAnalyticsMeasurementId,

        [Parameter(Mandatory = $true)]
        [String]
        $LogAnalyticsWorkspaceId,

        [Parameter(Mandatory = $true)]
        [String]
        $EarthEnvironmentOperatorsEmailAddress
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

            $FrontendParameters = @{
                buildNumber                             = @{ value = $BuildNumber                           }
                environmentShortName                    = @{ value = $EnvironmentName.ToLower()             }
                customDomainName                        = @{ value = $CustomDomainName.ToLower()            }
                logAnalyticsWorkspaceId                 = @{ value = $LogAnalyticsWorkspaceId               }
                earthEnvironmentOperatorsEmailAddress   = @{ value = $EarthEnvironmentOperatorsEmailAddress }
            }

            $FrontendParametersJson = $FrontendParameters | ConvertTo-Json

            Write-Information "FrontendParametersJson:"
            Write-Information $FrontendParametersJson
            Write-Information ""

            # PowerShell v7.3.0 has a breaking change in how it handles
            # parsing double quotes in strings. Previous versions required
            # escaping the double quotes. Dev machines have been updated,
            # but the Azure DevOps machines haven't yet.

            $CurrentPowerShellVersion       = $($PSVersionTable.PSVersion)
            $CurrentPowerShellMajorVersion  = $CurrentPowerShellVersion.Major
            $CurrentPowerShellMinorVersion  = $CurrentPowerShellVersion.Minor

            if ($CurrentPowerShellMajorVersion -le 7 -and $CurrentPowerShellMinorVersion -lt 3) {
                $FrontendParametersJson = $FrontendParametersJson.Replace('"', '\"')
            }

            $CreateResponseJson = az deployment group create `
                --mode              Complete `
                --resource-group    $EarthFrontendResourceGroupName `
                --template-file     ./infrastructure/main.bicep `
                --parameters        $FrontendParametersJson

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
                --resource-group    $EarthFrontendResourceGroupName `
                --name              $WebsiteName `
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

            if (-Not ($URLToTest)) {
                $URLToTest = "https://$CDNHostname"
            }

            Write-Information ""
            Write-Information "=================================================================="
            Write-Information "CDN Hostname:    $CDNHostname"
            Write-Information "Custom Hostname: $CustomDomainName"
            Write-Information "URL to Test:     $URLToTest"
            Write-Information "=================================================================="
            Write-Information ""

            $FrontendInfraOutput = @{
                earthWebsiteBaseUrl             = $URLToTest
                azureWebsiteResourceName        = $WebsiteName
                azureCdnEndpointResourceName    = $EndpointResourceName
            }

            return $FrontendInfraOutput
        }
    }
}


function Update-FrontendWebsite {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory = $true)]
        [String]
        $BuildNumber,

        [Parameter(Mandatory = $true)]
        [String]
        $EarthFrontendResourceGroupName,

        [Parameter(Mandatory = $false)]
        [String]
        $AzureCdnEndpointResourceName,

        [Parameter(Mandatory = $true)]
        [String]
        $AzureWebsiteResourceName,

        [Parameter(Mandatory = $true)]
        [String]
        $EarthWebsiteBaseUrl
    )

    process {
        if ($PSCmdlet.ShouldProcess($EarthFrontendResourceGroupName)) {
            $Output = az webapp deployment source config-zip `
                --resource-group    $EarthFrontendResourceGroupName `
                --name              $AzureWebsiteResourceName `
                --src               ./content/website.zip

            if (!$?) {
                Write-Information   $Output
                Write-Information   ""
                Write-Error         "Website content deployment failed!"
            }

            Write-Information "Content deployed, purging CDN cache..."
            Write-Information ""

            $Output = az afd endpoint purge `
                --resource-group    $EarthFrontendResourceGroupName `
                --profile-name      'EarthFrontDoor' `
                --endpoint-name     $AzureCdnEndpointResourceName `
                --content-paths     '/*'

            if (!$?) {
                Write-Information   $Output
                Write-Information   ""
                Write-Error         "CDN cache purged failed!"
            }

            Write-Information "CDN cache purged!"
            Write-Information ""

            # When the CDN infrastructure is first deployed, the content isn't immediately available
            # and so the first few initial requests will fail. Perform the livliness test in a loop
            # to give the CDN a chance to start up.
            $WebsiteIsAlive = $false

            $BuildNumberUrl = "$EarthWebsiteBaseUrl/build-number.css"

            for ($i = 0; $i -lt 25; $i++) {
                try {
                    $Response               = Invoke-WebRequest $BuildNumberUrl
                    $StatusCode             = $Response.StatusCode
                    $Content                = $Response.Content
                    $ContainsBuildNumber    = $Content.Contains($BuildNumber)

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

                Start-Sleep -Seconds 10
            }

            if ($WebsiteIsAlive -eq $false) {
                Write-Error "$BuildNumberUrl failed to respond successfully after many attempts."
            }
        }
    }
}

Write-Information ""
Write-Information "Deploying Earth's frontend..."
Write-Information ""

. ./frontend-config.ps1

$FrontendConfig = Get-FrontendConfig -EnvironmentName $EnvironmentName

Write-Information "Creating resource group $($FrontendConfig.EarthFrontendResourceGroupName)..."

$ResourceGroupCreateResponse = az group create `
    --name      $FrontendConfig.EarthFrontendResourceGroupName `
    --location  $FrontendConfig.EarthFrontendResourceGroupLocation

if (!$?) {
    Write-Information   $ResourceGroupCreateResponse
    Write-Information   ""
    Write-Error         "Failed to create resource group $($FrontendConfig.EarthFrontendResourceGroupName)!"
}

Write-Information "Resource group created, deploying infrastructure to it..."

$FrontendInfraOutput = Update-FrontendInfrastructure `
    -EnvironmentName                        $EnvironmentName `
    -EarthFrontendResourceGroupName         $FrontendConfig.EarthFrontendResourceGroupName `
    -CustomDomainName                       $EarthWebsiteCustomDomainName `
    -FlexportApiClientId                    $FlexportApiClientId `
    -FlexportApiClientSecret                $FlexportApiClientSecret `
    -GoogleAnalyticsMeasurementId           $GoogleAnalyticsMeasurementId `
    -LogAnalyticsWorkspaceId                $LogAnalyticsWorkspaceId `
    -EarthEnvironmentOperatorsEmailAddress  $EarthEnvironmentOperatorsEmailAddress

Write-Information ""
Write-Information "Frontend infrastructure deployed, deploying NextJS website..."
Write-Information ""

Update-FrontendWebsite `
    -BuildNumber                    $BuildNumber `
    -EarthFrontendResourceGroupName $FrontendConfig.EarthFrontendResourceGroupName `
    -AzureCdnEndpointResourceName   $FrontendInfraOutput.AzureCdnEndpointResourceName `
    -AzureWebsiteResourceName       $FrontendInfraOutput.AzureWebsiteResourceName `
    -EarthWebsiteBaseUrl            $FrontendInfraOutput.EarthWebsiteBaseUrl

Write-Information ""
Write-Information "Deployment of Earth's frontend completed!"
Write-Information ""

return $FrontendInfraOutput.EarthWebsiteBaseUrl
