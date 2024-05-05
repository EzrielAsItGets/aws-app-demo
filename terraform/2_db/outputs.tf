# -----------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------

output "db_name" {
  value = module.rds_mysql.db_instance_name
}

output "db_endpoint" {
  value = split(":", module.rds_mysql.db_instance_endpoint)[0]
}

output "db_port" {
  value = module.rds_mysql.db_instance_port
}

output "username" {
  value = module.rds_mysql.db_instance_username
}

output "secret_arn" {
  value = module.rds_mysql.db_instance_master_user_secret_arn
}
