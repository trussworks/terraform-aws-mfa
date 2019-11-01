Configures IAM policy to enforce MFA when accessing the AWS API.

This configured policy also requires users to assume a role for most API calls.

Creates the following resources:

* IAM policy requiring a valid MFA security token for all API calls except those needed for managing a user's own IAM user.
* IAM group policy attachment for defining which IAM groups to enforce MFA on.
* IAM user policy attachment for defining which IAM users to enforce MFA on.

## Terraform Versions

Terraform 0.12. Pin module version to ~> 2.X. Submit pull-requests to master branch.

Terraform 0.11. Pin module version to ~> 1.X. Submit pull-requests to terraform011 branch.

## Usage

```hcl
module "aws_mfa" {
  source = "trussworks/mfa/aws"

  iam_groups = ["engineers"]
  iam_users  = ["joe"]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| iam\_groups | List of IAM groups to enforce MFA when accessing the AWS API. | list(string) | `[]` | no |
| iam\_users | List of IAM users to enforce MFA when accessing the AWS API. | list(string) | `[]` | no |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
