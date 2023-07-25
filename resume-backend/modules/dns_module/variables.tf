variable "bucket_name" {
  type = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}

variable "domain_name" {
  type        = string
  description = "The domain name for the S3 bucket."
}

variable "primary_domain_name" {
  type = string
  description = "The primary domain name for the website."
}

variable "primary_zone_id" {
  type = string
  description = "The primary zone ID for the website."
}

variable tag_name_pfx {
    type    = string
    default = " "
    description = "This will the prefix for the cloudfront tags."
}