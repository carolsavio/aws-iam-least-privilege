# --- S3 BUCKET ----
resource "aws_s3_bucket" "lab_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "lab_bucket_pab" {
  bucket                  = aws_s3_bucket.lab_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "lab_bucket_policy" {
  bucket     = aws_s3_bucket.lab_bucket.id
  policy     = data.aws_iam_policy_document.bucket_policy.json
  depends_on = [aws_s3_bucket_public_access_block.lab_bucket_pab]
}

# --- EC2 INSTANCE ---
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "lab_ec2" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  iam_instance_profile        = module.ec2_iam_role.instance_profile_name
  associate_public_ip_address = true 

  tags = {
    Name = "minha-instancia-lab"
  }
}

# --- IAM GROUP & USER ---
resource "aws_iam_group" "dev_group" {
  name = "Developers"
}

resource "aws_iam_policy" "group_policy" {
  name   = "Acesso-SSM-Devs"
  policy = data.aws_iam_policy_document.group_ssm_policy.json
}

resource "aws_iam_group_policy_attachment" "dev_group_attach" {
  group      = aws_iam_group.dev_group.name
  policy_arn = aws_iam_policy.group_policy.arn
}

resource "aws_iam_user" "dev_user" {
  name = "dev-user"
}

resource "aws_iam_user_group_membership" "dev_user_membership" {
  user   = aws_iam_user.dev_user.name
  groups = [aws_iam_group.dev_group.name]
}

module "ec2_iam_role" {           
  source              = "./modules/iam-role"
  role_name           = "EC2-S3-Role"
  create_custom_policy = true
  custom_policy_json  = data.aws_iam_policy_document.ec2_s3_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}