# AWS Static Website Terraform Module

This Terraform module provisions infrastructure for hosting a static website on AWS using S3 and CloudFront.

## Features

- S3 bucket configured for static website hosting
- CloudFront distribution for content delivery
- Origin Access Identity for secure S3 access
- Configurable CORS settings
- Configurable lifecycle rules
- Configurable CloudFront cache behaviors
- Configurable error responses
- Optional WAF integration
- Optional access logging
- Optional server-side encryption
- Optional custom domain with SSL/TLS certificate

## Usage

```hcl
module "static_website" {
  source = "github.com/vnedyalk0v/terraform-aws-static-site"

  bucket_name         = "my-static-website-bucket"
  force_destroy       = true
  enable_versioning   = true
  enable_encryption   = true
  block_public_access = true

  # CloudFront settings
  price_class           = "PriceClass_100"
  default_root_object   = "index.html"
  enable_ipv6           = true
  minimum_protocol_version = "TLSv1.2_2021"

  # Custom error responses
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
    Environment = "dev"
    Project     = "static-website"
    Terraform   = "true"
  }
}
```

## Examples

- [Simple Example](./examples/simple) - Basic static website hosting
- [Custom Domain Example](./examples/custom-domain) - Static website with custom domain and SSL/TLS certificate

## Requirements

| Name      | Version  |
| --------- | -------- |
| terraform | >= 1.0.0 |
| aws       | ~> 5.0   |

## Providers

| Name | Version |
| ---- | ------- |
| aws  | ~> 5.0  |

## Modules

| Name       | Source               | Version |
| ---------- | -------------------- | ------- |
| s3_bucket  | ./modules/s3         | n/a     |
| cloudfront | ./modules/cloudfront | n/a     |

## Resources

Resources created by this module:

- S3 bucket for static website hosting
- S3 bucket policy
- CloudFront distribution
- CloudFront origin access identity

## Inputs

| Name                       | Description                                                                              | Type           | Default              | Required |
| -------------------------- | ---------------------------------------------------------------------------------------- | -------------- | -------------------- | :------: |
| bucket_name                | Name of the S3 bucket to create for static website hosting                               | `string`       | n/a                  |   yes    |
| force_destroy              | Whether to force destroy the bucket even if it contains objects                          | `bool`         | `false`              |    no    |
| tags                       | A map of tags to add to all resources                                                    | `map(string)`  | `{}`                 |    no    |
| enable_versioning          | Enable versioning for the S3 bucket                                                      | `bool`         | `true`               |    no    |
| enable_access_logging      | Enable access logging for the S3 bucket                                                  | `bool`         | `false`              |    no    |
| access_log_bucket_name     | Name of the S3 bucket to store access logs                                               | `string`       | `null`               |    no    |
| access_log_prefix          | Prefix for the access logs                                                               | `string`       | `"logs/"`            |    no    |
| block_public_access        | Enable S3 block public access                                                            | `bool`         | `true`               |    no    |
| enable_encryption          | Enable server-side encryption for the S3 bucket                                          | `bool`         | `true`               |    no    |
| kms_key_arn                | ARN of the KMS key to use for encryption (if null, uses Amazon S3-managed keys (SSE-S3)) | `string`       | `null`               |    no    |
| cors_rules                 | CORS rules for the S3 bucket                                                             | `list(object)` | `[]`                 |    no    |
| lifecycle_rules            | Lifecycle rules for the S3 bucket                                                        | `list(object)` | `[]`                 |    no    |
| aliases                    | List of CNAME aliases to be used in CloudFront                                           | `list(string)` | `[]`                 |    no    |
| acm_certificate_arn        | ARN of the ACM certificate to use for CloudFront (must be in us-east-1 for CloudFront)   | `string`       | `null`               |    no    |
| price_class                | CloudFront price class                                                                   | `string`       | `"PriceClass_100"`   |    no    |
| minimum_protocol_version   | Minimum TLS version for CloudFront viewer connections                                    | `string`       | `"TLSv1.2_2021"`     |    no    |
| default_root_object        | Object that CloudFront will return when root URL is requested                            | `string`       | `"index.html"`       |    no    |
| error_responses            | Custom error responses for CloudFront                                                    | `list(object)` | See variables.tf     |    no    |
| geo_restriction            | CloudFront geo restriction configuration                                                 | `object`       | See variables.tf     |    no    |
| enable_waf                 | Enable AWS WAF for CloudFront                                                            | `bool`         | `false`              |    no    |
| web_acl_id                 | ID of the AWS WAF web ACL to associate with CloudFront                                   | `string`       | `null`               |    no    |
| enable_cloudfront_logging  | Enable CloudFront access logging                                                         | `bool`         | `false`              |    no    |
| cloudfront_log_bucket_name | Name of the S3 bucket to store CloudFront access logs                                    | `string`       | `null`               |    no    |
| cloudfront_log_prefix      | Prefix for the CloudFront access logs                                                    | `string`       | `"cloudfront-logs/"` |    no    |
| enable_ipv6                | Enable IPv6 support for CloudFront                                                       | `bool`         | `false`              |    no    |
| cache_policy_id            | ID of the cache policy to use for the default cache behavior                             | `string`       | `null`               |    no    |
| origin_request_policy_id   | ID of the origin request policy to use for the default cache behavior                    | `string`       | `null`               |    no    |
| response_headers_policy_id | ID of the response headers policy to use for the default cache behavior                  | `string`       | `null`               |    no    |

## Outputs

| Name                                | Description                                |
| ----------------------------------- | ------------------------------------------ |
| bucket_name                         | Name of the S3 bucket                      |
| bucket_arn                          | ARN of the S3 bucket                       |
| bucket_regional_domain_name         | Regional domain name of the S3 bucket      |
| cloudfront_distribution_id          | ID of the CloudFront distribution          |
| cloudfront_distribution_arn         | ARN of the CloudFront distribution         |
| cloudfront_distribution_domain_name | Domain name of the CloudFront distribution |
| website_url                         | URL of the static website                  |

## Security Considerations

- By default, the S3 bucket is configured with block public access enabled
- By default, server-side encryption is enabled for the S3 bucket
- CloudFront uses Origin Access Identity to securely access the S3 bucket
- TLS 1.2 is set as the minimum protocol version for CloudFront
- WAF integration is available for additional security

## License

This module is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Authors

Georgi Nedyalkov

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
