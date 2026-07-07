# Terraform AWS Infrastructure Project
A modular, production‑style AWS environment deployed using Terraform. This project demonstrates Infrastructure‑as‑Code (IaC), networking fundamentals, remote state management, and real DevOps workflows.

# Overview
This project provisions a secure, scalable AWS environment using Terraform. It includes a VPC, public and private subnets, routing, security groups, an EC2 instance, and a full remote state backend using S3 + DynamoDB.

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

