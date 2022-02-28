$InformationPreference = 'Continue' # Enable 'Write-Information' calls to show in the console.

$ApplicationName = "Flexport Earth"

Write-Information "Setting up your subscription..."
Write-Information "Registering $ApplicationName Application..."

New-AzADApplication -DisplayName $ApplicationName