[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $UrlToPoll,

    [Parameter(Mandatory=$true)]
    [Int32]
    $PollDurationMinutes
)

Set-StrictMode –Version latest

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

$i              = 0
$SleepSeconds   = $PollDurationMinutes * 60

do {
    $i++
    $StartTime = Get-Date
    $XCache    = (Invoke-WebRequest $UrlToPoll).Headers["X-Cache"]
    $EndTime   = Get-Date
    $Duration  = $EndTime - $StartTime

    Write-Information "${i}: ${EndTime}: ${Duration}: $XCache"

    Start-Sleep -Seconds $SleepSeconds
} while ($true)
