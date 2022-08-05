[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $BuildNumber,

    [Parameter(Mandatory = $false)]
    [String]
    $BuildUrl,

    [Parameter(Mandatory = $true)]
    [String]
    $FlexportApiClientId,

    [Parameter(Mandatory = $true)]
    [String]
    $FlexportApiClientSecret
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

function Test-UnitAndComponentFunctionality {
    Write-Information ""
    Write-Information "Running unit tests..."

    npm test

    if (!$?) {
        Write-Error "Unit tests failed to run successfully, see previous log entries."
    }

    Write-Information "Unit tests ran successfully!"
    Write-Information ""
}

$ScriptStartTime = Get-Date

$ReleasablesDirectory = "releasables"
$WebsiteContentSourceDirectory = "website-content"

# Run dependency management
. "$ReleasablesDirectory/dependencies/dependency-manager.ps1"

# Validate all the PowerShell scripts
$Results = Invoke-ScriptAnalyzer -Path **

if ($Results) {
    $Results
    Write-Error "PowerShell lint issues detected, please fix and try again."
}

Write-Information ""
Write-Information "Building Earth Website (Build Number: $BuildNumber | Build URL: $BuildUrl)"
Write-Information ""

try {
    Push-Location $WebsiteContentSourceDirectory

    $BuildNumberFilePath = "./public/build-number.css"
    "#build-number-anchor::before { content: ""$BuildNumber""; }" | Out-File -FilePath $BuildNumberFilePath
    Write-Information "Build number written to $BuildNumberFilePath"

    # Update BuildUrl if available.
    if ($BuildUrl) {
        $IndexPath = "./pages/index.tsx"
        $IndexContent = Get-Content -Path $IndexPath
        $IndexContent = $IndexContent.Replace("javascript:alert('Build URL not specified.');", $BuildUrl)
        $IndexContent | Out-File -FilePath $IndexPath
        Write-Information "Build URL written to $IndexPath"
    }

    Write-Information ""
    Write-Information "Compiling website files..."
    npm install
    $env:FLEXPORT_API_CLIENT_ID = "$FlexportApiClientId"; $env:FLEXPORT_API_CLIENT_SECRET = "$FlexportApiClientSecret"; npm run build
    if (!$?) {
        Write-Error "Failed to build the website, see previous log entries."
    }
    Write-Information "Website files compiled successfully!"
    Write-Information ""

    Test-UnitAndComponentFunctionality

    $WebsiteContentOutputPath = "../$ReleasablesDirectory/frontend/content"
    New-Item $WebsiteContentOutputPath -ItemType Directory -Force
    $WebsiteContentZipOutputPath = "../$ReleasablesDirectory/frontend/content/website.zip"

    Write-Information "Compressing website content to $WebsiteContentZipOutputPath"
    zip -ru $WebsiteContentZipOutputPath ./ -x '.env'
    if (!$?) {
        Write-Error "Failed to compress the website, see previous log entries."
    }
    Write-Information "Compression complete!"
    Write-Information ""
}
finally {
    Pop-Location
}

Write-Information "Earth website build completed!"
Write-Information ""

$Duration = New-TimeSpan -Start $ScriptStartTime -End $(Get-Date)
Write-Information "Script completed in $Duration"
