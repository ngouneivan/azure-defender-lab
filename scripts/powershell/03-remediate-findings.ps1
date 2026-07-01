#Requires -Modules Az.Security, Az.Accounts
<#
.SYNOPSIS  Liste les findings actifs (input pour la remediation phase 04)
.PARAMETER WhatIf  Mode simulation
#>
param([switch]$WhatIf)

if (-not (Get-AzContext)) { Connect-AzAccount }

$tasks = Get-AzSecurityTask | Where-Object { $_.State -ne 'Resolved' }
Write-Host "  $($tasks.Count) tache(s) active(s)" -ForegroundColor Yellow
$tasks | Select-Object Name, State | Format-Table -AutoSize
Write-Host '  Voir guides\04-cspm-remediation.md pour les actions.' -ForegroundColor Gray
