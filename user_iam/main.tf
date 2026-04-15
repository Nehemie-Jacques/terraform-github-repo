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

# ----- IAM Policy : Force MFA & Self Management -----
data "aws_iam_policy_document" "force_mfa" {
  # Autorise l'utilisateur à configurer son propre MFA
  statement {
    sid    = "AllowViewAccountInfo"
    effect = "Allow"
    actions = [
      "iam:GetAccountPasswordPolicy",
      "iam:ListVirtualMFADevices"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowManageOwnPasswords"
    effect = "Allow"
    actions = [
      "iam:ChangePassword",
      "iam:GetUser"
    ]
    resources = ["arn:aws:iam::*:user/$${aws:username}"]
  }

  statement {
    sid    = "AllowManageOwnMFA"
    effect = "Allow"
    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice"
    ]
    resources = [
      "arn:aws:iam::*:mfa/$${aws:username}",
      "arn:aws:iam::*:user/$${aws:username}"
    ]
  }

  # Bloque tout accès aux autres services si MFA n'est pas actif
  statement {
    sid    = "DenyAllExceptMFAManagement"
    effect = "Deny"
    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:GetUser",
      "iam:ListVirtualMFADevices",
      "iam:ResyncMFADevice",
      "iam:ChangePassword",
      "iam:GetAccountPasswordPolicy"
    ]
    resources = ["*"]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}

# ----- IAM Policy : S3 Restricted (Moindre Privilège) -----
data "aws_iam_policy_document" "s3_restricted" {

  # Autorise la liste des buckets, mais nécessite MFA
  statement {
    sid    = "AllowListAllBuckets"
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetAccountPublicAccessBlock"
    ]
    resources = ["*"]
  }

  # Autorise la création de bucket mais SEULEMENT sur la région eu-west-3
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

  # Autorise la gestion de bucket et objets seulement sur les buckets qui portent l'identifiant du user dans le nom
  statement {
    sid    = "AllowManageOwnBuckets"
    effect = "Allow"
    actions = [
      "s3:DeleteBucket",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketAcl",
      "s3:PutBucketAcl",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      # Pour les objets
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::${var.user_name}-*",
      "arn:aws:s3:::${var.user_name}-*/*"
    ]
  }

  # Note d'architecture : AWS IAM ne permet PAS de limiter le NOMBRE de buckets.
  # La convention adoptée ici est de les obliger à préfixer le bucket avec leur nom et
  # nous suggérons un audit externe (via Config/Lambda).
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