variable "project" {
  type        = string
  description = "Project name prefix"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "rds_port" {
  type        = number
  default     = 5432
  description = "Port for RDS (default PostgreSQL)"
}
