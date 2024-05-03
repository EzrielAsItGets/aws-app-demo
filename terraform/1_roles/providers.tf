terraform {
  cloud {
    organization = "ezrielasitgets"
    workspaces {
      tags = []
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


