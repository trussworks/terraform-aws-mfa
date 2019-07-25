<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Configures IAM policy to enforce MFA when accessing the AWS API.

This configured policy also requires users to assume a role for most API calls.

Creates the following resources:

* IAM policy requiring a valid MFA security token for all API calls except those needed for managing a user's own IAM user.
* IAM group policy attachment for defining which IAM groups to enforce MFA on.
* IAM user policy attachment for defining which IAM users to enforce MFA on.

## Usage

```hcl
module "aws_mfa" {
  source = "trussworks/logs/mfa"

  iam_groups = ["engineers"]
  iam_users  = ["joe"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| iam\_groups | List of IAM groups to enforce MFA when accessing the AWS API. | list | `[]` | no |
| iam\_users | List of IAM users to enforce MFA when accessing the AWS API. | list | `[]` | no |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
