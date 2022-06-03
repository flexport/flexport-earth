[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $BuildNumber,

    [Parameter(Mandatory = $false)]
    [String]
    $BuildId
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./dependencies/dependency-manager.ps1

Write-Information ""
Write-Information "Building Earth Website (Build Number: $BuildNumber | Build ID: $BuildId)"
Write-Information ""

Push-Location ./frontend/website-content/

$BuildNumberFilePath = "./styles/build-number.css"
"#build-number-anchor::before { content: ""$BuildNumber""; }" | Out-File -FilePath $BuildNumberFilePath
Write-Information "Build Number written to $BuildNumberFilePath"

# Update BuildID if available.
if ($BuildId) {
    $IndexPath = "./pages/index.tsx"
    $IndexContent = Get-Content -Path $IndexPath
    $IndexContent = $IndexContent.Replace('{BUILDID}', $BuildId)
    $IndexContent | Out-File -FilePath $IndexPath
    Write-Information "Build ID written to $IndexPath"
}

Write-Information ""
Write-Information "Compiling website files..."
npm install
npm run build
Write-Information "Website files compiled successfully!"
Write-Information ""

Write-Information "Compressing website content..."
zip -ru website.zip ./ -x "website.zip"
Write-Information "Compression complete!"
Write-Information ""

Write-Information "Earth website build completed!"
Write-Information ""

Pop-Location