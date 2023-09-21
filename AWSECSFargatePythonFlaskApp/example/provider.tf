terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"
  default_tags {
    tags = {
      Environment  = "Development"
      Project_name = "Monitoring-App"
    }
  }
}
