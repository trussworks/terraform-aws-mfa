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
  iam_users  = ["jill"]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_group_policy_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user_policy_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_policy_document.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_iam_groups"></a> [iam\_groups](#input\_iam\_groups) | List of IAM groups to enforce MFA when accessing the AWS API. | `list(string)` | `[]` | no |
| <a name="input_iam_users"></a> [iam\_users](#input\_iam\_users) | List of IAM users to enforce MFA when accessing the AWS API. | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

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
