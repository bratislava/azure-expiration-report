#!/usr/bin/pwsh -File
param([Int32]$days=15) 

Function Get-AZSPReport
{
    $ADSPs = Get-AzADApplication
    $CustomReport = @()
    foreach ($ADSP in $ADSPs)
    {
        $AZADAppCreds = Get-AzADAppCredential -ApplicationId $ADSP.AppID
        foreach ($AZADAppCred in $AZADAppCreds)
        {
            $EndDate = $AZADAppCred.EndDateTime
            $Currentdate = Get-Date
            $diffDays = (New-TimeSpan -Start $Currentdate -End $EndDate).Days
            $status = $(if ($diffDays -le $days) { "WARNING" } else { "OK" })
            $tags = ($ADSP.Tag | Join-String -Separator ",")
    
            $SPReport = New-Object PSObject
            $SPReport | Add-Member -type NoteProperty -name Status -Value $status
            $SPReport | Add-Member -type NoteProperty -name DisplayName -Value $ADSP.DisplayName
            $SPReport | Add-Member -type NoteProperty -name AppID -Value $ADSP.AppID
            $SPReport | Add-Member -type NoteProperty -name Tags -Value $tags
            $SPReport | Add-Member -type NoteProperty -name StartDate -Value $AZADAppCred.StartDateTime
            $SPReport | Add-Member -type NoteProperty -name EndDate -Value $AZADAppCred.EndDateTime
            $SPReport | Add-Member -type NoteProperty -name DaysToExpire -Value $diffDays
            $SPReport | Add-Member -type NoteProperty -name Type -Value $(if ($AZADAppCred.Type -eq "AsymmetricX509Cert") { "AsymmetricX509Cert" } else { "Secret" })
            $CustomReport += $SPReport
        }
    }

    $CustomReport | Sort-Object { $_.enddate -as [datetime] }
}

Write-Host "Logging in to AD..." -ForegroundColor Yellow
$SecurePassword = ConvertTo-SecureString $Env:AZURE_PASSWORD -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential($Env:AZURE_USERNAME, $SecurePassword) 
Connect-AzAccount -ServicePrincipal -Credential $credentials -Tenant $Env:AZURE_TENANTID

Write-Host "Fetching Expiration Report... " -ForegroundColor Yellow
# Report app secrets expiration and output it as array of jsons
Get-AZSPReport | ForEach-Object { ConvertTo-Json -Compress @($_) }
Write-Host "All Done!" -ForegroundColor Yellow
