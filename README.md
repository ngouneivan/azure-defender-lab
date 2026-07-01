# Microsoft Defender for Cloud Lab

> **CSPM + Workload Protection**
> Lab personnel - Portfolio MICSI - 2026-07-01

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

*Portfolio MICSI - ngouneivan - 2026-07-01*
