data "aws_iam_policy_document" "secrets" {
  count = var.create_role && var.attach_secrets_policy ? 1 : 0

  statement {
    actions = [
      "secretsmanager:ListSecrets",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "ssm:DescribeParameters",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "kms:Decrypt",
      "kms:GetKeyRotationStatus",
      "kms:GetKeyPolicy",
      "kms:DescribeKey",
    ]
    resources = ["*"]
  }

}

resource "aws_iam_policy" "secrets" {
  count = var.create_role && var.attach_secrets_policy ? 1 : 0

  name_prefix = "${var.policy_name_prefix}Secrets_Policy-"
  path        = var.role_path
  description = "Provides permissions for IRSA attached to a kubernetes SA to get secrets from AWS SSM and AWS Secrets Manager"
  policy      = data.aws_iam_policy_document.secrets[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "secrets" {
  count = var.create_role && var.attach_secrets_policy ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.secrets[0].arn
}

resource "aws_iam_policy" "amazoneks_efs_csi_driver_policy" {
  count       = var.create_role && var.attach_amazoneks_efs_csi_driver_policy ? 1 : 0
  name_prefix = "${var.policy_name_prefix}EKS_EFS_CSI_Drive_Policy-"
  path        = var.role_path
  policy      = data.aws_iam_policy_document.amazoneks_efs_csi_driver_policy_document[0].json
  description = "Provides policy that allows the CSI driver’s service account to make calls to AWS APIs on your behalf"
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "amazoneks_efs_csi_driver_policy_attachment" {
  count      = var.create_role && var.attach_amazoneks_efs_csi_driver_policy ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.amazoneks_efs_csi_driver_policy[0].arn
}


