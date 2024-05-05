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
