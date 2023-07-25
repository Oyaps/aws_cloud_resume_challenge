locals {

  terraform_scripts_path = "${path.module}/../scripts"

}

# S3 bucket for website.
resource "aws_s3_bucket" "subdomain_bucket" {
  bucket = "www.${var.bucket_name}"


  lifecycle {
    ignore_changes = [
      website
    ]
  }

  tags = {
        Name = "${var.tag_name_pfx}-subdomain-bucket"

    }
}

#### ACL Configuration for Subdomain Bucket ####
resource "aws_s3_bucket_acl" "subdomain_bucket_acl" {
  bucket = aws_s3_bucket.subdomain_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "subdomain_policy" {
  bucket = aws_s3_bucket.subdomain_bucket.id
  policy = templatefile("${local.terraform_scripts_path}/s3_policy.json", { bucket = "www.${var.bucket_name}" })
}

#### Website Configuration for Primary Bucket ####
resource "aws_s3_bucket_website_configuration" "subdomain_website_config" {
  bucket = aws_s3_bucket.subdomain_bucket.bucket

  index_document {
    suffix = "index.html"
  }

}

/* #### CORS Configuration for Primary Bucket ####
resource "aws_s3_bucket_cors_configuration" "primary_bucket" {
  bucket = aws_s3_bucket.root_domain_bucket.id

  cors_rule {
    allowed_headers = ["Content-Type"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://${var.domain_name}"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
} */

# S3 bucket for redirecting subdomain bucket to root domain bucket
resource "aws_s3_bucket" "root_domain_bucket" {
  bucket = var.bucket_name


  lifecycle {
    ignore_changes = [
      website
    ]
  } 

  tags = {
        Name = "${var.tag_name_pfx}-root-domain-bucket"

    }
}


#### ACL Configuration for Primary Bucket ####
resource "aws_s3_bucket_acl" "root_bucket_acl" {
  bucket = aws_s3_bucket.root_domain_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "root_domain_policy" {
  bucket = aws_s3_bucket.root_domain_bucket.id
  policy = templatefile("${local.terraform_scripts_path}/s3_policy.json", { bucket = var.bucket_name })
}

#### Website Configuration for Root domain/Primary Bucket ####

resource "aws_s3_bucket_website_configuration" "root_website_config" {
  bucket = aws_s3_bucket.root_domain_bucket.bucket


  redirect_all_requests_to {

    host_name = "www.${var.domain_name}"
    
  } 
}



