output "database_arn" {
  value = aws_db_instance.rds_instance.arn
}

output "endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}
