# Guide 01 — Prérequis

> **Statut** : TERMINÉ ✅
> **Date** : 2025-XX-XX

## Résultat

Tous les prérequis validés avant d'activer les plans Defender for Cloud.

## Checklist complétée

### Accès Azure
- [x] Subscription active : Azure subscription 1 (512817a3-87c7-4af5-a7ea-829b55885255)
- [x] Module Az PowerShell installé (AllUsers — permanent sur le PC)
- [x] Connexion Azure validée (Connect-AzAccount)

### Providers Azure enregistrés
- [x] Microsoft.Security    → Registered
- [x] Microsoft.PolicyInsights → Registered
- [x] Microsoft.Insights    → Registered

### Lab Sentinel existant
- [x] Log Analytics Workspace identifié : law-sentinel-lab
- [x] Resource Group : rg-sentinel-lab
- [x] ResourceId complet récupéré et renseigné dans terraform/variables.tf

## Variables renseignées dans terraform/variables.tf

| Variable | Valeur |
|----------|--------|
| subscription_id | 512817a3-87c7-4af5-a7ea-829b55885255 |
| workspace_name | law-sentinel-lab |
| workspace_id | /subscriptions/512817a3.../workspaces/law-sentinel-lab |

## Commandes utilisées

```powershell
# Vérification subscription
Get-AzSubscription | Select-Object Name, Id, State

# Récupération workspace Sentinel existant
$ws = Get-AzOperationalInsightsWorkspace -Name "law-sentinel-lab" -ResourceGroupName "rg-sentinel-lab"
Write-Host "workspace_id = $($ws.ResourceId)"

# Enregistrement des providers
Register-AzResourceProvider -ProviderNamespace Microsoft.Security
Register-AzResourceProvider -ProviderNamespace Microsoft.PolicyInsights
Register-AzResourceProvider -ProviderNamespace Microsoft.Insights
```

## Problèmes rencontrés

- Module Az non installé au départ → Install-Module -Name Az -Scope AllUsers -Force
- Get-AzRoleAssignment -SignInName KO sur compte Microsoft personnel
  → Contournement : Get-AzRoleAssignment -Scope "/subscriptions/..."