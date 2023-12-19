output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet1_id" {
  value = module.vpc.subnet1_id
}

output "web_server_instance_id" {
  value = module.ec2.web_server_instance_id
}

output "load_balancer_dns" {
  value = module.load_balancer.load_balancer_dns
}

output "website_bucket_url" {
  value = module.s3.website_bucket_url
}
