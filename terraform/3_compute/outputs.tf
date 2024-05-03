# -----------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------

output "ecs_role_arn" {
  value = module.ecs_role.iam_role_arn
}

output "ecs_role_name" {
  value = module.ecs_role.iam_role_name
}
