output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.static_website.bucket_name
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.static_website.cloudfront_distribution_id
}

output "website_url" {
  description = "URL of the static website"
  value       = module.static_website.website_url
}
