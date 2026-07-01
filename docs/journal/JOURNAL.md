# Journal de Lab - Microsoft Defender for Cloud

> Auteur : ngouneivan
> Demarrage : 2026-07-01
> Objectif : CSPM + Defender Plans + mesure Secure Score avant/apres

---

## 2026-07-01 - Initialisation du projet

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
