resource "aws_lb" "main" {
  internal       = false
  load_balancer_type = "application"
  security_groups = [var.load_balancer_sg]
  enable_deletion_protection = false
  enable_http2 = true
  enable_cross_zone_load_balancing = true

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "target_group" {
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }
}

output "load_balancer_dns" {
  value = aws_lb.main.dns_name
}
