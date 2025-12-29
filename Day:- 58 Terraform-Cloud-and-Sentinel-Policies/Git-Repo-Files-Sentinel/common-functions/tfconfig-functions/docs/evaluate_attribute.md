# evaluate_attribute
This function evaluates an attribute within an item in the Terraform configuration. The attribute must either be a top-level attribute or an attribute directly under "config".

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../tfconfig-functions.sentinel) module.

## Declaration
`evaluate_attribute = func(item, attribute)`

## Arguments
* **item**: a single item containing an attribute whose value you want to determine.
* **attribute**: a string giving the attribute. In general, the attribute should be a top-level attribute of item, but it can also have the form "config.x".

In practice, this function is only called by the filter functions, so the specification of the `attribute` parameter will be done when calling them.

## Common Functions Used
None.

## What It Returns
This function returns the attribute as it occurred within the Terraform configuration. The type will vary depending on what kind of attribute is evaluated. If the attribute had the form "config.x", it will look for "constant_value" or "references" under `item.config.x` and then whichever one it finds. In the latter case, it will return a list with all the references that the attribute referenced. Note that this does not evaluate the values of the references.

## What It Prints
This function does not print anything.

## Examples
This function is called by the `filter_attribute_does_not_match_regex` and `filter_attribute_matches_regex` filter functions in the tfconfig-functions.sentinel module like this:
```
val = evaluate_attribute(item, attr) else null
```
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# 1. Purpose of evaluate_attribute

evaluate_attribute is a helper function used in Sentinel policies to:

> Extract the value of a specific attribute from a Terraform configuration item, consistently and safely.

Terraform configuration data (from tfconfig) is not always simple key–value data. Attributes can be:

* Literal (hard-coded) values
* References to other resources or variables
* Nested inside a config block

# 2. Where this function lives

* Module: tfconfig-functions.sentinel
* Used internally by filter functions
* Not usually called directly in policies

# 3. Function signature

evaluate_attribute = func(item, attribute)

# Arguments explained

# 1. item

* A single Terraform configuration object

* Typically something like:

  * a resource
  * a data source
  * a provider block
    
* Comes from tfconfig.resources, tfconfig.module_calls, etc.

Example item structure (simplified):

  "type": "azurerm_storage_account",
  "name": "example",
  "config": 
  {
    "name": 
    {
      "constant_value": "mystorageaccount"
    }
  }
}

# 2. attribute

* A string specifying which attribute to evaluate

* Can be:

  * A top-level attribute:         "type"
    
  * A config attribute:         "config.name"
    
The function supports only these two forms intentionally to keep it predictable.

# 4. What problem does it solve (important)

In Terraform tfconfig:

* Literal values are stored under:   constant_value
  
* Referenced values are stored under:   references
  
Example:

"name": 
{
  "references": ["var.storage_name"]
}

If your policy directly reads item.config.name, you would not know whether the value is constant or a reference.

* evaluate_attribute hides this complexity.

# 5. How evaluate_attribute works (logical flow)

Here is the step-by-step logic the function follows:

# Step 1: Identify attribute type

The function checks whether: attribute is a top-level attribute:     item[attribute]
  
* OR it starts with "config." :     item.config.x
  
# Step 2: If it is a top-level attribute

Example: attribute = "type"

It simply returns: item.type

* No further processing needed.

# Step 3: If it is a config.x attribute

Example: attribute = "config.name"

The function:

1. Looks up:    item.config.name
   
2. Checks what exists under it:

   * constant_value

    * OR references

# Step 4: If constant_value exists

Example:

"name":
{
  "constant_value": "mystorageaccount"
}

The function returns: "mystorageaccount" ( This is a literal value. )

# Step 5: If references exist instead

Example:

"name":
{
  "references": ["var.storage_name"]
}

The function returns: ["var.storage_name"]


# Important:

* It does NOT resolve the reference
* It only reports what was referenced

# 6. What the function returns

The return type depends on the attribute:

|   Attribute form         |    Possible return type       |
| ------------------------ | ----------------------------- |
|   Top-level              |   string, bool, number, map   |
|   config.x (constant)    |   string, number, bool        |
|   config.x (reference)   |   list of strings             |

# 7. What the function does NOT do

* t does not:

* Evaluate Terraform expressions
* Resolve variables
* Resolve resource outputs
* Print logs or debug output

It is purely a read-only extractor.

# 8. Why filter functions depend on it

Example usage: val = evaluate_attribute(item, attr) else null

This allows filter functions to:

* Safely extract attributes
* Handle missing attributes gracefully
* Work uniformly across different Terraform constructs

Without this function, every filter would need duplicate logic to:

* Check constant_value
* Check references
* Handle missing keys

# 9. Real-world example

# Terraform code

resource "azurerm_storage_account" "example" 
{
  name = var.storage_name
}

# Sentinel call

evaluate_attribute(item, "config.name")

# Returned value

["var.storage_name"]

This allows a policy like:

* “Reject resources where name references a forbidden variable”
* “Ensure names are not dynamically generated”

# 10. Summary in one sentence

> evaluate_attribute is a Sentinel utility function that safely extracts a Terraform attribute.

> whether it’s a literal value or a reference—so filter policies can operate consistently without caring how the value was defined.

