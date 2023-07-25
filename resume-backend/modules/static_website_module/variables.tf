
variable "bucket_name" {
  type = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}


variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable tag_name_pfx {
    type    = string
    default = " "
    description = "This will the prefix for the bucket tags."
}