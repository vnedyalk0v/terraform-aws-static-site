variable "region" {
  description = "The AWS region to deploy the S3 bucket"
  type        = string
  default     = "us-east-1" # Default to us-east-1 as it's required for CloudFront certificates
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create for static website hosting"
  type        = string
}

variable "force_destroy" {
  description = "Whether to force destroy the bucket even if it contains objects"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources (defaults will be used if not provided)"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "static-website"
    ManagedBy   = "Terraform"
  }
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_access_logging" {
  description = "Enable access logging for the S3 bucket"
  type        = bool
  default     = false
}

variable "access_log_bucket_name" {
  description = "Name of the S3 bucket to store access logs"
  type        = string
  default     = null
}

variable "access_log_prefix" {
  description = "Prefix for the access logs"
  type        = string
  default     = "logs/"
}

variable "block_public_access" {
  description = "Enable S3 block public access"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable server-side encryption for the S3 bucket"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN of the KMS key to use for encryption (if null, uses Amazon S3-managed keys (SSE-S3))"
  type        = string
  default     = null
}

variable "cors_rules" {
  description = "CORS rules for the S3 bucket"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "HEAD"]
      allowed_origins = ["*"]
      expose_headers  = []
      max_age_seconds = 3000
    }
  ]
}

variable "lifecycle_rules" {
  description = "Lifecycle rules for the S3 bucket"
  type = list(object({
    id                                          = string
    enabled                                     = bool
    prefix                                      = string
    expiration_days                             = number
    noncurrent_version_expiration_days          = number
    noncurrent_version_transition_days          = number
    noncurrent_version_transition_storage_class = string
  }))
  default = []
}

variable "aliases" {
  description = "List of CNAME aliases to be used in CloudFront"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate to use for CloudFront (must be in us-east-1 for CloudFront)"
  type        = string
  default     = null
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100" # Use only North America and Europe
  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.price_class)
    error_message = "Price class must be one of PriceClass_100, PriceClass_200, or PriceClass_All."
  }
}

variable "minimum_protocol_version" {
  description = "Minimum TLS version for CloudFront viewer connections"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "default_root_object" {
  description = "Object that CloudFront will return when root URL is requested"
  type        = string
  default     = "index.html"
}

variable "error_responses" {
  description = "Custom error responses for CloudFront"
  type = list(object({
    error_code            = number
    response_code         = number
    response_page_path    = string
    error_caching_min_ttl = number
  }))
  default = [
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
}

variable "geo_restriction" {
  description = "CloudFront geo restriction configuration"
  type = object({
    restriction_type = string
    locations        = list(string)
  })
  default = {
    restriction_type = "none"
    locations        = []
  }
}

variable "enable_waf" {
  description = "Enable AWS WAF for CloudFront"
  type        = bool
  default     = false
}

variable "web_acl_id" {
  description = "ID of the AWS WAF web ACL to associate with CloudFront"
  type        = string
  default     = null
}

variable "enable_cloudfront_logging" {
  description = "Enable CloudFront access logging"
  type        = bool
  default     = false
}

variable "cloudfront_log_bucket_name" {
  description = "Name of the S3 bucket to store CloudFront access logs"
  type        = string
  default     = null
}

variable "cloudfront_log_prefix" {
  description = "Prefix for the CloudFront access logs"
  type        = string
  default     = "cloudfront-logs/"
}

variable "enable_ipv6" {
  description = "Enable IPv6 support for CloudFront"
  type        = bool
  default     = false
}

variable "use_default_cache_policy" {
  description = "Whether to use the default cache policy (CachingOptimized) or custom TTL settings"
  type        = bool
  default     = true
}

variable "cache_policy_id" {
  description = "ID of the cache policy to use for the default cache behavior (only used when use_default_cache_policy is false)"
  type        = string
  default     = null
}

variable "min_ttl" {
  description = "Minimum amount of time that you want objects to stay in CloudFront caches (only used when use_default_cache_policy is false)"
  type        = number
  default     = 0
  validation {
    condition     = var.min_ttl >= 0
    error_message = "min_ttl must be greater than or equal to 0."
  }
}

variable "default_ttl" {
  description = "Default amount of time that you want objects to stay in CloudFront caches (only used when use_default_cache_policy is false)"
  type        = number
  default     = 3600
  validation {
    condition     = var.default_ttl >= 0
    error_message = "default_ttl must be greater than or equal to 0."
  }
}

variable "max_ttl" {
  description = "Maximum amount of time that you want objects to stay in CloudFront caches (only used when use_default_cache_policy is false)"
  type        = number
  default     = 86400
  validation {
    condition     = var.max_ttl >= 0
    error_message = "max_ttl must be greater than or equal to 0."
  }
}

variable "origin_request_policy_id" {
  description = "ID of the origin request policy to use for the default cache behavior"
  type        = string
  default     = null
}

variable "response_headers_policy_id" {
  description = "ID of the response headers policy to use for the default cache behavior"
  type        = string
  default     = null
}

variable "http_version" {
  description = "Maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3 and http3"
  type        = string
  default     = "http2and3"
  validation {
    condition     = contains(["http1.1", "http2", "http2and3", "http3"], var.http_version)
    error_message = "http_version must be one of http1.1, http2, http2and3, or http3."
  }
}
