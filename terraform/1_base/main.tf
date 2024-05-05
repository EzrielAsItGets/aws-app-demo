# -----------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = "${var.project_id}-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_names = ["PrivateSubnet01", "PrivateSubnet02", "PrivateSubnet03"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnet_names  = ["PublicSubnet01", "PublicSubnet02", "PublicSubnet03"]
  # Cloudwatch log group and IAM role will be created
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  default_security_group_ingress = [
    {
      type      = "ingress"
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      self      = true
    },
    {
      type        = "ingress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  default_security_group_egress = [
    {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  flow_log_max_aggregation_interval         = 60
  flow_log_cloudwatch_log_group_name_prefix = "/aws/myapp-flow-logs/"
  flow_log_cloudwatch_log_group_name_suffix = "test"
  flow_log_cloudwatch_log_group_class       = "STANDARD"
  enable_nat_gateway                        = true
  single_nat_gateway                        = true
  one_nat_gateway_per_az                    = false
  tags                                      = var.common_tags
}

module "ecr" {
  source                            = "terraform-aws-modules/ecr/aws"
  repository_name                   = "aws-app-demo"
  repository_read_write_access_arns = ["arn:aws:iam::988367001939:user/admin"]
  repository_image_tag_mutability   = "MUTABLE"
  repository_force_delete           = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = var.common_tags
}



module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.8.1"
  vpc_id  = module.vpc.vpc_id
  endpoints = {
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "ecrapi-vpc-endpoint" }
    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "ecrdk-vpc-endpoint" }
    },
    s3 = {
      service             = "s3"
      service_type        = "Gateway"
      private_dns_enabled = true
      route_table_ids     = concat(module.vpc.private_route_table_ids, module.vpc.public_route_table_ids)
      tags                = { Name = "s3-vpc-endpoint" }
    },
    logs = {
      service             = "logs"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "logs-vpc-endpoint" }
    },
    secretsmanager = {
      service             = "secretsmanager"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "secretsmanager-vpc-endpoint" }
    },
  }
  tags = var.common_tags
}

