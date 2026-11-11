# AIS CP1 - TP 1 - MERIDIAN : construire le lab, inventorier et cartographier
 
Bachelor AIS - CP1 : appliquer les bonnes pratiques dans l'administration des infrastructures.
 
Ce dépôt contient les livrables du TP 1 : construction d'un lab de 3 machines virtuelles, création du domaine `meridian.lan`, installation de GLPI, inventaire du parc et de l'Active Directory, classement par criticité et cartographie du système d'information de MERIDIAN Systèmes (180 salariés, Paris et Lyon).
 
> Aucun mot de passe ne figure dans ce dépôt.
 
## Le lab
 
| Machine | Rôle | Système | Adresse IP |
| --- | --- | --- | --- |
| PAR-AD-01 | Contrôleur du domaine meridian.lan, DNS | Windows Server 2025 | 10.10.20.10 |
| PAR-GLPI-01 | Inventaire et centre de services GLPI | Debian 13 | 10.10.20.20 |
| PAR-ADM-01 | Poste d'administration (RSAT, scripts) | Windows 11 | 10.10.20.100 |
 
Réseau : VMware Workstation, VMnet8 (NAT) en 10.10.20.0/24, DHCP désactivé, passerelle 10.10.20.2.
 
## Contenu du dépôt
 
| Dossier | Contenu |
| --- | --- |
| `docs/` | Document des livrables : fiche d'installation, tableau de criticité, écarts AD / GLPI, fiche d'identité du SI, réponses aux questions |
| `captures/` | Get-ADDomain depuis PAR-ADM-01, page d'accueil GLPI, liste des ordinateurs inventoriés |
| `scripts/` | `Inventaire-Serveurs.ps1` : inventaire des serveurs AD et des comptes ordinateurs inactifs depuis 90 jours |
| `inventaire/` | Fichiers CSV produits par le script |
| `schema/` | Schéma d'ensemble du SI (PNG et source draw.io) |
 
## Utiliser le script
 
Depuis un poste joint au domaine avec les outils RSAT, dans PowerShell en administrateur :
 
```powershell
Set-ExecutionPolicy RemoteSigned -Scope Process
.\scripts\Inventaire-Serveurs.ps1
```
 
Le script crée 3 fichiers dans `C:\Inventaire` :
 
- `serveurs.csv` : serveurs du domaine, version, dernier démarrage, dernière connexion
- `ordinateurs-inactifs.csv` : comptes ordinateurs sans connexion depuis 90 jours ou jamais connectés
- `ordinateurs-ad.csv` : tous les comptes ordinateurs, pour comparaison avec GLPI
## Principaux constats
 
- Un seul contrôleur de domaine : aucune redondance de l'AD ni du DNS
- 4 comptes ordinateurs déclarés dans l'AD ne se sont jamais connectés
- LYO-SRV-01 sous Windows Server 2012 R2, plus supporté depuis octobre 2023
- GLPI accessible en HTTP, sans chiffrement

## Captures

**Get-ADDomain depuis PAR-ADM-01**
<img width="2558" height="1061" alt="Get-ADDomain" src="https://github.com/user-attachments/assets/660b180a-a0dc-4a7d-a250-dfe5629b13a1" />

**Page d'accueil GLPI**
<img width="2532" height="1110" alt="Accueil glpi" src="https://github.com/user-attachments/assets/0f8542c8-10ec-4887-a5a2-5fca74026a4a" />

**Ordinateurs inventoriés dans GLPI**
<img width="2554" height="1114" alt="3 machines glpi" src="https://github.com/user-attachments/assets/0609b994-2820-429e-88fc-1e7a862d4044" />

**Contenu de serveurs.csv**
<img width="1368" height="340" alt="Contenu Serveurs csv" src="https://github.com/user-attachments/assets/7e75fe31-b2a2-4048-817a-540cb23a0868" />

## Schéma d'ensemble
<img width="2164" height="1502" alt="schema-meridian" src="https://github.com/user-attachments/assets/91d5d7e2-52d5-46b1-975f-fe491a61459f" />

## Auteur
 
Grégory Datis - formation AIS, formateur Harabi Amine.
