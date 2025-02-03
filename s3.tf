# Create an S3 bucket for storing application files (user uploads, reports, etc.)
resource "aws_s3_bucket" "finance_tracker_uploads" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "finance-tracker-uploads"
  }
}

# Enable versioning for backup and rollback
resource "aws_s3_bucket_versioning" "finance_tracker_uploads_versioning" {
  bucket = aws_s3_bucket.finance_tracker_uploads.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access for security
resource "aws_s3_bucket_public_access_block" "finance_tracker_uploads" {
  bucket = aws_s3_bucket.finance_tracker_uploads.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Define a stricter S3 bucket policy for security (Only allow the application to access it)
# IAM Policy for S3 Bucket Access
resource "aws_iam_policy" "finance_tracker_s3_policy" {
  name        = "finance-tracker-s3-policy"
  description = "Allows the application to access the S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = "${aws_s3_bucket.finance_tracker_uploads.arn}/*"
      }
    ]
  })
}

# Attach the IAM Policy to the Application Role
resource "aws_iam_policy_attachment" "app_s3_policy" {
  name       = "app-s3-policy-attachment"
  roles      = [aws_iam_role.application_role.name]
  policy_arn = aws_iam_policy.finance_tracker_s3_policy.arn 
}


# IAM Role for Application to Access the S3 Bucket
resource "aws_iam_role" "application_role" {
  name = "finance-tracker-app-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

