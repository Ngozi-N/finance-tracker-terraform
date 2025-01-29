provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.3.0"
  backend "s3" {
    bucket         = "finance-tracker-tfstate"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }
}
