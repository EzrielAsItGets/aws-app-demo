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
  tags                 = var.common_tags
}

module "ecr" {
  source                            = "terraform-aws-modules/ecr/aws"
  repository_name                   = "aws-app-demo"
  repository_read_write_access_arns = ["arn:aws:iam::988367001939:user/admin"]
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



module "vpc_vpc-endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.8.1"
  vpc_id  = module.vpc.vpc_id
  endpoints = {
    s3 = {
      # interface endpoint
      service = "ecr"
      tags    = { Name = "s3-vpc-endpoint" }
    }
  }
  tags = var.common_tags
}

