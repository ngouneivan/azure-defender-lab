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
