# Overview

All instructions below are tested to work for:
- MacOS
- Windows

# Getting started for development

1. Clone this repo locally.
2. Fork this repo.
3. Update your remotes:

    `git remote set-url --push https://github.com/<your-username-here>/flexport-earth.git`

Note:

Your commits must be be [verified](https://docs.github.com/en/authentication/managing-commit-signature-verification) in ordered to be merged.

## Install Development Tools

    ./install-development-tools.ps1

## Azure

You'll need an Azure subscription to deploy to. Once you have one, you can follow the steps below.

### Login

    az login

If you work with multiple subscriptions, be sure to set the correct default subscription that the Earth scripts should use:

    az account set --subscription <subscription name here>

### Provision a new Azure Tenant

    ./provision-azure-tenant.ps1

### Provision a new Azure Subscription

    ./provision-azure-subscription.ps1 -AzureSubscriptionName <subscription name here>

### Deploy your local changes

    cd releaseables
    ./deploy-earth.ps1 -EnvironmentName <environment name here>

### Clean up your Azure deployment

    cd releaseables
    ./destroy-earth.ps1 -EnvironmentName <environment name here>
