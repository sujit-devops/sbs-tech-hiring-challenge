################ Create DynamoDB table to have lock ################ 

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "dynamodb-state-sp-locking"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  depends_on = [ resource.aws_s3_bucket.terraform_state ]
}