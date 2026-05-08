variable "aws_region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
  default     = "meu-bucket-lab-moira5000"
}

variable "admin_arn" {
  description = "ARN do usuário ADM ou role"
  type        = string
  default     = "arn:aws:iam::111122223333:user/seu-usuario" # <- Arn adm aqui
}

variable "terraform_arn" {
  description = "ARN do Terraform"
  type = string
  default = "arn:aws:iam::111122223333:user/seu-usuario" # <- Arn terraform aqui
}

variable "create_custom_policy" {
  description = "Define se deve criar a política customizada"
  type        = bool
  default     = false
}