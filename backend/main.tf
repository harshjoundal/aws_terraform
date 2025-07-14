provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_backend" {
  bucket = "terrafrom-backend-eks-state-bucket-harshj"

  tags = {
    Name = "Terraform Backend EKS State Bucket"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_dynamodb_table" "aws_dynamodb_table" {
    name         = "terrafrom-backend-eks-state-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"
    
    attribute {
        name = "LockID"
        type = "S"
    }
    
    tags = {
        Name = "Terraform State Lock Table"
    }
}