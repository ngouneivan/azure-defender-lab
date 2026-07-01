#Requires -Version 5.1
<#
.SYNOPSIS
    Initialise la structure du lab Microsoft Defender for Cloud
.DESCRIPTION
    Cible : D:\personnel-ivan\PROJETS-PERSO-LAB\Microsoft Defender for Cloud
    Cree l'arborescence, les fichiers de demarrage, git init et premier commit.
.PARAMETER LabPath
    Chemin du dossier projet (defaut : dossier pre-configure)
.EXAMPLE
    .\Init-DefenderLab.ps1
#>
param(
    [string]$LabPath = "D:\personnel-ivan\PROJETS-PERSO-LAB\Microsoft Defender for Cloud"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Today  = Get-Date -Format "yyyy-MM-dd"
$Author = (git config user.name 2>$null)
if (-not $Author) { $Author = $env:USERNAME }

# ── Helpers ──────────────────────────────────────────────────────────────────
function Write-Step ([string]$m) { Write-Host "    -> $m" -ForegroundColor Cyan    }
function Write-OK   ([string]$m) { Write-Host "  [OK] $m" -ForegroundColor Green   }
function Write-Warn ([string]$m) { Write-Host "  [!!] $m" -ForegroundColor Yellow  }
function Write-Head ([string]$m) { Write-Host "`n  ===== $m =====" -ForegroundColor White }

function New-LabFile ([string]$RelPath, [string]$Content) {
    $full = Join-Path $LabPath $RelPath
    New-Item -ItemType File -Path $full -Force | Out-Null
    Set-Content -Path $full -Value $Content -Encoding UTF8
    Write-Step $RelPath
}

# ── Banner ───────────────────────────────────────────────────────────────────
Clear-Host
Write-Host ""
Write-Host "  +=========================================================+" -ForegroundColor DarkCyan
Write-Host "  |   Microsoft Defender for Cloud Lab                      |" -ForegroundColor DarkCyan
Write-Host "  |   CSPM  .  Defender Plans  .  Secure Score              |" -ForegroundColor DarkCyan
Write-Host "  +=========================================================+" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "  Auteur  : $Author"
Write-Host "  Date    : $Today"
Write-Host "  Cible   : $LabPath"
Write-Host ""

# ── Garde-fou ────────────────────────────────────────────────────────────────
if (-not (Test-Path $LabPath)) {
    Write-Host "  [INFO] Dossier non trouve, creation..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $LabPath -Force | Out-Null
}
$existingItems = Get-ChildItem -Path $LabPath -Force -ErrorAction SilentlyContinue
if ($existingItems.Count -gt 0) {
    Write-Warn "Le dossier n'est pas vide ($($existingItems.Count) element(s))"
    $confirm = Read-Host "  Continuer quand meme ? Les fichiers seront ecrases (o/N)"
    if ($confirm -notmatch '^[oO]$') { Write-Host '  Abandon.' -ForegroundColor Red; exit 0 }
}

# =============================================================================
Write-Head "ETAPE 1 - Arborescence"
# =============================================================================
# Pourquoi cette structure :
#   docs/    -> architecture + journal de lab (preuves de progression)
#   guides/  -> 7 guides phases (remplis en live lors de chaque session)
#   terraform/ -> IaC : tout ce qui touche Azure est versionne dans Git
#   scripts/ -> PS1 (admin Azure) + KQL (queries Sentinel/Log Analytics)
#   policies/ -> Azure Policies custom (outil de remediation CSPM)
#   reports/ -> Secure Score avant/apres (KPI documentable en entretien)
#   assets/  -> screenshots + diagrammes (README, LinkedIn, Word)

$folders = @(
    "docs\architecture"
    "docs\journal"
    "guides"
    "terraform\modules\defender-plans"
    "terraform\modules\test-workloads"
    "scripts\powershell"
    "scripts\kql"
    "scripts\bash"
    "policies\custom"
    "reports\baseline"
    "reports\after-remediation"
    "assets\screenshots"
    "assets\diagrams"
)

foreach ($f in $folders) {
    New-Item -ItemType Directory -Path (Join-Path $LabPath $f) -Force | Out-Null
    Write-Step $f
}
Write-OK "$($folders.Count) dossiers crees"

# =============================================================================
Write-Head "ETAPE 2 - Fichiers racine"
# =============================================================================

New-LabFile ".gitignore" @'
# Terraform
.terraform/
.terraform.lock.hcl
*.tfstate
*.tfstate.backup
*.tfvars
*.tfvars.json
terraform.tfvars

# Azure / secrets
*.env
.env.*
*.pem
*.pfx

# OS & IDE
.DS_Store
Thumbs.db
.vscode/

# Reports (donnees sensibles)
reports/**/*.csv
reports/**/*.json
'@
$_content = @'
# Microsoft Defender for Cloud Lab

> **CSPM + Workload Protection**
> Lab personnel - Portfolio MICSI - LABDATE

---

## Objectif

Deployer et mesurer **Microsoft Defender for Cloud** sur Azure :

- Activer le **CSPM** : Secure Score, Recommendations, Regulatory Compliance, Attack Paths
- Activer les **Defender Plans (CWPP)** : Servers P2, Storage, SQL, Key Vault
- Mesurer le **Secure Score avant / apres remediation** (KPI documentable)
- Integrer les alertes dans **Microsoft Sentinel** (lab existant)
- Produire un **rapport de posture cloud** HTML

---

## Architecture

```
On-premises (DC-01 / test.lab)
      | Azure Arc (AMA)
      v
+-- Microsoft Defender for Cloud --------------------------------+
|                                                               |
|  CSPM                        Defender Plans (CWPP)            |
|  +-- Secure Score            +-- Defender for Servers P2     |
|  +-- Recommendations         +-- Defender for Storage        |
|  +-- Regulatory Compliance   +-- Defender for SQL            |
|  +-- Attack Paths            +-- Defender for Key Vault      |
+---------------------------------------------------------------+
              | Alerts & data
              v
  Log Analytics Workspace (existant) --> Microsoft Sentinel
```

---

## Phases

| Phase | Guide | Objectif |
|-------|-------|----------|
| 01 | Prerequis | Droits, outils, Azure Arc |
| 02 | Activation plans | Terraform : CSPM + Defender Plans |
| 03 | Baseline Secure Score | Mesure J0 - rapport CSV |
| 04 | Remediation CSPM | Corrections critiques - delta Score |
| 05 | Workload Protection | Tests alertes VM / Storage / Key Vault |
| 06 | Regulatory Compliance | CIS Benchmark + NIST 800-53 |
| 07 | Integration Sentinel | Connecteur + regles analytics |

---

## KPIs cibles

| KPI | Valeur cible |
|-----|-------------|
| Secure Score J0 | A documenter |
| Delta apres remediation | +15 points minimum |
| Controls CIS passes | > 60 % |
| Alertes dans Sentinel | 3 alertes minimum |

---

## Keywords CV / LinkedIn

Microsoft Defender for Cloud - CSPM - CWPP - Secure Score - CIS - NIST 800-53
Azure Policy - Defender for Servers - Microsoft Sentinel - Terraform - Azure Arc - KQL

---

*Portfolio MICSI - LABAUTHOR - LABDATE*
'@
$_content = $_content -replace 'LABDATE', $Today -replace 'LABAUTHOR', $Author
New-LabFile "README.md" $_content
Write-OK "Fichiers racine crees"

# =============================================================================
Write-Head "ETAPE 3 - Documentation"
# =============================================================================

$_content = @'
# Journal de Lab - Microsoft Defender for Cloud

> Auteur : LABAUTHOR
> Demarrage : LABDATE
> Objectif : CSPM + Defender Plans + mesure Secure Score avant/apres

---

## LABDATE - Initialisation du projet

### Actions realisees
- [x] Dossier projet cree
- [x] Structure initialisee (Init-DefenderLab.ps1)
- [ ] Variables Terraform renseignees (subscription_id, workspace_id)
- [ ] Remote GitHub ajoute et push effectue

### Decisions d'architecture
| Decision | Choix | Raison |
|----------|-------|--------|
| Region | France Central | Coherence lab Sentinel |
| Resource Group | rg-defender-lab | Isolation du lab |
| Log Analytics WS | Reutilisation existant | Evite les couts dupliques |

### Notes
> Aucun plan Defender actif pour l'instant.
> Prochaine etape : Phase 01 - verifier les prerequis.

---

## Template session

## YYYY-MM-DD - Titre

### Objectif
>

### Actions realisees
- [ ]

### Commandes cles
```powershell
# Coller ici
```

### Secure Score
| Moment | Score global | Delta |
|--------|--------------|-------|
| Avant  |       /100   |   -   |
| Apres  |       /100   |  +X   |

---
'@
$_content = $_content -replace 'LABDATE', $Today -replace 'LABAUTHOR', $Author
New-LabFile "docs\\journal\\JOURNAL.md" $_content
New-LabFile "docs\\architecture\\overview.md" @'
# Architecture - Microsoft Defender for Cloud Lab

## Composants

### On-premises
| Composant | Detail |
|-----------|--------|
| DC-01 | Windows Server 2022, test.lab |
| Azure Arc Agent | Azure Monitor Agent (AMA) |

### Azure - Defender for Cloud
| Plan | Resource Group | Plan/Tier |
|------|---------------|----------|
| CSPM (inclus) | Subscription | Gratuit |
| Defender for Servers P2 | rg-defender-lab | Standard P2 |
| Defender for Storage | rg-defender-lab | Standard |
| Defender for SQL | rg-defender-lab | Standard |
| Defender for Key Vault | rg-defender-lab | Standard |

### Azure - Existant (lab Sentinel)
| Ressource | Resource Group |
|-----------|---------------|
| Log Analytics WS | rg-sentinel-lab |
| Microsoft Sentinel | rg-sentinel-lab |

## Flux de donnees

1. DC-01 (Arc + AMA) -> Log Analytics WS
2. Ressources Azure -> Defender for Cloud (scan CSPM toutes les 24h)
3. Defender for Cloud -> Alerts -> Log Analytics WS -> Sentinel
4. Recommendations -> Remediation manuelle + Azure Policy

## Estimation des couts
| Composant | Cout | Note |
|-----------|------|------|
| Defender for Servers P2 | ~15 dollar/server/mois | Desactiver apres session |
| Defender for Storage | ~0.005 dollar/10k ops | Desactiver apres session |
| Defender for Key Vault | ~0.02 dollar/10k ops | Desactiver apres session |
| Total lab | 10-30 dollar/session | Controle par script 01 |
'@
Write-OK "Documentation creee"

# =============================================================================
Write-Head "ETAPE 4 - Guides (stubs a remplir phase par phase)"
# =============================================================================
# Pourquoi des stubs ?
#   Un guide redige EN LIVE pendant la session est plus credible qu'un guide preprepare.
#   Il contient les vraies commandes, les vrais resultats, les vrais problemes.

New-LabFile "guides\\01-prerequisites.md" @'
# Guide 01 - Prerequis

> Statut : A REMPLIR lors de la session 01
> Duree estimee : 30 min

## Objectif
Verifier que l'environnement est pret avant de toucher a Azure.

## Checklist

### Acces Azure
- [ ] Abonnement actif
- [ ] Role Owner ou Contributor + Security Admin
- [ ] az login && az account show OK

### Outils locaux
- [ ] Azure CLI (az --version)
- [ ] Terraform >= 1.6.0 (terraform --version)
- [ ] PowerShell 7+ avec module Az.Security

### Lab Sentinel existant
- [ ] Log Analytics Workspace ID note
- [ ] Microsoft Sentinel actif sur le WS
- [ ] DC-01 visible dans Azure Arc

## Variables a noter pour terraform/variables.tf
subscription_id = ""
workspace_id    = ""
workspace_name  = ""

## Commandes de verification
```powershell
Connect-AzAccount
Get-AzSubscription | Select-Object Name, Id, State
Register-AzResourceProvider -ProviderNamespace Microsoft.Security
Register-AzResourceProvider -ProviderNamespace Microsoft.PolicyInsights
```
'@
New-LabFile "guides\\02-enable-defender-plans.md" @'
# Guide 02 - Activation des plans Defender

> Statut : A REMPLIR lors de la session 02

## Pourquoi Terraform et pas le portail ?
Tracer chaque activation dans Git. Reproductible, auditable, desactivable en un apply.

## Etapes
1. Renseigner terraform/variables.tf
2. terraform init
3. terraform plan -out=tfplan
4. terraform apply tfplan
5. Verifier dans le portail : Defender for Cloud > Environment Settings

## Verification
```powershell
Get-AzSecurityPricing | Select-Object Name, PricingTier | Sort-Object Name
```
'@
New-LabFile "guides\\03-secure-score-baseline.md" @'
# Guide 03 - Baseline Secure Score (J0)

> Statut : A REMPLIR lors de la session 03

## Pourquoi c'est critique
En entretien : 'De combien avez-vous ameliore la posture ?'
Sans baseline J0 = reponse impossible.

## Etapes
1. Lancer le script d'export
2. Sauvegarder dans reports/baseline/
3. Screenshot du dashboard Secure Score
4. Documenter dans JOURNAL.md + Word

```powershell
.\scripts\powershell\02-export-secure-score.ps1 -OutputPath 'reports\baseline\score-J0.csv'
```

## A documenter apres la session
- Score global J0 : ___/100
- Controls passes : ___
- Controls echoues : ___
- Top 3 recommendations critiques :
  1.
  2.
  3.
'@
New-LabFile "guides\\04-cspm-remediation.md" @'
# Guide 04 - Remediation CSPM

> Statut : A REMPLIR lors de la session 04
'@
New-LabFile "guides\\05-workload-protection.md" @'
# Guide 05 - Workload Protection

> Statut : A REMPLIR lors de la session 05
'@
New-LabFile "guides\\06-regulatory-compliance.md" @'
# Guide 06 - Regulatory Compliance (CIS + NIST)

> Statut : A REMPLIR lors de la session 06
'@
New-LabFile "guides\\07-sentinel-integration.md" @'
# Guide 07 - Integration Microsoft Sentinel

> Statut : A REMPLIR lors de la session 07
'@
Write-OK "7 guides crees (stubs)"

# =============================================================================
Write-Head "ETAPE 5 - Terraform (IaC)"
# =============================================================================
# Tout ce qui touche Azure est declare ici et versionne dans Git.
# Reproductible, auditable, desactivable en un seul terraform apply.

New-LabFile "terraform\\providers.tf" @'
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.85"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
'@
New-LabFile "terraform\\variables.tf" @'
variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID (az account show --query id)"
}

