---
title: Terraform Input Variables using Environment Variables
description: Learn Terraform Input Variables using Environment Variables
---

## Step-01: Introduction
- Override default variable values using Environment Variables

## Step-02: Input Variables Override with Environment Variables
- Set environment variables and execute `terraform plan` to see if it overrides default values 
```t
# Sample
export TF_VAR_variable_name=value

# SET Environment Variables
export TF_VAR_resoure_group_name=rgenv
export TF_VAR_resoure_group_location=westus2
export TF_VAR_virtual_network_name=vnetenv
export TF_VAR_subnet_name=subnetenv
echo $TF_VAR_resoure_group_name, $TF_VAR_resoure_group_location, $TF_VAR_virtual_network_name, $TF_VAR_subnet_name
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

# UNSET Environment Variables after demo
unset TF_VAR_resoure_group_name
unset TF_VAR_resoure_group_location
unset TF_VAR_virtual_network_name
unset TF_VAR_subnet_name
echo $TF_VAR_resoure_group_name, $TF_VAR_resoure_group_location, $TF_VAR_virtual_network_name, $TF_VAR_subnet_name
```

## Step-04: Clean-Up Files
```t
# Delete Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```


## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)

-----------------------------------------------------------------------------------------------------------------------------------------

# Explanation 

## Step-01: Introduction

### Override default variable values using Environment Variables

- Terraform allows you to override default values of input variables using Environment Variables.  

- This is a flexible way to provide values dynamically without modifying the .tf files.  

- Terraform follows a specific convention:
  
  - The environment variable must be prefixed with TF_VAR_ followed by the variable name defined in the Terraform configuration file.  
  - For example, if you have a variable resource_group_name, you can override it using TF_VAR_resource_group_name.

## Step-02: Input Variables Override with Environment Variables

You will set environment variables to override the default input variable values here.  

### Steps:  

1. Syntax for Setting Environment Variables:  
   
   export TF_VAR_variable_name=value
     
   - The variable name should match the input variable in your Terraform configuration.  
   - export sets the variable as an environment variable so Terraform can access it.  

2. Example:  
 
   Here, assume we have variables in our Terraform code:  
   - resource_group_name  
   - resource_group_location 
   - virtual_network_name  
   - subnet_name  

   Set these environment variables:  
   
   export TF_VAR_resource_group_name=rgenv
   export TF_VAR_resource_group_location=westus2
   export TF_VAR_virtual_network_name=vnetenv
   export TF_VAR_subnet_name=subnetenv
   
   Explanation:  

    - TF_VAR_resource_group_name: Overrides the variable resource_group_name with the value rgenv.  
   - Similarly, other variables are overridden dynamically with the given values.  

4. Verify Variables:  

   To ensure the environment variables are set, print them:  
   
   echo $TF_VAR_resource_group_name, $TF_VAR_resource_group_location, $TF_VAR_virtual_network_name, $TF_VAR_subnet_name
     
   This confirms that the variables are exported correctly.

## Step-03: Execute Terraform Commands

This step focuses on running standard Terraform commands to ensure the overrides work as expected.

### 1. Initialize Terraform 
   
   terraform init
     
   - This initializes the working directory, downloads required providers, and sets up the backend if configured.  

### 2. Validate Configuration Files
   
   terraform validate
     
   - Checks the syntax and integrity of the Terraform configuration files to ensure no errors.  

### 3. Format Terraform Configuration Files 
   
   terraform fmt
     
   - Terraform files (like .tf files) are automatically formatted to follow the standard Terraform style conventions.  

### 4. Review Terraform Plan
   
   terraform plan
   
   - This command shows the execution plan by comparing the current state and the desired state.  
   - It will use the environment variables you set earlier to override default variable values.  
   - The output confirms whether the input variables have been overridden successfully.  

### 5. Unset Environment Variables (Clean-up after Demo)
   
   To clean up the environment variables after testing:  
   
   unset TF_VAR_resource_group_name
   unset TF_VAR_resource_group_location
   unset TF_VAR_virtual_network_name
   unset TF_VAR_subnet_name
   
   Verify Cleanup:  
   
   echo $TF_VAR_resource_group_name, $TF_VAR_resource_group_location, $TF_VAR_virtual_network_name, $TF_VAR_subnet_name
    
   - This ensures that the environment variables are no longer set.

## Step-04: Clean-Up Files  

After completing the demo, clean up any Terraform-related files created during the process.

### Commands:  

1. Delete Terraform Backend and State Files:  
   
   rm -rf .terraform
   rm -rf terraform.tfstate
     
   - terraform: Removes the Terraform working directory and any downloaded provider plugins.  

    - terraform.tfstate: Deletes the Terraform state files, which store the current state of infrastructure.  
     - This ensures a clean slate for future executions.  

## Summary

1. Step 01 introduces the use of environment variables to override Terraform input variables dynamically.  
2. Step 02 explains how to set environment variables using the TF_VAR_ convention.  
3. Step-03 covers the execution of Terraform commands like init, validate, fmt, plan, and the clean-up of variables.  
4. Step-04 ensures all temporary files (Terraform backend and state) are deleted post-demo.  

By following these steps, you can manage Terraform input variables more dynamically and test configuration changes without modifying your .tf files directly. This is particularly useful in CI/CD pipelines or when sharing infrastructure code across teams.
