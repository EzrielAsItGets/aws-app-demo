# -----------------------------------------------------------------------
# Data Sources
# -----------------------------------------------------------------------

# Data source for retrieving information from the base workspace
data "terraform_remote_state" "base_workspace" {
  backend = "remote"
  config = {
    organization = "ezrielasitgets"
    workspaces = {
      name = "${var.project_id}-1_base-${var.aws_region}"
    }
  }
}

# Data source for retrieving information from the database workspace
data "terraform_remote_state" "db_workspace" {
  backend = "remote"
  config = {
    organization = "ezrielasitgets"
    workspaces = {
      name = "${var.project_id}-2_db-${var.aws_region}"
    }
  }
}

# Data source for retrieving information from the roles workspace
data "terraform_remote_state" "roles_workspace" {
  backend = "remote"
  config = {
    organization = "ezrielasitgets"
    workspaces = {
      name = "${var.project_id}-3_roles-${var.aws_region}"
    }
  }
}