variable "location" {
  type        = string
  description = "Region Azure du lab"
  default     = "francecentral"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group du lab"
  default     = "rg-defender-lab"
}

variable "workspace_id" {
  type        = string
  description = "ID complet du Log Analytics WS existant (lab Sentinel)"
}

variable "workspace_name" {
  type        = string
  description = "Nom du Log Analytics Workspace existant"
}

variable "enable_defender_servers" {
  type    = bool
  default = true
}

variable "enable_defender_storage" {
  type    = bool
  default = true
}

variable "enable_defender_sql" {
  type    = bool
  default = false
}

variable "enable_defender_keyvault" {
  type    = bool
  default = true
}
'@
New-LabFile "terraform\\outputs.tf" @'
output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Nom du Resource Group cree"
}

output "defender_plans_status" {
  description = "Statut des plans Defender"
  value = {
    servers  = var.enable_defender_servers  ? "Standard (P2)" : "Free"
    storage  = var.enable_defender_storage  ? "Standard"      : "Free"
    sql      = var.enable_defender_sql      ? "Standard"      : "Free"
    keyvault = var.enable_defender_keyvault ? "Standard"      : "Free"
  }
}
'@
New-LabFile "terraform\\main.tf" @'
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Project     = "defender-for-cloud-lab"
    Environment = "lab"
    ManagedBy   = "terraform"
  }
}

