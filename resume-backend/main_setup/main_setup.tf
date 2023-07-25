

module "website_module" {
  
  source = "../modules/static_website_module"

  /* region = var.region */
  bucket_name = var.bucket_name
  domain_name = var.primary_domain
  tag_name_pfx       = "crc"

}

module "content_delivery_module" {
  
  source = "../modules/dns_module"

  bucket_name = var.bucket_name
  domain_name = module.website_module.domain_bucket_name
  primary_domain_name = var.primary_domain
  primary_zone_id = var.primary_domain_host_zone_id
  tag_name_pfx       = "crc"

}

module "database_module" {
  
  source = "../modules/database_module"

  tag_name_pfx       = "crc"

}

module "lambda_api_module" {
  
  source = "../modules/lambda_api_module"

  /* my_region = var.region
  accountId = var.accountID
  bucket_name = "www.${var.bucket_name}" */


}


