/**
 * # CloudFront Module for Static Website Hosting
 *
 * This module creates a CloudFront distribution for serving a static website from an S3 bucket.
 */

locals {
  s3_origin_id = "S3-${var.bucket_name}"

  # Default cache policy if none is provided
  default_cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized

  # Default origin request policy if none is provided
  default_origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # CORS-S3Origin

  # Default response headers policy if none is provided
  default_response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03" # SecurityHeadersPolicy
}

# Create CloudFront distribution
resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  is_ipv6_enabled     = var.enable_ipv6
  comment             = "CloudFront distribution for ${var.bucket_name}"
  default_root_object = var.default_root_object
  price_class         = var.price_class
  tags                = var.tags
  web_acl_id          = var.enable_waf ? var.web_acl_id : null

  # Alternate domain names (CNAMEs)
  aliases = length(var.aliases) > 0 && var.acm_certificate_arn != null ? var.aliases : []

  # S3 origin configuration
  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = var.origin_access_identity_path
    }
  }

  # Default cache behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    compress         = true

    cache_policy_id            = var.cache_policy_id != null ? var.cache_policy_id : local.default_cache_policy_id
    origin_request_policy_id   = var.origin_request_policy_id != null ? var.origin_request_policy_id : local.default_origin_request_policy_id
    response_headers_policy_id = var.response_headers_policy_id != null ? var.response_headers_policy_id : local.default_response_headers_policy_id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Custom error responses
  dynamic "custom_error_response" {
    for_each = var.error_responses
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }

  # Geo restriction
  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction.restriction_type
      locations        = var.geo_restriction.locations
    }
  }

  # SSL/TLS configuration
  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == null ? true : false
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.acm_certificate_arn == null ? null : "sni-only"
    minimum_protocol_version       = var.acm_certificate_arn == null ? "TLSv1" : var.minimum_protocol_version
  }

  # Access logging
  dynamic "logging_config" {
    for_each = var.enable_logging && var.logging_bucket != null ? [1] : []
    content {
      include_cookies = false
      bucket          = "${var.logging_bucket}.s3.amazonaws.com"
      prefix          = var.logging_prefix
    }
  }
}
