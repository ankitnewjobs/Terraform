---
title: Terraform Input Variables CLI Argument var
description: Learn Terraform Input Variables CLI Argument -var
---

## Step-01: Introduction
- Override default variable values using CLI argument `-var`
- Also learn about Terraform Plan Generation 

## Step-02: Input Variables Override default value with cli argument `-var`
- We are going to override the default values defined in `c2-variables.tf` by providing new values using the `-var` argument using CLI
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Option-1 (Always provide -var for both plan and apply)
# Review the terraform plan
terraform plan -var="resoure_group_name=demorg" -var="resoure_group_location=westus" -var="virtual_network_name=demovnet" -var="subnet_name=demosubnet" 

# Create Resources (optional - We are just learning concept)
terraform apply -var="resoure_group_name=demorg" -var="resoure_group_location=westus" -var="virtual_network_name=demovnet" -var="subnet_name=demosubnet" 
```

## Step-03: Generate Terraform Plan and use that using Terraform Apply
```t
# Option-2 (Generate plan file with -var and use that with apply)
# Generate Terraform plan file
terraform plan -var="resoure_group_name=demorg" -var="resoure_group_location=westus" -var="virtual_network_name=demovnet" -var="subnet_name=demosubnet"  -out v1.plan

# Terraform Show
terraform show v1.plan

# Create / Deploy Terraform Resources using Plan file
terraform apply v1.plan 
```

## Step-04: Clean-Up Files
```t
# Destroy Resources
terraform destroy -auto-approve
Subnet Name: demosubnet (When Prompted)

# Delete Files
rm -rf .terraform*
rm -rf terraform.tfstate*
mv v1.plan v1.plan_bkup
```

## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)

-----------------------------------------------------------------------------------------------------------------------------------------

### Explanation of the Steps

The guide demonstrates how to override default variable values in Terraform using CLI arguments and generate and apply Terraform plans. Here’s a detailed breakdown:

### Step-01: Introduction

- Purpose: 

  - Learn how to override the default values of variables in Terraform configurations using the -var argument in CLI.
  - Understand the process of generating and applying a Terraform plan for resource provisioning.

- Tools/Commands:

  - terraform init: Initializes the working directory containing Terraform configuration files.
  - terraform validate: Ensures the configuration files are syntactically valid.
  - terraform fmt: Formats the configuration files to follow the standard conventions.

### Step-02: Override Default Variable Values

1. Concept:
 
   - Variables in Terraform allow for parameterization. Default values for variables are often defined in a file (like c2-variables.tf).
   - These defaults can be overridden by explicitly passing new values via the CLI using the -var flag.
   
2. Commands:

   - Plan with Overrides:
   
     - terraform plan -var="key=value" allows previewing resource creation or changes with specific variable values.

     - Example:
     
       terraform plan -var="resoure_group_name=demorg" -var="resoure_group_location=westus"
       
   - Apply with Overrides:

      - terraform apply -var="key=value" applies the configuration with specified variable values, creating the resources.

### Step-03: Generate and Use a Terraform Plan

1. Purpose:

   - Generate a reusable plan file that captures the desired infrastructure state based on input variables.
   - Apply this plan later to create or modify resources.

3. Commands:

    - Generate Plan:
     
     - terraform plan -var="key=value" -out filename.plan: Create a plan file.
    
     - Example:
       
       terraform plan -var="resoure_group_name=demorg" -out v1.plan
       
   - Review Plan:
        - terraform show filename.plan: Displays the content of the generated plan.

   - Apply Plan:
     - terraform apply filename.plan: Applies the previously generated plan to deploy resources.

### Step-04: Clean-Up

1. Purpose:
   - Safely remove resources and clean up files after experimentation or learning.
   
2. Commands:

    - Destroy Resources:
     - terraform destroy -auto-approve: Removes all resources created by Terraform.
     - You might be prompted to provide additional details (e.g., Subnet Name).
 
   - Delete Local Files:
     - Remove files created during the process:
       
       rm -rf .terraform
       rm -rf terraform.tfstate
       mv v1.plan v1.plan_bkup
       
### Key Takeaways

- The -var flag is a versatile way to override default variable values without altering configuration files.
- Generating a plan file ensures repeatability and consistency in deployments, which is especially useful in CI/CD pipelines.
- Always clean up resources and temporary files after testing to avoid unnecessary costs and clutter.

### References

For more information on Terraform variables:
- [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html)
