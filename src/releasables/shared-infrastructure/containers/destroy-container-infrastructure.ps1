[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EnvironmentName
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

. ./container-infra-config.ps1

if($PSCmdlet.ShouldProcess($EnvironmentName)) {
    # Load common configuration values

    $Config             = Get-ContainerInfraConfig -EnvironmentName $EnvironmentName
    $ResourceGroupName  = $Config.ContainerInfraResourceGroupName

    $Exists = az group exists --resource-group $ResourceGroupName

    if($Exists -eq "true") {
        Write-Information ""
        Write-Information "Destroying Container infra in the $EnvironmentName environment..."

        az group delete `
            --name $ResourceGroupName `
            --yes

        if (!$?) {
            Write-Error "Deletion of resource group $ResourceGroupName failed!"
        }

        Write-Information "Container infra destroyed!"
    }  else {
        Write-Information "Resource group $ResourceGroupName doesn't exist, moving on..."
    }
}
