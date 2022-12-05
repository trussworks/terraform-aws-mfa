/**
 * Configures IAM policy to enforce MFA when accessing the AWS API.
 *
 * This configured policy also requires users to assume a role for most API calls.
 *
 * Creates the following resources:
 *
 * * IAM policy requiring a valid MFA security token for all API calls except those needed for managing a user's own IAM user.
 * * IAM group policy attachment for defining which IAM groups to enforce MFA on.
 * * IAM user policy attachment for defining which IAM users to enforce MFA on.
 *
 * ## Usage
 *
 * ```hcl
 * module "aws_mfa" {
 *   source = "trussworks/mfa/aws"
 *
 *   iam_groups = ["engineers"]
 *   iam_users  = ["jill"]
 * }
 * ```
 */

data "aws_partition" "current" {
}

data "aws_iam_policy_document" "main" {
  statement {
    sid    = "AllowAllUsersToListAccounts"
    effect = "Allow"

    actions = [
      "iam:ListAccountAliases",
      "iam:ListUsers",
      "iam:ListVirtualMFADevices",
      "iam:GetAccountPasswordPolicy",
      "iam:GetAccountSummary",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "AllowIndividualUserToSeeAndManageOnlyTheirOwnAccountInformation"
    effect = "Allow"

    actions = [
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:DeleteLoginProfile",
      "iam:GetLoginProfile",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey",
      "iam:ListSigningCertificates",
      "iam:DeleteSigningCertificate",
      "iam:UpdateSigningCertificate",
      "iam:UploadSigningCertificate",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:iam::*:user/&{aws:username}",
    ]
  }

  statement {
    sid    = "AllowIndividualUserToListOnlyTheirOwnMFA"
    effect = "Allow"

    actions = [
      "iam:ListMFADevices",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:iam::*:mfa/*",
      "arn:${data.aws_partition.current.partition}:iam::*:user/&{aws:username}",
    ]
  }

  statement {
    sid    = "AllowIndividualUserToManageTheirOwnMFA"
    effect = "Allow"

    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:iam::*:mfa/&{aws:username}",
      "arn:${data.aws_partition.current.partition}:iam::*:user/&{aws:username}",
    ]
  }

  statement {
    sid    = "AllowIndividualUserToDeactivateOnlyTheirOwnMFAOnlyWhenUsingMFA"
    effect = "Allow"

    actions = [
      "iam:DeactivateMFADevice",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:iam::*:mfa/&{aws:username}",
      "arn:${data.aws_partition.current.partition}:iam::*:user/&{aws:username}",
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }

  statement {
    # Since this statement uses not_actions, it effectively blocks some statements
    # that do not support MFA, such as sts:GetFederationToken.
    # Therefore, this policy effectively forbids directly calling AWS APIs
    # without assuming a role first.
    sid = "BlockMostAccessUnlessSignedInWithMFA"

    effect = "Deny"

    # not_actions is a list of actions that this statement does not apply to.
    # Used to apply a policy statement to all actions except those listed.
    not_actions = [
      "iam:ChangePassword",
      "iam:CreateLoginProfile",
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:ListVirtualMFADevices",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:ListAccountAliases",
      "iam:ListUsers",
      "iam:ListSSHPublicKeys",
      "iam:ListAccessKeys",
      "iam:ListServiceSpecificCredentials",
      "iam:ListMFADevices",
      "iam:GetAccountSummary",
      "sts:GetSessionToken",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}

resource "aws_iam_policy" "main" {
  #Use alphanumeric and '+=,.@-_' characters. Maximum 128 characters.
  name        = "enforce-mfa"
  path        = "/"
  description = "Requires valid MFA security token for all API calls except those needed for managing a user's own IAM user."
  policy      = data.aws_iam_policy_document.main.json
}

resource "aws_iam_group_policy_attachment" "main" {
  count      = length(var.iam_groups)
  group      = element(var.iam_groups, count.index)
  policy_arn = aws_iam_policy.main.arn
}

resource "aws_iam_user_policy_attachment" "main" {
  count      = length(var.iam_users)
  user       = element(var.iam_users, count.index)
  policy_arn = aws_iam_policy.main.arn
}
