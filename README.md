# Terraform execution with CICD

In this repo we have source code terraform as **IaaC** for creation of server. 

With remote backend and state locking as good practice.
We have the lifecycle of terraform from initialising, format, validate, plan and apply.
>We do have separate CI for destroying the resource.


## Preq
Provided S3 is configured and DynamoDB is initialised.
We can use this as remote backend and stage locking.

