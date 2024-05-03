# -----------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region where the resources will be created"
  type        = string
}

variable "project_id" {
  description = "Name of the project"
  type        = string
}

variable "aws_region_short_names" {
  description = "Map of AWS Region names to their shortened forms"
  type        = map(string)
  default = {
    "us-east-1" = "use1"
    "us-west-2" = "usw2"
  }
}
