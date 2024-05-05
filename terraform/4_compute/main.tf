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
      port_mappings = [
        {
          name          = "myappcontainerport"
          containerPort = 8080
          protocol      = "tcp"
        },
        {
          name          = "dbport"
          containerPort = data.terraform_remote_state.db_workspace.outputs.db_port
          protocol      = "tcp"
        }
      ]
      log_configuration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/aws/ecs/myapp-ecs-service-use1/myappcontainer"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      },
      environment = [
        {
          name  = "HOST"
          value = data.terraform_remote_state.db_workspace.outputs.db_endpoint
        },
        {
          name  = "USER"
          value = data.terraform_remote_state.db_workspace.outputs.username
        },
        {
          name  = "DBNAME"
          value = data.terraform_remote_state.db_workspace.outputs.db_name
        }
      ],
      secrets = [
        {
          name      = "PASSWORD"
          valueFrom = "${data.terraform_remote_state.db_workspace.outputs.secret_arn}:password::"
        }
      ]
    }
  }
  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups["myappecs"].arn
      container_name   = "myappcontainer"
      container_port   = "8080"
    }
  }
  task_exec_iam_role_arn = data.terraform_remote_state.roles_workspace.outputs.ecs_tasks_role_arn
  tasks_iam_role_arn     = data.terraform_remote_state.roles_workspace.outputs.ecs_tasks_role_arn
  subnet_ids             = data.terraform_remote_state.base_workspace.outputs.vpc_private_subnets
  tags                   = var.common_tags
}

module "alb" {
  source                     = "terraform-aws-modules/alb/aws"
  load_balancer_type         = "application"
  name                       = "${var.project_id}-alb-${var.aws_region_short_names[var.aws_region]}"
  vpc_id                     = data.terraform_remote_state.base_workspace.outputs.vpc_id
  subnets                    = data.terraform_remote_state.base_workspace.outputs.vpc_private_subnets
  create_security_group      = false
  enable_deletion_protection = false
  security_groups            = [data.terraform_remote_state.base_workspace.outputs.default_security_group_id]
  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "myappecs"
      }
    },
    fixed_response = {
      port     = 81
      protocol = "HTTP"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed message"
        status_code  = "200"
      }
    }
  }

  target_groups = {
    myappecs = {
      backend_protocol                  = "HTTP"
      backend_port                      = 8080
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "8080"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }

      # There's nothing to attach here in this definition. Instead,
      # ECS will attach the IPs of the tasks to this target group
      create_attachment = false
    }
  }
}

