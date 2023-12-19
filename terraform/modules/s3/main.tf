resource "aws_s3_bucket" "website_bucket" {
    acl    = "public-read"
    website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "path/to/your/index.html"  // Replace with the actual path to your index.html file
  acl    = "public-read"
}

output "website_bucket_url" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}