module "defender_plans" {
  source = "./modules/defender-plans"

  enable_servers  = var.enable_defender_servers
  enable_storage  = var.enable_defender_storage
  enable_sql      = var.enable_defender_sql
  enable_keyvault = var.enable_defender_keyvault
  workspace_id    = var.workspace_id
}

module "test_workloads" {
  source              = "./modules/test-workloads"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  workspace_id        = var.workspace_id
  depends_on          = [module.defender_plans]
}
'@
New-LabFile "terraform\\modules\\defender-plans\\variables.tf" @'
variable "enable_servers"  { type = bool;   default = true  }
variable "enable_storage"  { type = bool;   default = true  }
variable "enable_sql"      { type = bool;   default = false }
variable "enable_keyvault" { type = bool;   default = true  }
variable "workspace_id"    { type = string                  }
'@
New-LabFile "terraform\\modules\\defender-plans\\main.tf" @'
data "azurerm_client_config" "current" {}

resource "azurerm_security_center_subscription_pricing" "servers" {
  count         = var.enable_servers ? 1 : 0
  tier          = "Standard"
  resource_type = "VirtualMachines"
  subplan       = "P2"
}

resource "azurerm_security_center_subscription_pricing" "storage" {
  count         = var.enable_storage ? 1 : 0
  tier          = "Standard"
  resource_type = "StorageAccounts"
}

