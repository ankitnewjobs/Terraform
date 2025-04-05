# Input Variables

# 1. Business Unit Name

variable "business_unit"
{
  description = "Business Unit Name"
  type = string
  default = "hr"
}

# 2. Environment Name

variable "environment" 
{
  description = "Environment Name"
  type = string
  default = "dev"
}

# 3. Virtual Machine Name

variable "virtual_machine_name" 
{
  description = "Virtual Machine Name"
  type = string 
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This code block defines input variables used in a Terraform configuration file, typically stored in a file like variables.tf.

### What are Terraform Variables?

In Terraform, variables make the configuration dynamic and reusable:

- Default values in the code (as seen here),
- A .tfvars file,
- Environment variables,
- Or through the Terraform apply prompt.

### Explanation

# Input Variables

# 1. Business Unit Name

variable "business_unit"
{
  description = "Business Unit Name"
  type = string
  default = "hr"
}

#### variable "business_unit":

- This declares a variable named business_unit.
- description: A short description of what this variable is — Business Unit Name.
- type = string: The value must be a string.
- default = "hr": If no value is provided during deployment, it defaults to "hr".

So if you don’t pass a value, Terraform will assume the business unit is "hr".

# 2. Environment Name

variable "environment" 
{
  description = "Environment Name"
  type = string
  default = "dev"
}

#### variable "environment":

- Declares a variable called environment.
- description: Tells the user this is the name of the environment (e.g., dev, test, prod).
- default = "dev": If you don’t pass anything, it assumes you're deploying to the development environment.

# 3. Virtual Machine Name

variable "virtual_machine_name" 
{
  description = "Virtual Machine Name"
  type = string 
}

####  variable "virtual_machine_name":

- Declares a variable named virtual_machine_name.
- Has a description to tell the user what it's for.
- It’s a string type, but it has no default value, meaning:
  - This value must be provided at runtime via CLI, a .tfvars file, or another method.
  - If you forget to provide it, Terraform will prompt you.

###  Summary

|    Variable Name      |  Description              | Type   | Default Value  | Required? |
|-----------------------|---------------------------|--------|----------------|-----------|
| business_unit         |  Business Unit Name       | string |    "hr"        |  No      |
| environment           |  Environment Name         | string |  "dev"         |  No      |
| virtual_machine_name  |  Virtual Machine Name     | string | None           |  Yes     |








