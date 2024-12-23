# Terraform Lab 6

## Overview
In this lab you will create some AWS resources using the console, and then import them into Terraform management. 

## Lab Setup

Create a new folder for tf-lab6, then move to that new folder:

```sh

mkdir -p   ~/LABS/terraform/tf-lab6

cd         ~/LABS/terraform/tf-lab6
```


## Create instances in AWS Console
Create three EC2 instances in the AWS Console. 

1. Using the search bar at the top of the page, search for `ec2`, and click the first result as shown in the screenshot. 

![ec2 search](images/ec2_search.png)
2. In the EC2 dashboard click `instances`, and then `Launch instances`. 
3. At the top of the page in the ```Name and Tags``` box change Key to ```role``` and set Value to ```terraform```.
4. In the ```Application and OS Images (Amazon Machine Image)``` box, select the ```Amazon Linux``` image
<!-- ![aws-ami](images/aws_ami.png) -->

5. Keep the ```t2.micro``` instance type
6. In the ```Key pair``` box select ```Proceed without a key pair```
7. Keep the proposed Storage settings
8. In the ```Summary``` box at the bottom of the page, set the number of instances to 3
9. Click the ```Launch Instance``` button at the bottom of the page

## Create Terraform configuration 
While waiting for the instances to launch create a new configuration file. 

Inside the ```tf-lab6``` directory create a `main.tf` file and add a resource with the following attributes:
- type: `aws_instance`
- name: `tf-example-import`
- ami: AMI from instances created above
- instance_type: The type specified when creating the instance.
- count: `3`
- tags: `Name: TF-example-import`, `role: terraform`

You might want to look at the ```tf-lab2``` example to help here.

Remember this resource block is for three instances. You will need to add the `count.index` to the `Name` tag. If you get stuck ask the instructor for assistance.

## Import the configuration 
Now that you've created the instances and the Terraform configuration, use the `terraform import` command to import the existing instances. 

If you get stuck check the help page `terraform import --help` or the [terraform documentation](https://www.terraform.io/docs/cli/import/index.html)

## Verify the configuration 

Use the

```terraform state list```

and 

```terraform state show <instance>```

commands to verify that the imports worked

# Cleanup

**Do not** destroy the infrastructure as we will re-use it in the next lab

**Do** remove the ```.terraform``` directory containing the AWS plugin to prevent disk-space issues:
```
rm -rf .terraform/
```



# Congratulations !
Go back to the [lab index](../../)


