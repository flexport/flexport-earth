# Overview

All instructions below are tested to work for:
- MacOS
- Windows

# Getting started for local development

1. Clone this repo locally.
2. Fork this repo.
3. Update your remotes:

    `git remote set-url --push https://github.com/<your-username-here>/flexport-earth.git`

Note:

Your commits must be be [verified](https://docs.github.com/en/authentication/managing-commit-signature-verification) in ordered to be merged.

## System Dependencies

1. [PowerShell Core (7.2)](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
2. [Azure CLI (2.36.0)](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## Install Development Tools

    cd development-tools
    ./install-development-tools.ps1

## Azure

You'll need an Azure subscription to deploy to. Once you have one, you can follow the steps below.

For provisioning new Azure Accounts, Tenants, and Subscriptions, continue [here](azure/README.md).

### Deploy your local changes

    ./deploy.ps1

### Clean up your Azure deployment

    ./destroy.ps1
