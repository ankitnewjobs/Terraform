# find_all_module_calls
This function finds all module calls in all modules in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

Calling it is equivalent to referencing `tfconfig.module_calls`. It is included so that policies that use the tfconfig-functions.sentinel module do not need to import both it and the tfconfig/v2 module.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_all_module_calls = func()`

## Arguments
None

## Common Functions Used
None

## What It Returns
This function returns a single flat map of all module_calls indexed by the address of the module_call's module and its name. The map actually is identical to the [`tfconfig.module_calls`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-module_calls-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here is an example of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
allModuleCalls = config.find_all_module_calls()
```
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# 1. High-level purpose

find_all_module_calls is a helper function used in Terraform Cloud / Enterprise Sentinel policies.

Its job is simple:

> Return every module block (module call) defined anywhere in the Terraform configuration, across:

* the root module
* all child modules
* nested modules

It does this by reading Terraform configuration metadata via the tfconfig/v2 import.

# 2. What is a “module call” in Terraform?

In Terraform, a module call is a module block:

module "network"
{
  source = "./modules/network"
  vnet_cidr = "10.0.0.0/16"
}

Each module block:

* calls another module
* has a name (network)
* has a source
* has input variables
* exists at a specific module path (root or child module)

Sentinel refers to these as module_calls.

# 3. Why this function exists (design rationale)

Terraform Sentinel already exposes:

tfconfig.module_calls

So why create find_all_module_calls()?

# Reason:

To avoid forcing policies to import tfconfig/v2 directly.

Instead of doing this in every policy: import "tfconfig/v2" as tfconfig

You can just do: import "tfconfig-functions" as config

and call: config.find_all_module_calls()

This:

* keeps policies clean
* standardizes access patterns
* centralizes config-related logic

# 4. Declaration explained

find_all_module_calls = func()

# Key points:

* It’s a zero-argument function
* No inputs are required
* It always works on the current workspace plan

# 5. What data source does it use?

Internally, the function relies on: tfconfig.module_calls

From the tfconfig/v2 import.

# tfconfig.module_calls contains:

* all module calls across the entire configuration
* including nested modules
* derived from Terraform configuration, not state or plan changes

# 6. Return value 

# Return type

> A flat map of module calls

# Map key format

Each key is: <module address>.<module call name>

Example keys:

root.network
root.compute
root.network.subnets

# Map value

Each value is an object describing the module call, typically including:

* name – module name
* source – where the module comes from
* version (if registry module)
* expressions – inputs passed to the module
* module_address – where it is called from

# 7. Example return structure (simplified)

Imagine this Terraform:

module "vnet" 
{
  source = "./modules/vnet"
}

module "aks"
{
  source = "Azure/aks/azurerm"
}

Calling: allModuleCalls = config.find_all_module_calls()

Produces something conceptually like:

{
  "root.vnet":
  {
    name = "vnet",
    source = "./modules/vnet",
    module_address = "root"
  },
  "root.aks": 
  {
    name = "aks",
    source = "Azure/aks/azurerm",
    module_address = "root"
  }
}

> Exact fields may vary, but the key structure and flat map behavior are guaranteed.

# 8. What does “flat map” means

A flat map means:

* No nesting by module depth
* No arrays
* Everything is accessible in one loop

This makes Sentinel rules simpler: allModuleCalls = config.find_all_module_calls()

violations = 
[
  key for key, mc in allModuleCalls
  if not mc.source contains "registry.terraform.io"
]

# 9. What the function does NOT do

It does not:

* print anything
* modify data
* evaluate plans or resource changes
* inspect runtime values

* It only reads Terraform configuration metadata

# 10. Typical real-world use cases

# Enforce module source restrictions

allowed = ["registry.terraform.io", "github.com/org"]

all = config.find_all_module_calls()

main = rule
{
  all mc in all 
  {
    any allowedSrc in allowed 
    {
      mc.source contains allowedSrc
    }   } }

# Prevent use of local modules

main = rule
{
  All MC in config.find_all_module_calls()
 {
    not mc.source startswith "./"
  }  }

# Enforce approved module versions

sentinel
main = rule
{
  All MC in config.find_all_module_calls()
 {
    mc.version is not null
  } }
