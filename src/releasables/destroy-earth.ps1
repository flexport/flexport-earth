[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EnvironmentName
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./dependencies/dependency-manager.ps1

if($PSCmdlet.ShouldProcess($EnvironmentName)) {
    Write-Information ""
    Write-Information "Destroying $EnvironmentName environment..."
    Write-Information ""

    $EarthResourceGroupsPattern = "$EnvironmentName-earth-"

    Write-Information "Deleting all resource groups that start with '$EarthResourceGroupsPattern'..."
    Write-Information ""

    $ResourceGroupsJson = az group list --query "[?starts_with(name, '$EarthResourceGroupsPattern')]"
    $ResourceGroups     = $ResourceGroupsJson | ConvertFrom-Json

    foreach ($ResourceGroup in $ResourceGroups) {
        $ResourceGroupName = $ResourceGroup.name

        Write-Information "Deleting resource group $ResourceGroupName..."

        az group delete `
            --name $ResourceGroupName `
            --no-wait `
            --yes

        Write-Information "Deleted!"
    }

    Write-Information ""
    Write-Information "All Earth resources have been deleted."
}