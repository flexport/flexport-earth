Set-StrictMode –Version latest

$EarthFrontendResourceGroupName     = "$EnvironmentName-earth-frontend".ToLower()
$EarthFrontendResourceGroupLocation = "WestUS"

Write-Verbose "EarthFrontendResourceGroupLocation: $EarthFrontendResourceGroupLocation"
Write-Verbose "EarthFrontendResourceGroupName:     $EarthFrontendResourceGroupName"
