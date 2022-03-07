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

    .\provision-azure-subscription.ps1

# Destroy an environment

    .\deprovision-azure-subscription.ps1
