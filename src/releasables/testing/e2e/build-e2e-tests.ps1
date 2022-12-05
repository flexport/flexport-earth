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

$ImageName = "earth-e2e-tests:$BuildNumber"

Write-Information "Building Docker image $ImageName"
docker build --build-arg BUILD_NUMBER=$BuildNumber . -t $ImageName

if ($Publish) {
    Write-Information "Publishing to $AzureContainerRegistryLoginServer"
    $RemoteImageName = "$AzureContainerRegistryLoginServer/$ImageName"

    docker tag $ImageName $RemoteImageName

    az acr login --name $AzureContainerRegistryLoginServer

    docker push $RemoteImageName
}