#Requires -Modules Az.Security, Az.Accounts
<#
.SYNOPSIS  Exporte le Secure Score en CSV pour comparaison baseline/apres
.PARAMETER OutputPath  Chemin du CSV de sortie
.EXAMPLE
    .\02-export-secure-score.ps1 -OutputPath 'reports\baseline\score-J0.csv'
    .\02-export-secure-score.ps1 -OutputPath 'reports\after-remediation\score-Jplus.csv'
#>
param(
    [string]$OutputPath = "reports\baseline\secure-score-$(Get-Date -Format 'yyyy-MM-dd').csv"
)

if (-not (Get-AzContext)) { Connect-AzAccount }

$global = Get-AzSecuritySecureScore | Where-Object Name -eq 'ascScore'
if (-not $global) { Write-Warning 'Secure Score indisponible - verifier que Defender est actif.'; exit 1 }

$controls = Get-AzSecuritySecureScoreControl | Select-Object `
    DisplayName, CurrentScore, MaxScore,
    @{N='Percentage'; E={ if ($_.MaxScore -gt 0) { [math]::Round(($_.CurrentScore/$_.MaxScore)*100,1) } else { 0 } }},
    HealthyResourceCount, UnhealthyResourceCount

$dir = Split-Path $OutputPath -Parent
if ($dir -and (-not (Test-Path $dir))) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
$controls | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8

$pct = [math]::Round($global.Percentage * 100, 1)
Write-Host ""
Write-Host "  Secure Score Global : $pct % ($($global.CurrentScore)/$($global.MaxScore))" -ForegroundColor Cyan
Write-Host "  Export : $OutputPath" -ForegroundColor Green
Write-Host ""
Write-Host '  Top 5 controls a ameliorer :' -ForegroundColor Yellow
$controls | Sort-Object Percentage | Select-Object -First 5 | Format-Table DisplayName, Percentage, UnhealthyResourceCount -AutoSize
