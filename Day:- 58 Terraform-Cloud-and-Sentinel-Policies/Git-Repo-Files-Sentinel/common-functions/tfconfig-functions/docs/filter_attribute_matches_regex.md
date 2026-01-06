# filter_attribute_matches_regex
This function filters a collection of items such as resources, data sources, or blocks to those with an attribute that matches a given regular expression (regex). A policy would call it when it wants the attribute to not match that regex. The attribute must either be a top-level attribute or an attribute directly under "config".

It uses the Sentinel [matches](https://docs.hashicorp.com/sentinel/language/spec/#matches-operator) operator which uses [RE2](https://github.com/google/re2/wiki/Syntax) regex.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../tfconfig-functions.sentinel) module.

## Declaration
`filter_attribute_matches_regex = func(items, attr, expr, prtmsg)`

## Arguments
* **items**: a map of items such as providers, provisioners, resources, data sources, variables, outputs, or module calls.
* **attr**: the name of a top-level attribute or an attribute directly under "config". In the fist case, give the attribute as a string. In the second case, give it as "config.x" where "x" is the attribute you're trying to restrict.
* **expr**: the regex expression that should be matched. Note that any occurrences of `\` need to be escaped with `\` itself since Sentinel allows certain special characters to be escaped with `\`. For example, if you did not want to match sub-domains of ".acme.com", you would set `expr` to `(.+)\\.acme\\.com$` instead of the more usual `(.+)\.acme\.com$`. If you want to match null, set expr to "null".
* **prtmsg**: a boolean indicating whether violation messages should be printed (if `true`) or not (if `false`).

## Common Functions Used
This function calls the [evaluate_attribute](./evaluate_attribute.md) and the [to_string](./to_string.md) functions.

## What It Returns
This function returns a map with two maps, `items` and `messages`, both of which are indexed by the complete [addresses](https://www.terraform.io/docs/internals/resource-addressing.html) of the items that meet the condition of the filter function. The `items` map contains the actual resources for which the attribute (`attr`) matches the given regex, `expr`, while the `messages` map contains the violation messages associated with those instances.

## What It Prints
This function prints the violation messages if the parameter, `prtmsg`, was set to `true`. Otherwise, it does not print anything.

## Examples
Here is an example of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
violatingEC2Instances = config.filter_attribute_matches_regex(allEC2Instances,
                        "config.ami", "^data\\.aws_ami\\.(.*)$", true)
```
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# 1. What this function does 

filter_attribute_matches_regex is a configuration-time validation helper.

It scans Terraform configuration objects and:

Finds items whose attribute value matches a given regular expression

Most policies use it in a negative sense:

* This attribute must NOT match this pattern.

# 2. What kind of data does it work on

This function works on Terraform configuration metadata, not runtime values.

It can inspect:

* Resources
* Data sources
* Providers
* Provisioners
* Variables
* Outputs
* Module blocks

It cannot inspect:

* Plan-time values
* Computed values
* Expressions after interpolation

# 3. Function declaration

filter_attribute_matches_regex = func(items, attr, expr, prtmsg)

This function takes 4 arguments, each with a specific role.

# 4. Arguments explained in detail

# 4.1 items collection to filter

items

* A map of Terraform objects (keyed by full Terraform address)

* Example keys:

  * aws_instance.web
  * module.vpc.aws_subnet.public

Each item contains:

* Top-level metadata
* Optional config block

# 4.2 attr attribute to inspect

attr = "type"

or

attr = "config.ami"

There are two valid forms:

# Case 1: Top-level attribute

"type"
"name"
"source"

Example: resource "aws_instance" "web" {}

Here: attr = "type"

# Case 2: Attribute under config

"config.ami"
"config.engine"
"config.bucket"

Example:

resource "aws_instance" "web" 
{
  ami = data.aws_ami.amazon_linux.id
}

Here: attr = "config.ami"

Nested attributes beyond this are NOT allowed

* config.tags.env 
* config.lifecycle.prevent_destroy 

# 4.3 expr regex to match

expr = "^data\\.aws_ami\\.(.*)$"

* A regular expression (RE2 syntax)
* The function flags items where:

attribute_value MATCHES expr

# Important: Regex escaping in Sentinel

Sentinel treats `\` as an escape character, so the regex needs double escaping.

|   Regex meaning  |   Sentinel string   |
| ---------------- | ------------------- |
|  `.`             |   `\\.`             |
|   \d             |   \\d               |
|   \.acme\.com    |   \\.acme\\.com     |

# Special case: matching null

If you want to detect null values: expr = "null"

The function converts attribute values to strings, so null → "null".

# 4.4 prtmsg — print messages or not

prtmsg = true | false

* true → print violations
* false → collect silently

Usually:

* false in shared libraries
* true in debugging or enforcement policies

# 5. Common functions used internally

# 5.1 evaluate_attribute

Purpose:

* Resolve the attribute value safely

* Works for:

  * Top-level attributes
  * config.x attributes

It prevents crashes if the attribute is missing.

# 5.2 to_string

Purpose:

* Normalize attribute values to strings
* Makes regex matching safe

Example:

42 → "42"
null → "null"

# 6. Internal logic (step-by-step)

Conceptually, the function works like this:

# Step 1: Iterate over items

for each item in items: Each item is addressed like: aws_instance.web

# Step 2: Evaluate attribute

value = evaluate_attribute(item, attr)

* Handles both:

  * "type"
  * "config.ami"

* Returns `null` if missing

# Step 3: Convert to string

value_str = to_string(value)

Ensures consistent regex evaluation.

# Step 4: Apply regex match

if value_str matches expr:

Uses Sentinel’s: matches

Which uses Google RE2:

* Safe
* Fast
* No catastrophic backtracking

# Step 5: Record violation

If a match is found:

* Store item in items map
* Generate a descriptive message

Example: Resource aws_instance.web has config.ami matching forbidden regex

# Step 6: Optionally print message

if prtmsg:
  print(message)

# 7. What the function returns

{
  items = { ... },
  messages = { ... }
}

# 7.1 items map

* Only violating items
* Indexed by full Terraform address

Example:

items = 
{
  "aws_instance.web" = { ... }
}

# 7.2 messages map

* Human-readable explanation
* Same keys as items

Example:

messages = 
{
  "aws_instance.web" = "AMI must not be derived from a data source"
}

# 8. What it prints

|   prtmsg  |         Behavior                  |
| --------- | --------------------------------- |
|   true    |   Prints all violation messages   |
|   false   |   Prints nothing                  |

# 9. Example explained line-by-line

violatingEC2Instances = config.filter_attribute_matches_regex
(
  allEC2Instances,
  "config.ami",
  "^data\\.aws_ami\\.(.*)$",
  true
)

# Meaning:

* Inspect all EC2 instances
* Read the ami attribute
* Flag if AMI comes from a data source
* Print violations

This enforces: “AMI must be hard-coded or module-provided, not dynamically fetched.”

# 10. Typical real-world use cases

Prevent dynamic AMI resolution
Enforce naming conventions
Restrict public bucket names
Enforce corporate domain patterns
Detect data-source-based configs

# 11. Policy usage pattern

violations = filter_attribute_matches_regex
(
  allResources,
  "config.name",
  ".*-temp$",
  false
)

main = rule 
{
  length(violations.items) == 0
}

# 12. Key differences vs filter_attribute_in_list

|   Aspect        |   In List       |      Regex                  |
| --------------- | --------------- | --------------------------- |
|   Matching      |   Exact match   |   Pattern match             |
|   Flexibility   |   Low           |   High                      |
|   Escaping      |   None          |   Required                  |
|   Use case      |   Known values  |   Naming / structure rules  |

