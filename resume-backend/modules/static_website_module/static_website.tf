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

 #### CORS Configuration for Subdomain Bucket ####
resource "aws_s3_bucket_cors_configuration" "subdomain_cors" {
  bucket = aws_s3_bucket.subdomain_bucket.id  

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }  
}

#### ACL Configuration for Subdomain Bucket ####
resource "aws_s3_bucket_acl" "subdomain_bucket_acl" {
  bucket = aws_s3_bucket.subdomain_bucket.id
  acl    = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.sd_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "sd_bucket_acl_ownership" {
  bucket = aws_s3_bucket.subdomain_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  # depends_on = [aws_s3_bucket_public_access_block.sd_public_access]
}


resource "aws_s3_bucket_public_access_block" "sd_public_access" {
  bucket = aws_s3_bucket.subdomain_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "subdomain_policy" {
  bucket = aws_s3_bucket.subdomain_bucket.id
  policy = templatefile("${local.terraform_scripts_path}/sd_s3_policy.json", { bucket = "www.${var.bucket_name}" })
  depends_on = [aws_s3_bucket_public_access_block.sd_public_access]
}

#### Website Configuration for Subdomain Bucket ####
resource "aws_s3_bucket_website_configuration" "subdomain_website_config" {
  bucket = aws_s3_bucket.subdomain_bucket.bucket

  index_document {
    suffix = "index.html"
  }

}



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

 #### CORS Configuration for Primary Bucket ####
resource "aws_s3_bucket_cors_configuration" "root_domain_cors" {
  bucket = aws_s3_bucket.root_domain_bucket.id  

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }  
}

#### ACL Configuration for Primary Bucket ####
resource "aws_s3_bucket_acl" "root_bucket_acl" {
  bucket = aws_s3_bucket.root_domain_bucket.id
  acl    = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.rt_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "rt_bucket_acl_ownership" {
  bucket = aws_s3_bucket.root_domain_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.rt_public_access]
}


resource "aws_s3_bucket_public_access_block" "rt_public_access" {
  bucket = aws_s3_bucket.root_domain_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "root_domain_policy" {
  bucket = aws_s3_bucket.root_domain_bucket.id
  policy = templatefile("${local.terraform_scripts_path}/sd_s3_policy.json", { bucket = var.bucket_name })
  depends_on = [aws_s3_bucket_public_access_block.rt_public_access]
}

#### Website Configuration for Root domain/Primary Bucket ####

resource "aws_s3_bucket_website_configuration" "root_website_config" {
  bucket = aws_s3_bucket.root_domain_bucket.bucket


  redirect_all_requests_to {

    host_name = "www.${var.domain_name}"
    
  } 
}



