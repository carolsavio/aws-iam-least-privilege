data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Anexa a política customizada (se você passar alguma)
resource "aws_iam_role_policy" "custom_policy" {
  count = var.create_custom_policy ? 1 : 0
  name   = "${var.role_name}-CustomPolicy"
  role   = aws_iam_role.this.id
  policy = var.custom_policy_json
}

# Anexa políticas gerenciadas da AWS (como o SSM)
resource "aws_iam_role_policy_attachment" "managed_policies" {
  count      = length(var.managed_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = var.managed_policy_arns[count.index]
}

# Cria o Perfil de Instância necessário para a EC2 assumir a Role
resource "aws_iam_instance_profile" "this" {
  name = "${var.role_name}-Profile"
  role = aws_iam_role.this.name
}