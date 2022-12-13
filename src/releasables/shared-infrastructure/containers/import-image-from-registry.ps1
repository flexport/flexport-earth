[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [PSCustomObject]
    $FromContainerRegistry,

    [Parameter(Mandatory = $true)]
    [PSCustomObject]
    $ToContainerRegistry,

    [Parameter(Mandatory = $true)]
    [String]
    $ImageName,

    [Parameter(Mandatory = $true)]
    [String]
    $ImageTag
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

Write-Information ""
Write-Information "Checking to see if repository $($ToContainerRegistry.RegistryName)/$($ImageName) already exists..."

$repositories = $(
    az acr repository list `
        --name      $ToContainerRegistry.RegistryName `
        --output    tsv|tail -1
)

Write-Information "The following repositories were returned:"
Write-Information $($repositories | ConvertTo-Json)
Write-Information ""

$Import = $False

if ($repositories) {
    Write-Information ""
    Write-Information "Checking $($ToContainerRegistry.RegistryName)/$($ImageName) to see if image tag $ImageTag already exists..."
    Write-Information ""

    # First check if the image already exists in the destination...
    $tags = $(az acr repository show-tags `
        --name          $ToContainerRegistry.RegistryName `
        --repository    $ImageName `
        --output        tsv)

    Write-Information "The following tags exists:"
    Write-Information $($tags | ConvertTo-Json)

    if (-Not $tags.Contains($ImageTag)) {
        Write-Information "Tag does not exist in repository $($ToContainerRegistry.RegistryName)/$($ImageName)."

        $Import = $True
    } else {
        Write-Information "Image tag $ImageTag already exists in the target $($ToContainerRegistry.RegistryName)/$($ImageName) repository."
    }
} else {
    Write-Information ""
    Write-Information "Repository $($ToContainerRegistry.RegistryName)/$($ImageName) doesn't exist..."

    $Import = $True
}

if ($Import -eq $True) {
    $ImageAndTag = "$($ImageName):$ImageTag"

    Write-Information "Attempting to import $($FromContainerRegistry.RegistryServerAddress)/$ImageAndTag to $($ToContainerRegistry.RegistryServerAddress)..."

    az acr import `
        --name        $ToContainerRegistry.RegistryName `
        --source      "$($FromContainerRegistry.RegistryServerAddress)/$ImageAndTag" `
        --image       $ImageAndTag `
        --username    $FromContainerRegistry.RegistryServicePrincipalUsername `
        --password    $FromContainerRegistry.RegistryServicePrincipalPassword

    if (!$?) {
        Write-Error "Importing image $ImageAndTag from $($FromContainerRegistry.RegistryServerAddress) failed!"
    }

    Write-Information "Import complete."
}
