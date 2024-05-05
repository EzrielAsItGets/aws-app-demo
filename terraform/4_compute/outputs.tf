# -----------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------

output "ecs_cluster_arn" {
  value = module.ecs_cluster.cluster_arn
}

output "ecs_cluster_name" {
  value = module.ecs_cluster.cluster_name
}

output "ecs_container_name" {
  value = module.ecs_task_definition.container_definitions
}

output "ecs_service_name" {
  value = module.ecs_task_definition.name
}

output "alb_dns" {
  value = module.alb.dns_name
}
