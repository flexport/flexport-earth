[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $BuildNumber
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

docker build --build-arg BUILD_NUMBER=$BuildNumber . -t earth-e2e-tests:$BuildNumber
