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
