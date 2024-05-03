# -----------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------

output "ecs_cluster_arn" {
  value = module.ecs_cluster_arn.cluster_arn
}

output "ecs_cluster_name" {
  value = module.ecs_cluster_arn.cluster_name
}
