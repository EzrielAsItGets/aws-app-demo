# -----------------------------------------------------------------------
# Data Sources
# -----------------------------------------------------------------------

data "terraform_remote_state" "base_workspace" {
  backend = "remote"
  config = {
    organization = "hashicorp"
    workspaces = {
      name = "${var.project_id}-1_base-${var.aws_region_short_names[var.aws_region]}"
    }
  }
}
