######################################################################################

#   Title:          acuval App AWS cloud resources Phase 1- DEVELOPMENT VPC
#   Author:         Linda Asamoah, AWS Solutions Architect
#                   Prepared for The Cloud Resume Challenge
#   Description:    Computing resources for
#                   development and deployment using AWS
#                   public cloud resources.
#   File Desc:      Variables to pass to main_setup, which will create overall
#                   and infrastructure with all environments 
#
#######################################################################################



variable "default_tags" {
  type        = map(any)
  description = "These are the default tage for all resources deployed with terraform"
}

variable "region" {
  type        = string
  description = "Set this to the region to deploy resources. Ensure the region has at least three availiability zones"
}

variable "accountID" {
  type        = string
  description = "Set this to the AWS account to deploy resources."
}

variable "bucket_name" {
  type = string
  description = "The name of the bucket. Normally root domain name."
}

variable "primary_domain" {
  type        = string
  description = "The primary domain name for the website."
}

variable "primary_domain_host_zone_id" {
  type        = string
  description = "The name of the host zone file for the primary domain"
}




