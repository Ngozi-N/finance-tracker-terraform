resource "aws_lb" "finance_tracker" {
  name               = "finance-tracker-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.eks.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false
  tags = { Name = "finance-tracker-alb" }
}
