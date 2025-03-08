provider "aws" {
  region = "eu-central-1"
}

module "static_website" {
  source = "../../"

  bucket_name         = "my-static-website-bucket-${random_string.suffix.result}"
  force_destroy       = true
  enable_versioning   = true
  enable_encryption   = true
  block_public_access = true

  # CloudFront settings
  price_class              = "PriceClass_100"
  default_root_object      = "index.html"
  enable_ipv6              = false
  minimum_protocol_version = "TLSv1.2_2021"

  # Custom error responses
  error_responses = [
    {
      error_code            = 404
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 10
    },
    {
      error_code            = 403
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 10
    }
  ]

  # CORS configuration
  cors_rules = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "HEAD"]
      allowed_origins = ["*"]
      expose_headers  = []
      max_age_seconds = 3000
    }
  ]

  # Tags
  tags = {
    Environment = "dev"
    Project     = "static-website"
    Terraform   = "true"
  }
}

# Generate a random suffix for the S3 bucket name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
