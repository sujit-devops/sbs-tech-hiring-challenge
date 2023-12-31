
/*
terraform {
  backend "s3" {
    bucket         = "jshsflaksjflwffjfsuji1112-terraform-state"
    key            = "Users/sujit/sbs-tech-hiring-challenge-sample/terraform/terraform.tfstate"
    encrypt        = true
    region         = "us-east-1"
    dynamodb_table = "dynamodb-state-locking"
  }
}
*/


################ Create S3 bucket to store terraform state ################ 
resource "aws_s3_bucket" "terraform_state" {
  bucket = "jshsflaksjflwffjfsuji1112-terraform-state"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  } 
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
  depends_on = [ resource.aws_s3_bucket.terraform_state ]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
  depends_on = [ resource.aws_s3_bucket.terraform_state ]
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on = [ resource.aws_s3_bucket.terraform_state ]
}