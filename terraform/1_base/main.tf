# -----------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------

module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  name            = "${var.project_id}-vpc-${var.aws_region_short_names[var.aws_region]}"
  cidr            = "10.0.0.0/16"
  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  tags            = var.common_tags
}
