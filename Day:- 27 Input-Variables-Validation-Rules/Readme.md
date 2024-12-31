---
title: Terraform Input Variables with Validation Rules
description: Learn Terraform Input Variables with Validation Rules
---
## Step-01: Introduction
- Learn some Terraform Functions
1. length()
2. substr()
3. contains()
4. lower()
5. regex()
6. can()
- Implement Custom Validation Rules in Variables

## Step-02: Learn Terraform Length Function
- The `terraform console` command provides an interactive console for evaluating expressions.
- [Terraform Console](https://www.terraform.io/docs/cli/commands/console.html)
- [Terraform Length Function](https://www.terraform.io/docs/language/functions/length.html)
```t
# Go to Terraform Console
terraform console

# Test length function
Template: length()

# String
length("hi")
length("hello")

# List
length(["a", "b", "c"]) 

# Map
length({"key" = "value"}) 
length({"key1" = "value1", "key2" = "value2" }) 
```

## Step-03: Learn Terraform SubString Function
- [Terraform Sub String Function](https://www.terraform.io/docs/language/functions/substr.html)
```t
# Go to Terraform Console
terraform console

# Test substr function
Template: substr(string, offset, length)
substr("stack simplify", 1, 4)
substr("stack simplify", 0, 6)
substr("stack simplify", 0, 1)
substr("stack simplify", 0, 0)
substr("stack simplify", 0, 10)
```

## Step-04: Learn Terraform contains() Function
- [Terraform Contains Function](https://www.terraform.io/docs/language/functions/contains.html)
```t
# Go to Terraform Console
terraform console

# Test contains() function
Template: contains(list, value)
contains(["a", "b", "c"], "a")
contains(["a", "b", "c"], "d")
contains(["eastus", "eastus2"], "westus2")
```

## Step-05: Learn Terraform lower() and upper() Function
- [Terraform Lower Function](https://www.terraform.io/docs/language/functions/lower.html)
- [Terraform Upper Function](https://www.terraform.io/docs/language/functions/upper.html)
```t
# Go to Terraform Console
terraform console

# Test lower() function
Template: lower("STRING")
lower("KALYAN REDDY")
lower("STACKSIMPLIFY")

# Test upper() function
Template: lower("string")
upper("kalyan reddy")
upper("stacksimplify")
```

## Step-06: Create Resource Group Variable with Validation Rules
- Understand and implement custom validation rules in variables
- **condition:** Defines the expression used to evaluate the Input Variable value. Must return either `true for valid`, or `false for invalid value`.
- **error_message:** Defines the error message displayed by Terraform when the condition expression returns false for an invalid value. Must be ended with period or question mark 
- **c2-variables.tf**
```t
# 4. Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "eastus"
  validation {
    condition  = var.resoure_group_location == "eastus" || var.resoure_group_location == "eastus2"
    #condition = contains(["eastus", "eastus2"], lower(var.resoure_group_location))
    error_message = "We only allow Resources to be created in eastus or eastus2 Locations."
  }  
}
```
## Step-07: Run Terraform commands
```t
# Initialize Terraform
terraform init

# Validate Terraform configuration files
terraform validate

# Format Terraform configuration files
terraform fmt

# Review the terraform plan
terraform plan

# Observation
1. When `resoure_group_location = "eastus"`, terraform plan should pass
2. When `resoure_group_location = "eastus2"`, terraform plan should pass
3. When `resoure_group_location = "westus"`, terraform plan should fail with error message as validation rule failed. 

# Uncomment validation rule with contains() function and comment previous one
condition = contains(["eastus", "eastus2"], lower(var.resoure_group_location))

# Review the terraform plan
terraform plan

# Observation
1. When `resoure_group_location = "eastus"`, terraform plan should pass
2. When `resoure_group_location = "eastus2"`, terraform plan should pass
3. When `resoure_group_location = "westus"`, terraform plan should fail with error message as validation rule failed. 
```
## Step-08: Learn Terraform regex() and can() Function
- [Terraform regex Function](https://www.terraform.io/docs/language/functions/regex.html)
- [Terraform can Function](https://www.terraform.io/docs/language/functions/can.html)
```t
# Go to Terraform Console
terraform console

# Test regex() function
Template: regex(pattern, string)
### TRUE CASES
regex("india$", "westindia")
regex("india$", "southindia")
can(regex("india$", "westindia"))
can(regex("india$", "southindia"))

### FAILURE CASES
regex("india$", "eastus")
can(regex("india$", "eastus"))
```

## Step-09: Update Resource Group Location Variable with can() and regex() function related Validation Rule
- Update Resource Group Location Variable with can() and regex() function related Validation Rule
```t
# 4. Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "eastus"
  validation {
    #condition  = var.resoure_group_location == "eastus" || var.resoure_group_location == "eastus2"
    #condition = contains(["eastus", "eastus2"], lower(var.resoure_group_location))
    #error_message = "We only allow Resources to be created in eastus or eastus2 Locations."
    condition = can(regex("india$", var.resoure_group_location))
    error_message = "We only allow Resources to be created in westindia and southindia locations."
  }  
}
```

## Step-10: Run Terraform commands
```t
# Validate Terraform configuration files
terraform validate

# Review the terraform plan
terraform plan

# Observation
1. When `resoure_group_location = "westinida"`, terraform plan should pass
2. When `resoure_group_location = "southindia"`, terraform plan should pass
3. When `resoure_group_location = "eastus2"`, terraform plan should fail with error message as validation rule failed. 
```

## Step-11: Clean-Up
```t
# Delete Files
rm -rf .terraform*

# Roll back to state as below for Students seamless demo before git check-in
# Change-1: c1-variables.tf
# 4. Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type = string
  default = "eastus"
  validation {
    condition  = var.resoure_group_location == "eastus" || var.resoure_group_location == "eastus2"
    #condition = contains(["eastus", "eastus2"], lower(var.resoure_group_location))
    error_message = "We only allow Resources to be created in eastus or eastus2 Locations."
    #condition = can(regex("india$", var.resoure_group_location))
    #error_message = "We only allow Resources to be created in westindia and southindia locations."
  }  
}

# Change-2: terraform.tfvars
resoure_group_location = "eastus"
#resoure_group_location = "westus2"
#resoure_group_location = "westindia"
#resoure_group_location = "eastus2"
```


## References
- [Terraform Input Variables](https://www.terraform.io/docs/language/values/variables.html)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation:- 

This is a comprehensive tutorial for learning and practicing Terraform functions, along with implementing variable validation. 

Here's a detailed explanation of each step:

### Step-01: Introduction

This step introduces some Terraform functions and highlights the goal of implementing custom validation rules for input variables. The functions covered include:

1. length(): Measures the size of strings, lists, or maps.
2. substr(): Extracts a substring from a string.
3. contains(): Checks if a list contains a specific value.
4. lower() and upper(): Converts strings to lowercase or uppercase.
5. regex(): Validates a string against a pattern.
6. can(): Checks if an expression can be evaluated without errors.

Custom validation rules allow developers to enforce specific constraints on input variables.

### Step-02: Terraform Length Function

The length() function determines the size of a string, list, or map. Examples:

- length("hi") returns 2 (two characters).
- length(["a", "b", "c"]) returns 3 (three elements in the list).
- length({"key" = "value"}) returns 1 (one key-value pair).

Terraform Console (terraform console) is used to interactively test these expressions.

### Step-03: Terraform SubString Function

The substr() function extracts a portion of a string based on an offset and length. Examples:

- substr("stack simplify", 1, 4) extracts "tack" (starts at index 1, length 4).
- substr("stack simplify", 0, 6) extracts "stack ".

This is useful for parsing or truncating strings dynamically.

### Step-04: Terraform Contains Function

The contains() function checks whether a value exists in a list. Examples:

- contains(["a", "b", "c"], "a") returns true (value exists).
- contains(["eastus", "eastus2"], "westus2") returns false (value not in the list).

This is helpful for validation or conditional logic.

### Step-05: Terraform Lower and Upper Functions

The lower() and upper() functions convert strings to lowercase or uppercase. Examples:

- lower("STACKSIMPLIFY") returns "stacksimplify".
- upper("Kalyan reddy") returns "KALYAN REDDY".

These are commonly used for standardizing string input for comparisons.

### Step-06: Variable Validation Rules

This step demonstrates how to validate input variables. Validation rules enforce constraints on input values:

- Condition: Expression that returns true for valid input, false otherwise.
- Error Message: Custom error message when validation fails.

Example:

variable "resource_group_location" {
  description = "Resource Group Location"
  type        = string
  default     = "eastus"
  validation {
    condition     = var.resource_group_location == "eastus" || var.resource_group_location == "eastus2"
    error_message = "We only allow Resources to be created in eastus or eastus2 Locations."
  }
}

This ensures only eastus or eastus2 are valid values for the resource_group_location variable.

### Step-07: Run Terraform Commands

1. Initialize Terraform: terraform init
2. Validate Configurations: terraform validate
3. Review Plan: terraform plan

Observations:

- When the location is valid (e.g., eastus), the plan proceeds.
- For invalid inputs (e.g., westus), it fails with a validation error.

### Step-08: Terraform Regex and Can Functions

- regex(): Validates whether a string matches a specific pattern.
  - Example: regex("india$", "west India") returns true.
    
- can(): Checks if an expression is evaluable without errors.
  - Example: can(regex("india$", "west India")) returns true.

### Step-09: Update Variable with Regex Validation

Updates the resource_group_location variable validation:

validation {
  condition     = can(regex("india$", var.resource_group_location))
  error_message = "We only allow Resources to be created in westindia and southindia locations."
}

Observations:

- Passes for westindia or southindia.
- Fails for eastus.

### Step-10: Clean-Up

This step ensures the configurations are reset to their original state for reuse. It also removes temporary files generated during execution.

### Use Cases

1. Enforcing resource creation constraints.
2. Dynamically validating input values.
3. Enhancing modularity by testing Terraform functions.
   
