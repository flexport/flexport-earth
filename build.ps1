[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [String]
    $BuildNumber = [guid]::NewGuid(),

    [Parameter(Mandatory = $false)]
    [String]
    $BuildId
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./releasables/dependencies/dependency-manager.ps1

# Load global development settings
$GlobalDevelopmentSettings = Get-Content 'development-config.json' | ConvertFrom-Json

$DevelopmentToolsDirectory      = $GlobalDevelopmentSettings.DevelopmentToolsDirectory
$ReleasablesDirectory           = $GlobalDevelopmentSettings.ReleasablesDirectory
$WebsiteContentSourceDirectory  = $GlobalDevelopmentSettings.WebsiteContentSourceDirectory

# Install required tools
$("$DevelopmentToolsDirectory/install-development-tools.ps1")

# Validate all the PowerShell scripts
$Results = Invoke-ScriptAnalyzer -Path **

if ($Results) {
    $Results
    Write-Error "PowerShell lint issues detected, please fix and try again."
}

Write-Information ""
Write-Information "Building Earth Website (Build Number: $BuildNumber | Build ID: $BuildId)"
Write-Information ""

try {
    Push-Location $WebsiteContentSourceDirectory

    $BuildNumberFilePath = "./styles/build-number.css"
    "#build-number-anchor::before { content: ""$BuildNumber""; }" | Out-File -FilePath $BuildNumberFilePath
    Write-Information "Build number written to $BuildNumberFilePath"

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

    $WebsiteContentOutputPath = "../$ReleasablesDirectory/frontend/content"
    New-Item $WebsiteContentOutputPath -ItemType Directory -Force
    $WebsiteContentZipOutputPath = "../$ReleasablesDirectory/frontend/content/website.zip"

    Write-Information "Compressing website content to $WebsiteContentZipOutputPath"
    zip -ru $WebsiteContentZipOutputPath ./
    if (!$?) {
        Write-Error "Failed to compress the website, see previous log entries."
    }
    Write-Information "Compression complete!"
    Write-Information ""
}
finally {
    Pop-Location
}

try {
    Push-Location "$ReleasablesDirectory/testing/functional"
    npm install cypress --save-dev
}
finally {
    Pop-Location 
}

Write-Information "Earth website build completed!"
Write-Information ""
