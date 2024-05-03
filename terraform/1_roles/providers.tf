terraform {
  backend "remote" {
    organization = "ezrielasitgets"
    workspaces {
      prefix = "myapp-1_roles-"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.47.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


