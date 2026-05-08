# Busca dinamicamente o ID da conta AWS
data "aws_caller_identity" "current" {}

# 1. Política Inline da EC2 para o S3
data "aws_iam_policy_document" "ec2_s3_policy" {
  statement {
    sid       = "ListarBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.lab_bucket.arn]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["data/processed/*", "data/uploads/*"]
    }
  }

  statement {
    sid       = "LerEscreverObjetos"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = [
      "${aws_s3_bucket.lab_bucket.arn}/data/processed/*",
      "${aws_s3_bucket.lab_bucket.arn}/data/uploads/*"
    ]
  }
}

# 2. Política do Grupo dos Desenvolvedores (SSM + MFA)
data "aws_iam_policy_document" "group_ssm_policy" {
  statement {
    sid       = "PermitirAcessoViaSSMObrigatorioMFA"
    effect    = "Allow"
    actions   = ["ssm:StartSession"]
    resources = [
      aws_instance.lab_ec2.arn,
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:session/*",
      "arn:aws:ssm:*:*:document/SSM-SessionManagerRunShell"
    ]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }

  statement {
    sid       = "PermissoesVisuaisDoConsole"
    effect    = "Allow"
    actions   = [
      "ec2:Describe*",
      "ssm:DescribeInstanceInformation",
      "ssm:GetConnectionStatus",
      "ssm:DescribeSessions"
    ]
    resources = ["*"]
  }
}

# 3. Política de Bloqueio do Bucket S3
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid       = "DenyDirectAccessToEveryoneExceptEC2RoleAndAdmins"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = [
      aws_s3_bucket.lab_bucket.arn,
      "${aws_s3_bucket.lab_bucket.arn}/*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "ArnNotLike"
      variable = "aws:PrincipalArn"
      values = [
        module.ec2_iam_role.role_arn,
        "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/${module.ec2_iam_role.role_name}/*",
        var.admin_arn,
        var.terraform_arn
      ]
    }
  }
}