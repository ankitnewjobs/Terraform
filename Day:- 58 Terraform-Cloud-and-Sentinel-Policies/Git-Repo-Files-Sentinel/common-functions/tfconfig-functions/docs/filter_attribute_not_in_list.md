# filter_attribute_not_in_list
This function filters a collection of items such as providers, provisioners, resources, data sources, variables, outputs, or module calls to those with a top-level attribute that is not contained in a provided list. A policy would call it when it wants the attribute to have a value from the list.

This function is intended to examine metadata of various Terraform objects within a Terraform configuration. It cannot be used to examine the values of attributes of resources or data sources. Use the filter functions of the tfplan-functions or tfstate-functions modules for that.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`filter_attribute_not_in_list = func(items, attr, allowed, prtmsg)`

## Arguments
* **items**: a map of items such as providers, provisioners, resources, data sources, variables, outputs, or module calls.
* **attr**: the name of a top-level attribute given as a string that must be in a given list. Nested attributes cannot be used by this function.
* **allowed**: a list of values the attribute is allowed to have.
* **prtmsg**: a boolean indicating whether violation messages should be printed (if `true`) or not (if `false`).

## Common Functions Used
This function calls the [to_string](./to_string.md) function.

## What It Returns
This function returns a map with two maps, `items` and `messages`. The `items` map contains the actual items of the original collection for which the attribute (`attr`) is not in the list (`allowed`) while the `messages` map contains the violation messages associated with those items.

## What It Prints
This function prints the violation messages if the parameter, `prtmsg`, was set to `true`. Otherwise, it does not print anything.

## Examples
Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `plan`:
```
violatingProviders = config.filter_attribute_not_in_list(allProviders,
                     "name", allowed_list, false)

violatingResources = config.filter_attribute_not_in_list(allResources,
                     "type", allowed_list, false)

violatingProvisioners = config.filter_attribute_not_in_list(allProvisioners,
                     "type", allowed_list, false)
```

# This function is used by several cloud-agnostic policies that allow certain types of items including [allowed-datasources.sentinel](../../../cloud-agnostic/allowed-datasources.sentinel), [allowed-providers.sentinel](../../../cloud-agnostic/allowed-providers.sentinel), [allowed-provisioners.sentinel](../../../cloud-agnostic/allowed-provisioners.sentinel), and [allowed-resources.sentinel](../../../cloud-agnostic/allowed-resources.sentinel).
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# 1. Why This Function Exists

Terraform policies usually need to answer questions like:

* Are only approved resource types being used?
* Did someone add an unapproved provider?
* Is a forbidden provisioner sneaking into the config?

Terraform configs are static declarations, so Sentinel provides:

* tfconfig → for configuration structure
* tfplan → for planned values
* tfstate → for applied values

* filter_attribute_not_in_list exists specifically for configuration-time governance.

It is intentionally:

* Simple
* Deterministic
* Fast
* Non-value-based

This ensures:

* Policies fail early
* No dependency on variable interpolation or runtime values

# 2. What “Filter” Means Here 

The name is subtle: filter_attribute_not_in_list

This does NOT mean:

* “validate”
* “enforce”
* “deny”

It literally means: Return only the objects that violate the rule

So this function:

* Never fails a policy
* Never returns true/false
* Only collects violations

# 3. Shape of the Input Data (items)

The items parameter is always a map, not a list.

# Example: allResources

Internally looks like:

{
  "azurerm_virtual_machine.vm1":
  {
    "type": "azurerm_virtual_machine",
    "name": "vm1",
    "provider": "azurerm",
      },
  "null_resource.bad": 
  {
    "type": "null_resource",
    "name": "bad",
      }
}

Key observations:

* Map key = Terraform address
* Map value = metadata object
* Metadata is not runtime data

# 4. Why Only “Top-Level Attributes” Are Allowed

The docs emphasize this for a reason.

# Allowed:

item["type"]
item["name"]
item["provider"]

# Not allowed:

item["tags"]["env"]
item["network_interface"][0]["subnet_id"]

# Why?

