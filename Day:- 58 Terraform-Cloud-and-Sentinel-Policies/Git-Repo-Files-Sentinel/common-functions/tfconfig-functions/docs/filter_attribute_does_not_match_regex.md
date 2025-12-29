# filter_attribute_does_not_match_regex
This function filters a collection of items such as providers, provisioners, resources, data sources, variables, outputs, or module calls to those with an attribute that does not match a given regular expression (regex). A policy would call it when it wants the attribute to match that regex. The attribute must either be a top-level attribute or an attribute directly under "config".

It uses the Sentinel [matches](https://docs.hashicorp.com/sentinel/language/spec/#matches-operator) operator which uses [RE2](https://github.com/google/re2/wiki/Syntax) regex.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../tfconfig-functions.sentinel) module.

## Declaration
`filter_attribute_does_not_match_regex = func(items, attr, expr, prtmsg)`

## Arguments
* **items**: a map of items such as providers, provisioners, resources, data sources, variables, outputs, or module calls.
* **attr**: the name of a top-level attribute or an attribute directly under "config". In the fist case, give the attribute as a string. In the second case, give it as "config.x" where "x" is the attribute you're trying to restrict.
* **expr**: the regex expression that should not be matched. Note that any occurrences of `\` need to be escaped with `\` itself since Sentinel allows certain special characters to be escaped with `\`. For example, if you did not want to not match sub-domains of ".acme.com", you would set `expr` to `(.+)\\.acme\\.com$` instead of the more usual `(.+)\.acme\.com$`.
* **prtmsg**: a boolean indicating whether violation messages should be printed (if `true`) or not (if `false`).

## Common Functions Used
This function calls the [evaluate_attribute](./evaluate_attribute.md) and the [to_string](./to_string.md) functions.

## What It Returns
This function returns a map with two maps, `items` and `messages`, both of which are indexed by the complete [addresses](https://www.terraform.io/docs/internals/resource-addressing.html) of the items that meet the condition of the filter function. The `items` map contains the actual resources for which the attribute (`attr`) does not match the given regex, `expr`, while the `messages` map contains the violation messages associated with those instances.

## What It Prints
This function prints the violation messages if the parameter, `prtmsg`, was set to `true`. Otherwise, it does not print anything.

## Examples
Here is an example of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
violatingEC2Instances = config.filter_attribute_does_not_match_regex(allEC2Instances,
                        "config.ami", "^data\\.aws_ami\\.(.*)$", true)
```
This is from the [require-most-recent-AMI-version.sentinel](../../../aws/require-most-recent-AMI-version.sentinel) policy.
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# 1. What problem does this function solves

Terraform configurations can define attributes in many ways:

* Hard-coded values
* References to variables, data sources, or other resources
* Nested under config

Policies often need to say things like:

> Reject all resources whose attribute does not follow a naming convention

or

> Reject resources whose attribute does not reference an approved data source

This function filters a collection of Terraform items and returns only the ones violating a regex rule.

Despite the confusing wording, it finds violations, not compliant items.

# 2. Function signature

filter_attribute_does_not_match_regex = func(items, attr, expr, prtmsg)

# 3. Arguments (with real meaning)

# 3.1 items — collection to evaluate

* A map of Terraform objects
* Keys are Terraform addresses
* Values are Terraform items (resources, providers, etc.)

Examples:

tfconfig.resources
tfconfig.data_sources
tfconfig.module_calls

Example map key:

aws_instance.web
module.vpc.aws_subnet.public

# 3.2 attr — which attribute to inspect

Must be either:

|    Form              |    Example          |
| -------------------- | ------------------- |
|   Top-level          |   "type"            |
|   Config attribute   |   "config.name"     |

Nested paths like config.tags.Name are not supported directly.

Why?

* tfconfig stores only one level under config
* Deep traversal is intentionally avoided for predictability

# 3.3 expr — regex that MUST NOT match

* Uses Sentinel’s matches operator
* Regex engine: RE2

Sentinel requires double escaping for backslashes.

# Example

Want to block: .acme.com

Regex must be written as: (.+)\\.acme\\.com$

# 3.4 prtmsg — print violations or not

|   Value   |           Behavior                         |
| --------- | ------------------------------------------ |
|   true    |    Print violation messages                |
|   false   |    Silent (machine-readable output only)   |

Useful for:

* Debugging
* Human-readable policy output
* CI logs

# 4. Functions it depends on

# 4.1 evaluate_attribute

Used to:

* Extract attribute safely
* Handle:

  * constant_value
  * references

This avoids policy authors writing fragile attribute access logic.

# 4.2 to_string

Used to:

* Convert attribute values into strings
* Needed because:

  * Attributes may be strings, lists, or numbers
  * Regex matching requires strings

# 5. Internal logic (step by step)

Here’s the actual conceptual flow of the function:

# Step 1: Initialize empty result maps

violating_items = {}
messages = {}

# Step 2: Iterate over every item

for address, item in items {

Each address is a Terraform resource address.

# Step 3: Extract the attribute safely

val = evaluate_attribute(item, attr) else null

This:

* Handles missing attributes
* Handles constants vs references

If the attribute does not exist → skip the item.

# Step 4: Normalize value to string

val_str = to_string(val)

Why?

* Regex only works on strings
* References often come as lists → converted to readable string

Example: ["var.ami_id"] → "var.ami_id"

# Step 5: Apply regex check

if !(val_str matches expr) 

This is the core condition.

If the attribute does NOT match the regex → violation.

# Step 6: Record violation

violating_items[address] = item
messages[address] = "Violation message"

The message usually contains:

* Address
* Attribute name
* Actual value
* Expected regex

# Step 7: Optionally print message

if prtmsg 
{
  print(messages[address])
}

# Step 8: Return structured result

return 
{
  "items": violating_items,
  "messages": messages
}

# 6. What the function returns

 items =
 {
    "aws_instance.web" = <resource object>
  },
  messages =
  {
    "aws_instance.web" = "Attribute config.ami does not match regex ..."
  }
}

# Why this design is powerful

* items → used for enforcement
* messages → used for human-readable feedback

Policies can:

* Fail if length(result.items) > 0
* Print messages only if needed

# 7. What the function prints

|   prtmsg  |        Output                    |
| --------- | -------------------------------- |
|   true    |     Violation messages printed   |
|   false   |     Nothing printed              |

Printing does not affect the return value.

# 8. Real-world example (from AWS)

# Terraform

resource "aws_instance" "web" 
{
  ami = "ami-123456"
}

# Policy intent

> EC2 instances must use the latest AMI via data source

# Policy call

violatingEC2Instances =
  config.filter_attribute_does_not_match_regex(
    allEC2Instances,
    "config.ami",
    "^data\\.aws_ami\\.(.*)$",
    true
  )

# Why this works

* Approved AMIs must be:   ami = data.aws_ami.latest.id
  
* Hardcoded AMI IDs fail the regex
* Violators are returned and printed

# 9. Common mistakes & gotchas

# Misunderstanding the name

> “does_not_match” means violations, not compliant resources.

# Forgetting double escaping

\.   ❌
\\.  ✅

# Expecting reference resolution

This function:

* Detects references
* Does NOT evaluate them

# Using deep config paths

config.tags.Name ❌
config.name      ✅
