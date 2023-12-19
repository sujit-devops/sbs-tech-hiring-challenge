variable "cidr_block" {
  description = "The CIDR block for the VPC"
}

resource "aws_vpc" "my_vpc" {
  cidr_block            = var.cidr_block
  enable_dns_support    = true
  enable_dns_hostnames  = true
}