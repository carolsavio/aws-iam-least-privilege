variable "aws_region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
  default     = "meu-bucket-lab"
}

variable "admin_arn" {
  description = "ARN do seu usuário ADM ou role"
  type        = string
  default = "value" # <- Arn aqui - Exemplo: "arn:aws:iam::111122223333:user/seu-usuario"
  # 
}