# -----------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------

output "db_name" {
  value = module.rds_mysql.db_instance_name
}

output "db_endpoint" {
  value = module.rds_mysql.db_instance_endpoint
}

output "db_port" {
  value = module.rds_mysql.db_instance_port
}

output "name" {
  value = module.rds_mysql.db_instance_username
}
