variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "primary_zone_id" {
  type = string
  description = "The primary zone ID for the website."
}

variable tag_name_pfx {
    type    = string
    default = " "
    description = "This will the prefix for the bucket tags."
}