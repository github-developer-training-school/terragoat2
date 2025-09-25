// Demo Terraform configuration for Trivy plan scanning
// This is intentionally self-contained and does not require real cloud credentials
// to generate a plan file. It's safe to keep in the repository for demos.

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "us-west-2"
  # No credentials are set here on purpose. 'terraform plan' will still produce
  # a plan for this static resource (Terraform may warn about unknown credentials
  # depending on your providers and terraform version).
}

resource "aws_s3_bucket" "trivy_demo_public_bucket" {
  bucket = "trivy-demo-example-bucket-terraform-plan"
  acl    = "public-read"
  
  tags = {
    Environment = "trivy-demo"
    Purpose     = "trivy-plan-demo"
  }
}

# Separate versioning resource (preferred over inline 'versioning' block)
resource "aws_s3_bucket_versioning" "trivy_demo_versioning" {
  bucket = aws_s3_bucket.trivy_demo_public_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
