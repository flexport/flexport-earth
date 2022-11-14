[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $TargetUrl,

    [Parameter(Mandatory = $true)]
    [String]
    $BuildNumber,

    [Parameter(Mandatory = $true)]
    [TimeSpan]
    $LoopForDuration
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Load some configuration values...
$GlobalDevelopmentSettings = Get-Content 'dev/development-config.json' | ConvertFrom-Json
$ReleasablesPath           = $GlobalDevelopmentSettings.ReleasablesDirectory

try {
    Push-Location "$ReleasablesPath"

    $TestRunLoopDateTimeStarted = Get-Date

    Write-Information "Starting test run loop at $TestRunLoopDateTimeStarted"

    $Counter    = 0
    $TestRuns   = @()

    do {
        $Counter++

        Write-Information ""
        Write-Information "Starting test run #$Counter"
        Write-Information ""

        $Result                 = $Null
        $TestRunDateTimeStarted = Get-Date

        try {
            ./test-earth.ps1 `
                -EarthWebsiteUrl $TargetUrl `
                -BuildNumber     $BuildNumber

            $Result = "Pass"
        }
        catch {
            Write-Information ""
            Write-Information "Run #$Counter failed!"
            Write-Information ""

            $Result = "Failed"
        }

        $TestRunResults = @{
            "Duration" = (Get-Date) - $TestRunDateTimeStarted
            "Result"   = $Result
        }

        $TestRuns += $TestRunResults

        $TimeRemaining = ($TestRunLoopDateTimeStarted + $LoopForDuration) - (Get-Date)

        Write-Information ""
        Write-Information "Test Run Loop Time Remaining: $TimeRemaining"
        Write-Information ""

        $TestRuns

    } while ($TimeRemaining -gt 0)
}
finally {
    Pop-Location
}