[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $EnvironmentName
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

function Update-SubscriptionBudget {
    [CmdletBinding(SupportsShouldProcess)]
    Param()

    process {
        if ($PSCmdlet.ShouldProcess($EarthFrontendResourceGroupLocation)) {
            $StartDate  = (Get-Date).ToString("yyyy-MM-01")
            $EndDate    = (Get-Date).AddYears(2).ToString("yyyy-MM-dd")

            $Parameters = @{
                budgetName = @{ value = "$EnvironmentName-subscription-budget" }
                startDate  = @{ value = "$StartDate" }
                endDate    = @{ value = "$EndDate" }
            }

            $ParametersJson = $Parameters | ConvertTo-Json

            # PowerShell v7.3.0 has a breaking change in how it handles
            # parsing double quotes in strings. Previous versions required
            # escaping the double quotes. Dev machines have been updated,
            # but the Azure DevOps machines haven't yet.

            $CurrentPowerShellVersion       = $($PSVersionTable.PSVersion)
            $CurrentPowerShellMajorVersion  = $CurrentPowerShellVersion.Major
            $CurrentPowerShellMinorVersion  = $CurrentPowerShellVersion.Minor

            if ($CurrentPowerShellMajorVersion -le 7 -and $CurrentPowerShellMinorVersion -lt 3) {
                $ParametersJson = $ParametersJson.Replace('"', '\"')
            }

            az deployment sub create `
                --location      $EarthFrontendResourceGroupLocation `
                --template-file azure-subscription/subscription-budget.bicep `
                --parameters    @azure-subscription/subscription-budget.parameters.json `
                --parameters    $ParametersJson

            if (!$?) {
                Write-Error "Budget deployment failed."
            }
        }
    }
}