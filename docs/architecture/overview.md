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
