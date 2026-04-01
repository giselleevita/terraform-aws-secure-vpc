variable "name_prefix" {
  description = "Prefix used for naming AWS resources"
  type        = string

  validation {
    condition     = length(trim(var.name_prefix, " ")) > 0
    error_message = "name_prefix must not be empty."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.20.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "public_subnet_cidrs" {
  description = "Two public subnet CIDR blocks, one per AZ"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2 && alltrue([for cidr in var.public_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "public_subnet_cidrs must contain exactly two valid CIDR blocks."
  }
}

variable "private_subnet_cidrs" {
  description = "Two private subnet CIDR blocks, one per AZ"
  type        = list(string)
  default     = ["10.20.11.0/24", "10.20.12.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) == 2 && alltrue([for cidr in var.private_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "private_subnet_cidrs must contain exactly two valid CIDR blocks."
  }
}

variable "availability_zones" {
  description = "Optional list of two AZs. If empty, the first two available AZs are used"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.availability_zones) == 0 || length(var.availability_zones) == 2
    error_message = "availability_zones must be empty or contain exactly two AZ names."
  }
}

variable "alb_ingress_cidrs" {
  description = "CIDR ranges allowed to access ALB on 80/443"
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = alltrue([for cidr in var.alb_ingress_cidrs : can(cidrhost(cidr, 0))])
    error_message = "alb_ingress_cidrs must contain valid CIDR blocks."
  }
}

variable "alb_deletion_protection" {
  description = "Enable deletion protection on the ALB"
  type        = bool
  default     = true
}

variable "waf_web_acl_arn" {
  description = "Optional WAFv2 Web ACL ARN to associate with the ALB"
  type        = string
  default     = null
}

variable "flow_logs_retention_days" {
  description = "CloudWatch Logs retention period in days for VPC flow logs"
  type        = number
  default     = 90

  validation {
    condition     = var.flow_logs_retention_days >= 1
    error_message = "flow_logs_retention_days must be at least 1 day."
  }
}

variable "tags" {
  description = "Tags applied to all supported resources"
  type        = map(string)
  default     = {}
}