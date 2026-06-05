# Case Study: Terraform AWS Secure VPC

## Problem

Cloud projects often start with ad hoc networking: public instances, unclear route tables, no flow logs, and security groups that are hard to review. This module demonstrates a small, explicit VPC baseline that separates public edge resources from private application subnets and turns network visibility on by default.

## Solution

The module creates a two-AZ VPC with public and private subnet tiers. Public subnets host edge resources such as an ALB and NAT gateway. Private subnets route outbound traffic through the NAT gateway and avoid public IP assignment. VPC Flow Logs are enabled to support troubleshooting, incident review, and audit evidence.

The design is cost-conscious: it uses one NAT gateway rather than NAT per AZ. That tradeoff is documented instead of hidden.

## Architecture

- One VPC with DNS support enabled.
- Two public subnets associated with an internet gateway route.
- Two private subnets associated with a private route table.
- One NAT gateway for private-subnet outbound traffic.
- Public ALB with configurable ingress CIDRs and optional WAFv2 Web ACL association.
- VPC Flow Logs to a CloudWatch Logs group.

## Engineering Choices

- The module keeps the network shape simple enough for quick review.
- Two AZs avoid a single-subnet design while keeping inputs predictable.
- Flow logs are always created so visibility is part of the baseline.
- The NAT design favors cost and simplicity over AZ-level egress availability.
- Security group rules are explicit, and the README documents where consumers must add stricter workload controls.

## Security And Reliability Controls

- Public/private subnet separation.
- No public IP assignment on private subnets.
- Configurable ALB ingress CIDRs.
- Optional WAF association for the ALB.
- VPC Flow Logs for all traffic.
- CI checks for Terraform formatting, validation, linting, and tfsec.

## Current Limitations

The module does not currently include isolated database subnets, NAT per AZ, private VPC endpoints, ALB access logging, or workload security groups. It is a VPC baseline, not a complete AWS landing zone.

## What This Shows

This repo is useful for showing Terraform discipline, AWS network fundamentals, and the ability to document infrastructure tradeoffs honestly. It should be presented as a focused baseline module rather than a complete production landing zone.

## Next Improvements

- Add optional isolated subnets and outputs.
- Add NAT-per-AZ mode.
- Add S3, DynamoDB, ECR, SSM, KMS, and CloudWatch Logs endpoints.
- Add ALB access logging.
- Add Terraform tests that assert route-table and security-group behavior.
