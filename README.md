# SBS-tech-hiring-challenge

###  Deploy a Highly Available Webserver solution using a mixture of Compute, Load Balancing and other services available from AWS. 
###  The Solution should be self-healing, fault-tolerant as much as possible, and must make use of server-less offerings from AWS for compute.
###  Web-Server: Linux OS

###  Aim of the solution should be self-healing, fault-tolerant as much as possible.


### Expected Output
### Launch the HTML page that contains the SBS World Cup Image in addition to the message “Date on Webserver IP Address {PRIVATE_IP_ADDRESS} is {YEAR/MONTH/DATE HOUR:MIN:SECS}”

#### Infrastructure Usage: 
  1. Followed Netwoking Services 
      VPC, Security Group, Subnets, IGW
  2. IAM profile used for accessing compute with S3
  3. S3 Bucket 
    - To store terraform backend file
    - To store the static website.
  4. Dynamo DB to handle lock file
  5. Load Balancer to Distribute the traffic
  6. Auto scaling group used for to increase the scaled based on demand
