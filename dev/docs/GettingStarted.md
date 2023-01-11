# Overview

All instructions below are tested to work for:
- MacOS
- Windows

# Getting started for development

1. Clone this repo locally.
    `git clone https://github.com/flexport/flexport-earth.git`

2. Fork this repo.
    in github click the fork icon in the upper right.
3. cd flexport-earth

4. Update your remotes replacing <your-username-here> with your github username:

    `git remote set-url --push origin https://github.com/<your-username-here>/flexport-earth.git`

Note:

Your commits must be be [verified](https://docs.github.com/en/authentication/managing-commit-signature-verification) to be merged to the main branch.

## System Dependencies

If running on Windows, install the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install) first.

1. [PowerShell Core (7.3.1)](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)

    If you get the following message "<installer-name> can’t be opened because Apple cannot check it for malicious software." please do the following:
        Open System Settings
        in the left hand nav select "Privacy & Security"
        in the right hand section scroll down to the Security section. there will be an entry for <installer-name> was blocked from use because it is not from an identified developer.
        click open Anyway
        enter login credentials.
        click Open. installer should now run


2. [Azure CLI (2.44.0)](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
3. [NodeJS (16.15.0)](https://nodejs.org/en/download/)
4. [Docker (version 20.10.21)](https://docs.docker.com/get-docker/)

## Start a PowerShell Console

    pwsh

## Building a Release

    ./dev BuildRelease

Note: This will also execute the unit and component tests.

## Viewing Website Content Locally

The NextJS frontend can be started in [dev mode](https://nextjs.org/docs/api-reference/cli#development) by running:

    ./dev StartWebsiteLocallyDevMode

The NextJS frontend can be started in [production mode](https://nextjs.org/docs/api-reference/cli#production) by running:

    ./dev StartWebsiteLocallyProdMode

## Execute End to End Tests Locally

    ./dev RunE2ETests

Note: Will need to open a new terminal window for this after starting the website locally.

## Google Analytics

You can optionally use / test Google Analytics in your personal development environment.

First you will need to create your own presonal Google Analytics account, see [here](../../product/docs/administrative-features/reporting-and-analytics/google-analytics/README.md#how-to-provision-a-new-google-analytics-account-for-a-new-earth-environment) for how to do that.

Then configure your Google Analytics Measurement ID in your local configuration.

If this is your first time running Earth, simply executing any of the development scripts will prompt you for this (and other configuration settings) at which point you can input this ID.

If you've previously executed Earth, then you can set the value in your [local configuration](./configuration/LocalDevelopment.md).

## Azure

You'll need an Azure subscription to deploy to. Once you have one, you can follow the steps below.

For provisioning new Azure Accounts, Tenants, and Subscriptions, continue [here](/src/azure/provisioning/README.md).

### Deploy your locally built changes to Azure

    ./dev DeployToAzure

### Clean up your Azure deployment

    ./dev DestroyAzureEnvironment

### Pushing Changes to GitHub

Once you've made some changes and committed them, you can push them remotely using the push script:

    ./dev Push

## Developing for Earth

Continue reading [here](./) on how to develop for Flexport Earth.
