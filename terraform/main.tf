provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::590184025278:role/s3"
  }
}

resource "aws_s3_bucket" "react_app_bucket" {
  bucket = "my-react-app-bucket-12345"
}

resource "aws_s3_bucket_public_access_block" "react_app_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.react_app_bucket.bucket
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "react_app_bucket_website" {
  bucket = aws_s3_bucket.react_app_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "react_app_bucket_policy" {
  bucket = aws_s3_bucket.react_app_bucket.bucket

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "${aws_s3_bucket.react_app_bucket.arn}/*"
      }
    ]
  })
}

output "bucket_name" {
  value = aws_s3_bucket.react_app_bucket.bucket
}
