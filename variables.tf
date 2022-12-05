variable "iam_groups" {
  description = "List of IAM groups to enforce MFA when accessing the AWS API."
  type        = list(string)
  default     = []
}

variable "iam_users" {
  description = "List of IAM users to enforce MFA when accessing the AWS API."
  type        = list(string)
  default     = []
}