resource "azurerm_security_center_subscription_pricing" "sql" {
  count         = var.enable_sql ? 1 : 0
  tier          = "Standard"
  resource_type = "SqlServers"
}

resource "azurerm_security_center_subscription_pricing" "keyvault" {
  count         = var.enable_keyvault ? 1 : 0
  tier          = "Standard"
  resource_type = "KeyVaults"
}

resource "azurerm_security_center_workspace" "main" {
  scope        = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  workspace_id = var.workspace_id
}
'@
New-LabFile "terraform\\modules\\test-workloads\\main.tf" @'
# Scaffold - a completer en phase 05
variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "workspace_id"        { type = string }
# TODO phase 05 : azurerm_windows_virtual_machine, azurerm_storage_account, azurerm_key_vault
'@
Write-OK "Terraform cree"

# =============================================================================
Write-Head "ETAPE 6 - Scripts PowerShell"
# =============================================================================

New-LabFile "scripts\\powershell\\01-enable-defender-plans.ps1" @'
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
'@
New-LabFile "scripts\\powershell\\02-export-secure-score.ps1" @'
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
'@
New-LabFile "scripts\\powershell\\03-remediate-findings.ps1" @'
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
'@
New-LabFile "scripts\\powershell\\04-generate-report.ps1" @'
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
'@
Write-OK "Scripts PowerShell crees"

