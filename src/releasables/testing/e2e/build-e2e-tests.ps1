[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $BuildNumber,

    [Parameter(Mandatory = $false)]
    [Boolean]
    $Publish = $false,

    [Parameter(Mandatory = $false)]
    [String]
    $AzureContainerRegistryLoginServer,

    [Parameter(Mandatory = $false)]
    [String]
    $BuildEnvironmentName
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

. ./monitor/e2e-monitor-config.ps1

Write-Information "BuildEnvironmentName: $BuildEnvironmentName"

. ./e2e-monitor-config.ps1

$E2EMonitorConfig = Get-E2EMonitorConfig `
    -EnvironmentName    $BuildEnvironmentName `
    -BuildNumber        $BuildNumber

$E2EMonitorContainerImageName = $E2EMonitorConfig.E2EMonitorContainerImageName

Write-Information "Building Docker image $E2EMonitorContainerImageName"

docker build `
    --build-arg BUILD_NUMBER=$BuildNumber `
    . `
    --tag $E2EMonitorContainerImageName

if ($Publish) {
    Write-Information "Publishing to $AzureContainerRegistryLoginServer"

    $RemoteImageName = "$AzureContainerRegistryLoginServer/$E2EMonitorContainerImageName"

    docker tag $E2EMonitorContainerImageName $RemoteImageName

    az acr login --name $AzureContainerRegistryLoginServer

    docker push $RemoteImageName

    if (!$?) {
        Write-Error "Docker push failed!"
    }
}
