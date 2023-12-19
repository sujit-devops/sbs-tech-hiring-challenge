variable "region" {
  description = "AWS region"
}

// VPC variables
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}

variable "subnet1_cidr_block" {
  description = "CIDR block for Subnet1"
}

variable "availability_zone" {
  description = "Availability Zone for Subnet1"
}

// EC2 variables
variable "ami" {
  description = "AMI ID for the instances"
}

variable "instance_type" {
  description = "Instance type for the instances"
}

variable "key_name" {
  description = "Key pair name for SSH access"
}

variable "user_data" {
  description = "User data script for EC2 instances"
}

// Load Balancer variables
variable "target_group_port" {
  description = "Port for the target group"
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
}

variable "listener_port" {
  description = "Port for the load balancer listener"
}

variable "listener_protocol" {
  description = "Protocol for the load balancer listener"
}
