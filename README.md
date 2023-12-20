# Product Architecture
<img width="200" alt="Screenshot 2023-12-20 at 9 01 27 pm" src="https://github.com/techielife9/sbs-tech-hiring-challenge/assets/29218570/b511f2c0-dfd1-4f1d-8caa-1624815f339c"> <br/>

In this project, I developed a streamlined infrastructure for hosting a static website using Amazon Web Services (AWS) S3 and CloudFront. The primary goal of this project is to demonstrate the automated provisioning and deployment of a web hosting solution for static websites.

# Expected Result
<img width="720" alt="Screenshot 2023-12-19 at 4 07 42 pm" src="https://github.com/techielife9/sbs-tech-hiring-challenge/assets/29218570/3ec748a8-68df-4879-86f0-f1f38553ac4e"> <br/>


# SBS-tech-hiring-challenge Approach 3

Deploy a Highly Available Webserver solution using a mixture of Compute, Load Balancing and other services available from AWS. <br/>
The Solution should be self-healing, fault-tolerant as much as possible, and must make use of server-less offerings from AWS for compute. <br/>

Aim of the solution should be self-healing, fault-tolerant as much as possible, and must make use of server-less offerings from AWS for compute. <br/>

Infra used:  <br/>
  - CloudFront distribution + private S3 bucket <br/>
  - Advantage: easy to implement, private s3 bucket, cache for static files <br/>

## Key Components and Features:
Terraform Infrastructure as Code (IaC):
I utilized Terraform, an IaC tool, to define and provision the AWS resources required for my static website hosting solution. This allows for version-controlled, repeatable infrastructure deployments.

## AWS S3 Bucket:
Created an S3 bucket to store and serve the static website files. This bucket is configured for website hosting, allowing for easy content delivery.

## CloudFront:
Used CloudFront to distribute the static website's content across a network of edge locations worldwide. This reduces latency and improves the load times for users in different geographical locations. There by making the website self healing, highly available and fault tolerant at all times.


## Content Upload and Management:
Provided instructions and scripts for uploading and managing my website content within the S3 bucket.

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

3. After navigating to the directory where your configuration files are located in your IDE's terminal, you can run the following command to initialize Terraform and prepare it for use with AWS:<br/>
terraform init <br/>
terraform plan <br/>
terraform apply <br/>
Running terraform init will install the necessary plugins and modules required for connecting to AWS and managing your infrastructure.<br/>

4. And then define backend.tf, cloudfront.tf, dynamodb_table.tf, s3.tf file for creating the required infra as discussed at the beginning.

terraform apply -auto-approve
The code above will apply the necessary configurations for features such as static website hosting, bucket policies, and blocking public access to your bucket, create CDN distribution.



  
