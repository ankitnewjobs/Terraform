# find_all_outputs
This function finds all outputs in all modules in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

Calling it is equivalent to referencing `tfconfig.outputs`. It is included so that policies that use the tfconfig-functions.sentinel module do not need to import both it and the tfconfig/v2 module.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_all_outputs = func()`

## Arguments
None

## Common Functions Used
None

## What It Returns
This function returns a single flat map of all outputs indexed by the address of the output's module and its name. The map actually is identical to the [`tfconfig.outputs`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-outputs-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here is an example of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
allOutputs = config.find_all_outputs()
```
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# 1. What is an “output” in Terraform

In Terraform, an output is:

> A named, exported value from a module that can be:

* displayed to users after applying
* consumed by a parent module
* referenced by Terraform Cloud/Enterprise
* inspected by Sentinel policies

Example:

output "vnet_id" 
{
  value = azurerm_virtual_network.main.id
}

Conceptually:

* Outputs are the public interface of a module
* They define what a module exposes, not how it works internally

# 2. Outputs exist at multiple levels

In real Terraform systems, outputs exist in:

1. Root module
2. Child modules
3. Nested child modules

Example structure:

root
 ├─ outputs.tf
 ├─ module "network"
 │   ├─ outputs.tf
 │   └─ module "subnet"
 │       └─ outputs.tf

Each module defines its own output namespace.

# 3. The problem Sentinel needs to solve

From a policy perspective:

> “I want to reason about all outputs everywhere, not just root outputs.”

However:

* Terraform code is hierarchical
* Outputs are scoped per module
* Walking the tree manually is complex

So Sentinel needs:
* A flattened, global view
* With fully qualified addresses

That is exactly what find_all_outputs provides.

# 4. What find_all_outputs does 

find_all_outputs: *Collects every output block from every module in the Terraform configuration and returns them as a single flat map.

Important characteristics:

* Uses static configuration analysis (not runtime values)
* Works before applying
* Reads module definitions, not state

# 5. Relationship to tfconfig.outputs

Terraform Sentinel already exposes: tfconfig.outputs

find_all_outputs is simply:  A convenience wrapper around tfconfig.outputs

Why this matters:

* Policies import one module (tfconfig-functions)
* Cleaner and more reusable policy design
* Centralized access pattern

# 6. What does “flat map” mean here?

Instead of nested structures like: root → module → submodule → outputs

{
  "root.output_name": {...},
  "root.network.vnet_id": {...},
  "root.network.subnet.subnet_ids": {...}
}

# Why this is important

Sentinel works best with:

* simple for loops
* all, any, filter
* deterministic keys

# 7. Output addressing (key structure)

Each output is indexed by: <module_address>.<output_name>

# Examples

|   Terraform Location     |   Output Name  |        Sentinel Key                 |
| ------------------------ | -------------- | ----------------------------------- |
|   Root module            |   location     |    root.location                    |
|   Module network         |   vnet_id      |    root.network.vnet_id             |
|   Nested module subnet   |   subnet_ids   |    root.network.subnet.subnet_ids   |

This address:

* uniquely identifies the output
* preserves module hierarchy in string form
* avoids collisions

# 8. Example Terraform configuration

# Root module

output "environment" 
{
  value = var.env
}

# Child module: network

output "vnet_id" 
{
  value = azurerm_virtual_network.main.id
}

# Nested module: subnet

output "subnet_ids" 
{
  value = azurerm_subnet.main[*].id
}

# 9. Conceptual result of find_all_outputs()

Calling: allOutputs = config.find_all_outputs()

Produces a conceptual structure like:

{
  "root.environment": 
  {
    name = "environment",
    module_address = "root",
    expression = "var.env"
  },

  "root.network.vnet_id": 
  {
    name = "vnet_id",
    module_address = "root.network",
    expression = "azurerm_virtual_network.main.id"
  },

  "root.network.subnet.subnet_ids": 
  {
    name = "subnet_ids",
    module_address = "root.network.subnet",
    expression = "azurerm_subnet.main[*].id"
  }
}

> Sentinel does not evaluate values here—only structure and references.

# 10. What information does an output object represents

Each output entry conceptually contains:

* name – output name
* module_address – where it is defined
* expression – what it references
* sensitive flag (if defined)
* description (if provided)

This allows policies to reason about:

* exposure
* data flow
* security boundaries

# 11. What this function does NOT do

Does not:

* expose runtime values
* read Terraform state
* know actual resource IDs
* know secret values

It only understands:

* structure
* references
* configuration intent

# 12. Why outputs matter for governance

From a platform / DevOps / security perspective:

Outputs define:

* What data leaves a module
* What data becomes globally visible
* What data may be exposed to pipelines or users

# 13. Real-world policy examples (theoretical)

# Example 1: Prevent sensitive outputs

main = rule
{
  all o in config.find_all_outputs() 
  {
    o.sensitive is true
  } }

Intent: Enforce that all outputs are explicitly marked sensitive.

# Example 2: Block outputs exposing raw secrets

main = rule
{
  all o in config.find_all_outputs() 
  {
    not o.expression contains "password"
  }
}

Intent: Prevent leaking secrets via outputs.

# Example 3: Enforce naming standards

main = rule
{
  all o in config.find_all_outputs() 
  {
    o.name matches "^[a-z0-9_]+$"
  }
}

# 14. Why is this abstraction powerful

find_all_outputs:

* removes module hierarchy complexity
* enables organization-wide standards
* works consistently across repositories
* scales to large Terraform estates
