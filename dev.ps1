# This script is for local development purposes only to make it easier
# for developers to work with all the various scripts and their parameters.

# This script operates similarly to a CI/CD system in that it feeds
# settings and configuration values into the various scripts to run them.

# Because this script behaves similarly to the CI/CD system, using it to
# run and test Earth locally should behave consistently with how these scripts
# will behave when executed by the CI/CD system so that there's no surprises
# when running everything outside of a developers environment.

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateSet(
        'BuildRelease',
        'BuildReleaseAndPublish',
        'StartWebsiteLocallyDevMode',
        'StartWebsiteLocallyProdMode',
        'DeployToAzure',
        'RunE2ETests',
        'Push',
        'DestroyAzureEnvironment'
    )]
    [String]
    $Workflow
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

enum DevWorkflows {
    BuildRelease
    BuildReleaseAndPublish
    StartWebsiteLocallyDevMode
    StartWebsiteLocallyProdMode
    DeployToAzure
    RunE2ETests
    Push
    DestroyAzureEnvironment
}

function Get-DeployerServicePrincipalCredentials {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [Object]
        $GlobalDevelopmentSettings,

        [Parameter(Mandatory = $true)]
        [Object]
        $DeveloperEnvironmentSettings,

       [Parameter(Mandatory = $true)]
       [PSCustomObject]
       $EarthRuntimeConfig
    )

    process {
        $CacheDirectory = $GlobalDevelopmentSettings.CachedAzureCredsDirectory
        $CredsPath      = "$CacheDirectory/$($EarthRuntimeConfig.EarthDeployerServicePrincipalName).json"

        if (-Not (Test-Path $CredsPath)) {
            Write-Information "Deployer Service Principal cached credentials not found at $CredsPath.

To resolve this, please perform the following:

1. Sign in to Azure as the Administrator of your Azure Subscription by running the following on your command line:

    az login

2. Run the following script on your command line:

    ./src/azure/provisioning/subscription-provision.ps1

This will create a Service Principal in Azure and cache the credentials for use.

3. Rerun your previous command.
"

            exit
        }

        $ServicePrincipalCredentials = Get-Content -Path $CredsPath | ConvertFrom-Json

        $ServicePrincipalCredentials = @{
            Tenant      = $ServicePrincipalCredentials.tenant
            DisplayName = $ServicePrincipalCredentials.displayName
            AppId       = $ServicePrincipalCredentials.appId
            Password    = ConvertTo-SecureString -String $ServicePrincipalCredentials.password -AsPlainText
        }

        return $ServicePrincipalCredentials
    }
}

function Invoke-Workflow {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [DevWorkflows]
        $Workflow
    )

    # Load some configuration values...
    $GlobalDevelopmentSettings = Get-Content 'dev/development-config.json' | ConvertFrom-Json

    $DevelopmentToolsDirectory = $GlobalDevelopmentSettings.DevelopmentToolsDirectory

    . "$DevelopmentToolsDirectory/local-config-manager.ps1"

    $DeveloperEnvironmentSettings = Get-DeveloperEnvironmentSettings

    . ./src/releasables/earth-runtime-config.ps1

    $EarthRuntimeConfig = Get-EarthRuntimeConfig `
        -AzureSubscriptionName $DeveloperEnvironmentSettings.AzureSubscriptionName

    switch ($Workflow) {
        BuildRelease
        {
            Invoke-Build `
                -GlobalDevelopmentSettings      $GlobalDevelopmentSettings `
                -DeveloperEnvironmentSettings   $DeveloperEnvironmentSettings
        }

        BuildReleaseAndPublish
        {
            Invoke-BuildAndPublish `
                -GlobalDevelopmentSettings      $GlobalDevelopmentSettings `
                -DeveloperEnvironmentSettings   $DeveloperEnvironmentSettings `
                -EarthRuntimeConfig             $EarthRuntimeConfig
        }

        DeployToAzure
        {
            Invoke-Deploy `
                -GlobalDevelopmentSettings      $GlobalDevelopmentSettings `
                -DeveloperEnvironmentSettings   $DeveloperEnvironmentSettings `
                -EarthRuntimeConfig             $EarthRuntimeConfig
        }

        DestroyAzureEnvironment
        {
            Invoke-Destroy `
                -GlobalDevelopmentSettings      $GlobalDevelopmentSettings `
                -DeveloperEnvironmentSettings   $DeveloperEnvironmentSettings
        }

        Push
        {
            Invoke-Push `
                -GlobalDevelopmentSettings      $GlobalDevelopmentSettings `
                -DeveloperEnvironmentSettings   $DeveloperEnvironmentSettings `
                -EarthRuntimeConfig             $EarthRuntimeConfig
        }

        StartWebsiteLocallyDevMode
        {
            Start-Website `
                -GlobalDevelopmentSettings      $GlobalDevelopmentSettings `
                -DeveloperEnvironmentSettings   $DeveloperEnvironmentSettings `
                -Mode                           Dev
        }

        StartWebsiteLocallyProdMode
        {
            Start-Website `
                -GlobalDevelopmentSettings      $GlobalDevelopmentSettings `
                -DeveloperEnvironmentSettings   $DeveloperEnvironmentSettings `
                -Mode                           Prod
        }

        RunE2ETests
        {
            Invoke-E2ETests `
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

        $BuildNumber = [Guid]::NewGuid()

        ./build.ps1 `
            -BuildNumber                    $BuildNumber `
            -FlexportApiClientID            $DeveloperEnvironmentSettings.FlexportApiClientID `
            -FlexportApiClientSecret        $($DeveloperEnvironmentSettings.FlexportApiClientSecret | ConvertFrom-SecureString -AsPlainText)

        Write-Information ""
        Write-Information "To run the build locally:"
        Write-Information ""
        Write-Information "   ./dev StartWebsiteLocallyDevMode"
        Write-Information "   ./dev StartWebsiteLocallyProdMode"
        Write-Information ""
        Write-Information "To deploy the build to Azure:"
        Write-Information ""
        Write-Information "   ./dev DeployToAzure"
        Write-Information ""
    }
    finally {
        Pop-Location
    }
}

