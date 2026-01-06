# filter_attribute_in_list
This function filters a collection of items such as providers, provisioners, resources, data sources, variables, outputs, or module calls to those with a top-level attribute that is contained in a provided list. A policy would call it when it wants the attribute to not have a value from the list.

This function is intended to examine metadata of various Terraform objects within a Terraform configuration. It cannot be used to examine the values of attributes of resources or data sources. Use the filter functions of the tfplan-functions or tfstate-functions modules for that.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`filter_attribute_in_list = func(items, attr, forbidden, prtmsg)`

## Arguments
* **items**: a map of items such as providers, provisioners, resources, data sources, variables, outputs, or module calls.
* **attr**: the name of a top-level attribute given as a string that must be in a given list. Nested attributes cannot be used by this function.
* **forbidden**: a list of values the attribute is not allowed to have.
* **prtmsg**: a boolean indicating whether violation messages should be printed (if `true`) or not (if `false`).

## Common Functions Used
This function calls the [to_string](./to_string.md) function.

## What It Returns
This function returns a map with two maps, `items` and `messages`. The `items` map contains the actual items of the original collection for which the attribute (`attr`) is in the list (`allowed`) while the `messages` map contains the violation messages associated with those items.

## What It Prints
This function prints the violation messages if the parameter, `prtmsg`, was set to `true`. Otherwise, it does not print anything.

## Examples
Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `plan`:
```
violatingProviders = config.filter_attribute_in_list(allProviders,
                     "name", prohibited_list, false)

violatingResources = config.filter_attribute_in_list(allResources,
                     "type", prohibited_list, false)
violatingProvisioners = config.filter_attribute_in_list(allProvisioners,
                     "type", prohibited_list, false)
```

* This function is used by several cloud-agnostic policies that prohibit certain types of items including [prohibited-datasources.sentinel](../../../cloud-agnostic/prohibited-datasources.sentinel), [prohibited-providers.sentinel](../../../cloud-agnostic/prohibited-providers.sentinel), [prohibited-provisioners.sentinel](../../../cloud-agnostic/prohibited-provisioners.sentinel), [require-all-providers-have-version-constrain.sentinel (Cloud Agnostic)](../../../cloud-agnostic/require-all-providers-have-version-constrain.sentinel) and [prohibited-resources.sentinel](../../../cloud-agnostic/prohibited-resources.sentinel).
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# 1. What this function is for 

filter_attribute_in_list is a generic filtering utility used in Sentinel policies to:

It is not used to inspect runtime values (such as resource arguments or attribute values in the plan).
It only works on Terraform configuration metadata (what’s written in .tf files).

# 2. When would we use this function

You use this function when you want to enforce rules such as:

* Disallow certain providers (e.g., null, random)
* Disallow certain resource types (e.g., aws_instance)
* Disallow certain provisioners (e.g., local-exec)
* Enforce that provider version constraints exist

# 3. Function declaration

filter_attribute_in_list = func(items, attr, forbidden, prtmsg)

This means the function takes 4 parameters.

# 4. Arguments explained in detail

# 4.1 items (map)

items

* A map of Terraform objects collected from the configuration
  
* Examples:

  * allProviders
  * allResources
  * allProvisioners

Each entry typically looks like:

{
  "aws_instance.my_vm" =
  {
    type = "aws_instance"
    name = "my_vm"
      }
}

This function loops over this map and checks each item.

# 4.2 attr (string)

attr = "type"

* The top-level attribute to inspect
* Must be a direct attribute, not nested

Valid examples:

* "type"
* "name"
* "source"

Invalid:

* "tags.env"
* "lifecycle.prevent_destroy"

The function checks:

Does item[attr] exist, and is its value in the forbidden list?

# 4.3 forbidden (list)

forbidden = ["null", "random"]

* A list of disallowed values
* If item[attr] matches any value in this list → violation

Example logic:

if item.type == "null" → violation

# 4.4 prtmsg (boolean)

prtmsg = true | false

* Controls logging behavior
* true → violation messages are printed
* false → messages are collected silently

Very useful:

* false for reusable library functions
* true when debugging or writing standalone policies

# 5. What the function does internally (logical flow)

Conceptually, the function follows these steps:

# Step 1: Iterate over all items

for each item in items:

# Step 2: Extract the attribute value

value = item[attr]

# Step 3: Convert value to string

Uses: to_string(value)

Why?

* Sentinel attributes may be strings, lists, or unknowns
* String conversion avoids type comparison issues

# Step 4: Check against the forbidden list

if value is in the forbidden: Mark the item as violating

# Step 5: Generate a violation message

Example message: Resource aws_instance.my_vm has forbidden type "aws_instance"

Messages are stored in: messages[item_key] = "violation message"

# Step 6: Optionally print messages

if prtmsg == true:
    print(message)

# 6. What the function returns

The function returns a map with two sub-maps:

{
  items = { ... },
  messages = { ... }
}

# 6.1 items map

Contains only violating items

Example:

items =
{
  "aws_instance.my_vm" = { ... }
}

# 6.2 messages map

Contains human-readable explanations

Example:

messages = 
{
  "aws_instance.my_vm" = "Resource type aws_instance is prohibited"
}

 This structure allows:

* Enforcement (length(items) == 0)
* Reporting (print(messages))

# 7. What it prints (side effects)

|   prtmsg   |         Output                    |
| -----------| --------------------------------- |
|   true     |   Prints each violation message   |
|   false    |   Prints nothing                  |

The return value is always the same regardless of printing.

# 8. Example usage explained

# Example 1: Prohibited providers

violatingProviders = config.filter_attribute_in_list
(
  allProviders,
  "name",
  prohibited_list,
  false
)

Meaning:

* Look at all providers
* Check provider name
* If the name is in the prohibited_list
* Collect violations silently

# Example 2: Prohibited resources

violatingResources = config.filter_attribute_in_list
(
  allResources,
  "type",
  prohibited_list,
  false
)

Meaning:

* Look at all Terraform resources
* Check the type (e.g., aws_instance)
* Flag if the type is forbidden

# 9. Why does this function NOT inspect resource values

This function:

* Cannot read runtime values
* Cannot read plan attributes
* Cannot evaluate expressions

It only sees static configuration metadata.

For runtime values, you must use:

* tfplan-functions
* tfstate-functions

Example:

* tfplan.resource_changes
* tfstate.resources

# 10. Why is this function important in policy-as-code

This function enables:

 Centralized governance
 Reusable policy logic
 Cloud-agnostic enforcement
 Cleaner Sentinel policies

Instead of repeating logic, policies simply call this helper.

# 11. Real-world policy pattern

violations = filter_attribute_in_list
(
  allResources,
  "type",
  ["null_resource", "local_file"],
  false
)

main = rule 
{
  length(violations.items) == 0
}

Policy passes if no forbidden resources are found
Fails if any exist
