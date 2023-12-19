resource "aws_instance" "web_server" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_group  = var.security_group
  key_name        = var.key_name
  user_data       = var.user_data
  tags = {
    Name = "WebServer"
  }
}

output "web_server_instance_id" {
  value = aws_instance.web_server.id
}
