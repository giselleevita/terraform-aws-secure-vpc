# terraform-aws-secure-vpc

![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.3-purple)
![AWS](https://img.shields.io/badge/AWS-VPC%20%7C%20Flow%20Logs-orange)
![License](https://img.shields.io/badge/license-MIT-green)

> Terraform module for a production-hardened AWS VPC — private/public/isolated subnet segmentation, NAT gateways, VPC Flow Logs to S3, default-deny security groups, and optional private VPC endpoints.

For the hiring-focused project narrative, see [docs/CASE_STUDY.md](docs/CASE_STUDY.md).

Drop this module into any AWS account to establish a network security baseline aligned with CIS AWS Foundations Benchmark and NIST SP 800-53.

---

## What It Enforces

| Control | Implementation |
|---|---|
| Network segmentation | Public, private, and isolated subnet tiers across multi-AZ |
| Default-deny egress | Default security group blocks all traffic; explicit rules required |
| Audit-ready flow logs | VPC Flow Logs to S3 and/or CloudWatch for threat detection |
| HA egress | NAT Gateway per AZ — no single point of failure |
| Private S3/DynamoDB access | VPC endpoints eliminate internet egress for internal AWS traffic |

---

## Compliance Mapping

| Framework | Controls Covered |
|---|---|
| CIS AWS Foundations v2 | 3.7, 3.9, 5.1, 5.2, 5.4 |
| NIST SP 800-53 | SC-7, SC-8, AU-2, AU-12, SI-4 |
| ISO 27001:2022 | A.8.20, A.8.21, A.8.22, A.5.33 |

---

## Usage

```hcl
module "secure_vpc" {
  source             = "./modules/secure-vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  enable_flow_logs   = true
  flow_logs_dest     = "s3"   # or "cloudwatch"
  enable_vpc_endpoints = true  # S3 + DynamoDB
}
```

---

## Subnet Tiers

| Tier | Internet Access | Use Case |
|---|---|---|
| Public | Yes (IGW) | Load balancers, bastion hosts |
| Private | Outbound only (NAT) | Application servers, EKS nodes |
| Isolated | None | Databases, internal services |

---

## Requirements

- Terraform >= 1.3
- AWS provider >= 5.0
- IAM permissions: `ec2:*`, `logs:*` (for flow logs)

---

## Related

- [terraform-aws-iam-baseline](https://github.com/giselleevita/terraform-aws-iam-baseline) — least-privilege IAM baseline
- [secure-docs-aws](https://github.com/giselleevita/secure-docs-aws) — encrypted document storage with KMS + S3

---

## License

MIT
