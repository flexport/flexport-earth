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

. ./e2e-tests-config.ps1

Write-Information "BuildEnvironmentName: $BuildEnvironmentName"

$E2ETestsContainerImageNameAndTag = "$($E2ETestConfig.E2ETestsContainerImageName):$BuildNumber"

Write-Information "Building Docker image $E2ETestsContainerImageNameAndTag"

docker build `
    --build-arg BUILD_NUMBER=$BuildNumber `
    . `
    --tag $E2ETestsContainerImageNameAndTag

if ($Publish) {
    Write-Information "Publishing to $AzureContainerRegistryLoginServer"

    $RemoteImageName = "$AzureContainerRegistryLoginServer/$E2ETestsContainerImageNameAndTag"

    docker tag $E2ETestsContainerImageNameAndTag $RemoteImageName

    az acr login --name $AzureContainerRegistryLoginServer

    docker push $RemoteImageName

    if (!$?) {
        Write-Error "Docker push failed!"
    }
}
