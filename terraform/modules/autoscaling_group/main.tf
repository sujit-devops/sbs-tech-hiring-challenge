variable "launch_configuration_name" {
  description = "The name of the launch configuration"
}

variable "subnet_a_id" {
  description = "The ID of the subnetA"
}



resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  launch_configuration = var.launch_configuration_name
  vpc_zone_identifier  = var.subnet_a_id
  health_check_type          = "EC2"
  health_check_grace_period  = 300

  depends_on = [var.launch_configuration_name]
    tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
}

