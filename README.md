# Kubernetes Infrastructure Setup

This Terraform code sets up the network, EKS cluster, and CloudFront resources in two environments: **Dev** and **Prod**.

## Directory Structure

### `.github`
This directory contains GitHub Actions workflows:

- **Review Workflow**: Validates non-master branch commits. This includes:
  - Running `terraform plan` to ensure the changes work as expected.
  - Running `terraform fmt` to verify proper formatting.
  - Optionally integrating **TFSEC** for security reviews of the infrastructure.
- **Deployment Workflow**: Deploys the latest commit on the `master` branch using `terraform apply`.

All steps are automated using Terragrunt's `run-all` command. While this approach may not suit all kind of projects, it simplifies this example by managing multiple environments simultaneously.

---

### `common`
This directory contains shared resources within the same account, such as **ECR registries**. The registries are created using a custom Terraform module that I developed and hosted in a separate Git repository.

Hosting modules in separate repositories allows different teams to collaborate and manage the module independently, improving scalability and modularity.

---

### `DEV`, `PROD`
These directories contain environment-specific resources for **Dev** and **Prod**, including:

1. **Network**
   - For the network setup, I used the official `aws-vpc` module, which provides all the necessary resources for a simple network setup.
   - The module creates:
     - Public, private, and intra subnets.
     - Associated route tables and NAT gateways.

2. **Cluster**
   - For the Kubernetes cluster, I used the official `aws-eks` module.
   - This module sets up:
     - An additional node group (besides the default one).
     - Three essential cluster add-ons: **CoreDNS**, **kube-proxy**, and **vpc-cni**.

3. **CDN**
   - I created a separate **CDN module** for this setup.
   - The module provisions:
     - An empty S3 bucket.
     - A CloudFront distribution.
     - An S3 origin for the CloudFront distribution.
     - The necessary policies.