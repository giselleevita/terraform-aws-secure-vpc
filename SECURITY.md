# Security Policy

## Reporting Security Issues

If you discover a security vulnerability in this module, please email security concerns to the maintainer rather than opening a public GitHub issue.

**Do not** publicly disclose security vulnerabilities until they have been addressed.

---

## Security Scope

This module demonstrates **production-grade VPC architecture** with focus on network segmentation, visibility, and compliance readiness. It is designed to show:
- Network segmentation with public/private tiers
- Flow log visibility and compliance
- WAF-ready infrastructure
- Multi-AZ architecture for resilience

### What This Module Does
- Creates a VPC with public and private subnets across 2 AZs
- Configures routing and gateways for high availability
- Enables VPC Flow Logs for network visibility
- Provides IAM role and policies for flow log delivery
- Attaches optional WAF ACL to Application Load Balancer
- Manages security group ingress/egress rules

### What This Module Does NOT Do
- Manage EC2 instances or compute resources
- Configure S3 buckets for flow log storage (must pre-exist)
- Provide application-level security (WAF rules are template only)
- Manage route53 DNS or domain configuration
- Handle inter-VPC peering or transit gateway setup
- Provide VPN or direct connect configuration

---

## Assumptions & Limitations

1. **S3 Bucket Pre-exists**: VPC Flow Logs require an S3 bucket for storage; create this separately
2. **Two AZ Requirement**: This module enforces exactly 2 Availability Zones for redundancy (non-negotiable by design)
3. **IP CIDR Planning**: CIDR ranges must not overlap with existing VPCs or on-premises networks
4. **WAF is Optional**: Web Application Firewall integration is conditional; omit if not needed
5. **Single NAT Gateway**: Cost-optimized with one NAT gateway in public subnet (not HA)

---

## Dependency Security

This module uses only:
- **Terraform AWS Provider** (v5.0+): Regularly updated by HashiCorp
- **AWS VPC, ELB, IAM, Logs APIs**: Native AWS services with no external dependencies

Monitor the AWS provider changelog for security updates: https://github.com/hashicorp/terraform-provider-aws/releases

---

## Network Security Design

### Public Tier
- Directly routes to Internet Gateway
- Accepts inbound traffic on port 80/443 (ALB)
- NAT Gateway provides outbound internet for private tier
- No business logic runs here; ALB only

### Private Tier
- No direct internet access
- All outbound traffic routes through NAT Gateway
- Suitable for application/database workloads
- Restricted ingress from security group only

### Flow Logs
- Captures all network traffic (accepts and rejects)
- Logs to CloudWatch Logs group with configurable retention
- IAM role has minimal permissions (S3 write only)
- Critical for compliance audits (HIPAA, PCI-DSS, SOC 2)

---

## Testing & Validation

All changes to this module are validated with:
- `terraform fmt` — Formatting consistency
- `terraform validate` — Syntax and schema validation
- `tflint` — Best practices linting (catches common VPC misconfigurations)
- `tfsec` — Security scanning for network vulnerabilities
- `examples/basic/` — Full integration test with real values

Before using in production:
1. Review the VPC structure in AWS Console (VPC Dashboard)
2. Validate CIDR ranges don't overlap with existing infrastructure
3. Test with non-production subnets first
4. Run `terraform plan` and verify all route table entries
5. Confirm flow logs are writing to CloudWatch
6. If using WAF, validate the Web ACL is attached to ALB

---

## Known Limitations

- Single NAT Gateway (high availability requires additional configuration)
- Fixed 2 AZ requirement (no single-AZ or 3+ AZ option)
- ALB access logging not configured (optional enhancement)
- No VPN endpoint included (add separately if needed)
- Does not include Systems Manager endpoint (add for private EC2 access)
- NAT Gateway not highly available (all egress goes through single gateway)

---

## Security Best Practices When Using This Module

1. **CIDR Isolation**: Plan IP ranges to avoid conflicts with existing VPCs, on-premises networks, and multi-region deployments
2. **Security Group Audits**: Regularly review security group rules—don't open unnecessary ports
3. **Flow Log Monitoring**: Don't just ingest logs; set up CloudWatch Alarms for suspicious patterns
4. **IAM Least Privilege**: Flow log role grants only S3:PutObject (not Read or Delete)
5. **WAF Rules**: If enabling WAF, configure rule groups appropriate for your workload (OWASP Top 10, IP reputation, rate limiting)
6. **VPC Endpoint Strategy**: For services like S3, DynamoDB, ECR—add VPC endpoints to avoid internet egress
7. **Compliance Validation**: Use AWS Config rules to continuously validate VPC configuration matches policy
8. **Cost Management**: Monitor NAT Gateway data processing charges; consider VPC endpoints for S3 to reduce egress costs

---

## Version Support

- **Terraform**: 1.5.0 or later
- **AWS Provider**: 5.0 or later
- **AWS Regions**: All regions with proper AZ availability
- **Availability Zones**: Requires minimum 2 AZs in target region

Older versions may work but are not tested or supported.

---

## Incident Response

If you detect suspicious network activity in VPC Flow Logs:
1. Check CloudTrail for API calls matching the suspicious traffic
2. Review security group rules for unintended changes
3. Examine IAM role usage (AssumeRole activity)
4. If compromised, immediately restrict security group egress to block lateral movement
5. Enable VPC Flow Logs full detail mode (requires extra storage cost) for forensic analysis

---

## Compliance Notes

This module helps meet requirements for:
- **PCI DSS**: Network segmentation, flow logging, audit trails
- **HIPAA**: Private subnets for PHI data, flow logs for access tracking
- **SOC 2**: Network segmentation, availability across AZs, monitoring enabled
- **CIS AWS Foundations**: VPC Flow Logs enabled, security groups configured

Review your specific compliance framework for additional requirements not covered here.
