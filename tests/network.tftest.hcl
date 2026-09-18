mock_provider "aws" {
  mock_data "aws_availability_zones" {
    defaults = {
      names = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    }
  }

  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{}"
    }
  }
}

variables {
  name_prefix        = "secure-test"
  availability_zones = ["eu-west-1a", "eu-west-1b"]
}

run "secure_network_defaults" {
  command = plan

  assert {
    condition     = length(aws_subnet.public) == 2 && length(aws_subnet.private) == 2
    error_message = "The module must create exactly two public and two private subnets."
  }

  assert {
    condition     = alltrue([for subnet in aws_subnet.private : subnet.map_public_ip_on_launch == false])
    error_message = "Private subnets must never auto-assign public IP addresses."
  }

  assert {
    condition     = aws_flow_log.this.traffic_type == "ALL"
    error_message = "VPC flow logs must capture accepted and rejected traffic."
  }

  assert {
    condition     = aws_lb.this.enable_deletion_protection == true
    error_message = "ALB deletion protection must be enabled by default."
  }

  assert {
    condition     = length(aws_wafv2_web_acl_association.alb) == 0
    error_message = "The default null WAF ARN must produce a valid plan without an association."
  }
}

run "rejects_wrong_subnet_count" {
  command = plan

  variables {
    public_subnet_cidrs = ["10.20.1.0/24"]
  }

  expect_failures = [var.public_subnet_cidrs]
}
