$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$ExpectedPowerShellVersion = "7.3.0"
$ExpectedAzureCliVersion = "2.42.0"

$PowerShellVersion = $PSVersionTable.PSVersion
if ($PowerShellVersion -ne $ExpectedPowerShellVersion) {
    Write-Warning "Current PowerShell version is $PowerShellVersion, expected $ExpectedPowerShellVersion"
    Write-Warning "Some functionality may not behave correctly."
}

$AzureCliVersion = (az version | ConvertFrom-Json).'azure-cli'
if ($AzureCliVersion -ne $ExpectedAzureCliVersion) {
    Write-Warning "Current Azure CLI version is '$AzureCliVersion', expected '$ExpectedAzureCliVersion'"
    Write-Warning "Some functionality may not behave correctly."
}
