# Terraform AWS Infrastructure Project
A modular, production‑style AWS environment deployed using Terraform. This project demonstrates Infrastructure‑as‑Code (IaC), networking fundamentals, remote state management, and real DevOps workflows.

# Overview
This project provisions a secure, scalable AWS environment using Terraform. It includes a VPC, public and private subnets, routing, security groups, an EC2 instance, and a full remote state backend using S3 and DynamoDB.

It is designed to showcase practical DevOps skills:

 - Modular Terraform design
 - Environment separation (dev/prod)
 -  Remote state + state locking
 - AWS networking fundamentals
 -  Secure infrastructure patterns
 -  Clear documentation and architecture diagrams

# Architecture
The infrastructure includes:
 - VPC
 - Public subnet
 - Private subnet
 - Internet Gateway
  - NAT Gateway
 - Route tables + associations
 - Security groups
 - EC2 instance in private subnet
 - IAM role for EC2
 - S3 bucket for Terraform remote state
 - DynamoDB table for state locking
A visual diagram is included in the diagrams/ folder.

# Project Structure
terraform-infrastructure/
│
├── modules/
│   ├── vpc/
│   ├── ec2/
│   └── security-groups/
│
├── envs/
│   ├── dev/
│   └── prod/
│
├── diagrams/
│   └── architecture.png
│
└── README.md

# Remote State Setup
Terraform remote state is stored in:

S3 bucket (e.g., terraform-state-nadia)
DynamoDB table for state locking (e.g., terraform-lock)
This enables safe collaboration, prevents state corruption, and reflects production workflows.

# How to Deploy
1. Configure AWS credentials
   aws configure
   
2. Navigate to an environment
   cd envs/dev
   
3. Initialise Terraform
   terraform init
   
4. Preview changes
   terraform plan

5. Deploy infrastructure
   terraform apply

# Modules Included
VPC Module
Creates the VPC, subnets, IGW, NAT Gateway, route tables, and associations.

Security Groups Module
Defines reusable security groups for EC2 and other resources.

EC2 Module
Deploys an EC2 instance into the private subnet with IAM roles and optional user data.

# Technologies Used
Terraform
AWS (EC2, VPC, IAM, S3, DynamoDB, CloudWatch)
Infrastructure‑as‑Code (IaC)
Remote state + locking
Modular Terraform patterns

# What I Learned
How to design modular Terraform code
How remote state and locking work in real DevOps teams
How to build secure AWS networking (public/private subnets, routing, NAT)
How IAM roles and security groups shape access patterns
How to structure IaC repositories professionally
How to deploy infrastructure repeatedly across environments

# Future Improvements
- Add ALB + Auto Scaling Group
- Add RDS or DynamoDB
- Add CI/CD pipeline for Terraform (GitHub Actions)
- Add monitoring dashboards (CloudWatch / Grafana)
- Add SSM Session Manager instead of SSH
- Add tagging standards for cost visibility

# About This Project
This project is part of my DevOps/Cloud Engineering portfolio, demonstrating practical skills in AWS, Terraform, automation, and infrastructure design.
