# -----------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------


module "rds_mysql" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.project_id}-mysqldb-${var.aws_region_short_names[var.aws_region]}"

  create_db_option_group    = false
  create_db_parameter_group = false

  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine               = "mysql"
  engine_version       = "8.0"
  family               = "mysql8.0" # DB parameter group
  major_engine_version = "8.0"      # DB option group
  instance_class       = "db.t4g.micro"

  allocated_storage = 200

  db_name  = "myappmysql"
  username = "username"
  port     = 8080

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 0

  tags = var.common_tags
}
