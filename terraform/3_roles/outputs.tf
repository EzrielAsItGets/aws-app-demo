# -----------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------

output "ecs_role_arn" {
  value = module.ecs_role.iam_role_arn
}

output "ecs_role_name" {
  value = module.ecs_role.iam_role_name
}

output "ecs_tasks_role_arn" {
  value = module.ecs_tasks_role.iam_role_arn
}

output "ecs_tasks_role_name" {
  value = module.ecs_tasks_role.iam_role_name
}
