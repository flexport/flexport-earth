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

Your commits must be be [verified](https://docs.github.com/en/authentication/managing-commit-signature-verification) in ordered to be merged.

## System Dependencies

If running on Windows, install the [Windows Linux System](https://docs.microsoft.com/en-us/windows/wsl/install) first.

1. [PowerShell Core (7.2.3)](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
2. [Azure CLI (2.36.0)](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
3. [NodeJS (16.15.0)](https://nodejs.org/en/download/)

## Start a PowerShell Console

    pwsh

## Install Development Tools

    ./development-tools/install-development-tools.ps1

## Viewing Website Content Locally

    The NextJS frontend can be started by running:

    ./start-website-locally.ps1

## Azure

You'll need an Azure subscription to deploy to. Once you have one, you can follow the steps below.

For provisioning new Azure Accounts, Tenants, and Subscriptions, continue [here](azure/README.md).

### Deploy your local changes to Azure

    ./deploy.ps1

### Clean up your Azure deployment

    ./destroy.ps1

### Pushing Changes to GitHub

Once you've made some changes and committed them, you can push them remotely using the push script:

    ./push.ps1
