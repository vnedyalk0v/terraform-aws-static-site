/**
 * # AWS Static Website Terraform Module
 *
 * This module provisions infrastructure for hosting a static website on AWS using S3 and CloudFront.
 */

provider "aws" {
  region = var.region
}

# Create CloudFront distribution first
module "cloudfront" {
  source = "./modules/cloudfront"

  bucket_name                 = var.bucket_name
  bucket_regional_domain_name = "${var.bucket_name}.s3.${var.region}.amazonaws.com"
  bucket_arn                  = "arn:aws:s3:::${var.bucket_name}"
  origin_access_identity_path = "" # Not used with OAC, but kept for backward compatibility
  aliases                     = var.aliases
  acm_certificate_arn         = var.acm_certificate_arn
  price_class                 = var.price_class
  minimum_protocol_version    = var.minimum_protocol_version
  default_root_object         = var.default_root_object
  http_version                = var.http_version
  use_default_cache_policy    = var.use_default_cache_policy
  min_ttl                     = var.min_ttl
  default_ttl                 = var.default_ttl
  max_ttl                     = var.max_ttl
  error_responses             = var.error_responses
  geo_restriction             = var.geo_restriction
  tags                        = var.tags
  enable_waf                  = var.enable_waf
  web_acl_id                  = var.web_acl_id
  enable_logging              = var.enable_cloudfront_logging
  logging_bucket              = var.cloudfront_log_bucket_name
  logging_prefix              = var.cloudfront_log_prefix
  enable_ipv6                 = var.enable_ipv6
  cache_policy_id             = var.cache_policy_id
  origin_request_policy_id    = var.origin_request_policy_id
  response_headers_policy_id  = var.response_headers_policy_id
}

# Then create S3 bucket with CloudFront distribution ARN
module "s3_bucket" {
  source = "./modules/s3"

  region                      = var.region
  bucket_name                 = var.bucket_name
  force_destroy               = var.force_destroy
  tags                        = var.tags
  enable_versioning           = var.enable_versioning
  enable_access_logging       = var.enable_access_logging
  access_log_bucket_name      = var.access_log_bucket_name
  access_log_prefix           = var.access_log_prefix
  block_public_access         = var.block_public_access
  enable_encryption           = var.enable_encryption
  kms_key_arn                 = var.kms_key_arn
  cors_rules                  = var.cors_rules
  lifecycle_rules             = var.lifecycle_rules
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
}
