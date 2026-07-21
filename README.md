#Terraform AWS Infrastructure Project
A modular, production‑style AWS environment deployed using Terraform. This project demonstrates Infrastructure‑as‑Code (IaC), secure networking, remote state management, and real DevOps workflows.

#Overview
This project provisions a secure AWS environment using Terraform. It includes a VPC with public and private subnets, routing, security groups, an EC2 instance in a private subnet, and a full remote state backend using S3 and DynamoDB.

It is designed to showcase practical DevOps skills:

Modular Terraform design

Environment separation (dev/prod)

Remote state + state locking

AWS networking fundamentals

Modern zero‑trust access patterns

Clear documentation and architecture diagrams

Architecture
The infrastructure includes:

VPC

Public subnet

Private subnet

Internet Gateway

NAT Gateway

Route tables + associations

Security groups

EC2 instance in private subnet

IAM role for EC2

S3 bucket for Terraform remote state

DynamoDB table for state locking

Application Load Balancer (ALB)

This architecture follows modern AWS best practices, including SSM‑only access and no exposed SSH ports.

Architecture Diagram
[Looks like the result wasn't safe to show. Let's switch things up and try something else!]

Security Model
This project uses a zero‑trust, no‑SSH security model, aligned with modern AWS recommendations.

Key Principles
No public EC2 instances

No inbound SSH anywhere

No bastion host required

All access via AWS Systems Manager Session Manager

Private EC2 instances have no public IP

Security groups allow only ALB → EC2 traffic

Outbound‑only connectivity from private subnets

IAM roles control access instead of network exposure

Benefits
Stronger security posture

No SSH key management

No exposed attack surface

Fully auditable access (CloudTrail + SSM logs)

Cleaner architecture and simpler operations

Connectivity Flow
This section explains how traffic moves through the environment.

Inbound Traffic (Public → Private)
User accesses the ALB (public subnet).

ALB forwards HTTP traffic to the private EC2 instance.

Private EC2 responds through the ALB.

Outbound Traffic (Private → Internet)
Private EC2 sends outbound HTTPS traffic (e.g., SSM, yum updates).

NAT Gateway forwards traffic to the internet.

Responses return through NAT → private EC2.

Administrative Access (SSM Only)
EC2 instance boots with SSM agent preinstalled.

IAM role (AmazonSSMManagedInstanceCore) registers the instance with SSM.

You connect using AWS Console or CLI:

EC2 → Connect → Session Manager

No inbound ports, no SSH, no bastion host.

This creates a secure, modern, minimal‑exposure environment.

Instance Access (SSM‑Only)
This infrastructure uses AWS Systems Manager Session Manager for all EC2 access.
SSH is disabled, no public keys are required, and no bastion host is deployed.

Private EC2 instances have no public IP

No inbound SSH rules exist on any security group

Access is performed through the AWS Console or AWS CLI

The EC2 IAM role includes AmazonSSMManagedInstanceCore

The SSM agent is preinstalled on Amazon Linux 2

Outbound HTTPS allows the instance to register with SSM

This follows modern AWS best practices and provides secure, auditable, zero‑trust access without exposing port 22.

Project Structure
Code
terraform-infrastructure/
├── modules/
│   ├── vpc/
│   ├── ec2/
│   ├── alb/
│   └── security-groups/
├── envs/
│   ├── dev/
│   └── prod/
├── diagrams/
│   └── architecture.png
└── README.md
Remote State Setup
Terraform remote state is stored in:

S3 bucket (e.g., terraform-state-nadia)

DynamoDB table for state locking (e.g., terraform-lock)

This enables safe collaboration, prevents state corruption, and reflects production workflows.
