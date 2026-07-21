variable "project" {
  type        = string
  description = "Project name prefix"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets for ALB"
}

variable "security_group_id" {
  type        = string
  description = "Security group for ALB"
}

variable "instance_id" {
  type        = string
  description = "EC2 instance to attach to target group"
}

variable "target_port" {
  type        = number
  default     = 80
  description = "Port EC2 listens on"
}
