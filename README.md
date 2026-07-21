# Terraform AWS Infrastructure Project

A modular, production‑style AWS environment deployed using Terraform. This project demonstrates Infrastructure‑as‑Code (IaC), secure networking, remote state management, and real DevOps workflow patterns.

## Overview

This project provisions a secure AWS environment using Terraform. It includes a VPC with public and private subnets, routing, security groups, an EC2 instance in a private subnet, and a full remote state setup with state locking.

It is designed to showcase practical DevOps skills:

- Modular Terraform design
- Environment separation (dev/prod)
- Remote state + state locking
- AWS networking fundamentals
- Modern zero‑trust access patterns
- Clear documentation and architecture diagrams

## Quick Start

```bash
# Configure AWS credentials
aws configure

# Navigate to an environment
cd envs/dev

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Deploy infrastructure
terraform apply
```

## Prerequisites

- **Terraform** >= 1.0
- **AWS CLI** configured with credentials
- **AWS account** with appropriate IAM permissions
- **S3 bucket** and **DynamoDB table** for remote state (see [Remote State Setup](#remote-state-setup))

## Architecture

The infrastructure includes:

- VPC with public and private subnets
- Internet Gateway
- NAT Gateway
- Route tables + associations
- Security groups (ALB and EC2)
- EC2 instance in private subnet
- IAM role for EC2
- S3 bucket for Terraform remote state
- DynamoDB table for state locking
- Application Load Balancer (ALB)

This architecture follows modern AWS best practices, including SSM‑only access and no exposed SSH ports.

### Architecture Diagram

See `diagrams/architecture.png` for a visual representation of the infrastructure layout.

## Security Model

This project uses a **zero‑trust, no‑SSH security model**, aligned with modern AWS recommendations.

### Key Principles

- ✅ No public EC2 instances
- ✅ No inbound SSH anywhere
- ✅ No bastion host required
- ✅ All access via AWS Systems Manager Session Manager
- ✅ Private EC2 instances have no public IP
- ✅ Security groups allow only ALB → EC2 traffic
- ✅ Outbound‑only connectivity from private subnets
- ✅ IAM roles control access instead of network exposure

### Benefits

- Stronger security posture
- No SSH key management overhead
- No exposed attack surface
- Fully auditable access (CloudTrail + SSM logs)
- Cleaner architecture and simpler operations

### Security Checklist

- [ ] No hardcoded credentials in code
- [ ] IAM roles follow least-privilege principle
- [ ] Security groups restrict traffic appropriately
- [ ] CloudTrail logging enabled for audit trail
- [ ] State file encryption enabled in S3
- [ ] VPC Flow Logs enabled for network monitoring

## Connectivity Flow

### Inbound Traffic (Public → Private)

1. User accesses the ALB (public subnet)
2. ALB forwards HTTP traffic to the private EC2 instance
3. Private EC2 responds through the ALB

### Outbound Traffic (Private → Internet)

1. Private EC2 sends outbound HTTPS traffic (SSM, yum updates, etc.)
2. NAT Gateway forwards traffic to the internet
3. Responses return through NAT → private EC2

### Administrative Access (SSM Only)

1. EC2 instance boots with SSM agent preinstalled
2. IAM role (`AmazonSSMManagedInstanceCore`) registers the instance with SSM
3. Connect using AWS Console or CLI:
   ```bash
   aws ssm start-session --target <instance-id> --region us-east-1
   ```

## Instance Access (SSM‑Only)

This infrastructure uses **AWS Systems Manager Session Manager** for all EC2 access:

- SSH is disabled; no public keys are required
- No bastion host is deployed
- Private EC2 instances have no public IP
- No inbound SSH rules exist on any security group
- Access is performed through the AWS Console or AWS CLI
- The EC2 IAM role includes `AmazonSSMManagedInstanceCore`
- The SSM agent is preinstalled on Amazon Linux 2
- Outbound HTTPS allows the instance to register with SSM

This follows modern AWS best practices and provides secure, auditable, zero‑trust access without exposing port 22.

## Project Structure

```
terraform-infrastructure/
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── alb/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── security-groups/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── envs/
│   ├── dev/
│   │   ├── terraform.tfvars
│   │   └── main.tf
│   └── prod/
│       ├── terraform.tfvars
│       └── main.tf
├── diagrams/
│   └── architecture.png
└── README.md
```

## Remote State Setup

Terraform remote state is stored in:

- **S3 bucket** (e.g., `terraform-state-nadia`)
- **DynamoDB table** for state locking (e.g., `terraform-lock`)

This enables:
- Safe collaboration across team members
- Prevention of state corruption and conflicts
- Full audit trail of infrastructure changes
- Reflection of production DevOps workflows

### Assumptions

- Using Amazon Linux 2 for EC2 instances
- AWS region defaults to `us-east-1` (configurable via `tfvars`)
- Remote state backend is pre-configured

## Modules

### VPC Module

Creates the VPC, subnets, IGW, NAT Gateway, route tables, and associations.

### Security Groups Module

Defines reusable security groups for ALB and private EC2.

### EC2 Module

Deploys an EC2 instance into the private subnet with IAM roles and optional user data.

### ALB Module

Creates an Application Load Balancer, target group, listener, and EC2 attachment.

## Common Operations

### Connect to EC2 via SSM

```bash
aws ssm start-session --target <instance-id> --region us-east-1
```

### Destroy infrastructure

```bash
terraform destroy
```

### View current state

```bash
terraform state list
terraform state show <resource_name>
```

### Refresh state (without applying)

```bash
terraform refresh
```

## Troubleshooting

### SSM Session Manager not working
- Verify the EC2 IAM role includes `AmazonSSMManagedInstanceCore`
- Ensure the instance has outbound HTTPS access to SSM endpoints
- Check that the instance is registered in the Systems Manager Fleet Manager

### Terraform lock timeout
- Ensure the DynamoDB table exists and is accessible
- Verify IAM permissions allow DynamoDB read/write operations
- Check for stuck locks: `terraform force-unlock <LOCK_ID>`

### State file conflicts
- Never edit `.tfstate` directly
- Use `terraform refresh` if needed to sync state
- Use `terraform state rm` to remove problematic resources

### ALB not forwarding traffic
- Verify security group rules allow ALB → EC2 traffic on port 80/443
- Check that the EC2 instance is registered in the ALB target group
- Ensure the EC2 instance is running and healthy

## Technologies Used

- **Terraform** - Infrastructure as Code
- **AWS Services**:
  - EC2 (Elastic Compute Cloud)
  - VPC (Virtual Private Cloud)
  - IAM (Identity & Access Management)
  - S3 (Simple Storage Service)
  - DynamoDB (for state locking)
  - ALB (Application Load Balancer)
  - Systems Manager (SSM)
  - CloudWatch (Monitoring)
- **Infrastructure‑as‑Code (IaC)** patterns
- **Remote state + locking** for team collaboration
- **Modular Terraform** design patterns

## What I Learned

- How to design modular, reusable Terraform code
- How remote state and locking work in real DevOps teams
- How to build secure AWS networking (public/private subnets, routing, NAT)
- How IAM roles and security groups shape access patterns
- How to structure IaC repositories professionally
- How to deploy infrastructure repeatedly across environments
- How to implement modern SSM‑only access patterns (no SSH)
- Best practices for zero‑trust infrastructure design

## Future Improvements

- [ ] Add VPC Endpoints for SSM (remove NAT Gateway dependency)
- [ ] Add Auto Scaling Group for dynamic capacity
- [ ] Add RDS or DynamoDB database layer
- [ ] Add CI/CD pipeline for Terraform (GitHub Actions)
- [ ] Add monitoring dashboards (CloudWatch / Grafana)
- [ ] Add tagging standards for cost visibility and governance
- [ ] Implement Terraform testing (terratest, tflint)
- [ ] Add backup and disaster recovery strategies

## Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Systems Manager Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html)
- [Terraform Best Practices](https://www.terraform.io/cloud-docs/recommended-practices)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Zero Trust Architecture on AWS](https://docs.aws.amazon.com/security/latest/userguide/zero-trust.html)

## About This Project

This project is part of my DevOps/Cloud Engineering portfolio, demonstrating practical skills in AWS, Terraform, automation, and infrastructure design.

---

**Questions or feedback?** Feel free to open an issue or reach out!
