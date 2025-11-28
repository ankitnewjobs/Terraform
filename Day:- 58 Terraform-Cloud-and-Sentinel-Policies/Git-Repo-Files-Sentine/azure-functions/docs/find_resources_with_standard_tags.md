# find_resources_with_standard_tags
This function finds all Azure resource instances of specified types in the current plan that are not being permanently deleted using the [tfplan/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfplan-v2.html) import.

This function works with both the short name of the Azure provider, "azurerm", and fully-qualfied provider names that match the regex, `(.*)azurerm$`. The latter is required because Terraform 0.13 and above returns the fully-qualified names of providers such as "registry.terraform.io/hashicorp/azurerm" to Sentinel. Older versions of Terraform only return the short-form such as "azurerm".

## Sentinel Module
This function is contained in the [azure-functions.sentinel](../azure-functions.sentinel) module.

## Declaration
`find_resources_with_standard_tags = func(resource_types)`

## Arguments
* **resource_types**: a list of Azure resource types that should have specified tags defined.

## Common Functions Used
None

## What It Returns
This function returns a single flat map of resource instances indexed by the complete [addresses](https://www.terraform.io/docs/internals/resource-addressing.html) of the instances. The map is actually a filtered sub-collection of the [`tfplan.resource_changes`](https://www.terraform.io/docs/cloud/sentinel/import/tfplan-v2.html#the-resource_changes-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here is an example of calling this function, assuming that the aws-functions.sentinel file that contains it has been imported with the alias `azure`:
```
resource_types = [
  "azurerm_resource_group",
  "azurerm_virtual_machine"
  "azurerm_linux_virtual_machine",
  "azurerm_windows_virtual_machine",
]

allAzureSResourcesWithStandardTags =  
                        azure.find_resources_with_standard_tags(resource_types)
```

This function is used by the [enforce-mandatory-tags.sentinel](../../enforce-mandatory-tags.sentinel) policy.

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# Purpose of This Function

The goal of this function is:

# To find all Azure resources (in the current Terraform plan) that:

1. Belong to a specific resource type (e.g., azurerm_resource_group or azurerm_virtual_machine)
2. Are not being permanently deleted
3. Should contain mandatory standard tags (such as "Owner", "Environment", "Costcenter", etc.)
4. Return them in a single flat map so they can be evaluated by the policy.

This is used by a policy like enforce-mandatory-tags.sentinel to check if mandatory tags exist.

# Why is this function necessary?

Terraform 0.13+ changed how providers are referenced internally.

# Before Terraform 0.13 

* Providers were referred to simply as: azurerm

# After Terraform 0.13

Providers are fully qualified: registry.terraform.io/hashicorp/azurerm

* Sentinel receives these provider names from the plan.
* So this function must support both formats.

This is why the function checks provider names using a regex: (.*)azurerm$

→ Matches anything that ends with “azurerm”.

This ensures compatibility across Terraform versions.

# How the Function Works Internally – Conceptual View

Even though the raw function code isn't shown, from the description, we know the steps:

# Step 1: Accept Input

The function receives a list of Azure resource types:

resource_types =
[
  "azurerm_resource_group",
  "azurerm_virtual_machine",
  "azurerm_linux_virtual_machine",
  "azurerm_windows_virtual_machine",
]

These are the resource types that the policy expects to be tagged.

# Step 2: Get Terraform plan resources

Sentinel uses the Terraform Plan import:

sentinel
tfplan/v2

Which exposes: tfplan.resource_changes

This is a collection of every resource Terraform will:

* create
* update
* delete
* replace

Each item contains:

* address
* mode
* type
* provider_name
* change.actions

# Step 3: Filter only Azure resources

The function keeps only:

* resources whose provider name matches:   "azurerm" or "(.*)azurerm$"
* AND whose type is in the resource_types list.

Example:

provider_name = "registry.terraform.io/hashicorp/azurerm" 
type = "azurerm_resource_group" 

# Step 4: Exclude resources being "permanently deleted."

Resource plan actions include:

["create"]
["update"]
["delete"]
["delete", "create"]  (replace)

The function excludes: ["delete"]        → permanent delete

But includes: ["delete", "create"] → replacement resource (needs tagging)

This ensures:
   * If a resource is being replaced → still validate tags
   * If a resource is being removed permanently → don't validate tags

# Step 5: Return a flat map of results

Sentinel typically returns objects like:

{
  "azurerm_resource_group.example" : <resource_change_object>,
  "azurerm_virtual_machine.vm1"   : <resource_change_object>,
}

This flat map is easy for a tag-enforcement policy to iterate through.

# What the Function Returns

It returns a flat map:

* Key → Complete Terraform resource address
  example: "module.network.azurerm_virtual_machine.vm1"
  
* Value → The resource's full change object (tfplan.resource_changes[...])

This gives the policy all the resource objects it must validate.

# What the Function Prints

Nothing. Sentinel does not print unless a policy explicitly calls print().

# Example Usage Explanation

Given:

sentinel
resource_types = 
[
  "azurerm_resource_group",
  "azurerm_virtual_machine"
  "azurerm_linux_virtual_machine",
  "azurerm_windows_virtual_machine",
]

allAzureResourcesWithStandardTags = azure.find_resources_with_standard_tags(resource_types)

# Meaning:

1. You provide the list of Azure resource types whose tags must be checked.
2. The function scans the entire Terraform plan.
3. It returns ONLY those resource instances that:

   * match the types above
   * are Azure resources
   * are not being deleted permanently

Then allAzureResourcesWithStandardTags is used in:

enforce-mandatory-tags.sentinel

→ to verify whether each of these resources contains the required tags.

# Where This Function Is Used

This function is utilized by:

# enforce-mandatory-tags.sentinel

This policy checks whether resources include tags like:

* "environment"
* "owner"
* "costcenter"
* "project"
* etc.

If a required tag is missing → policy fails.

# Simplified Summary

|     Concept        |                        Explanation                         |
| ------------------ | ---------------------------------------------------------- |
|   Purpose          |   Find Azure resources that need tag validation            |
|   Input            |   List of resource types                                   |
|   Output           |   Map of matching resources that are not being deleted     |
|   Why regex?       |   To match both short and fully qualified provider names   |
|   Used by          |   enforce-mandatory-tags.sentinel`                         |
|   Does it print?   |   No                                                       |
|   Scope            |   Works with Terraform Cloud `tfplan/v2` import            |
