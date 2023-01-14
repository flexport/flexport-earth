[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [String]
    $CIBuildUrl,

    [Parameter(Mandatory = $true)]
    [String]
    $BuildNumber,

    [Parameter(Mandatory = $true)]
    [String]
    $FlexportApiClientId,

    [Parameter(Mandatory = $true)]
    [String]
    $FlexportApiClientSecret,

    [Parameter(Mandatory = $true)]
    [String]
    $PublishToEnvironment,

    [Parameter(Mandatory=$true)]
    [String]
    $AzureServicePrincipalTenant,

    [Parameter(Mandatory=$true)]
    [String]
    $AzureServicePrincipalAppId,

    [Parameter(Mandatory=$true)]
    [SecureString]
    $AzureServicePrincipalPassword
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

Write-Information "Starting Build & Publish of Earth..."
Write-Information ""
Write-Information "First, ensuring Docker Container infrastructure is prepared to receive build output..."

# Sign in to Azure as the Deployer Service Principal so that
# we can interact with build infrastructure such as the Azure Container Service
# for publishing Docker images that are built.

./azure/sign-in-as-service-principal.ps1 `
    -ServicePrincipalTenant      $AzureServicePrincipalTenant `
    -ServicePrincipalAppId       $AzureServicePrincipalAppId `
    -ServicePrincipalPassword    $AzureServicePrincipalPassword

$ContainerRegistryLoginServer = ""

try {
    Push-Location "./releasables/shared-infrastructure/containers"

    $ContainerRegistryLoginServer = ./deploy-container-infrastructure.ps1 -EnvironmentName $PublishToEnvironment
}
finally {
    Pop-Location
}

Write-Information ""
Write-Information "Container infrastructure is operational, commencing build..."
Write-Information ""

try {
    ./build.ps1 `
        -BuildNumber                        $BuildNumber `
        -CIBuildUrl                         $CIBuildUrl `
        -FlexportApiClientID                $FlexportApiClientId `
        -FlexportApiClientSecret            $FlexportApiClientSecret `
        -Publish                            $true `
        -AzureContainerRegistryLoginServer  $ContainerRegistryLoginServer
}
finally {
    Pop-Location
}

Write-Information "Earth build $BuildNumber completed and published!"
