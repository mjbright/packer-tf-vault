# Terraform Lab 2

## Overview 
In this lab you will update the existing `main.tf` file to use variables. 

**NOTE: If you run out of disk space remove the `.terraform` directory from previous labs**

## Set the instance name with a variable
Under our working directory create a `tf-lab2` directory and copy `main.tf` to our new directory: 
```sh
mkdir tf-lab2 
cd $_
cp ../tf-lab1/main.tf . 
```
The configuration in `main.tf` includes hard-coded values. Terraform variables allow you to write configuration that is easier to re-use and flexible. 

Add a variable to define the instance name. 

Create a new file called `variables.tf` with a block that defines a new `instance_name` variable. 

```hcl
variable "instance_name" {
  description    = "Name tag for EC2 instance"
  type           = string
  default        = "TF-example-2"
}
```

Now update the `main.tf` `aws_instance` resource block to use our new variable. 

```
  tags = {
    Name = var.instance_name
  }
```

We also need to update the resource name in `main.tf` to `tf-example-2`
```
..snip
resource "aws_instance" "tf-example-2" {
  ami           = "ami-830c94e3"
  ..snip
}
```
After updating the resource block to use the new variable apply the configuration 

```sh
terraform apply
```

If everything looks good, respond with `yes` to the prompt.

Now apply the configuration again, but pass the variable on the command-line. 
```sh
terraform apply -var 'instance_name=SomeOtherName'
```

Variables passed via the command-line will not be saved , so you need to repeatedly set them, or add them to a variables file.

## Query Data with Outputs
In this lab you will use output values to organize data to be queried and shown back to the user. 

Create a file called `outputs.tf` to output the instance's ID and Public IP address with the following: 
```hcl
output "instance_id" {
  description    = "ID of the EC2 instance"
  value          = aws_instance.tf-example-2.id
}

output "instance_public_ip" {
  description   = "Public IP address of EC2 instance"
  value       = aws_instance.tf-example-2.public_ip
}
```

## Inspect output values
You must apply the new configuration before you can use these output values. 

Apply the configuration using `terraform apply`

**Note:** you may choose to specify the instance_name variable on the command-line as for the previous apply if you wish to continue to use that value.

Terraform now prints output values to the screen every time you apply your configuration. Query the outputs using the `terraform output` command. 

Output will be similar to: 
```
instance_id = "i-0bf954919ed765de1"
instance_public_ip = "54.186.202.254"
```

You can use Terraform outputs to connect Terraform projects with other parts of your infrastructure or CICD pipelines. 


# Cleanup
Destroy the infrastructure you created
```sh
terraform destroy -auto-approve
```

# Congrats!
