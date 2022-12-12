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
    $GoogleAnalyticsMeasurementId,

    [Parameter(Mandatory = $true)]
    [String]
    $ContainerSourceRegistryServerAddress,

    [Parameter(Mandatory = $true)]
    [String]
    $ContainerSourceRegistryServicePrincipalUsername,

    [Parameter(Mandatory = $true)]
    [String]
    $ContainerSourceRegistryServicePrincipalPwd,

    [Parameter(Mandatory = $true)]
    [String]
    $ContainerTargetRegistryUsername,

    [Parameter(Mandatory = $true)]
    [String]
    $ContainerTargetRegistryPwd
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$ScriptStartTime = Get-Date

# Run dependency management
. ./dependencies/dependency-manager.ps1

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

            # PowerShell v7.3.0 has a breaking change in how it handles
            # parsing double quotes in strings. Previous versions required
            # escaping the double quotes. Dev machines have been updated,
            # but the Azure DevOps machines haven't yet.

            $CurrentPowerShellVersion = $($PSVersionTable.PSVersion)
            $CurrentPowerShellMajorVersion = $CurrentPowerShellVersion.Major
            $CurrentPowerShellMinorVersion = $CurrentPowerShellVersion.Minor

            if ($CurrentPowerShellMajorVersion -le 7 -and $CurrentPowerShellMinorVersion -lt 3) {
                $ParametersJson = $ParametersJson.Replace('"', '\"')
            }

            az `
                deployment sub create `
                --location $EarthFrontendResourceGroupLocation `
                --template-file azure-subscription/subscription-budget.bicep `
                --parameters @azure-subscription/subscription-budget.parameters.json `
                --parameters $ParametersJson

            if (!$?) {
                Write-Error "Budget deployment failed."
            }
        }
    }
}

Write-Information ""
Write-Information "Deploying Earth build $BuildNumber to $EnvironmentName environment..."
Write-Information ""

#Update-SubscriptionBudget

try {
    Push-Location "./shared-infrastructure/containers"

    ./deploy-container-infrastructure.ps1 -EnvironmentName $EnvironmentName
}
finally {
    Pop-Location
}

$EarthWebsiteUrl = ""

try {
    Push-Location "./frontend"

    $EarthWebsiteUrl = ./deploy-frontend-infrastructure.ps1 `
        -EnvironmentName                $EnvironmentName `
        -BuildNumber                    $BuildNumber `
        -EarthWebsiteCustomDomainName   $EarthWebsiteCustomDomainName `
        -FlexportApiClientId            $FlexportApiClientId `
        -FlexportApiClientSecret        $FlexportApiClientSecret `
        -GoogleAnalyticsMeasurementId   $GoogleAnalyticsMeasurementId
}
finally {
    Pop-Location
}

# Run E2E tests, with multiple retries as sometimes
# they fail with transient errors instead of real issues.
# The retries avoid doing full deployments and also avoid
# blocking CD pipeline waiting for someone to manually retry.
# ./test-earth.ps1 `
#     -BuildNumber        $BuildNumber `
#     -EarthWebsiteUrl    $EarthWebsiteUrl `
#     -MaxTries           3

# Once we've confirmed the latest application and tests are working successfully,
# deploy the E2E Monitor for continuously running the tests against the environment
# to catch any issues that occur between deployments.

. ./shared-infrastructure/containers/container-infra-config.ps1

$ContainerInfraConfig = Get-ContainerInfraConfig -EnvironmentName $EnvironmentName

try {
    Push-Location "./testing/e2e/monitor"

    ./deploy-e2e-monitor.ps1 `
        -EnvironmentName                                    $EnvironmentName `
        -BuildNumber                                        $BuildNumber `
        -EarthWebsiteBaseUrl                                $EarthWebsiteUrl `
        -ContainerSourceRegistryServerAddress               $ContainerSourceRegistryServerAddress `
        -ContainerSourceRegistryServicePrincipalUsername    $ContainerSourceRegistryServicePrincipalUsername `
        -ContainerSourceRegistryServicePrincipalPwd         $ContainerSourceRegistryServicePrincipalPwd `
        -ContainerTargetRegistryName                        $ContainerInfraConfig.ContainerRegistryName `
        -ContainerTargetRegistryUsername                    $ContainerTargetRegistryUsername `
        -ContainerTargetRegistryPwd                         $ContainerTargetRegistryPwd
}
finally {
    Pop-Location
}

$Duration = New-TimeSpan `
    -Start $ScriptStartTime `
    -End   $(Get-Date)

Write-Information "Earth deployment completed in $Duration"
