# ----- IAM User -----
resource "aws_iam_user" "s3_user" {
  name = var.user_name
  path = "/"

  # Tag the user to easily track their usage in AWS Billing/Budgets
  tags = {
    "CreatedBy" = "Terraform",
    "Owner"     = var.user_name
  }
}

# Assure qu'ils peuvent se connecter (facultatif si uniquement programmatique, on l'active ici avec mot de passe initial)
resource "aws_iam_user_login_profile" "s3_user_profile" {
  user                    = aws_iam_user.s3_user.name
  password_reset_required = true
}

# ----- IAM Policy : Self Management (MFA & Password) -----
data "aws_iam_policy_document" "force_mfa" {
  # Autorise l'utilisateur à voir les informations de base et lister les MFA
  statement {
    sid    = "AllowViewAccountInfo"
    effect = "Allow"
    actions = [
      "iam:GetAccountPasswordPolicy",
      "iam:GetAccountSummary",
      "iam:ListVirtualMFADevices",
      "iam:ListUsers"
    ]
    resources = ["*"]
  }

  # Autorise l'utilisateur à gérer son profil de connexion et ses clés d'accès
  statement {
    sid    = "AllowManageOwnCredentials"
    effect = "Allow"
    actions = [
      "iam:ChangePassword",
      "iam:GetUser",
      "iam:CreateLoginProfile",
      "iam:UpdateLoginProfile",
      "iam:DeleteLoginProfile",
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey"
    ]
    resources = ["arn:aws:iam::*:user/$${aws:username}"]
  }

  # Autorise l'utilisateur à configurer et activer son MFA (rendre facultatif S3 sans bloquer)
  statement {
    sid    = "AllowManageOwnMFA"
    effect = "Allow"
    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:ListMFADevices"
    ]
    resources = [
      "arn:aws:iam::*:mfa/$${aws:username}",
      "arn:aws:iam::*:user/$${aws:username}"
    ]
  }

  # Note : Nous avons retiré la politique de "Deny" globale. L'utilisateur peut 
  # manipuler S3 sans MFA ou activer son MFA plus tard.
}

# ----- IAM Policy : S3 Full Access (avec restriction de région pour création) -----
data "aws_iam_policy_document" "s3_restricted" {

  # Accès à la console et liste
  statement {
    sid    = "AllowListAllBuckets"
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetAccountPublicAccessBlock",
      "s3:GetBucketPublicAccessBlock"
    ]
    resources = ["*"]
  }

  # Autorise la création de bucket mais SEULEMENT sur eu-west-3
  statement {
    sid    = "AllowCreateBucketInRegion"
    effect = "Allow"
    actions = [
      "s3:CreateBucket"
    ]
    resources = ["arn:aws:s3:::*"]

    condition {
      test     = "StringEquals"
      variable = "s3:LocationConstraint"
      values   = [var.region_restriction]
    }
  }

  # Autorise TOUTES les autres actions (versioning, policy, cross-origin, objects...) sur TOUS les buckets
  statement {
    sid    = "AllowS3FullAccess"
    effect = "Allow"
    not_actions = [
      "s3:CreateBucket"
    ]
    resources = [
      "arn:aws:s3:::*",
      "arn:aws:s3:::*/*"
    ]
  }
}

# ----- Attach Policies -----
resource "aws_iam_user_policy" "force_mfa_policy" {
  name   = "ForceMFA"
  user   = aws_iam_user.s3_user.name
  policy = data.aws_iam_policy_document.force_mfa.json
}

resource "aws_iam_user_policy" "s3_access_policy" {
  name   = "S3RestrictedAccess"
  user   = aws_iam_user.s3_user.name
  policy = data.aws_iam_policy_document.s3_restricted.json
}

# ----- AWS Budget (Account Level filtered by User tags/Cost categories if supported) -----
# Ici nous créons un budget générique alertant l'utilisateur
resource "aws_budgets_budget" "s3_user_budget" {
  name              = "Budget-Limit-${var.user_name}"
  budget_type       = "COST"
  limit_amount      = var.budget_limit
  limit_unit        = "USD"
  time_period_start = "2024-01-01_00:00"
  time_unit         = "MONTHLY"

  cost_filter {
    name   = "Service"
    values = ["Amazon Simple Storage Service"]
  }

  # Alerte à 50%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 50
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.user_email]
  }

  # Alerte à 80%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.user_email]
  }

  # Alerte à 100%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.user_email]
  }
}