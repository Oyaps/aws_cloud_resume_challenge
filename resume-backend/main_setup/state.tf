
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket         = "resume-terraform-states"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    profile        = "terraform-user"
    dynamodb_table = "resume-terraform-lock"
  }
}

# Configure the AWS Provider and region
provider "aws" {
  profile = "terraform-user"
  region  = var.region


  default_tags {
    tags = var.default_tags
  }
}

provider "aws" {
  alias  = "acm_provider"
  region = var.region

  default_tags {
    tags = var.default_tags
  }
}

