# Create a DB Subnet Group with at least 2 Availability Zones
resource "aws_db_subnet_group" "finance_tracker_subnet_group" {
  name       = "finance-tracker-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "finance-tracker-db-subnet-group"
  }
}

# Create the RDS Instance
resource "aws_db_instance" "finance_tracker_db" {
  identifier            = "finance-tracker-db"
  engine               = "postgres"
  instance_class       = var.rds_instance_class
  allocated_storage    = 20
  username            = var.rds_username
  password            = var.rds_password
  publicly_accessible  = false
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.finance_tracker_subnet_group.name
  vpc_security_group_ids = [aws_security_group.eks.id]
  multi_az = true  # Ensure high availability by using at least 2 AZs
  db_name = "finance_tracker_db"

  tags = {
    Name = "finance-tracker-db"
  }
}
