variable "vpc_id" {
  description = "The ID of the VPC"
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "SubnetA"
  }

  depends_on = [var.vpc_id]
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "SubnetB"
  }

  depends_on = [var.vpc_id]
}


