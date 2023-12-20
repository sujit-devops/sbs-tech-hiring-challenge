# Product Architecture
<img width="200" alt="Screenshot 2023-12-20 at 9 01 27 pm" src="https://github.com/techielife9/sbs-tech-hiring-challenge/assets/29218570/b511f2c0-dfd1-4f1d-8caa-1624815f339c"> <br/>

In this project, I developed a streamlined infrastructure for hosting a static website using Amazon Web Services (AWS) S3 and CloudFront. The primary goal of this project is to demonstrate the automated provisioning and deployment of a web hosting solution for static websites.

# Expected Result
<img width="720" alt="Screenshot 2023-12-19 at 4 07 42 pm" src="https://github.com/techielife9/sbs-tech-hiring-challenge/assets/29218570/3ec748a8-68df-4879-86f0-f1f38553ac4e"> <br/>


# SBS-tech-hiring-challenge Approach 3

Deploy a Highly Available Webserver solution using a mixture of Compute, Load Balancing and other services available from AWS. 
The Solution should be self-healing, fault-tolerant as much as possible, and must make use of server-less offerings from AWS for compute.
Web-Server: Linux OS
Aim of the solution should be self-healing, fault-tolerant as much as possible, and must make use of server-less offerings from AWS for compute.
Infra used: 
  - CloudFront distribution + private S3 bucket
  Advantage: easy to implement, private s3 bucket, cache for static files

## Key Components and Features:
Terraform Infrastructure as Code (IaC):
I utilized Terraform, an IaC tool, to define and provision the AWS resources required for my static website hosting solution. This allows for version-controlled, repeatable infrastructure deployments.

## AWS S3 Bucket:
I created an S3 bucket to store and serve the static website files. This bucket is configured for website hosting, allowing for easy content delivery.

## Content Upload and Management:
I provided instructions and scripts for uploading and managing my website content within the S3 bucket.

## Prerequisites:
1. Basic knowledge of AWS services and concepts.
2. Familiarity with Terraform and infrastructure as code principles.
3. An AWS account with appropriate permissions.
4. An IDE of your Choice , I would suggest VS Code Editor .
5. This project serves as an excellent foundation for hosting static websites of Football worldcup

## Steps:
## Step 1: Set Up Your Development Environment
Install Terraform and the AWS Command Line Interface (CLI) on your local machine. Configure your AWS credentials by running aws configure and providing your AWS access key and secret key.

## Step 2: Define Your Website Content
To prepare static website files (HTML), place them in the directory where your Terraform configuration files are located. Name the main HTML file "index.html," and optionally, you can also include an "error.html" file. If you prefer, you can reference my repository for the static website HTML files.

## Step 3: Terraform Configuration File Syntax
If we want to Create a terraform configuration file we have to use .tf (e.g., main.tf) to define the infrastructure as code using terraform.

## Step 4: Define your Configuration Files in your IDE
1. Define the AWS provider and required resources like S3 buckets, IAM roles, and policies

Define provider.tf file using the below code :
provider "aws" {
    region = "us-east-1"
}

2. In your Integrated Development Environment (IDE), open the terminal and navigate to the directory where you have created these configuration files.

3. After navigating to the directory where your configuration files are located in your IDE's terminal, you can run the following command to initialize Terraform and prepare it for use with AWS:
terraform init
Running terraform init will install the necessary plugins and modules required for connecting to AWS and managing your infrastructure.
4. And then define resource.tf file for creating bucket by using the below code :

resource "aws_s3_bucket" "bucket1" {
    bucket = "web-bucket-mathesh"
  
}
Then below command for creating the bucket :
terraform apply -auto-approve
And then add the below codes in resource.tf file :
resource "aws_s3_bucket_public_access_block" "bucket1" {
  bucket = aws_s3_bucket.bucket1.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "index" {
  bucket = "web-bucket-mathesh"
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = "web-bucket-mathesh"
  key    = "error.html"
  source = "error.html"
  content_type = "text/html"
}


resource "aws_s3_bucket_website_configuration" "bucket1" {
  bucket = aws_s3_bucket.bucket1.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.bucket1.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
	  "Principal": "*",
      "Action": [ "s3:GetObject" ],
      "Resource": [
        "${aws_s3_bucket.bucket1.arn}",
        "${aws_s3_bucket.bucket1.arn}/*"
      ]
    }
  ]
}
EOF
}

And then again run the command :
terraform applyb -auto-approve
The code above will apply the necessary configurations for features such as static website hosting, bucket policies, and blocking public access to your bucket.
Certainly, it's important to customize the code to your specific needs. Please remember to change the bucket name, region, and configurations as per your requirements when using the code from the Terraform documentation.

## Step 5: Define the Output file
1. We use an output file to obtain your website link in your IDE, eliminating the need to access the link through the AWS Console.
2. Define output.tf file by using the below terraform code :
output "websiteendpoint" {
    value = aws_s3_bucket.bucket1.website_endpoint
  
}
And then run the following command :
terraform apply -auto-approve



  
