variable "security_group_id" {
  description = "The ID of the security group"
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile"
}

variable "subnet_a_id" {
  description = "The ID of the subnetA"
}

resource "aws_launch_configuration" "web_lc" {
  name                 = "web_lc"
  image_id             = "ami-018ba43095ff50d08"
  instance_type        = "t2.micro"
  security_groups      = [ var.security_group_id ]
  iam_instance_profile = var.iam_instance_profile_name
  associate_public_ip_address = true

  user_data            = <<-EOF
                          #!/bin/bash
                          sudo su
                          yum update -y
                          yum install httpd -y
                          yum install ImageMagick -y   
                          sudo chmod 777 /etc/httpd/conf/httpd.conf
                          cat <<-EOL >> /etc/httpd/conf/httpd.conf
                              <VirtualHost *:80>
                              DocumentRoot /var/www/html/
                              DirectoryIndex sbs-world-cup.jpeg
                          </VirtualHost>
                          EOL
                          sudo chmod 755 /etc/httpd/conf/httpd.conf
                          systemctl start httpd
                          systemctl enable httpd
                          sudo yum install ImageMagick
                          aws s3 cp s3://my-static-website46551jaffsfwerdjdf/sbs-world-cup-image /var/www/html/sbs-world-cup.jpeg
                          PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
                          DATE_TIME=$(date "+%Y/%m/%d %H:%M:%S")
                          convert /var/www/html/sbs-world-cup.jpeg -pointsize 20 -fill white -annotate +70+70 "Date on Webserver IP Address $PRIVATE_IP is $DATE_TIME" /var/www/html/sbs-world-cup.jpeg
                          EOF
  depends_on = [ resource.aws_security_group.web_sg ]
}

resource "aws_instance" "web_instance" {
  ami             = "ami-018ba43095ff50d08"
  instance_type   = "t2.micro"
  availability_zone    = "us-east-1a"
  subnet_id       =  var.subnet_a_id
  security_groups = [ var.security_group_id ]
  iam_instance_profile = var.iam_instance_profile_name
  user_data            = <<-EOF
                          #!/bin/bash
                          sudo su
                          yum update -y
                          yum install httpd -y
                          yum install ImageMagick -y   
                          sudo chmod 777 /etc/httpd/conf/httpd.conf
                          cat <<-EOL >> /etc/httpd/conf/httpd.conf
                              <VirtualHost *:80>
                              DocumentRoot /var/www/html/
                              DirectoryIndex sbs-world-cup.jpeg
                          </VirtualHost>
                          EOL
                          sudo chmod 755 /etc/httpd/conf/httpd.conf
                          systemctl start httpd
                          systemctl enable httpd
                          sudo yum install ImageMagick
                          aws s3 cp s3://my-static-website46551jaffsfwerdjdf/sbs-world-cup-image /var/www/html/sbs-world-cup.jpeg
                          PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
                          DATE_TIME=$(date "+%Y/%m/%d %H:%M:%S")
                          convert /var/www/html/sbs-world-cup.jpeg -pointsize 20 -fill white -annotate +70+70 "Date on Webserver IP Address $PRIVATE_IP is $DATE_TIME" /var/www/html/sbs-world-cup.jpeg
                          EOF
  depends_on = [ resource.aws_security_group.web_sg ]

  tags = {
    Name = "web-instance"
  }
}
