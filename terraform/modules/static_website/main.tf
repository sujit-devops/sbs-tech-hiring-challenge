################  S3 static website bucket ######################## 

resource "aws_s3_bucket" "my-static-website" {
  bucket = "my-static-website46551jaffsfwerdjdf"

  tags = {
    Name = "my-static-website"
  }
}

resource "aws_s3_bucket_website_configuration" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

  depends_on = [resource.aws_s3_bucket.my-static-website]
}

resource "aws_s3_bucket_ownership_controls" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  depends_on = [aws_s3_bucket.my-static-website]
}

resource "aws_s3_bucket_public_access_block" "my-static-website" {
  bucket                  = aws_s3_bucket.my-static-website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  depends_on = [aws_s3_bucket.my-static-website]
}

# S3 bucket ACL access

resource "aws_s3_bucket_acl" "my-static-website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.my-static-website,
    aws_s3_bucket_public_access_block.my-static-website,
  ]

  bucket = aws_s3_bucket.my-static-website.id
  acl    = "public-read"
}

resource "aws_s3_object" "image_object" {
  bucket  = aws_s3_bucket.my-static-website.bucket
  key     = "sbs-world-cup-image"
  acl     = "public-read"
  source  = "/Users/sujit/sbs-tech-hiring-challenge-sample/sbs-world-cup.jpeg"
}
  