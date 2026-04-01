# Why This Module Exists

## The Problem

Most VPC deployments are either:
1. **Too simple:** a single subnet, no network segmentation, everything exposed to the internet
2. **Too complex:** dozens of subnets, inconsistent tagging, no logging, hard to audit

Both lead to security and compliance issues.

## The Solution

This module provides a **secure baseline** that is:
- Opinionated: sensible defaults reduce configuration burden
- Observable: flow logs capture all traffic
- Segmented: public and private tiers with proper routing
- Auditable: resources are tagged consistently

Deploy it, add your workloads, sleep better at night.

## Key Design Decisions

### Why two AZs always?
High availability isn't optional. If one AZ goes down, your workloads fail. Two AZs is the minimum for production. This module enforces it.

### Why flow logs from day one?
You can't detect an intrusion if you don't see the traffic. Flow Logs to CloudWatch are cheap ($0.50/GB) and essential for:
- Threat investigation
- GuardDuty integration
- Compliance audits
- Cost tracking

### Why separate public and private subnets?
Public workloads (ALB, NAT gateway) have a different threat model than private workloads (databases, internal services). Keeping them separate lets you apply different security group rules, VPC endpoints, and monitoring.

### Why NAT gateway in public subnet?
Private instances need outbound internet access (patches, external APIs). A NAT gateway in the public subnet provides that escape route without exposing private instances to inbound internet traffic.

### Why optional WAF?
WAF is powerful but not always necessary. The ALB is ready for it (proper security groups, access logging path), but you enable WAF only when you need it. This avoids lock-in and unnecessary costs.

## Real-World Usage

Deploy this module to get:
- Production-ready networking in minutes
- Automatic flow logs for compliance
- A foundation that scales (add RDS, Elasticache, etc.)
- Clear network boundaries for security teams to reason about

## Learning Outcome

If you understand this module, you understand:
- Why network segmentation matters
- How routing tables and NAT gateways work
- Why observability (logs) is non-negotiable
- How to design infrastructure for security, not just functionality

That knowledge is valuable in any cloud environment.
