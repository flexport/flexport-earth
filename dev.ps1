# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateSet(
        'Build',
        'Deploy',
        'Destroy',
        'Push',
        'StartWebsite',
        'RuntimeTests'
    )]
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
    push
    startWebsite
    runtimeTests
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

        deploy
        {
            Invoke-Deploy `
                -GlobalDevelopmentSettings      $GlobalDevelopmentSettings `
                -DeveloperEnvironmentSettings   $DeveloperEnvironmentSettings
        }

        destroy
        {
            Invoke-Destroy `
                -GlobalDevelopmentSettings      $GlobalDevelopmentSettings `
                -DeveloperEnvironmentSettings   $DeveloperEnvironmentSettings
        }

        push
        {
            Invoke-Push `
                -GlobalDevelopmentSettings      $GlobalDevelopmentSettings `
                -DeveloperEnvironmentSettings   $DeveloperEnvironmentSettings
        }

        startWebsite
        {
            Start-Website `
                -GlobalDevelopmentSettings      $GlobalDevelopmentSettings `
                -DeveloperEnvironmentSettings   $DeveloperEnvironmentSettings
        }

        runtimeTests
        {
            Invoke-RuntimeTests `
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

function Invoke-Deploy {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object]
        $GlobalDevelopmentSettings,

        [Parameter(Mandatory = $true)]
        [Object]
        $DeveloperEnvironmentSettings
    )

    $ReleasablesPath           = $GlobalDevelopmentSettings.ReleasablesDirectory
    $DevelopmentToolsDirectory = $GlobalDevelopmentSettings.DevelopmentToolsDirectory

    . "$DevelopmentToolsDirectory/sign-into-azure.ps1"
    . "$DevelopmentToolsDirectory/build-number.ps1"

    $BuildNumber = Get-BuildNumber

    try {
        Push-Location $ReleasablesPath

        ./deploy-earth.ps1 `
            -BuildNumber                  $BuildNumber `
            -EnvironmentName              $DeveloperEnvironmentSettings.EnvironmentName `
            -EarthWebsiteCustomDomainName $DeveloperEnvironmentSettings.EarthWebsiteCustomDomainName `
            -FlexportApiClientId          $DeveloperEnvironmentSettings.FlexportApiClientId `
            -FlexportApiClientSecret      $DeveloperEnvironmentSettings.FlexportApiClientSecret
    }
    finally {
        Pop-Location
    }
}

function Invoke-Destroy {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object]
        $GlobalDevelopmentSettings,

        [Parameter(Mandatory = $true)]
        [Object]
        $DeveloperEnvironmentSettings
    )

    $DevelopmentToolsDirectory = $GlobalDevelopmentSettings.DevelopmentToolsDirectory
    $RelesablesDirectory       = $GlobalDevelopmentSettings.ReleasablesDirectory

    . "$DevelopmentToolsDirectory/sign-into-azure.ps1"

    try {
        Push-Location $RelesablesDirectory

        ./destroy-earth.ps1 `
            -EnvironmentName $DeveloperEnvironmentSettings.EnvironmentName
    }
    finally {
        Pop-Location
    }
}

function Invoke-Push {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object]
        $GlobalDevelopmentSettings,

        [Parameter(Mandatory = $true)]
        [Object]
        $DeveloperEnvironmentSettings
    )

    $RelesablesDirectory = $GlobalDevelopmentSettings.ReleasablesDirectory

    # Run dependency management
    . "$RelesablesDirectory/dependencies/dependency-manager.ps1"

    # Make sure there's no pending changes.
    $GitStatus = git status

    if (-Not ($GitStatus -like "*nothing to commit*")) {
        Write-Error "You have pending changes that need to be committed."
    }

    # Make sure we're testing with latest from origin/main.
    git fetch origin main

    $CurrentBranchName       = git rev-parse --abbrev-ref HEAD
    $DiffCounts              = ((git rev-list --left-right --count origin/main...$CurrentBranchName) -split '\t')
    $CommitsBehindOriginMain = $DiffCounts[0]

    if ($CommitsBehindOriginMain -gt 0) {
        Write-Error "The current branch is behind origin/main by $CommitsBehindOriginMain, please update it before continuing."
    }

    Invoke-Build   -GlobalDevelopmentSettings $GlobalDevelopmentSettings -DeveloperEnvironmentSettings $DeveloperEnvironmentSettings
    Invoke-Deploy  -GlobalDevelopmentSettings $GlobalDevelopmentSettings -DeveloperEnvironmentSettings $DeveloperEnvironmentSettings
    Invoke-Destroy -GlobalDevelopmentSettings $GlobalDevelopmentSettings -DeveloperEnvironmentSettings $DeveloperEnvironmentSettings

    git push --set-upstream origin $CurrentBranchName
}

function Start-Website {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object]
        $GlobalDevelopmentSettings,

        [Parameter(Mandatory = $true)]
        [Object]
        $DeveloperEnvironmentSettings
    )

    $WebsiteContentDirectory = $GlobalDevelopmentSettings.WebsiteContentSourceDirectory

    try {
        Push-Location $WebsiteContentDirectory
        npm run dev
    }
    finally {
        Pop-Location
    }

}

function Invoke-RuntimeTests {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object]
        $GlobalDevelopmentSettings,

        [Parameter(Mandatory = $true)]
        [Object]
        $DeveloperEnvironmentSettings
    )

    $DevelopmentToolsDirectory  = $GlobalDevelopmentSettings.DevelopmentToolsDirectory
    $RelesablesDirectory        = $GlobalDevelopmentSettings.ReleasablesDirectory

    . "$DevelopmentToolsDirectory/build-number.ps1"

    $BuildNumber = Get-BuildNumber

    try {
        Push-Location "$RelesablesDirectory"

        ./test-earth.ps1 `
            -EarthWebsiteUrl http://localhost:3000 `
            -BuildNumber     $BuildNumber
    }
    finally {
        Pop-Location
    }

}

Invoke-Workflow -Workflow $Workflow
