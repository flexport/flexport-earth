[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $SourceRegistryServerAddress,

    [Parameter(Mandatory = $true)]
    [String]
    $SourceRegistryImageName,

    [Parameter(Mandatory = $true)]
    [String]
    $SourceRegistryImageReleaseTag,

    [Parameter(Mandatory = $true)]
    [String]
    $SourceRegistryServicePrincipalUsername,

    [Parameter(Mandatory = $true)]
    [String]
    $SourceRegistryServicePrincipalPwd,

    [Parameter(Mandatory = $true)]
    [String]
    $DestinationRegistryName,

    [Parameter(Mandatory = $true)]
    [String]
    $DestinationRepositoryName
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

Write-Information ""
Write-Information "Checking to see if repository $DestinationRepositoryName already exists..."

$repositories = $(az acr repository list --name $DestinationRegistryName --output tsv|tail -1)

Write-Information "The following repositories were returned:"
Write-Information $($repositories | ConvertTo-Json)
Write-Information ""

$Import = $False

if ($repositories) {
    Write-Information ""
    Write-Information "Checking $DestinationRegistryName to see if image tag $SourceRegistryImageReleaseTag already exists..."
    Write-Information ""

    # First check if the image already exists in the destination...
    $tags = $(az acr repository show-tags `
        --name          $DestinationRegistryName `
        --repository    $DestinationRepositoryName `
        --output        tsv)

    Write-Information "The following tags exists:"
    Write-Information $($tags | ConvertTo-Json)

    if (-Not $tags.Contains($SourceRegistryImageReleaseTag)) {
        Write-Information "Image does not exist in $DestinationRegistryName."

        $Import = $True
    } else {
        Write-Information "Image tag $SourceRegistryImageReleaseTag already exists in the target $DestinationRegistryName registry."
    }
} else {
    Write-Information ""
    Write-Information "Repository $DestinationRepositoryName doesn't exist..."

    $Import = $True
}

if ($Import -eq $True) {
    $ImageAndTag = "$($SourceRegistryImageName):$SourceRegistryImageReleaseTag"

    Write-Information "Attempting to import $SourceRegistryServerAddress/$ImageAndTag to $DestinationRegistryName..."

    az acr import `
        --name        $DestinationRegistryName `
        --source      "$SourceRegistryServerAddress/$ImageAndTag" `
        --image       $ImageAndTag `
        --username    $SourceRegistryServicePrincipalUsername `
        --password    $SourceRegistryServicePrincipalPwd

    if (!$?) {
        Write-Error "Importing image $SourceRegistryImageName from $SourceRegistryServerAddress failed!"
    }

    Write-Information "Import complete."
}
