# SBS TECH HIRING CHALLENGE LAB

## Product Architecture
<img width="1000" alt="Screenshot 2023-12-31 at 11 06 25 pm" src="https://github.com/techielife9/sbs-tech-hiring-challenge-v1/assets/29218570/33a4272b-78bb-44b8-b2f8-50135eaf1fd7">


## Expected Result

<img width="1000" alt="Screenshot 2023-12-31 at 7 52 03 pm" src="https://github.com/techielife9/sbs-tech-hiring-challenge-v1/assets/29218570/83d15ac9-52c7-41f1-9f82-d2fec5647882">


#### Serverless Approach

Deploy a Highly Available Webserver solution that is self-healing, fault-tolerant as much as possible, and must make use of server-less offerings from AWS for compute. <br/>

Infra used for serverless:  <br/>
  - CloudFront distribution + API Gateway + private S3 bucket + Lambda <br/>
  - Advantage: easy to implement, private s3 bucket, cache for static files + API gateway for trigger functionality  <br/>

#### Key Components and Features:
Terraform Infrastructure as Code (IaC):
I utilized Terraform, an IaC tool, to define and provision the AWS resources required for my static website hosting solution. This allows for version-controlled, repeatable infrastructure deployments.

#### AWS S3 Bucket
Created an S3 bucket to store backend files and serve the static website files. This bucket is configured for website hosting, allowing for easy content delivery.

#### DynamoDB 
In order to use the terraform state locking leveraging the AWS service Dynamo DB.

####  CloudFront
Used CloudFront to distribute the static website's content across a network of edge locations worldwide. This reduces latency and improves the load times for users in different geographical locations. There by making the website self healing, highly available and fault tolerant at all times.

####  AWS Lambda
Using the Lambda function used as a server side script to print the date and internal server IP address on the sbs worldcup image.

#### API Gateway
API Gateway is to trigger the lambda function.

####  Content Upload and Management
Provided instructions and scripts for uploading and managing my website content within the S3 bucket. <br/>
 1. index.html <br/>
 2. main.js <br/>
 3. sbs-world-cup.png <br/>

####  Prerequisites
1. Basic knowledge of AWS services and concepts.
2. Familiarity with Terraform and infrastructure as code principles.
3. An AWS account with appropriate permissions.
4. An IDE of your choice , I would suggest VS Code Editor .
5. This project serves as an excellent foundation for hosting static websites of Football worldcup

####  Steps
####  Step 1: Set Up Your Development Environment
Install Terraform and the AWS Command Line Interface (CLI) on your local machine. Configure your AWS credentials by running aws configure and providing your AWS access key and secret key.

#### Step 2: Define Your Website Content
To prepare static website files (HTML), place them in the directory where your Terraform configuration files are located. Name the main HTML file "index.html," and optionally, you can also include an "error.html" file. If you prefer, you can reference my repository for the static website HTML files. <br/>

I also made sure we will have server and client side script to display the date and timestamp for serverless app. <br/>
Also templatefile mechanism is used to read the file at the given path which is main.js and renders its content as a template using a supplied set of template variables in S3 bucket.

#### Step 3: Terraform Configuration File Syntax
If we want to create a terraform configuration file we have to use .tf (e.g., main.tf) to define the infrastructure as code using terraform.

####  Step 4: Define your Configuration Files in your IDE
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

4. And then define backend.tf, cloudfront.tf, dynamodb_table.tf, s3.tf, lambda.tf file for creating the required infrastructure. <br/>


terraform apply -auto-approve
The code above will apply the necessary configurations for features such as static website hosting, bucket policies, and blocking public access to your bucket, create CDN distribution. <br/>


####  Output
Below is the Cloudfront and API Gateway URL output after running the terraform apply to access the website.

<img width="1000" alt="Screenshot 2023-12-31 at 8 41 59 pm" src="https://github.com/techielife9/sbs-tech-hiring-challenge-v1/assets/29218570/3e8dd082-1f63-4e49-86ca-5c110383fb90">




  
