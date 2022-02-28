$InformationPreference = 'Continue' # Enable 'Write-Information' calls to show in the console.

$ApplicationName = "Flexport Earth"

Write-Information "Removing all resources from up your subscription..."
Write-Information "Removing $ApplicationName Application..."

Remove-AzADApplication -DisplayName $ApplicationName