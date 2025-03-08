variable "region" {
  description = "The AWS region to deploy the S3 bucket"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create for static website hosting"
  type        = string
}

variable "force_destroy" {
  description = "Whether to force destroy the bucket even if it contains objects"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
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
  default = []
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

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution that will access this bucket"
  type        = string
  default     = ""
}
