# Overview

All instructions below are tested to work for:
- MacOS
- Windows

# Getting started for development

1. Clone this repo locally
2. Fork this repo
3. Update your remotes:

    `git remote add fork https://github.com/<your-username-here>/flexport-earth.git`

# Set up a new Azure subscription
Provision an Azure subscription for Earth deployments. This only needs to be executed once against a subscription.

1. az account set --subscription "target-subscription-name-here"
2. .\provision-azure-subscription.ps1 -AzureSubscriptionName "target-subscription-name-here"
3. Save the output information as secrets in CD automation.

# Destroy an environment

1. az account set --subscription "target-subscription-name-here"
2. \deprovision-azure-subscription.ps1
