# Kubernetes Infra Setup

This terraform code create Network, EKS Cluster and Cloudfront resources in to environments which are Dev and Prod

## Directory Structure

* **.gihub**

    * includes github actions workflows. There are two workflow one of them for review and check the pushed non-master branch references. With these checks we can be sure the pushed non-master commits works correctly `terraform plan` and well formated `terraform fmt`. also review pipeline may include [TfSec](https://aquasecurity.github.io/tfsec/v1.28.1/) tool for reviewing from security perspective for infrastructure. Deployment workflows is deploying all last commit on master branch `terraform apply`. All this steps automated with `terragrunt` with `run-all` command. Run-all approachs may not suitable for all kind of projects but in this example i would like to create very simple example

* **common**
    
    * this directory has common resources in same account like ECR Registries. Ecr registries created by module, this module created by me and it is hosted on git repository. I want to demonstrate how to we use our modules in a terraform project. When we host the modules in different repositories it gives us to manage this module with in a different teams.  

* **DEV, PROD**
    * **Network**
        In network section of this example, I used official aws-vpc module because it provides neccessary resources for simple network. The module creates public, private and intra subnets and with neccessary route tables and nat-gateways

    * **Cluster**
        In cluster section of this example, I used official aws-eks module, with input parameters the module creates a node-group besides default one and it adds 3 cluster addons which are coredns, kube-proxy, vpc-cni
    
    * **CDN**
        In cluster section of this example, I created a seperate CDN module. This module create a empty s3 bucket, cloudfront, s3 origin for cloudfront and neccessary policies.

