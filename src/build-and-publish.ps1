[CmdletBinding()]
param (
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

    [Parameter(Mandatory = $false)]
    [String]
    $BuildUrl
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$ContainerRegistryLoginServer = ""

# Provision Docker Container Infrastructure
try {
    Push-Location "./releasables/shared-infrastructure/containers"

    $ContainerRegistryLoginServer = $(./deploy-container-infrastructure.ps1 `
        -EnvironmentName $PublishToEnvironment)
}
finally {
    Pop-Location
}

# Build
try {
    Write-Information "ContainerRegistryLoginServer: $ContainerRegistryLoginServer"

    ./build.ps1 `
        -BuildNumber                        $BuildNumber `
        -BuildUrl                           $BuildUrl `
        -FlexportApiClientID                $FlexportApiClientId `
        -FlexportApiClientSecret            $FlexportApiClientSecret `
        -Publish                            $true `
        -AzureContainerRegistryLoginServer  $ContainerRegistryLoginServer `
        -BuildEnvironmentName               $PublishToEnvironment
}
finally {
    Pop-Location
}
