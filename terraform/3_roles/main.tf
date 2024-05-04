# -----------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------

module "ecs_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  create_role           = true
  role_name             = "${var.project_id}-ecs-role-${var.aws_region_short_names[var.aws_region]}"
  trusted_role_services = ["ecs.amazonaws.com"]
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  number_of_custom_role_policy_arns = 1
  tags                              = var.common_tags
}

module "ecs_tasks_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  create_role           = true
  role_name             = "${var.project_id}-ecs-tasks-role-${var.aws_region_short_names[var.aws_region]}"
  trusted_role_services = ["ecs-tasks.amazonaws.com"]
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  number_of_custom_role_policy_arns = 1
  tags                              = var.common_tags
}
