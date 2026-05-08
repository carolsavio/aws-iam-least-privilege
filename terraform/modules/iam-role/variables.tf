variable "role_name" {
  description = "Nome da IAM Role"
  type        = string
}

variable "custom_policy_json" {
  description = "JSON de uma política customizada (opcional)"
  type        = string
  default     = ""
}

variable "managed_policy_arns" {
  description = "Lista de ARNs de políticas gerenciadas pela AWS"
  type        = list(string)
  default     = []
}

variable "create_custom_policy" {
  type    = bool
  default = false
}