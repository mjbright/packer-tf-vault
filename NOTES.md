
This file lists any environment specifics, or preparation notes which may be important ...

# Environment

Labs run not in AWS CloudShell but from a local VM.

# Lab 1: Build Packer image

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

- Create a subnet on the default vpc: ```aws ec2 create-default-subnet --availability-zone us-east-1a```

# Lab 2: Packer Provisioners

## Updates

- Modified firstrun.pkg.hcl to use Ubuntu 24.04
- Modified provisioner block to use "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server"

## Suggested improvements

- Don't modify lab1's example.pkg.hcl
- Rename firstrun.pkg.hcl as aws-redis.pkg.hcl
- Remove references to welcome.txt, example.sh
- Add provisioner block to aws-redis.pkg.hcl

# Lab 3: Packer Variables

## Updates

- Made text more explicit about use of *.auto.pkrvars.hcl files (and use of "packer build .")





