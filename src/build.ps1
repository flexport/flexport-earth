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
    $FlexportApiClientSecret,

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

function Write-BuildNumber {
    $BuildNumberFilePath = "./public/build-number.css"

    "#build-number-anchor::before { content: ""$BuildNumber""; }" | Out-File -FilePath $BuildNumberFilePath

    Write-Information "Build number written to $BuildNumberFilePath"
}
function Write-BuildUrl {
    $FilePath = "./components/footer/footer.tsx"

    $IndexContentOriginal = Get-Content -Path $FilePath -Raw
    $IndexContentUpdated  = $IndexContentOriginal.Replace(
        "javascript:alert('Build URL not specified.');",
        $BuildUrl
    )

    if ($IndexContentUpdated.Contains($BuildUrl) -eq $false) {
        Write-Error "The content was not updated with the BuildUrl as expected."
    }

    $IndexContentUpdated | Out-File -FilePath $FilePath

    Write-Information "Build URL written to $FilePath"
}
function Build-Website {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $FlexportApiClientId,

        [Parameter(Mandatory = $true)]
        [String]
        $FlexportApiClientSecret
    )

    Write-Information ""
    Write-Information "Compiling website files..."

    npm install
    if (!$?) {
        Write-Error "Failed to install dependencies, see previous log entries."
    }

    $env:FLEXPORT_API_CLIENT_ID = "$FlexportApiClientId"; $env:FLEXPORT_API_CLIENT_SECRET = "$FlexportApiClientSecret"; npm run build
    if (!$?) {
        Write-Error "Failed to build the website, see previous log entries."
    }

    Write-Information "Website files compiled successfully!"
    Write-Information ""
}
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

function Compress-Website {
    $WebsiteContentOutputPath    = "../$ReleasablesDirectory/frontend/content"
    $WebsiteContentZipOutputPath = "$WebsiteContentOutputPath/website.zip"

    New-Item $WebsiteContentOutputPath `
        -ItemType Directory `
        -Force | Out-Null

    Write-Information "Compressing website content to $WebsiteContentZipOutputPath"
    Write-Information ""

    zip -ru $WebsiteContentZipOutputPath ./ -x '.env'

    if (!$?) {
        Write-Error "Failed to compress the website, see previous log entries."
    }

    Write-Information "Compression complete!"
    Write-Information ""
}

function Invoke-BuildWorkflow {
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
        $FlexportApiClientSecret,

        [Parameter(Mandatory = $false)]
        [Boolean]
        $Publish = $false,

        [Parameter(Mandatory = $false)]
        [String]
        $AzureContainerRegistryLoginServer
    )

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

        Write-BuildNumber

        # Update BuildUrl if available from CI system.
        # Will not be available when running this script locally.
        if ($BuildUrl) {
            Write-BuildUrl
        }

        Build-Website `
            -FlexportApiClientId            $FlexportApiClientId `
            -FlexportApiClientSecret        $FlexportApiClientSecret

        Test-UnitAndComponentFunctionality

        Compress-Website
    }
    finally {
        Pop-Location
    }

    try {
        Push-Location "$ReleasablesDirectory/testing/e2e"

        ./build-e2e-tests.ps1 `
            -BuildNumber                        $BuildNumber `
            -Publish                            $Publish `
            -AzureContainerRegistryLoginServer  $AzureContainerRegistryLoginServer
    }
    finally {
        Pop-Location
    }
}

$ScriptStartTime                = Get-Date
$ReleasablesDirectory           = "releasables"
$WebsiteContentSourceDirectory  = "website-content"

# Run dependency management
. "$ReleasablesDirectory/dependencies/dependency-manager.ps1"

Invoke-BuildWorkflow `
    -BuildNumber                        $BuildNumber `
    -BuildUrl                           $BuildUrl `
    -FlexportApiClientId                $FlexportApiClientId `
    -FlexportApiClientSecret            $FlexportApiClientSecret `
    -Publish                            $Publish `
    -AzureContainerRegistryLoginServer  $AzureContainerRegistryLoginServer

Write-Information "Earth website build completed!"
Write-Information ""

$Duration = New-TimeSpan -Start $ScriptStartTime -End $(Get-Date)
Write-Information "Script completed in $Duration"