function Invoke-BuildAndPublish {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object]
        $GlobalDevelopmentSettings,

        [Parameter(Mandatory = $true)]
        [Object]
        $DeveloperEnvironmentSettings,

        [Parameter(Mandatory = $true)]
        [PSCustomObject]
        $EarthRuntimeConfig
    )

    $ServicePrincipalCredentials = Get-DeployerServicePrincipalCredentials `
        -GlobalDevelopmentSettings      $GlobalDevelopmentSettings `
        -DeveloperEnvironmentSettings   $DeveloperEnvironmentSettings `
        -EarthRuntimeConfig             $EarthRuntimeConfig

    try {
        Push-Location $GlobalDevelopmentSettings.SourceDirectory

        $BuildNumber = [Guid]::NewGuid()

        ./build-and-publish.ps1 `
            -BuildNumber                     $BuildNumber `
            -FlexportApiClientID             $DeveloperEnvironmentSettings.FlexportApiClientID `
            -FlexportApiClientSecret         $($DeveloperEnvironmentSettings.FlexportApiClientSecret | ConvertFrom-SecureString -AsPlainText) `
            -PublishToEnvironment            $DeveloperEnvironmentSettings.EnvironmentName `
            -AzureServicePrincipalTenant     $ServicePrincipalCredentials.Tenant `
            -AzureServicePrincipalAppId      $ServicePrincipalCredentials.AppId `
            -AzureServicePrincipalPassword   $ServicePrincipalCredentials.Password

        Write-Information ""
        Write-Information "To run the build locally:"
        Write-Information ""
        Write-Information "   ./dev StartWebsiteLocallyDevMode"
        Write-Information "   ./dev StartWebsiteLocallyProdMode"
        Write-Information ""
        Write-Information "To deploy the build to Azure:"
        Write-Information ""
        Write-Information "   ./dev DeployToAzure"
        Write-Information ""
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
        $DeveloperEnvironmentSettings,

        [Parameter(Mandatory = $true)]
        [PSCustomObject]
        $EarthRuntimeConfig
    )

    $ReleasablesPath           = $GlobalDevelopmentSettings.ReleasablesDirectory
    $DevelopmentToolsDirectory = $GlobalDevelopmentSettings.DevelopmentToolsDirectory

    . "$DevelopmentToolsDirectory/sign-into-azure.ps1"
    . "$DevelopmentToolsDirectory/build-number.ps1"

    $DeployerServicePrincipalCredentials = Get-DeployerServicePrincipalCredentials `
        -GlobalDevelopmentSettings      $GlobalDevelopmentSettings `
        -DeveloperEnvironmentSettings   $DeveloperEnvironmentSettings `
        -EarthRuntimeConfig             $EarthRuntimeConfig

    $BuildNumber = Get-BuildNumber

    try {
        Push-Location $ReleasablesPath

        ./deploy-earth.ps1 `
            -BuildNumber                                        $BuildNumber `
            -EnvironmentName                                    $DeveloperEnvironmentSettings.EnvironmentName `
            -EarthWebsiteCustomDomainName                       $DeveloperEnvironmentSettings.EarthWebsiteCustomDomainName `
            -FlexportApiClientId                                $DeveloperEnvironmentSettings.FlexportApiClientId `
            -FlexportApiClientSecret                            $DeveloperEnvironmentSettings.FlexportApiClientSecret `
            -GoogleAnalyticsMeasurementId                       $DeveloperEnvironmentSettings.GoogleAnalyticsMeasurementId `
            -ContainerTargetRegistryTenant                      $DeployerServicePrincipalCredentials.Tenant `
            -ContainerTargetRegistryUsername                    $DeployerServicePrincipalCredentials.AppId `
            -ContainerTargetRegistryPassword                    $DeployerServicePrincipalCredentials.Password `
            -EarthEnvironmentOperatorsEmailAddress              $DeveloperEnvironmentSettings.EarthEnvironmentOperatorsEmailAddress
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
        $DeveloperEnvironmentSettings,

        [Parameter(Mandatory = $true)]
        [PSCustomObject]
        $EarthRuntimeConfig
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
    Write-Information "Fetching latest changes from the main Flexport Earth GitHub repository to ensure you're up to date before continuing..."
    Write-Information ""

    git fetch origin main

    $CurrentBranchName       = git rev-parse --abbrev-ref HEAD
    $DiffCounts              = ((git rev-list --left-right --count origin/main...$CurrentBranchName) -split '\t')
    $CommitsBehindOriginMain = $DiffCounts[0]

    if ($CommitsBehindOriginMain -gt 0) {
        Write-Error "The current branch is behind origin/main by $CommitsBehindOriginMain, please update it before continuing."
    }

    Write-Information ""
    Write-Information "You're in sync with origin main, excellent! Continuing to test and push your changes..."
    Write-Information ""

    Invoke-BuildAndPublish  -GlobalDevelopmentSettings $GlobalDevelopmentSettings -DeveloperEnvironmentSettings $DeveloperEnvironmentSettings -EarthRuntimeConfig $EarthRuntimeConfig
    Invoke-Deploy           -GlobalDevelopmentSettings $GlobalDevelopmentSettings -DeveloperEnvironmentSettings $DeveloperEnvironmentSettings -EarthRuntimeConfig $EarthRuntimeConfig
    Invoke-Destroy          -GlobalDevelopmentSettings $GlobalDevelopmentSettings -DeveloperEnvironmentSettings $DeveloperEnvironmentSettings

    git push --set-upstream origin $CurrentBranchName
}

enum LocalWebsiteModes {
    Dev
    Prod
}

function Start-Website {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object]
        $GlobalDevelopmentSettings,

        [Parameter(Mandatory = $true)]
        [Object]
        $DeveloperEnvironmentSettings,

        [Parameter(Mandatory = $true)]
        [LocalWebsiteModes]
        $Mode
    )

    $WebsiteContentDirectory = $GlobalDevelopmentSettings.WebsiteContentSourceDirectory

    try {
        Push-Location $WebsiteContentDirectory

        $GoogleAnalyticsMeasurementId = $DeveloperEnvironmentSettings.GoogleAnalyticsMeasurementId

        # Set environment variables that the website requires before starting.
        $env:NEXT_PUBLIC_GOOGLE_ANALYTICS_MEASUREMENT_ID=$GoogleAnalyticsMeasurementId

        switch ($Mode) {
            Dev
            {
                npm run dev
            }

            Prod
            {
                npm run start
            }

            default { throw "The specified mode '${Mode}' is not valid." }
        }
    }
    finally {
        Pop-Location

        # Clean up env vars
        Remove-Item Env:\NEXT_PUBLIC_GOOGLE_ANALYTICS_MEASUREMENT_ID
    }
}

function Invoke-E2ETests {
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

# Ensure all the local development tools are installed
# and up to date before running any development workflows.
./dev/tools/install-development-tools.ps1

Invoke-Workflow -Workflow $Workflow
