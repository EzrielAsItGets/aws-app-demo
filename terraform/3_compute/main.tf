# -----------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------

module "ecs_cluster" {
  source       = "terraform-aws-modules/ecs/aws"
  cluster_name = "${var.project_id}-ecs-cluster-${var.aws_region_short_names[var.aws_region]}"

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
        base   = 20
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  tags = var.common_tags
}

module "ecs_task_definition" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  # Service
  name        = "${var.project_id}-ecs-service-${var.aws_region_short_names[var.aws_region]}"
  cluster_arn = module.ecs_cluster.cluster_arn

  # Task Definition
  volume = {
    ex-vol = {}
  }

  runtime_platform = {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  # Container definition(s)
  container_definitions = {
    al2023 = {
      image = "public.ecr.aws/amazonlinux/amazonlinux:2023-minimal"

      mount_points = [
        {
          sourceVolume  = "ex-vol",
          containerPath = "/var/www/ex-vol"
        }
      ]

      command    = ["echo hello world"]
      entrypoint = ["/usr/bin/sh", "-c"]
    }
  }

  subnet_ids = data.terraform_remote_state.base_workspace.outputs.vpc_private_subnets.value

  security_group_rules = {
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = var.common_tags
}

