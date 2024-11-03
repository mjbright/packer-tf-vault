
This file lists any environment specifics, or preparation notes which may be important ...

# Environment

Labs run not in AWS CloudShell but from a local VM.

# ======= Packer Labs ===========================================

# Packer Lab 1 ==> labs/packer-build/index.md <== Lab 1: Build Packer image

## Updates

- Updated to use Packer v1.11.2
- Updated to install the "AWS Plugin" for Packer

## Extra steps required

In the local environment is was necessary to:
- install the awscli (v2) using

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

- export AWS_DEFAULT_REGION=us-east-1

- Create a default vpc:               ```aws ec2 create-default-vpc```
- Create a subnet on the default vpc: ```aws ec2 create-default-subnet --availability-zone us-east-1a```

## LAB FILES:
- packer/lab1/plugin.pkr.hcl   => github.com/hashicorp/amazon
- packer/lab1/example.pkr.hcl  => var, source, build block (with shell provisioner)
- packer/lab1/lab1.build.1.txt => Notes on awscli, packer installation, packer build invocation

# Packer Lab 2 ==> labs/packer-provisioner/index.md <== Lab 2: Packer Provisioners

## Updates

- Modified firstrun.pkg.hcl to use Ubuntu 24.04
- Modified provisioner block to use "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server"

## Suggested improvements

- Don't modify lab1's example.pkg.hcl
- Rename firstrun.pkg.hcl as aws-redis.pkg.hcl
- Remove references to welcome.txt, example.sh
- Add provisioner block to aws-redis.pkg.hcl

## LAB FILES:
- firstrun.pkr.hcl => initial basic version using example.sh/welcome.txt
- redis-server.pkr.hcl => uses provisioner to install redis-server (use of DEBIAN_NONINTERACTIVE env var)

# Packer Lab 3 ==> labs/packer-variables/index.md <== Lab 3: Packer Variables

## Updates

- Made text more explicit about use of *.auto.pkrvars.hcl files (and use of "packer build .")

## LAB FILES:
- redis-server.pkr.hcl
- redis-server.auto.pkrvars.hcl
- redis-server.pkr.hcl

- packer/tf.test: outputs.tf vars.tf, provider.tf, terraform.tfvars, main_securitygroup.tf, main.tf

# ======= Terraform Labs ===========================================

# Terraform Lab 1 ==> labs/tf-first-instance/index.md <==

## LAB FILES: terraform/tf-lab1
- main.tf => terraform (aws), provider "aws", resource "aws_instance" "lab1-tf-example" blocks

# Terraform Lab 2 ==> labs/tf-variables-and-output/index.md <==

## LAB FILES: terraform/tf-lab2
- main.tf (as lab1, with Name tag from variable), variables.tf (tag), - outputs.tf (2 simple examples)

# Terraform Lab 3 ==> labs/tf-more-variables/index.md <==

## LAB FILES: terraform/tf-lab3, lab3 & lab4

initial version:
- variables.tf, outputs.tf
- terraform.tfvars
- main.tf
  - terraform, provider "aws"
  - data "aws_availability_zones" "available" => get available zones
  - resource "random_string" "lb_id"          => obtain partly randomized lb name
  - module "vpc", module "app_security_group", module "lb_security_group", module "elb_http", module "ec2_instances"
    => use various modules from terraform registry (terraform-aws-modules ...)
  - modules/aws-instance/variables.tf, outputs.tf, main.tf
    => use local module

## Updates
- Corrected aws_region (in variables.tf) to "us-west-1" as per initial main.tf

TODO: Add schema of topology ...

# Terraform Lab 4 ==> labs/tf-even-more-variables/index.md <==

# Terraform Lab 5 ==> labs/tf-remote-state/index.md <==

# Terraform Lab 6 ==> labs/tf-import/index.md <==

# Terraform Lab 7 ==> labs/tf-provisioner/index.md <==

# Terraform Lab 8 ==> labs/tf-module/index.md <==

# Terraform Lab 9 ==> labs/tf-write-module/index.md <==

# ======= Vault Labs ===========================================

# Vault Policies ==> labs/vault-policies/index.md <==

# Vault Secrets ==> labs/vault-secrets/index.md <==



