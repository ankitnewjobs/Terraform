module "tfplan-functions" {
    source = "../common-functions/tfplan-functions/tfplan-functions.sentinel"
}

module "tfstate-functions" {
    source = "../common-functions/tfstate-functions/tfstate-functions.sentinel"
}

module "tfconfig-functions" {
    source = "../common-functions/tfconfig-functions/tfconfig-functions.sentinel"
}

module "tfrun-functions" {
    source = "../common-functions/tfrun-functions/tfrun-functions.sentinel"
}
    
module "azure-functions" {
    source = "../azure-functions/azure-functions.sentinel"
}

policy "enforce-mandatory-tags" {
    source = "./enforce-mandatory-tags.sentinel"
    enforcement_level = "soft-mandatory"
}

policy "restrict-vm-publisher" {
    source = "./restrict-vm-publisher.sentinel"
    enforcement_level = "soft-mandatory"
}

policy "restrict-vm-size" {
    source = "./restrict-vm-size.sentinel"
    enforcement_level = "soft-mandatory"
}

policy "allowed-providers" {
    source = "./allowed-providers.sentinel"
    enforcement_level = "soft-mandatory"
}

policy "limit-proposed-monthly-cost" {
    source = "./limit-proposed-monthly-cost.sentinel"
    enforcement_level = "advisory"
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# 1. What This File Is: This file tells Terraform Cloud:

Here are the reusable Sentinel modules I want to make available, and here are the policies I want enforced, along with the corresponding enforcement levels.

It acts like a wiring layer between:

* Sentinel libraries (modules)
* Your custom governance policies

* Think of it as the main.tf of Sentinel governance.

# 2. Why Sentinel Uses Modules: Sentinel modules are like libraries:

* Reusable
* Versionable
* Shared across many policies

# 3. Module Definitions 

# 3.1 tfplan-functions Module

module "tfplan-functions"
{
    source = "../common-functions/tfplan-functions/tfplan-functions.sentinel"
}

# What this module provides: Functions that operate on Terraform plan data (tfplan/v2), such as:

* find_resources()
* filter_attribute_not_in_list()
* find_resources_with_standard_tags()
* Change-type filtering (create/update/delete)

# Why it’s critical

* Terraform plans are deeply nested JSON
* This module abstracts that complexity
* Almost every enforcement policy uses it

Example usage in a policy: import "tfplan-functions" as plan

# 3.2 tfstate-functions Module

module "tfstate-functions" 
{
    source = "../common-functions/tfstate-functions/tfstate-functions.sentinel"
}

# What this module provides: Functions that inspect the current Terraform state, not the plan.

Used for:

* Drift detection
* Validating already-existing resources
* Comparing desired vs actual state

### When it’s used

* Do existing resources comply?
* Are we modifying protected resources?

* This is post-deployment awareness, unlike tfplan.

# 3.3 tfconfig-functions Module

module "tfconfig-functions"
{
    source = "../common-functions/tfconfig-functions/tfconfig-functions.sentinel"
}

# What this module provides

Functions that analyze Terraform configuration files, not state or plan.

Used for:

* Provider restrictions
* Module usage enforcement
* Required providers
* Backend enforcement

Example: Only allow azurerm and random providers

This runs before planning even finishes.

# 3.4 tfrun-functions Module

module "tfrun-functions"
{
    source = "../common-functions/tfrun-functions/tfrun-functions.sentinel"
}

# What this module provides: Metadata about the Terraform run, such as:

* Workspace name
* Organization
* Run type (plan/apply)
* VCS branch
* Who triggered the run

# Why it matters

Enables context-aware policies:

if tfrun.workspace.name matches "prod"
{
  enforce_strict = true
}

This is how you build environment-aware governance.

# 3.5 azure-functions Module

module "azure-functions" 
{
    source = "../azure-functions/azure-functions.sentinel"
}

# What this module provides

Azure-specific helper logic, such as:

* Azure resource type detection
* Tag validation helpers
* Subscription/resource group parsing
* Azure naming convention helpers

# Why this is powerful

Instead of generic logic: if resource.type == "azurerm_virtual_machine"

You get Azure-aware helpers: azure.is_vm(resource)

* This enables cloud-specific governance without cluttering policies.

# 4. Policy Definitions 

Each policy block registers one Sentinel policy.

# 4.1 enforce-mandatory-tags

policy "enforce-mandatory-tags" 
{
    source = "./enforce-mandatory-tags.sentinel"
    enforcement_level = "soft-mandatory"
}

# What it does: Enforces required Azure tags like:

  * cost_center
  * owner
  * environment

### Enforcement Level: soft-mandatory

|      Behavior        |         Meaning              |
| -------------------- | ---------------------------- |
|     Blocks apply     |        No                    |
|     Shows warnings   |        Yes                   |
|     Can override     |        With justification    |

# Used when:

* You want compliance
* But don’t want to block delivery immediately

# 4.2 restrict-vm-publisher

policy "restrict-vm-publisher" 
{
    source = "./restrict-vm-publisher.sentinel"
    enforcement_level = "soft-mandatory"
}

# What it does

* Restricts Azure VM images to approved publishers

  * e.g., Canonical, MicrosoftWindowsServer

# Why soft-mandatory?

* Teams may need exceptions
* Governance is enforced gradually

# 4.3 restrict-vm-size

policy "restrict-vm-size"
{
    source = "./restrict-vm-size.sentinel"
    enforcement_level = "soft-mandatory"
}

# What it does

* Enforces allowed Azure VM sizes
* Prevents cost overruns
* Standardizes infrastructure

# 4.4 allowed-providers

policy "allowed-providers"
{
    source = "./allowed-providers.sentinel"
    enforcement_level = "soft-mandatory"
}

# What it does

* Restricts Terraform providers:

  * Blocks unknown or risky providers
  * Prevents shadow IT

# Typical use: allowed = ["azurerm", "random", "null"]

# 4.5 limit-proposed-monthly-cost

policy "limit-proposed-monthly-cost" 
{
    source = "./limit-proposed-monthly-cost.sentinel"
    enforcement_level = "advisory"
}

# What it does

* Estimates the cost impact of the plan
* Warns if the monthly cost exceeds the threshold

# Enforcement Level: advisory

|      Behavior        |    Meaning   |
| -------------------- | ---------- --|
|     Blocks apply     |    Never     |
|     Shows warnings   |    Yes       |
|     Informational    |    Yes       |

# d for:

* Cost awareness
* FinOps visibility
* Developer education

# 5. Enforcement Levels Explained 

|      Level         |   Blocks Apply   |    Override Needed    |         Use Case            |
| ------------------ | ---------------- | --------------------- | --------------------------- |
|   mandatory        |    Yes           |         No            |    Security / compliance    |
|   soft-mandatory   |    No            |         Yes           |    Gradual enforcement      |
|   advisory         |    No            |          No           |    Visibility only          |

Your setup shows mature governance:

* Hard stops avoided
* Education-first approach
* Gradual compliance adoption

# 6. Execution Order 

When Terraform runs:

terraform plan
   ↓
Sentinel loads modules
   ↓
Policies execute in parallel
   ↓
Each policy evaluates the main rule
   ↓
Results aggregated
   ↓
Apply allowed/warned/blocked
