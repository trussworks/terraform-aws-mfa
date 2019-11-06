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
  source = "trussworks/mfa/aws"

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

## Terraform Versions

Terraform 0.12. Pin module version to ~> 2.x Submit pull-requests to master branch.

Terraform 0.11. Pin module version to ~> 1.5.1. Submit pull-requests to terraform011 branch.

## Developer Setup

Install dependencies (macOS)

```shell
brew install pre-commit go terraform terraform-docs
```

### Testing

[Terratest](https://github.com/gruntwork-io/terratest) is being used for
automated testing with this module. Tests in the `test` folder can be run
locally by running the following command:

```text
make test
```

Or with aws-vault:

```text
AWS_VAULT_KEYCHAIN_NAME=<NAME> aws-vault exec <PROFILE> -- make test
```
