[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $BuildNumber,

    [Parameter(Mandatory = $false)]
    [String]
    $BuildId,

    [Parameter(Mandatory = $true)]
    [String]
    $EnvironmentName,

    [Parameter(Mandatory = $false)]
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
Write-Information "Deploying Earth build $BuildNumber (id: $BuildId) to $EnvironmentName environment..."

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
        [string]$CustomDomainName
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

            $CDNParameters = [PSCustomObject]@{
                customDomainName   = @{ value = $CustomDomainName.ToLower() }
                storageAccountName = @{ value = "${EnvironmentName}earthcdnstorage" }
            }

            $CDNParametersJson = $CDNParameters | ConvertTo-Json
            $CDNParametersJson = $CDNParametersJson.Replace('"', '\"')

            $CreateResponseJson = az deployment group create `
                --mode Complete `
                --resource-group $EarthFrontendResourceGroupName `
                --template-file ./frontend/cdn/main.bicep `
                --parameters $CDNParametersJson

            if (!$?) {
                Write-Error "CDN deployment failed."
            }

            $CreateResponse = $CreateResponseJson | ConvertFrom-Json
            $StorageAccountName = $CreateResponse.properties.outputs.storageAccountName.value

            # Enable storage to service static website content
            $Output = az storage blob service-properties update `
                --static-website `
                --account-name $StorageAccountName `
                --404-document error.html `
                --index-document index.html

            if (!$?) {
                $Output
                Write-Error "Enabling storage for serving static content failed."
            }

            $WebsiteContentLocalPath = './frontend/cdn/website-content'

            # Generate the build number file.
            $BuildNumberFilePath = "$WebsiteContentLocalPath/media/build-number.css"
            "#build-number-anchor::before { content: ""$BuildNumber""; }" | Out-File -FilePath $BuildNumberFilePath

            # Update BuildID if available.
            if ($BuildId) {
                $IndexPath = "$WebsiteContentLocalPath/index.html"
                $IndexContent = Get-Content -Path $IndexPath
                $IndexContent = $IndexContent.Replace('{BUILDID}', $BuildId)
                $IndexContent | Out-File -FilePath $IndexPath
            }

            # Upload website content to the CDN storage account
            $Output = az storage blob sync `
                --account-name $StorageAccountName `
                --source $WebsiteContentLocalPath `
                --container '$web' `
                --delete-destination true

            if (!$?) {
                $Output
                Write-Error "Website content upload failed."
            }

            $CDNHostname = $CreateResponse.properties.outputs.frontDoorEndpointHostName.value

            if (-Not ($URLToTest)) {
                $URLToTest = "https://$CDNHostname"
            }

            Write-Information "CDN Hostname:    $CDNHostname"
            Write-Information "Custom Homename: $CustomDomainName"
            Write-Information "URL to Test:     $URLToTest"

            # When the CDN infrastructure is first deployed, the content isn't immediately available
            # and so the first few initial requests will fail. Perform the livliness test in a loop
            # to give the CDN a chance to start up.
            $WebsiteIsAlive = $false

            for ($i = 0; $i -lt 20; $i++) {
                try {
                    $Response = Invoke-WebRequest $URLToTest
                    $StatusCode = $Response.StatusCode
                    $Content = $Response.Content
                    $ContentContainsPageNotFoundText = $Content.Contains("Page not found")

                    Write-Information "$i : Received HTTP Status Code: $StatusCode, ContentContainsPageNotFoundText: $ContentContainsPageNotFoundText"

                    if ($StatusCode -eq 200 -and $ContentContainsPageNotFoundText -eq $false) {
                        Write-Information ""
                        Write-Information "Received successful response from $URLToTest, website is alive!"
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
                Write-Error "$URLToTest failed to respond successfully after many attempts."
            }

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
    -BuildNumber $BuildNumber `
    -EarthWebsiteUrl $EarthWebsiteUrl
