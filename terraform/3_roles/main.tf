# -----------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------

# Module for creating an ECS role
module "ecs_role" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  create_role = true
  role_name   = "${var.project_id}-ecs-role-${var.aws_region_short_names[var.aws_region]}"

  # Services allowed to assume the role
  trusted_role_services = ["ecs.amazonaws.com"]

  # Custom IAM policies attached to the role
  custom_role_policy_arns           = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  number_of_custom_role_policy_arns = 1

  # Whether role requires MFA (Multi-Factor Authentication)
  role_requires_mfa = false

  # Tags for resources
  tags = var.common_tags
}

# Module for creating an ECS tasks role
module "ecs_tasks_role" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  create_role = true
  role_name   = "${var.project_id}-ecs-tasks-role-${var.aws_region_short_names[var.aws_region]}"

  # Services allowed to assume the role
  trusted_role_services = ["ecs-tasks.amazonaws.com"]

  # Custom IAM policies attached to the role
  custom_role_policy_arns           = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  number_of_custom_role_policy_arns = 1

  # Whether role requires MFA (Multi-Factor Authentication)
  role_requires_mfa = false

  # Tags for resources
  tags = var.common_tags
}
