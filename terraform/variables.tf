variable "bucket_name" {
  description = "The name of the S3 bucket"
}

variable "table_name" {
  description = "The name of the DynamoDB table"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
}

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "subnet_id" {
  description = "The ID of the subnet"
}

variable "subnet_a_id" {
  description = "The ID of the subnetA"
}

variable "security_group_id" {
  description = "The ID of the security group"
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile"
}

variable "launch_configuration_name" {
  description = "The name of the launch configuration"
}

variable "vpc_zone_identifiers" {
  type        = list(string)
  description = "A list of subnet IDs to launch resources in"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to attach to the load balancer"
}

variable "target_group_arn" {
  description = "The ARN of the target group"
}
