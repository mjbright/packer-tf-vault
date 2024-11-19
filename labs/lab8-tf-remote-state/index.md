# Terraform Lab 5

## Overview 
In this lab you will create an S3 bucket and migrate the Terraform state to a remote backend. 

## Lab Setup

Copy the previous ```terraform/tf-lab4/learn-terraform-variables``` folder to a new folder tf-lab5 as follows:

```sh

mkdir -p   ~/LABS/terraform/tf-lab5

cp -a      ~/LABS/terraform/tf-lab4/learn-terraform-variables ~/LABS/terraform/tf-lab5/
```

Then move to that new folder:

```sh
cd ~/LABS/terraform/tf-lab5/learn-terraform-variables
```


## Create an S3 bucket 
AWS requires every S3 bucket to have a unique name.

For this reason **add your initials to the end of the bucket**.

The example below uses `jrs` as the initials.

In the `tf-lab5/learn-terraform-variables` directory create a new file `s3.tf` with the following: 

```hcl
resource "aws_s3_bucket" "remote_state" {
    bucket = "remote-state-jrs"
    acl = "private"
    
    tags = {
        Name = "remote state backend"
    }
}
```

So that we can easily retrieve the name of the bucket in the future add the following to `outputs.tf`
```hcl
output "s3_bucket" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.remote_state.id
}
```
Using Terraform apply the changes. 

## Migrate the state
Now that we've created an S3 bucket, we need to migrate the state to the remote backend. 

When creating the backend configuration remember to **replace the `bucket` with the name of the bucket you created**. 

Create `backend.tf` with the following:
```hcl
terraform {
  backend "s3" {
    region = "us-west-1"
    bucket = "remote-state-jrs"
    key = "state.tfstate"
  }
}
```

## Reinitialize Terraform 
Now that you have created the S3 bucket and configured the `backend.tf` you must run `terraform init` to migrate the state to the new remote backend. 

```sh
terraform init -migrate-state
```

If prompted to migrate the existing state type 'yes'

If everything is successful you should see a message telling you the backend was migrated. 

## Verification

Note that the local ```terraform.tfstate``` file still exists but is now empty

We can still interrogate the now remote state using the command

```sh
terraform state list
```


# Cleanup
Destroy the infrastructure you created
```sh
terraform destroy -auto-approve
```

## Destroy doesn't quite complete

The destroy didn't successfully terminate because it couldn't delete the S3 bucket holding our state

You will have seen output similar to:
```
aws_s3_bucket.remote_state: Destroying... [id=remote-state-mjb]
╷
│ Error: error deleting S3 Bucket (remote-state-mjb): BucketNotEmpty: The bucket you tried to delete is not empty
│       status code: 409, request id: JHZ9NB6THXCH0NMZ, host id: s8AYyn3ADRh558XiphAIlhOyudeN49OCETWYaeKSW+s2dkk8oPbiRL+j03Juhu1lwV7686660Yo=
```

So we will now do the following steps
- revert to using local state
- mark the s3 as deletable even when not empty
- perform an apply against the s3 target only
- re-perform the destroy

### Revert to using local state
```
mv backend.tf backend.tf.unused
terraform init -migrate-state
```

### Mark the s3 bucket as deletable even when not empty

Add the line ```force_destroy = true``` into the s3.tf file

### Perform an apply against the s3 target only

```terraform apply -target aws_s3_bucket.remote_state```

This will apply the new parameter to the resource

### Re-perform the destroy

```terraform destroy```

### Verify the state is now empty

```terraform state list```


## Cleanup .terraform/

Remove the ```.terraform``` directory containing the AWS plugin to prevent disk-space issues:
```
rm -rf .terraform/
```


# Congrats!

