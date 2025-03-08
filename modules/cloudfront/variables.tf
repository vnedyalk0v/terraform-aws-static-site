variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  type        = string
}

variable "bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}

variable "origin_access_identity_path" {
  description = "Path of the CloudFront Origin Access Identity"
  type        = string
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

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
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

variable "enable_logging" {
  description = "Enable CloudFront access logging"
  type        = bool
  default     = false
}

variable "logging_bucket" {
  description = "Name of the S3 bucket to store CloudFront access logs"
  type        = string
  default     = null
}

variable "logging_prefix" {
  description = "Prefix for the CloudFront access logs"
  type        = string
  default     = "cloudfront-logs/"
}

variable "enable_ipv6" {
  description = "Enable IPv6 support for CloudFront"
  type        = bool
  default     = true
}

variable "cache_policy_id" {
  description = "ID of the cache policy to use for the default cache behavior"
  type        = string
  default     = null
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
