[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $EnvironmentName
)

$InformationPreference = 'Continue' # Enable 'Write-Information' output to show in the console.

az group delete --name "$EnvironmentName-earth-frontend" -y