# =============================================================================
Write-Head "ETAPE 7 - Requetes KQL"
# =============================================================================

New-LabFile "scripts\\kql\\01-secure-score-trend.kql" @'
// Tendance Secure Score sur 30 jours
// Utiliser en phase 03 (baseline) et phase 04 (suivi apres remediation)
SecureScores
| where TimeGenerated > ago(30d)
| project TimeGenerated, DisplayName, CurrentScore, MaxScore,
          Percentage = round(todouble(CurrentScore) / todouble(MaxScore) * 100, 1)
| order by TimeGenerated desc
'@
New-LabFile "scripts\\kql\\02-security-alerts.kql" @'
// Alertes Defender for Cloud (24h)
// Utiliser en phase 05 apres avoir declenche des alertes
SecurityAlert
| where TimeGenerated > ago(24h)
| where ProductName contains 'Defender' or ProductName contains 'Azure Security Center'
| project TimeGenerated, AlertName, AlertSeverity, Description, CompromisedEntity
| order by TimeGenerated desc
'@
New-LabFile "scripts\\kql\\03-compliance-state.kql" @'
// Conformite par framework reglementaire
// Utiliser en phase 06 apres avoir assigne CIS + NIST
SecurityRegulatoryCompliance
| where TimeGenerated > ago(7d)
| summarize
    Passed  = countif(State == 'Passed'),
    Failed  = countif(State == 'Failed'),
    Skipped = countif(State == 'Skipped')
  by ComplianceStandard = StandardName
