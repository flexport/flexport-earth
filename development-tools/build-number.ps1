function Get-BuildNumber {
    $GlobalDevelopmentSettings      = Get-Content 'development-config.json' | ConvertFrom-Json
    $WebsiteContentSourceDirectory  = $GlobalDevelopmentSettings.WebsiteContentSourceDirectory
    $BuildNumberFilePath            = "$WebsiteContentSourceDirectory/public/build-number.css"
    $BuildNumberCSS                 = Get-Content -Path $BuildNumberFilePath
    $MatchFound                     = $BuildNumberCSS -match 'content:\s"(.+)"'

    if (-Not $MatchFound) {
        Write-Error "Build number not found."
    }

    $BuildNumber = $Matches[1]

    return $BuildNumber
}