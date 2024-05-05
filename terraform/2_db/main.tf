# -----------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------

# Module for creating an RDS MySQL database
module "rds_mysql" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.project_id}-mysqldb-${var.aws_region_short_names[var.aws_region]}"

  # Configuration for creating DB subnet group
  create_db_subnet_group = true
  subnet_ids             = data.terraform_remote_state.base_workspace.outputs.vpc_private_subnets

  # Configuration for not creating DB option and parameter groups
  create_db_option_group    = false
  create_db_parameter_group = false

  # Database engine and version
  engine               = "mysql"
  engine_version       = "8.0"
  family               = "mysql8.0"
  major_engine_version = "8.0"

  # Instance type and storage settings
  instance_class    = "db.t4g.micro"
  allocated_storage = 200

  # Database configuration
  db_name  = "myappmysql"
  username = "username"

  # Maintenance and backup windows
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 0

  # Tags for resources
  tags = var.common_tags
}