Because:

* Nested attributes may not exist consistently
* Config objects differ by type
* Sentinel must stay generic across providers

If nested attributes were allowed:

* Policies would break unpredictably
* The function would no longer be cloud-agnostic

# 5. Step-by-Step Internal Execution Logic

# Step 1: Initialize Empty Results

The function prepares two empty maps:

violating_items = {}
violation_messages = {}

# Step 2: Iterate Over Every Item

Conceptually:

for key, item in items 
{
   ...
}

Where:

* key = Terraform address
* item = metadata object

# Step 3: Extract the Attribute

value = item[attr]

If attr = "type":

value = "azurerm_virtual_machine"

If the attribute doesn’t exist:

* Sentinel treats it as a violation
* Because “missing” ≠ “allowed”

# Step 4: Normalize the Value (to_string)

Why this matters:

Terraform metadata values may be:

* strings
* numbers
* symbols
* enums

Sentinel comparisons are strict, so: value_str = to_string(value)

This ensures:

* "azurerm_virtual_machine" matches "azurerm_virtual_machine"
* No type mismatch errors

# Step 5: Compare Against Allow List

Core check:

if value_str not in allowed 
{
   violation
}

This is a negative filter:

* Allowed → ignored
* Not allowed → captured

This design makes the function reusable for deny-by-default policies.

# Step 6: Record the Violation

If the check fails:

# 6.1 Add Item to Violations

violating_items[key] = item

This preserves:

* Full metadata
* Terraform address
* Context for later rules

# 6.2 Generate Human-Readable Message

Example message: Resource "null_resource.bad" has type "null_resource" which is not in the allowed list

This message is stored as: violation_messages[key] = message

# Step 7: Optional Printing

If: prtmsg == true

Then: print(message)

This is side-effect behavior, useful only for:

* Local debugging
* Policy authoring
* Troubleshooting

In CI/CD → usually disabled.

# Step 8: Return Structured Result

Final return value:

{
  "items": violating_items,
  "messages": violation_messages
}

This structure is intentional:

* Machines use items
* Humans use messages

# 6. Why the Function Does NOT Fail Policies

This is a critical design principle.

Failing a policy is the responsibility of the rule, not the function.

Example: violations = config.filter_attribute_not_in_list(...)

main = rule 
{
  count(violations.items) == 0
}

Why this matters:

* The same function can be reused for:

  * warnings
  * hard failures
  * reports

* Policies remain composable

# 7. Real Azure Governance Example (Conceptual)

# Goal:

Only allow:

* azurerm_virtual_machine
* azurerm_storage_account

# Execution Flow:

1. Terraform config is parsed
2. Sentinel extracts allResources
3. Function filters resources not in the allow list
4. Violations are returned
5. Policy rule blocks the run if violations exist

This happens before Terraform plan/apply.

# 8. Why This Function Is Cloud-Agnostic

Notice:

* No Azure
* No AWS
* No GCP
* No provider-specific logic

It only knows:

* maps
* strings
* lists

That’s why it’s reused by:

* allowed-resources.sentinel
* allowed-providers.sentinel
* allowed-datasources.sentinel
* allowed-provisioners.sentinel

# 9. Common Misunderstandings (Important)

“This checks resource attributes like size or location”
 No — only metadata

“This enforces policy by itself”
 No — rules enforce policy

“This works on Terraform plan”
 No — config only

“Nested attributes can be checked”
 No — by design

# 10. Mental Model (Best Way to Remember)

Think of it as A sieve that removes all approved objects and hands you only the bad ones

It does nothing else.

# 11. When NOT to Use This Function

Do NOT use it if:

* You need runtime values
* You need tag enforcement
* You need conditional logic based on variables

Use instead:

* tfplan-functions
* tfstate-functions

# 12. Final Deep Summary

> filter_attribute_not_in_list is a pure, deterministic Sentinel helper that scans Terraform configuration metadata, extracts a specified top-level attribute, compares it against an allow-list, and returns only the violating objects and messages—leaving enforcement decisions to the policy rule.
