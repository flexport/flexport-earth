﻿[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EarthWebsiteUrl
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Run dependency management
. ./dependencies/dependency-manager.ps1

Write-Information ""
Write-Information "Testing Earth at $EarthWebsiteUrl"

Write-Information ""
Write-Information "Installing Cypress..."
npm install cypress --save-dev
Write-Information "Cypress installed!"
Write-Information ""
Write-Information "Running tests..."

Invoke-Expression "$(npm bin)/cypress run --env EARTH_WEBSITE_URL=$EarthWebsiteUrl"