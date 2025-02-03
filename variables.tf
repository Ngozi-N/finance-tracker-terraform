variable "aws_region" {
  default = "eu-west-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "eks_cluster_name" {
  default = "finance-tracker-eks"
}

variable "rds_instance_class" {
  default = "db.t3.micro"
}

variable "rds_username" {
  default = "finance_user"
}

variable "rds_password" {
  default = "securepassword123!"
}

variable "s3_bucket_name" {
  default = "finance-tracker-uploads"
}

variable "ssh_key_name" {
  description = "SSH key name for accessing worker nodes"
  default     = "mytest_keypair"
}

variable "rds_database" {
  description = "The name of the PostgreSQL database"
  type        = string
  default     = "finance_tracker"  # Change this if needed
}
