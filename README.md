# terraform-aws-secure-vpc

Terraform module for a production-hardened AWS VPC — private/public subnet segmentation, NAT gateways, VPC Flow Logs, and security group defaults.

## What it does

- Multi-AZ VPC with public, private, and isolated subnet tiers
- NAT Gateway per AZ for HA egress
- VPC Flow Logs to S3/CloudWatch for audit and threat detection
- Default deny-all security group baseline
- Optional VPC endpoints for S3 and DynamoDB (no internet egress for internal traffic)

## Usage

```hcl
module "secure_vpc" {
  source             = "./modules/secure-vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  enable_flow_logs   = true
}
```

## Requirements

- Terraform >= 1.3
- AWS provider >= 5.0

## License

MIT
