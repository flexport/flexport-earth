# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateSet('Build','Deploy','Destroy')]
    [String]
    $Workflow
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

enum DevWorkflows {
    build
    deploy
    destroy
}

function Invoke-Workflow {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [DevWorkflows]
        $Workflow
    )

    # Load some configuration values...
    $GlobalDevelopmentSettings = Get-Content 'development-config.json' | ConvertFrom-Json

    $DevelopmentToolsDirectory = $GlobalDevelopmentSettings.DevelopmentToolsDirectory
    . "$DevelopmentToolsDirectory/local-config-manager.ps1"
    $DeveloperEnvironmentSettings = Get-EnvironmentSettingsObject

    switch ($Workflow) {
        build
        {
            Invoke-Build `
                -GlobalDevelopmentSettings      $GlobalDevelopmentSettings `
                -DeveloperEnvironmentSettings   $DeveloperEnvironmentSettings
        }
        default { throw "The specified workflow '${Workflow}' is not implemented." }
    }
}

function Invoke-Build {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object]
        $GlobalDevelopmentSettings,

        [Parameter(Mandatory = $true)]
        [Object]
        $DeveloperEnvironmentSettings
    )

    try {
        Push-Location $GlobalDevelopmentSettings.SourceDirectory

        ./build.ps1 `
            -BuildNumber             $([Guid]::NewGuid()) `
            -FlexportApiClientID     $DeveloperEnvironmentSettings.FlexportApiClientID `
            -FlexportApiClientSecret $DeveloperEnvironmentSettings.FlexportApiClientSecret
    }
    finally {
        Pop-Location
    }
}

Invoke-Workflow -Workflow $Workflow
