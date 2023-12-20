<img width="440" alt="Screenshot 2023-12-20 at 12 28 28 am" src="https://github.com/techielife9/sbs-tech-hiring-challenge/assets/29218570/70a44e1a-6760-443d-bb0a-45d890493aea">

# SBS Tech Hiring Challenge Approach 1

####  Deploy a Highly Available Webserver solution using a mixture of Compute, Load Balancing and other services available from AWS. 
The solution should be self-healing, fault-tolerant as much as possible.
Web-Server: Linux OS

#### Expected Output
Launch the HTML page that contains the SBS World Cup Image in addition to the message “Date on Webserver IP Address {PRIVATE_IP_ADDRESS} is {YEAR/MONTH/DATE HOUR:MIN:SECS}”

#### Infrastructure Usage 
   1. Usage of Netwoking Services <br />
      VPC, Security Group, Subnets, IGW
   2. IAM profile used for accessing compute with S3
   3. S3 Bucket <br /> 
     --> To store terraform backend file. <br /> 
     --> To store the static website. <br /> 
   4. Dynamo DB to handle lock file mechanism
   5. Application Load Balancer to Distribute the traffic
   6. Auto scaling group used to increase or decrease based on the demand

#### Used Terraform to provision the infrastructure
Usage .tf tile
   1. main
   2. modules
   3. outputs
   4. variables

#### Git Operations
   1. Using .gitignore to ignore the *.tfstate, *.tfstate.* files
   2. main branch has rough code to provision with infrastructure but lacks code re-usability
   3. Updated the latest code in feature-modules-terraform branch.
   4. Will only be pushing to main branch once the approver will approve the code.
   5. Should follow the PR process to merge to main branch.
