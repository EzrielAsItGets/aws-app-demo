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
  source                    = "terraform-aws-modules/ecs/aws//modules/service"
  name                      = "${var.project_id}-ecs-service-${var.aws_region_short_names[var.aws_region]}"
  cluster_arn               = module.ecs_cluster.cluster_arn
  create_iam_role           = false
  create_security_group     = false
  create_service            = true
  create_task_definition    = true
  create_task_exec_policy   = false
  create_task_exec_iam_role = false
  create_tasks_iam_role     = false
  security_group_ids        = [data.terraform_remote_state.base_workspace.outputs.default_security_group_id]
  iam_role_arn              = data.terraform_remote_state.roles_workspace.outputs.ecs_role_arn
  container_definitions = {
    myappcontainer = {
      image      = "988367001939.dkr.ecr.us-east-1.amazonaws.com/aws-app-demo:latest"
      command    = ["node", "server.js"]
      entrypoint = ["/bin/sh", "-c"]
    },
    log_configuration = {
      logDriver = "awslogs"
    },
    environment = {
      HOST   = data.terraform_remote_state.db_workspace.outputs.db_endpoint
      USER   = data.terraform_remote_state.db_workspace.outputs.username
      DBNAME = data.terraform_remote_state.db_workspace.outputs.db_name
    },
    secrets = {
      name      = "PASSWORD"
      valueFrom = data.terraform_remote_state.db_workspace.outputs.secret_arn
    }
  }
  task_exec_iam_role_arn = data.terraform_remote_state.roles_workspace.outputs.ecs_tasks_role_arn
  tasks_iam_role_arn     = data.terraform_remote_state.roles_workspace.outputs.ecs_tasks_role_arn
  subnet_ids             = data.terraform_remote_state.base_workspace.outputs.vpc_private_subnets
  tags                   = var.common_tags
}

