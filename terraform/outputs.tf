output "subnet_a_id" {
  value = aws_subnet.subnet_a.id
}
output "subnet_b_id" {
  value = aws_subnet.subnet_b.id
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
 
output "security_group_id" {
  value = aws_security_group.web_sg.id
}

output "bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}

output "launch_configuration_name" {
  value = aws_launch_configuration.web_lc.name
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.terraform_lock.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.web_target_group.arn
}

output "iam_instance_profile_name"{
  value = aws_iam_instance_profile.s3_ec2_profile.name
}
