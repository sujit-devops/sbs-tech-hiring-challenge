################  S3 static website bucket ######################## 

resource "aws_s3_bucket" "my-static-website" {
  bucket = "my-static-website46551jaffsfwerdjdf" # give a unique bucket name
  tags = {
    Name = "my-static-website"
  }
}

resource "aws_s3_bucket_public_access_block" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  depends_on = [ resource.aws_s3_bucket.my-static-website ]
}

resource "aws_s3_bucket_website_configuration" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
  depends_on = [ resource.aws_s3_bucket.my-static-website ]
}

# S3 bucket ACL access

resource "aws_s3_bucket_ownership_controls" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [ resource.aws_s3_bucket.my-static-website ]
}



resource "aws_s3_bucket_acl" "my-static-website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.my-static-website,
    aws_s3_bucket_public_access_block.my-static-website,
  ]

  bucket = aws_s3_bucket.my-static-website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "my-static-website" {
  bucket = aws_s3_bucket.this.id
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": {
        "Sid": "AllowCloudFrontServicePrincipalReadOnly",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "${aws_s3_bucket.my-static-website.arn}/*",
        "Condition": {
            "StringEquals": {
                "AWS:SourceArn": "${aws_cloudfront_distribution.my-static-website.arn}"
            }
        }
    }
}    
  EOF
}

resource "aws_s3_object" "image_object" {
  bucket  = aws_s3_bucket.my-static-website.bucket
  key    = "sbs-world-cup-image"
  acl    = "public-read"  # To make the object public
  source = "/Users/sujit/sbs-tech-hiring-challenge-sample/sbs-world-cup.jpeg"
}
