# Packer Lab 3

## Lab objectives: 
* Update template to use new var.ami_prefix and local.timestamp variables
* Provide image names to builder through various means


### Update template to use variables

In this section you will modify the template from the last lab to generate a unique AMI name.

Create and enter a new working directory
```sh
mkdir -p ~/LABS/packer/lab3
cd ~/LABS/packer/lab3
```

- Copy the redis-server.pkr.hcl file from the lab2, into this lab3 directory.

Add the following variable block to your template   
```hcl
variable "ami_prefix" {
  type    = string
  default = "packer-linux-aws-redis"
}
```

Add a local variable to your template   
```hcl
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

```

Local blocks declare the local variable name (`timestamp`) and the value (`regex_replace(timestamp(), "[- TZ:]", "")`). You can set the local value to anything, including other variables and locals. Locals are useful when you need to format commonly used values.

In this example, Packer sets the `timestamp` local variable to a formatted timestamp using functions.

Inputs variables and local variables are constants — you cannot update them during run time.


Update AMI name

In your Packer template, update your source block to reference the `ami_prefix` variable. Notice how the template references the variable as `var.ami_prefix`.

```hcl
source "amazon-ebs" "aws-redis" {
-  ami_name      = "${var.ami_name}"
+  ami_name      = "${var.ami_prefix}-${local.timestamp}"
   ## ...
}
```

### Build image

Build the image.
```sh
packer build redis-server.pkr.hcl
```


After running your `packer build` you should see output stating the image was created successfully. Notice how the Packer creates an AMI where its name consists of `packer-linux-aws-redis`, the default value for the `ami_prefix` variable, and a timestamp.

#### Build image with variables 

Since `ami_prefix` is parameterized, you can define your variable before building the image. There are multiple ways to assign variables. The order of ascending precedence is: variable defaults, environment variables, variable file(s), command-line flag. In this section, you will define variables using variable files and command-line flags.

#### Build image with variable file
Create a file named `redis-server.pkrvars.hcl` and add the following snippet into it.
```hcl
ami_prefix = "packer-aws-redis-var"
```

Build the image with the `--var-file` flag.
```sh
packer build --var-file=redis-server.pkrvars.hcl redis-server.pkr.hcl
```

Notice how the AMI name starts with `packer-aws-redis-var-`, the value for `ami_prefix` defined by the variable file.

#### Build image with `*.auto.pkrvars.hcl` variable file

Packer will automatically load any variable file that matches the name `*.auto.pkrvars.hcl`, without the need to pass the file via the command line.

Rename your variable file so Packer automatically loads it.

```sh
mv redis-server.pkrvars.hcl redis-server.auto.pkrvars.hcl
```

Build the image and notice how the AMI name starts with `packer-aws-redis-`.

**Note:** The `packer build .` command loads all the contents in the current directory - note the `dot` at the end of the line representing the current directory.

```sh
packer build .
```

#### Build image with command-line flag
Build the image, setting the variable directly from the command-line.

```sh
packer build --var ami_prefix=packer-aws-redis-var-flag .
```

Notice how the AMI name starts with `packer-aws-redis-var-flag`, the value for `ami_prefix` defined by the command-line flag. The command-line flag has the highest precedence and will override values defined by other methods.


Bonus: Configure `region` in a variables file.

## Variable Precedence

Note that we have seen various ways in which we can specify variable values to Packer.

Read about the precedence of these different ways at [https://developer.hashicorp.com/packer/guides/hcl/variables#assigning-variables](https://developer.hashicorp.com/packer/guides/hcl/variables#assigning-variables)

# Congratulations !
Go back to the [lab index](../../)

