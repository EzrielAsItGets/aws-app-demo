# -----------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------

output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecr_name" {
  value = module.ecr.repository_name
}

output "ecr_url" {
  value = module.ecr.repository_url
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}
