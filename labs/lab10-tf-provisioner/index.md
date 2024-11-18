# Terraform Lab 7

## Overview 
In this lab you will update `main.tf` to include provisioners.

Provisioners allow you to run shell scripts on the local machine, or remote resources. You can also use vendor provisioners from Chef, Puppet, and Salt.

## Lab Setup

Copy the previous ```terraform/tf-lab6``` folder to a new folder tf-lab7 as follows:

```sh
cp -a      ~/LABS/terraform/tf-lab6 ~/LABS/terraform/tf-lab7

```

Then move to that new folder:

```sh
cd ~/LABS/terraform/tf-lab7
```



## Add provisioners
Update the ```main.tf``` config as follows:

Add a `local-exec` provisioner with the following attributes: 
- command: Echo the public IP addresses into a file named `public_ips.txt`

Add another `local-exec` provisioner with the following attributes: 
- command: Echo the private IP addresses into a file named `private_ips.txt`

 # Cleanup
Destroy the infrastructure you created
```sh
terraform destroy -auto-approve
```

Remove the ```.terraform``` directory containing the AWS plugin to prevent disk-space issues:
```
rm -rf .terraform/
```

# Congrats! 