| extend PassRate = round(todouble(Passed) / (Passed + Failed) * 100, 1)
| order by PassRate asc
'@
New-LabFile "scripts\\kql\\04-recommendations-by-severity.kql" @'
// Recommendations actives classees par severite
// Utiliser en phase 04 pour prioriser la remediation
SecurityRecommendation
| where TimeGenerated > ago(24h)
| where RecommendationState == 'Active'
| summarize Count = count(), Resources = dcount(Id)
  by RecommendationSeverity, RecommendationDisplayName
| order by
    case(RecommendationSeverity, 'High', 1, 'Medium', 2, 'Low', 3, 4) asc,
    Count desc
'@
Write-OK "Requetes KQL creees"

# =============================================================================
Write-Head "ETAPE 8 - Azure Policy (exemple)"
# =============================================================================

New-LabFile "policies\\custom\\require-project-tag.json" @'
{
  "properties": {
    "displayName": "Lab - Exiger le tag Project sur les Resource Groups",
    "mode": "All",
    "policyRule": {
      "if": {
        "allOf": [
          { "field": "type", "equals": "Microsoft.Resources/subscriptions/resourceGroups" },
          { "field": "tags[Project]", "exists": "false" }
        ]
      },
      "then": { "effect": "deny" }
    }
  }
}
'@
Write-OK "Azure Policy creee"

# =============================================================================
Write-Head "ETAPE 9 - Placeholders (.gitkeep)"
# =============================================================================
# Git ne versionne pas les dossiers vides. Le .gitkeep force le tracking.

$placeholders = @(
    'reports\\baseline\\.gitkeep'
    'reports\\after-remediation\\.gitkeep'
    'assets\\screenshots\\.gitkeep'
    'assets\\diagrams\\.gitkeep'
    'scripts\\bash\\.gitkeep'
)

foreach ($p in $placeholders) {
    Set-Content -Path (Join-Path $LabPath $p) -Value '' -Encoding UTF8
    Write-Step $p
}
Write-OK "$($placeholders.Count) placeholders crees"

# =============================================================================
Write-Head "ETAPE 10 - Git init + premier commit"
# =============================================================================
# Premier commit = photo zero du projet.
# Chaque commit suivant = une phase franchie. L'historique Git raconte le lab.

Push-Location $LabPath
try {
    if (-not (Test-Path '.git')) {
        git init --initial-branch=main 2>&1 | Out-Null
        Write-Step 'git init --initial-branch=main'
    } else {
        Write-Warn 'Depot Git existant - skip init'
    }

    git add -A 2>&1 | Out-Null
    git commit -m 'feat: init Microsoft Defender for Cloud lab' 2>&1 | Out-Null
    Write-Step 'Premier commit effectue'
    Write-OK 'Depot Git initialise'

} catch {
    Write-Warn "Git non disponible : $_"
} finally {
    Pop-Location
}

# =============================================================================
Write-Host ""
Write-Host "  +=========================================================+" -ForegroundColor Green
Write-Host "  |  Structure creee avec succes !                          |" -ForegroundColor Green
Write-Host "  +=========================================================+" -ForegroundColor Green
Write-Host ""
Write-Host "  Dossier  : $LabPath"
Write-Host "  Dossiers : $($folders.Count)"
Write-Host ""
Write-Host "  Prochaines etapes :" -ForegroundColor White
Write-Host "  ---------------------------------------------------"
Write-Host "  1. Verifier la structure dans l Explorateur Windows" -ForegroundColor Cyan
Write-Host "  2. Renseigner terraform/variables.tf" -ForegroundColor Cyan
Write-Host "  3. Ajouter le remote GitHub :" -ForegroundColor Cyan
Write-Host ""
Write-Host "     cd \"$LabPath\"" -ForegroundColor DarkGray
Write-Host "     git remote add origin https://github.com/ngouneivan/azure-defender-lab.git" -ForegroundColor DarkGray
Write-Host "     git push -u origin main" -ForegroundColor DarkGray
Write-Host ""
