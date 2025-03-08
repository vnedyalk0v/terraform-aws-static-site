provider "aws" {
  region = "eu-central-1"
}

# Minimal configuration - just specify the bucket name
module "static_website" {
  source = "../../"

  # Only specify the bucket name
  bucket_name = "my-static-website-bucket-amjqrwcf"
}
