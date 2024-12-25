---
title: Terraform Input Variables using -var-file Argument
description: Learn Terraform Input Variables using -var-file Argument
---

## Step-01: Introduction
- Provide Input Variables using `<any-name>.tfvars` file with CLI 
argument `-var-file`

## Step-02: Assign Input Variables with -var-file argument
- If we plan to use different names for  `.tfvars` files, then we need to explicitly provide the argument `-var-file` during the `terraform plan or apply`
- We will use following things in this example
- **terraform.tfvars:** All other common variables will be picked from this file and environment specific files will be picked from specific `env.tfvars` files
- **dev.tfvars:** `environment` and `resoure_group_location` variable will be picked from this file
- **qa.tfvars:** `environment` and `resoure_group_location` variable will be picked from this file
### terraform.tfvars
```t
business_unit = "it"
resoure_group_name = "rg-tfvars"
virtual_network_name = "vnet-tfvars"
subnet_name = "subnet-tfvars"
```
### dev.tfvars
```t
environment = "dev"
resoure_group_location = "eastus2"
```
### qa.tfvars
```t
environment = "qa"
resoure_group_location = "eastus"
```

## Step-03: Execute Terraform Commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan -var-file="dev.tfvars"
terraform plan -var-file="qa.tfvars"

# Terraform Apply - Dev Environment
terraform apply -var-file="dev.tfvars"

# Terraform Apply - QA Environment
terraform apply -var-file="qa.tfvars" # DONT DO THIS FROM SAME WORKING DIRECTORY AS OF NOW
Observation
1. When we run the above command with "qa.tfvars" it will try to replace current dev resources with qa which is not right fundamentally. This is due to Resources Local Name reference is same for both Dev and QA. 
2. Later when we learn Terraform Workspaces concept we can create multiple environments in same working directory under different workspaces. 
3. As of now we didn't reach that state of learning. 
4. In next sections of the course we will learn. 
```

## Step-04: Destroy Resources
```t
# Destroy Resources
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```


## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)

-----------------------------------------------------------------------------------------------------------------------------------------

# Explanation:- 

This detailed script is a guide for managing input variables in Terraform using variable files (.tfvars) to define environment-specific configurations. The process involves initializing and applying Terraform configurations for different environments while highlighting the importance of proper resource management. 

Let’s break it down step by step.

## Step-01: Introduction

### Key Points:

- Purpose: To provide environment-specific variables dynamically using .tfvars files.
- How: Use the Terraform command-line argument -var-file to specify which .tfvars file to use during the terraform plan or terraform apply process.

## Step-02: Assign Input Variables with -var-file Argument

### Key Points:

- Default Behavior:
  - Terraform automatically looks for a file named terraform.tfvars to load default values.

- Custom Files:
  - If environment-specific files are named differently (e.g., dev.tfvars, qa.tfvars), the -var-file argument is required.

- File Organization:
  - terraform.tfvars: Stores common variables.
  - dev.tfvars: Contains variables specific to the Dev environment (e.g., environment and resoure_group_location).
  - qa.tfvars: Contains variables specific to the QA environment.

#### Example Variable Files

- terraform.tfvars:
  
  business_unit          = "it"
  resoure_group_name     = "rg-tfvars"
  virtual_network_name   = "vnet-tfvars"
  subnet_name            = "subnet-tfvars"
  
  - Common variables shared across all environments.

- dev.tfvars:
  
  environment            = "dev"
  resoure_group_location = "eastus2"
  
  - Overrides variables for the Dev environment.

- qa.tfvars:
  
  environment            = "qa"
  resoure_group_location = "eastus"
  
  - Overrides variables for the **QA** environment.

## Step-03: Execute Terraform Commands

This step covers initializing Terraform, validating configurations, formatting files, and applying plans.

### Commands and Explanations

1. Initialize Terraform:
   
   terraform init
   
   - Downloads provider plugins and sets up the working directory.

2. Validate Terraform Configuration:
   
   terraform validate
   
   - Ensures the configuration syntax and logic are valid.

3. Format Terraform Configuration Files:
   
   terraform fmt

   - Automatically formats configuration files to follow best practices.

4. Review the Terraform Plan:
   
   terraform plan -var-file="dev.tfvars"
   terraform plan -var-file="qa.tfvars"
   
   - Simulates the changes Terraform will make without applying them, using the specified .tfvars file.

5. Apply Terraform Plan:
 
   - Dev Environment:
     
     terraform apply -var-file="dev.tfvars"
     
     - Deploys resources for the **Dev environment.
   - QA Environment:
     
     terraform apply -var-file="qa.tfvars"
     
     - Deploys resources for the QA environment.

     - Warning: Running this in the same directory as Dev can overwrite Dev resources because the local resource names are identical for both environments.

### Observation

- Running terraform apply for both environments in the same directory will replace one environment's resources with the other's.

- Solution:
  - Use Terraform Workspaces to maintain multiple environments within the same working directory (to be introduced in later sections).

## Step-04: Destroy Resources

### Commands and Explanations

1. Destroy Resources:
   
   terraform destroy -auto-approve
   
   - Removes all resources created by Terraform.

2. Cleanup Files:
   
   rm -rf .terraform
   rm -rf terraform.tfstate
   
   - Deletes the `.terraform` directory and state files, cleaning up the working directory.

### Summary and Key Learnings

- Input Variables:
  - Use .tfvars files to define environment-specific configurations dynamically.
  - Common variables go in terraform.tfvars, while specific overrides are placed in dev.tfvars or qa.tfvars.

- Resource Replacement Issue:
  - Without unique resource names, running multiple environments from the same directory will overwrite resources.
  - Solution: Use Terraform Workspaces to segregate environments.

- Best Practices:
  - Always validate and review plans before applying them.
  - Maintain a clean and organized directory structure to avoid accidental overwrites.



