variable "security_group_id" {
  description = "The ID of the security group"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to attach to the load balancer"
}

variable "target_group_arn" {
  description = "The ARN of the target group"
}

variable "vpc_id" {
  description = "The ID of the VPC"
}

############################ Application Load Balancer ############################ 
resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = concat(aws_subnet.subnet_a[*].id, aws_subnet.subnet_b[*].id)
  depends_on         = [var.target_group_arn]
}

######################## Create a target group for the EC2 instances ########################
resource "aws_lb_target_group" "web_target_group" {
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

###################### Attach EC2 instances to the target group ######################
resource "aws_lb_target_group_attachment" "web_target_attachment" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.web_instance.id
  depends_on = [var.target_group_arn]
}

###################### Create a listener rule to forward traffic to the target group ##########
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = var.target_group_arn
    type             = "forward"
  }
  depends_on = [resource.aws_autoscaling_group.web_asg]
}
