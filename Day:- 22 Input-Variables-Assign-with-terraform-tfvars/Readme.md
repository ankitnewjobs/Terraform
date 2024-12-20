---
title: Terraform Input Variables using terraform.tfvars
description: Learn Terraform Input Variables using terraform.tfvars
---
## Step-01: Introduction
- Provide Input Variables using `terraform.tfvars` files

## Step-02: Assign Input Variables from terraform.tfvars
- Create a file named `terraform.tfvars` and define variables
- If the file name is `terraform.tfvars`, terraform will auto-load the variables present in this file by overriding the `default` values in `c2-variables.tf`
```t
business_unit = "it"
environment = "stg"
resoure_group_name = "rg-tfvars"
resoure_group_location = "eastus2"
virtual_network_name = "vnet-tfvars"
subnet_name = "subnet-tfvars"
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
terraform plan

# Create Resources
terraform apply

# Verify Resources
1. Resource Group Name
2. Resource Group Location
3. Virtual Network Name
4. Virtual Network Subnet Name 
5. Compare with names present in  c2-variables.tf to reconfirm it has overrided it and took from terraform.tfvars
```

## Step-04: Clean-Up Files
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

# Explanation 

This sequence outlines a step-by-step guide for using Terraform to manage infrastructure, specifically focusing on the use of terraform.tfvars files to override default variable values. Let’s go through each step in detail:

## Step-01: Introduction

- Concept:
  - Input Variables: Variables allow you to parameterize configurations, making them reusable and modular.
  - terraform.tfvars: A special file in Terraform used to define input variable values. If this file is present in the working directory, Terraform automatically loads it.

Why Use terraform.tfvars?

   - To customize configurations without editing the main .tf files.
  - Overrides the default values defined in the variable declaration file (e.g., c2-variables.tf).

## Step-02: Assign Input Variables from terraform.tfvars

1. Create the File:
   - File name: terraform.tfvars (must be named exactly for auto-loading by Terraform).
   
2. Define Variables:
   - Example terraform.tfvars content:
     
     business_unit = "it"
     environment = "stg"
     resoure_group_name = "rg-tfvars"
     resoure_group_location = "eastus2"
     virtual_network_name = "vnet-tfvars"
     subnet_name = "subnet-tfvars"
     

   - Key Details:
     - The values in terraform.tfvars override the default values specified in a separate variables file (e.g., c2-variables.tf).
     - This allows dynamic adjustment of values per environment or use case without modifying the core Terraform configuration.

## Step-03: Execute Terraform Commands

Terraform CLI commands to initialize, validate, and apply your configuration:

1. Initialize Terraform:
   
   terraform init
   
   - Sets up the working directory.
   - Downloads necessary provider plugins and prepares the backend for storing state.

2. Validate Configuration:
   
   terraform validate
   
   - Checks if the Terraform configuration files are syntactically and logically correct.

3. Format Configuration:
   
   terraform fmt
   
   - Formats Terraform files for consistent syntax and style.

4. Review Plan:
   
   terraform plan
   
   - Generates an execution plan.
   - Displays changes Terraform will make to your infrastructure.
   - Confirms that the overridden variables (from terraform.tfvars) are used instead of default values.

5. Apply Changes:
   
   terraform apply
   
   - Provisions resources as defined in the .tf files using the overridden variable values from terraform.tfvars.

6. Verify Resources:
 
   - Check that resources are created with the correct properties:
     1. Resource Group Name: rg-tfvars
     2. Resource Group Location: eastus2
     3. Virtual Network Name: vnet-tfvars
     4. Subnet Name: subnet-tfvars
   - Compare these with the default values in `c2-variables.tf` to confirm that Terraform used the terraform.tfvars file.

## Step-04: Clean-Up Files

1. Destroy Resources:
   
   terraform destroy -auto-approve
   
   - Deletes all resources created by Terraform.
   - -auto-approve skips the confirmation prompt, ensuring a non-interactive teardown.

2. Delete Local Files:
   
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   
   - terraform directory: Contains plugins and provider-related files.
   - terraform.tfstate files: Tracks the current state of your infrastructure.
   - Cleaning these files ensures no residual state or configurations persist.


## Key Takeaways

1. Variables & Overrides:
   - Default values can be overridden using terraform.tfvars, making your configuration flexible and environment-specific.

2. Execution Workflow:
   - Always start with terraform init, validate configurations, and review the plan before applying changes.

3. State Management:
   - Terraform's state files (terraform.tfstate) are critical for tracking infrastructure changes. Handle them carefully and use version control for tfvars files to ensure repeatability.

4. Clean-Up:
   - Properly destroy resources to avoid unnecessary costs.
   - Delete sensitive files (like state files) securely to maintain confidentiality.
