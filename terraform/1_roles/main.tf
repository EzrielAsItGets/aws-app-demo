# -----------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------

module "ecs_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  create_role = true

  role_name = "${var.project_id}-ecs-role-${var.aws_region_short_names[var.aws_Region]}"

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonECS_FullAccess",
  ]
  number_of_custom_role_policy_arns = 1
}
