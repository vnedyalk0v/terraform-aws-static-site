# Simple Static Website Example

This example demonstrates how to use the static website module to create a basic static website hosted on AWS using S3 and CloudFront.

## Usage

### Minimal Configuration

You can deploy the entire infrastructure with just a bucket name:

```hcl
module "static_website" {
  source = "github.com/your-username/terraform-aws-static-site"

  bucket_name = "my-static-website-bucket"
}
```

That's it! The module will use sensible defaults for all other settings, including:

- CORS configuration optimized for static websites
- S3 bucket with versioning enabled
- CloudFront distribution with OAC for secure S3 access
- Server-side encryption for the S3 bucket
- Block public access for the S3 bucket
- Default tags (Environment = "dev", Project = "static-website", ManagedBy = "Terraform")

### Full Configuration

For more control, you can customize any aspect of the infrastructure:

```hcl
module "static_website" {
  source = "github.com/your-username/terraform-aws-static-site"

  # Specify the AWS region for the S3 bucket
  region = "eu-central-1"  # This can be different from your provider's region

  # Basic configuration
  bucket_name         = "my-static-website-bucket"
  force_destroy       = true
  enable_versioning   = true
  enable_encryption   = true
  block_public_access = true

  # CloudFront settings
  price_class              = "PriceClass_100"
  default_root_object      = "index.html"
  enable_ipv6              = true
  minimum_protocol_version = "TLSv1.2_2021"
  http_version             = "http2and3"

  # Cache settings - choose one approach:

  # Option 1: Use default cache policy (CachingOptimized)
  use_default_cache_policy = true

  # Option 2: Use custom TTL settings
  # use_default_cache_policy = false
  # min_ttl     = 0
  # default_ttl = 300
  # max_ttl     = 600

  # Option 3: Use your own cache policy
  # use_default_cache_policy = false
  # cache_policy_id = aws_cloudfront_cache_policy.custom_policy.id

  # Custom error responses for SPA (Single Page Application)
  error_responses = [
    {
      error_code            = 404
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 10
    }
  ]

  # Tags
  tags = {
    Environment = "production"
    Project     = "my-website"
    ManagedBy   = "Terraform"
    Owner       = "DevOps Team"
  }
}
```

## Cache Policy Options

The module provides flexible caching options with sensible defaults:

1. **Default Cache Policy (Default)**: By default, the module uses AWS's managed CachingOptimized policy, which is optimized for static website hosting. You don't need to specify anything for this option.

2. **Custom Cache Policy**: If you want to use your own cache policy, create it as a separate resource and pass its ID:

   ```hcl
   resource "aws_cloudfront_cache_policy" "custom_policy" {
     name        = "CustomCachePolicy"
     comment     = "Custom cache policy for static website"
     default_ttl = 300
     max_ttl     = 600
     min_ttl     = 0

     # Cache key settings
     parameters_in_cache_key_and_forwarded_to_origin {
       cookies_config {
         cookie_behavior = "none"
       }
       headers_config {
         header_behavior = "none"
       }
       query_strings_config {
         query_string_behavior = "none"
       }
       enable_accept_encoding_gzip   = true
       enable_accept_encoding_brotli = true
     }
   }

   module "static_website" {
     # ... other settings ...
     use_default_cache_policy = false
     cache_policy_id          = aws_cloudfront_cache_policy.custom_policy.id
   }
   ```

3. **Custom TTL Settings**: If you want to directly specify TTL values without using a cache policy:
   ```hcl
   module "static_website" {
     # ... other settings ...
     use_default_cache_policy = false
     min_ttl                  = 0
     default_ttl              = 300
     max_ttl                  = 600
   }
   ```

## Features Demonstrated

- Basic S3 bucket configuration for static website hosting
- CloudFront distribution with Origin Access Control (OAC)
- Custom region selection for the S3 bucket
- Security best practices (encryption, block public access)
- CloudFront configuration with HTTP/3 support
- SPA (Single Page Application) support with custom error responses
- Flexible caching options

## Notes

- The S3 bucket region can be specified independently of the AWS provider's region
- CloudFront is a global service, so its region is always `us-east-1`
- The ACM certificate for custom domains must be in `us-east-1` for use with CloudFront
