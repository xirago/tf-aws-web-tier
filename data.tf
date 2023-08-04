data "aws_availability_zones" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Lookup latest Amazon Linux version
data "aws_ami" "awslinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Generate IAM policies as data resources
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    sid     = "assumeRole"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Permit ASG instances to lookup uo DB credentials
data "aws_iam_policy_document" "asm_access" {
  statement {
    actions = ["secretsmanagr:GetSecretValue", "kms:Decrypt"]
    effect  = "Allow"
    sid     = "SecretsAccess"

    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.shortname}/*"
    ]
  }
}
