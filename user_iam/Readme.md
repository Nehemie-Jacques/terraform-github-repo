# Création d'un User S3 avec Privilèges de Gestion Avancée et MFA Facultatif

Ce module Terraform crée un utilisateur IAM disposant d'un **Accès S3 complet**, tout en restreignant strictement l'emplacement (Region) de création des nouveaux compartiments.

## Fonctionnalités incluses

1. **Self-Service, Clés d'Accès et MFA Facultatif** : L'utilisateur dispose des droits nécessaires pour naviguer dans son compte (dashboard de sécurité, gestion de mot de passe), **créer/gérer ses propres Access Keys / Secret Keys** (pour accès programmatique), et **activer ou gérer son token MFA localement**. Bien que recommandé, le MFA n'est plus bloquant pour les tâches principales S3.
2. **Restriction de région S3** : La création de NOUVEAUX compartiments (`CreateBucket`) est restreinte à la région `eu-west-3`. Toute tentative de création sur une autre région sera bloquée par AWS IAM.
3. **Accès Complet S3 (Full Access)** : À l'exception de la contrainte régionale sur la création (`CreateBucket`), l'utilisateur bénéficie d'un accès total, permettant l'activation du versioning, gestion des statiques, édition des policies de buckets, et gestion totale des objets sur tous les compartiments (Read, Write, Delete).
4. **Contrôle du budget** : Alertes automatiques définies à 50%, 80% et 100% de la limite du budget S3, avec notification par e-mail automatique à l'utilisateur.

## Configuration et Déploiement

### Variables `variables.tf`

Vous pouvez (et devez) personnaliser ces variables via les valeurs par défaut :
- `user_name` (Nom du user)
- `user_email` (E-mail cible pour alerte budget)
- `budget_limit` (Limite en usd ex: $3)
- `region_restriction` (eu-west-3)

### Commandes

```bash
# Initialiser le répertoire
terraform init

# Planifier les créations et vérifier les modifications
terraform plan

# Appliquer le code
terraform apply
```

Pour récupérer le mot de passe généré : 
```bash
terraform output -raw user_initial_password
```