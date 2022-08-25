# Overview

All instructions below are tested to work for:
- MacOS
- Windows

# Getting started for development

1. Clone this repo locally.
2. Fork this repo.
3. Update your remotes:

    `git remote set-url --push origin https://github.com/<your-username-here>/flexport-earth.git`

Note:

Your commits must be be [verified](https://docs.github.com/en/authentication/managing-commit-signature-verification) to be merged to the main branch.

## System Dependencies

If running on Windows, install the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install) first.

1. [PowerShell Core (7.2.6)](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
2. [Azure CLI (2.39.0)](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
3. [NodeJS (16.15.0)](https://nodejs.org/en/download/)

## Start a PowerShell Console

    pwsh

## Building a Release

    ./dev build

Note: This will also execute the unit and component tests.

## Viewing Website Content Locally

The NextJS frontend can be started by running:

    ./dev StartWebsite

## Testing Website Functionality Locally

    ./dev RuntimeTests

Note: Will need to open a new terminal window for this after starting the website locally.

## Azure

You'll need an Azure subscription to deploy to. Once you have one, you can follow the steps below.

For provisioning new Azure Accounts, Tenants, and Subscriptions, continue [here](/src/azure/provisioning/README.md).

### Deploy your locally built changes to Azure

    ./dev deploy

### Clean up your Azure deployment

    ./dev destroy

### Pushing Changes to GitHub

Once you've made some changes and committed them, you can push them remotely using the push script:

    ./dev push

## Developing for Earth

Continue reading [here](./) on how to develop for Flexport Earth.
