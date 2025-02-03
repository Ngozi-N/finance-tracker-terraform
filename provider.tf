provider "aws" {
  region = var.aws_region
}
<<<<<<< HEAD

# store the state file after your S3 bucket 
#terraform {
#  backend "s3" {
#    bucket         = "finance-tracker-tfstate"
#    key            = "finance-tracker/terraform.tfstate"
#    region         = "eu-west-2"
#    encrypt        = true
#    dynamodb_table = "finance-tracker-locks"
#  }
#}
=======
>>>>>>> e0c2728 (Commit files)
