# find_outputs_by_sensitivity
This function finds all outputs of a specific sensitivity (`true` or `false`) in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_outputs_by_sensitivity = func(sensitive)`

## Arguments
* **sensitive**: the desired sensitivity of outputs which can be `true` or `false` (without quotes).

## Common Functions Used
None

## What It Returns
This function returns a single flat map of outputs indexed by the address of the module and the name of the output. The map is actually a filtered sub-collection of the [`tfconfig.outputs`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-outputs-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
sensitiveOutputs = config.find_outputs_by_sensitivity(true)

nonSensitiveOutputs = config.find_outputs_by_sensitivity(false)
```
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# find_outputs_by_sensitivity

- This function finds all outputs of a specific sensitivity (true or false) in the Terraform configuration of the current plan's workspace using the tfconfig/v2 import.

This sentence explains what the function does:

* It looks at Terraform outputs (output "..." {})
* It filters them based on:

  * sensitive = true
  * or sensitive = false
    
* It examines the Terraform configuration, not runtime values

* It uses Sentinel’s tfconfig/v2 import, which reads static Terraform configuration

Important: This does not look at the Terraform plan results (tfplan) — only the config.

# Sentinel Module: It tells you where the function lives.

# This function is contained in the tfconfig-functions.sentinel module.

This means:

* The function is not built-in
* It is defined inside a custom Sentinel module
* That module file is named tfconfig-functions.sentinel

To use it, you must import that file into your policy.

# sensitive: the desired sensitivity of outputs, which can be true or false (without quotes).

This explains the meaning of the parameter:

* You tell the function what kind of outputs you want:

  * true → sensitive outputs
  * false → non-sensitive outputs

* “Without quotes” means it must be a boolean, not text

# Common Functions Used: None

This means:

* The function does not depend on any helper functions
* It directly works with tfconfig.outputs

# What It Returns

* This function returns a single flat map of outputs indexed by the address of the module and the name of the output.

- The function returns a map (dictionary)

* The keys look like:

  module.network.db_password
  root.admin_email
  
* The values are output objects from tfconfig.outputs

“Flat map” means:

* No nesting
* Everything is at the same level

# The map is actually a filtered sub-collection of the tfconfig.outputs collection.

This explains how the map is built:

* Sentinel already provides tfconfig.outputs

* The function:

  1. Iterates over all outputs
  2. Keeps only those where:

     output.sensitive == sensitive

  3. Returns the filtered result

# What It Prints: This function does not print anything.`

This means:

* No print() statements
* No logs
* It only returns data

This is important in Sentinel because printing is often used only for debugging.

# Examples: This section shows how to use the function.

* Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias config:

This explains:

* You must import the module like this: import "tfconfig-functions" as config
  
* Then call the function via `config`

sensitiveOutputs = config.find_outputs_by_sensitivity(true)

This line means:

- Find only outputs marked as sensitive

- Store them in sensitiveOutputs

- Useful for policies like:
  > “Sensitive outputs must not be exposed”

nonSensitiveOutputs = config.find_outputs_by_sensitivity(false)

This line means:

* Find outputs not marked as sensitive

* Useful for:

  * Auditing
  * Enforcing documentation
  * Detecting secrets accidentally exposed

# How this is typically used in Sentinel policies

Example policy idea: sensitive_outputs = config.find_outputs_by_sensitivity(true)

main = rule
 {
  length(sensitive_outputs) == 0
}
