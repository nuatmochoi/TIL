resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "sw-terraform-state-lock-test1"
  force_destroy = true
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-up-and-running-locks-sw"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket         = "sw-terraform-state-lock-test1"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-northeast-2"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
