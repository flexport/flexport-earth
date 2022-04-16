# Overview

All instructions below are tested to work for:
- MacOS
- Windows

# Getting started for development

1. Clone this repo locally.
2. Fork this repo.
3. Update your remotes:

    `git remote set-url --push https://github.com/<your-username-here>/flexport-earth.git`

## Azure

You'll need an Azure subscription to deploy to. Once you have one, you can follow the steps below.

### Login

    az login

If you work with multiple subscriptions, be sure to set the correct default subscription that the Earth scripts should use:

    az account set --subscription <subscription name here>

### Deploy your local changes

    cd releaseables
    ./deploy-earth.ps1

### Clean up your Azure deployment

    cd releaseables
    ./destroy-earth.ps1
