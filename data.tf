data "aws_iam_policy_document" "amazoneks_efs_csi_driver_policy_document" {
  count = var.create_role && var.attach_amazoneks_efs_csi_driver_policy ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:CreateAccessPoint"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:DeleteAccessPoint"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
}
