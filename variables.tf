# ==============================================================================
# 1. VARIABLES
# ==============================================================================

variable "name_prefix" {
  description = "Prefix for naming AWS resources"
  type        = string
}
variable "prevent_destroy_state_bucket" {
  description = "Whether to prevent the S3 bucket from being destroyed"
  type        = bool
  default     = true
}

variable "cfg_dir" {
  description = "The directory containing the configuration files"
  type        = string
}
variable "state_bucket_name" {
  description = "The globally unique name of the S3 bucket for Terraform state"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., 'production', 'staging')"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all AWS resources"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "The AWS region to deploy Nexus in"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile to use for deployment"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "root_dir" {
  description = "The root directory of the project (location of top-level Justfile)"
  type        = string
}

variable "external_random_id" {
  description = "EXTERNALLY-GENERATED Random ID to ensure uniqueness"
  type        = string
}
