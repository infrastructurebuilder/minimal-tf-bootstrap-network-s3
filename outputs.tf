
output "vpc_id" {
  description = "The ID of the Nexus VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs for the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of IDs for the private subnets"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway attached to the VPC"
  value       = aws_internet_gateway.igw.id
}

output "state_bucket_name" {
  description = "The name of the S3 bucket created for Terraform state"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "alb_logs_bucket_name" {
  description = "The name of the S3 bucket created for ALB access logs"
  value       = aws_s3_bucket.alb_logs.bucket
}

output "aws_region" {
  description = "The AWS region where resources are deployed"
  value       = var.aws_region
}

output "aws_profile" {
  description = "The AWS CLI profile used for deployment"
  value       = var.aws_profile
}

output "terraform_state_admin_policy_name" {
  description = "The name of the IAM policy with full read-write access to the Terraform state bucket"
  value       = aws_iam_policy.terraform_state_admin.name
}

output "terraform_state_readonly_policy_name" {
  description = "The name of the IAM policy with read-only access to the Terraform state bucket"
  value       = aws_iam_policy.terraform_state_readonly.name
}

output "terraform_state_admin_role_name" {
  description = "The name of the IAM role with full read-write access to the Terraform state bucket"
  value       = aws_iam_role.terraform_state_admin.name
}

output "terraform_state_readonly_role_name" {
  description = "The name of the IAM role with read-only access to the Terraform state bucket"
  value       = aws_iam_role.terraform_state_readonly.name
}

output "terraform_state_restricted_write_policy_name" {
  description = "The name of the IAM policy with read-all and write-only-to-non-protected-keys access"
  value       = aws_iam_policy.terraform_state_restricted_write.name
}

output "terraform_state_restricted_write_role_name" {
  description = "The name of the IAM role with read-all and write-only-to-non-protected-keys access"
  value       = aws_iam_role.terraform_state_restricted_write.name
}