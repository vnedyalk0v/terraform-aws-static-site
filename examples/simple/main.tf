provider "aws" {
  region = "eu-central-1"
}

# Generate a random suffix for the S3 bucket name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Minimal configuration - just specify the bucket name
module "static_website" {
  source = "../../"

  # Only specify the bucket name
  bucket_name = "my-static-website-bucket-${random_string.suffix.result}"
}
