#Requires -Modules Az.Security, Az.Accounts
<#
.SYNOPSIS  Genere le rapport HTML de posture cloud (delta Secure Score avant/apres)
.PARAMETER BaselinePath  Dossier CSV baseline
.PARAMETER AfterPath     Dossier CSV apres remediation
.PARAMETER Output        Rapport HTML de sortie
#>
param(
    [string]$BaselinePath = 'reports\baseline',
    [string]$AfterPath    = 'reports\after-remediation',
    [string]$Output       = 'reports\rapport-posture-cloud.html'
)

Write-Host '  [TODO] A implementer en phase 04 (Remediation CSPM)' -ForegroundColor Yellow
Write-Host "  Baseline : $BaselinePath"
Write-Host "  After    : $AfterPath"
Write-Host "  Output   : $Output"
