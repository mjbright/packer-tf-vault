# Terraform Lab 7

## Overview 
In this lab you will update `main.tf` to include provisioners.

Provisioners allow you to run shell scripts on the local machine, or remote resources. You can also use vendor provisioners from Chef, Puppet, and Salt.

## Lab Setup

From the previous ```terraform/tf-lab6/learn-terraform-variables``` folder copy the contents to a new folder tf-lab7 as follows:

```sh

mkdir -p      ../../tf-lab7/
cp -a    $PWD ../../tf-lab7/
```

Then move to that new folder:

```sh
cd ../../tf-lab7/learn-terraform-variables
```



## Add provisioners
This lab updates the `main.tf` in the `tf-lab4` directory. 

Add a `local-exec` provisioner with the following attributes: 
- command: Echo the public IP addresses into a file named `public_ips.txt`

Add another `local-exec` provisioner with the following attributes: 
- command: Echo the private IP addresses into a file named `private_ips.txt`

 # Cleanup
Destroy the infrastructure you created
```sh
terraform destroy -auto-approve
```

# Congrats! 
