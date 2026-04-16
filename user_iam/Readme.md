# Création d'un User S3 avec Privilèges Restreints et MFA Obligatoire

Ce module Terraform crée un utilisateur IAM respectant le principe du **moindre privilège**, limité uniquement à des opérations nécessaires sur S3. 

## Fonctionnalités incluses

1. **MFA Obligatoire** : Impossible d'effectuer des opérations sans MFA configuré et authentifié.
2. **Restriction de région S3** : L'utilisateur ne peut créer de bucket que dans la région `eu-west-3`.
3. **Contrôle du budget** : Alertes automatiques définies à 50%, 80% et 100% de la limite du budget S3, avec envoi sur l'e-mail de l'utilisateur.
4. **Permissions restreintes S3** : Seules les actions indispensables sur S3 sont accordées (CreateBucket, ListBucket, PutObject, DeleteObject, etc.).

## Limitation AWS

L'utilisateur ne peut agir que sur les buckets qui commencent par son nom (`s3-manager-user-*`).

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