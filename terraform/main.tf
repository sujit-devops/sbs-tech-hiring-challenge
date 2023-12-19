/*
terraform {
  backend "s3" {
    bucket         = "jshsflaksjflwffjfsuji-terraform-state"
    key            = "Users/sujit/sbs-tech-hiring-challenge-sample/terraform/terraform.tfstate"
    encrypt        = true
    region         = "us-east-1"
    dynamodb_table = "dynamodb-state-locking"
  }
}
*/

provider "aws" {
  region = "us-east-1"
}

################ Create S3 bucket to store terraform state ################ 


resource "aws_s3_bucket" "terraform_state" {
  bucket = "jshsflaksjflwffjfsuji-terraform-state"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  } 
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
  depends_on = [ resource.aws_s3_bucket.terraform_state ]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
  depends_on = [ resource.aws_s3_bucket.terraform_state ]
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on = [ resource.aws_s3_bucket.terraform_state ]
}

################ Create DynamoDB table to have lock ################ 

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "dynamodb-state-locking"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  depends_on = [ resource.aws_s3_bucket.terraform_state ]
}

################ Create a VPC ################ 

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

################ Create subnets in two availability zones ################ 
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "SubnetA"
  }
  depends_on = [ resource.aws_vpc.my_vpc ]
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
    tags = {
    Name = "SubnetB"
  }
  depends_on = [ resource.aws_vpc.my_vpc ]
}

################ Create an Internet Gateway ################
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  depends_on = [ resource.aws_vpc.my_vpc ]
}

################ Attach Internet Gateway to VPC ################ 
resource "aws_route" "route_internet" {
  route_table_id         = aws_vpc.my_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
  depends_on = [ resource.aws_vpc.my_vpc ]
}


################  Create a security group allowing HTTP and SSH traffic ################ 
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [ resource.aws_vpc.my_vpc ]
}



################################ IAM Role ##############################
resource "aws_iam_role" "s3_ec2_role" {
  name = "s3-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


############################## IAM Role Policy ##############################
resource "aws_iam_role_policy" "s3_ec2_policy" {
  name   = "s3-ec2-policy"
  role   = aws_iam_role.s3_ec2_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::my-static-website46551jaffsfwerdjdf",
        "arn:aws:s3:::my-static-website46551jaffsfwerdjdf/*"
      ]
    }
  ]
}
EOF
}

############################## IAM Instance Profile ##############################
resource "aws_iam_instance_profile" "s3_ec2_profile" {
  name = "s3-ec2-profile"
  role = aws_iam_role.s3_ec2_role.name
}


############################## Launch Configuration for EC2 Instances ########################
resource "aws_launch_configuration" "web_lc" {
  name                 = "web_lc"
  image_id             = "ami-018ba43095ff50d08"  # Replace with your desired AMI ID
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.web_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.s3_ec2_profile.name
  #key_name             = "your-key-pair"  # Replace with your key pair
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

##############################    Create WebEC2 instance ############################## ###########    
resource "aws_instance" "web_instance" {
  ami             = "ami-018ba43095ff50d08" # Specify the AMI ID for your desired instance
  instance_type   = "t2.micro"             # Specify the instance type
  availability_zone    = "us-east-1a"
  subnet_id        = aws_subnet.subnet_a.id
  security_groups  = [ resource.aws_security_group.web_sg.id ]
  iam_instance_profile   = aws_iam_instance_profile.s3_ec2_profile.name

  #provisioner "remote-exec" {
  #  inline = [
  #    "sudo yum install -y ImageMagick",
  #  ]
  #}
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
                          chmod 755 /etc/httpd/conf/httpd.conf
                          systemctl start httpd
                          systemctl enable httpd      
                          PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
                          DATE_TIME=$(date "+%Y/%m/%d %H:%M:%S")
                          aws s3 cp s3://my-static-website46551jaffsfwerdjdf/sbs-world-cup-image /var/www/html/sbs-world-cup.jpeg
                          convert /var/www/html/sbs-world-cup.jpeg -pointsize 20 -fill white -annotate +70+70 "Date on Webserver IP Address $PRIVATE_IP is $DATE_TIME" /var/www/html/sbs-world-cup.jpeg
                          EOF

  tags = {
    Name = "web-instance"
  }
  depends_on = [ aws_launch_configuration.web_lc ]
}


################ Auto Scaling Group ################ 
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  launch_configuration = aws_launch_configuration.web_lc.name
  #vpc_zone_identifier  = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  vpc_zone_identifier  = [ aws_subnet.subnet_a.id ]
  health_check_type          = "EC2"
  health_check_grace_period  = 300
  depends_on = [ resource.aws_launch_configuration.web_lc ]
    tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
}


############################ Application Load Balancer ############################ 
resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false
  ip_address_type = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets = concat(aws_subnet.subnet_a[*].id, aws_subnet.subnet_b[*].id)
  depends_on = [ aws_lb_target_group.web_target_group ]
}


######################## Create a target group for the EC2 instances ########################
resource "aws_lb_target_group" "web_target_group" {
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.my_vpc.id
}



###################### Attach EC2 instances to the target group ######################
resource "aws_lb_target_group_attachment" "web_target_attachment" {
  target_group_arn = aws_lb_target_group.web_target_group.arn
  target_id        = aws_instance.web_instance.id
  depends_on = [ resource.aws_lb_target_group.web_target_group ]
}

###################### Create a listener rule to forward traffic to the target group ##########
  resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.web_target_group.arn
    type             = "forward"
  }
  depends_on = [ resource.aws_autoscaling_group.web_asg ]
}

################  S3 static website bucket ######################## 

resource "aws_s3_bucket" "my-static-website" {
  bucket = "my-static-website46551jaffsfwerdjdf" # give a unique bucket name
  tags = {
    Name = "my-static-website"
  }
}

resource "aws_s3_bucket_website_configuration" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
  depends_on = [ resource.aws_s3_bucket.my-static-website ]
}

# S3 bucket ACL access

resource "aws_s3_bucket_ownership_controls" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [ resource.aws_s3_bucket.my-static-website ]
}

resource "aws_s3_bucket_public_access_block" "my-static-website" {
  bucket = aws_s3_bucket.my-static-website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  depends_on = [ resource.aws_s3_bucket.my-static-website ]
}

resource "aws_s3_bucket_acl" "my-static-website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.my-static-website,
    aws_s3_bucket_public_access_block.my-static-website,
  ]

  bucket = aws_s3_bucket.my-static-website.id
  acl    = "public-read"
}


resource "aws_s3_object" "image_object" {
  bucket  = aws_s3_bucket.my-static-website.bucket
  key    = "sbs-world-cup-image"
  acl    = "public-read"  # To make the object public
  source = "/Users/sujit/sbs-tech-hiring-challenge-sample/sbs-world-cup.jpeg"
}
