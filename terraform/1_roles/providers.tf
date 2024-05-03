terraform {
  backend "remote" {
    organization = "ezrielasitgets"
    workspaces {
      prefix = "myapp-1_roles-${var.aws_region}"
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


