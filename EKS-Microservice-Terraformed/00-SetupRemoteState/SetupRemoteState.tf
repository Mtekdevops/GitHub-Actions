# Terraform Block
terraform {
  required_version = ">= 1.0" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.63.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1" #could be set by a variable..hardcoded for test simplicity.
}


resource "aws_s3_bucket" "tfbucket" {
  bucket = "tfstate-mtekdevops"
}

resource "aws_dynamodb_table" "tabledev" {
  name     = "tflockDDB-mtekdevops-dev"
  hash_key = "LockID"
  attribute {
      name = "LockID"
      type = "S"
    }

  billing_mode = "PAY_PER_REQUEST"
  point_in_time_recovery {
    enabled = true
  }
}


output "tfstatebucket" {
  description = "ID of the created TF State Bucket"
  value       = aws_s3_bucket.tfbucket.id
}

output "tflockDDBdev" {
  description = "name of the dev DDB state table"
  value       = aws_dynamodb_table.tabledev.id 
}