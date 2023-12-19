variable "vpc_id" {
  description = "The ID of the VPC"
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = var.vpc_id
  depends_on = [var.vpc_id]
}
