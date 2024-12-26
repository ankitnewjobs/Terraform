---
title: Terraform Input Variables using .auto.tfvars
description: Learn Terraform Input Variables using .auto.tfvars
---

## Step-01: Introduction
- Provide Input Variables using `auto.tfvars` files

## Step-02: Auto load input variables with .auto.tfvars files
- We will create a file with extension as `.auto.tfvars`. 
- With this extension, whatever may be the file name, the variables inside these files will be auto loaded during `terraform plan or apply`
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan 
```


## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)

------------------------------------------------------------------------------------------------------------------------------------------

# Explanation:- 

This guide explains the concept and usage of .auto.tfvars files in Terraform for managing input variables in an automated and streamlined manner. It also outlines the steps to interact with Terraform effectively for infrastructure provisioning.

### Step 01: Introduction

The .auto.tfvars file is a special type of Terraform configuration file used to define input variables that Terraform automatically loads without requiring explicit declaration during the terraform plan or terraform apply commands.

- Purpose of Input Variables:
  - Input variables are used to parameterize Terraform configurations, enabling reuse and customization without modifying the actual configuration files.
  - They allow separation of configuration code from specific values (e.g., environment-specific settings like region or instance size).

- Why .auto.tfvars files?
  - Instead of specifying a -var-file option every time you run terraform plan or terraform apply, Terraform automatically loads all .auto.tfvars files in the working directory. This reduces manual overhead and potential errors.

### Step 02: Auto Load Input Variables with .auto.tfvars Files

1. File Naming:
   - A file with the extension .auto.tfvars can have any name, such as dev.auto.tfvars, production.auto.tfvars, etc.
   - Terraform scans the working directory and loads all .auto.tfvars files automatically.

2. How It Works:
   - The variables defined in .auto.tfvars files do not need to be passed explicitly during commands.
   - The files are parsed and their values injected into the Terraform workflow at runtime.

3. Advantages:
   - Simplifies managing environment-specific or user-specific configurations.
   - Avoids repetitive -var or -var-file flags in Terraform CLI commands.

#### Example .auto.tfvars File

environment = "dev"
resource_group_location = "westus"
instance_type = "t2.micro"

#### Workflow with .auto.tfvars Files:
1. Create a .auto.tfvars file with the required variables.
2. Run Terraform commands (init, validate, plan, apply).
3. Terraform automatically includes the variables in the .auto.tfvars file without additional user input.

### Terraform Workflow Commands
The commands provided are standard Terraform commands to initialize, validate, format, and plan your infrastructure. Let’s break them down:

1. terraform init:
   - Initializes the working directory with the necessary plugins and modules.
   - Downloads provider configurations and initializes the backend (if defined).

   Example:
   
   terraform init
      Output: Confirms successful initialization.

2. terraform validate:
   - Checks the syntax and validity of the Terraform configuration files.
   - Ensures that the .tf files and their inputs (including variables) are error-free.

   Example:
   
   terraform validate
      Output: Outputs either "Success" or detailed error messages.

3. terraform fmt:
   - Formats all Terraform configuration files in the current directory and subdirectories to follow canonical styles.
   - Ensures consistency in spacing, indentation, and structure.

   Example:
   
   terraform fmt
      Output: Reports files that were reformatted.

4. terraform plan:
   - Creates an execution plan showing the changes Terraform will make to the infrastructure.
   - Reads variables from files, environment variables, or CLI flags (including .auto.tfvars).

   Example:
   
   terraform plan
      Output: A summary of actions to create, modify, or destroy resources.

### Key Notes

- If multiple .auto.tfvars files are in the same directory, all are loaded, and variable conflicts will cause errors.

- Best Practices:
  - Use meaningful filenames for .auto.tfvars files (e.g., dev.auto.tfvars, prod.auto.tfvars).
  - Keep sensitive information out of .auto.tfvars and use secrets management tools instead (e.g., Terraform Cloud or environment variables).
