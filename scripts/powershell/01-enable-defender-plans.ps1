#Requires -Modules Az.Security, Az.Accounts
<#
.SYNOPSIS  Active ou desactive les plans Defender for Cloud
.PARAMETER Disable  Passe en Free (fin de session = stop facturation)
.EXAMPLE
    .\01-enable-defender-plans.ps1          # Activer
    .\01-enable-defender-plans.ps1 -Disable  # Desactiver
#>
param([switch]$Disable)

if (-not (Get-AzContext)) { Connect-AzAccount }

$tier   = if ($Disable) { 'Free'    } else { 'Standard' }
$action = if ($Disable) { 'DISABLE' } else { 'ENABLE'   }
$color  = if ($Disable) { 'Yellow'  } else { 'Cyan'     }

$plans = @('VirtualMachines','StorageAccounts','KeyVaults','Dns','Arm','AppServices')

Write-Host '' 
Write-Host "[$action] Defender Plans --> $tier" -ForegroundColor $color

foreach ($plan in $plans) {
    try {
        Set-AzSecurityPricing -Name $plan -PricingTier $tier
        Write-Host "  OK $plan" -ForegroundColor Green
    } catch {
        Write-Warning "  XX $plan : $($_.Exception.Message)"
    }
}

if ($Disable) {
    Write-Host '' 
    Write-Host '[DONE] Plans desactives - couts arretes.' -ForegroundColor Green
} else {
    Write-Host '' 
    Write-Host '[DONE] Plans actives. RAPPEL : -Disable en fin de session !' -ForegroundColor Yellow
}
