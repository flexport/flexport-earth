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
    $AzureContainerRegistryLoginServer
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

. ./e2e-tests-config.ps1

$E2ETestConfig = Get-E2ETestConfig -BuildNumber $BuildNumber

$E2ETestsContainerImageNameAndTag = "$($E2ETestConfig.E2ETestsContainerImageName):$BuildNumber"

Write-Information "Building Docker image $E2ETestsContainerImageNameAndTag"

$BuildPath = "."

docker build `
    --build-arg BUILD_NUMBER=$BuildNumber `
    $BuildPath `
    --tag $E2ETestsContainerImageNameAndTag

if (!$?) {
    Write-Error "Docker build failed!"
}

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
