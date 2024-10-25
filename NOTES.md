
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


