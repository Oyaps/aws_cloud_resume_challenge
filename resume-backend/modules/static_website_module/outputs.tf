
output "domain_bucket_name" {
  value = aws_s3_bucket.root_domain_bucket.bucket_regional_domain_name
  description = "The root domain bucket"
}

output "subdomain_bucket_name" {
  value = aws_s3_bucket.subdomain_bucket.bucket_regional_domain_name
  description = "The subdomain bucket"
}