# Contributing to terraform-aws-secure-vpc

Contributions are welcome. This project is maintained as a reference implementation of secure AWS networking in Terraform.

## How to Contribute

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes with clear intent
4. Run `terraform fmt -recursive` to format code
5. Run `terraform validate` to check syntax
6. Test examples: `terraform init && terraform plan` in `examples/basic`
7. Commit with clear messages: `git commit -m "feat: description"`
8. Push and open a pull request with context

## Code Standards

- Use `terraform fmt` for consistent formatting
- Add validation rules to all new variables
- Update README.md with architecture changes
- Maintain security posture: no open security groups, explicit CIDR scoping
- Document why, not just what—comments should explain decisions

## Testing

Before submitting a PR, ensure all checks pass:

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
tflint --recursive
tfsec
```

For integration testing:

```bash
cd examples/basic
terraform init
terraform plan -out=tfplan
```

## Design Philosophy

This module is opinionated:
- Security defaults over simplicity
- Two AZs for high availability
- VPC Flow Logs always enabled
- Network segmentation (public/private tiers)

Before proposing major changes, open an issue to discuss.

## Questions?

Open an issue or discussion. We're happy to explain design choices.
