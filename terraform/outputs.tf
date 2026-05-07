output "instance_id" {
  description = "ID da Instância EC2"
  value       = aws_instance.lab_ec2.id
}

output "bucket_name" {
  description = "Nome do Bucket S3"
  value       = aws_s3_bucket.lab_bucket.id
}