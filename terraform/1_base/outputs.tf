# -----------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------

output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "ecr_name" {
  value = module.ecr.repository_name
}

output "ecr_url" {
  value = module.ecr.repository_url
}
