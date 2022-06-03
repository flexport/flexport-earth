Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./releasables/dependencies/dependency-manager.ps1

$RunningNonInteractive = [Environment]::GetCommandLineArgs().Contains('-NonInteractive')

if -Not ($RunningNonInteractive) {
    . ./development-tools/local-config-manager.ps1
}

# Install required tools
./development-tools/install-development-tools.ps1

$Results = Invoke-ScriptAnalyzer -Path **

if ($Results) {
    $Results
    Write-Error "PowerShell lint issues detected, please fix and try again."
}

try {
    Push-Location $ReleasablesPath

    # Generate a random build number for local builds.
    $BuildNumber = [guid]::NewGuid()

    ./build-earth.ps1 `
        -BuildNumber $BuildNumber
}
finally {
    Pop-Location
}
