# find_datasources_by_type
This function finds all data sources of a specific type in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_datasources_by_type = func(type)`

## Arguments
* **type**: the type of data source to find, given as a string.

## Common Functions Used
None

## What It Returns
This function returns a single flat map of data sources indexed by the complete [addresses](https://www.terraform.io/docs/internals/resource-addressing.html) of the data sources (excluding indices representing their counts). The map is actually a filtered sub-collection of the [`tfconfig.resources`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-resources-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
allAMIs = config.find_datasources_by_type("aws_ami")

allImages = config.find_datasources_by_type("azurerm_image")

allImages = config.find_datasources_by_type("google_compute_image")

allDatastores = config.find_datasources_by_type("vsphere_datastore")
```
find_datasources_by_type.md
---------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# 1. What find_datasources_by_type Really Is

find_datasources_by_type is a helper function written in Sentinel.

Its job is to: Look inside the Terraform configuration of the current run and find all data sources of a specific type.

Example:

data "azurerm_image" "example"
{
  name = "my-image"
}

If you pass "azurerm_image" to this function, it finds all such data blocks, no matter:

* Which module they are in
* How deeply nested the module is
* Whether there are multiple instances

# 2. Why This Function Exists (Very Important)

Terraform Sentinel policies often need to:

* Enforce rules on data sources
* Not just on resources

Examples:

* Ensure all data.azurerm_image come from an approved gallery
* Block unapproved AMIs (aws_ami)
* Validate naming standards for images

Terraform itself does not give an easy built-in way to query data sources by type across modules.

* This function solves that problem.

# 3. Where the Function Lives

> Sentinel Module: tfconfig-functions.sentinel

A Sentinel module is like a reusable library.

Instead of writing the same logic in every policy, you: import "tfconfig-functions" as config

Then call: config.find_datasources_by_type("azurerm_image")

# 4. What Input the Function Takes

## Declaration

find_datasources_by_type = func(type)

# Argument: type

* A string
* Must exactly match Terraform data source type

* Examples:

  * "aws_ami"
  * "azurerm_image"
  * "google_compute_image"

If the string doesn’t match any data source types in the configuration, the function returns an empty map.

# 5. What Is tfconfig/v2 and Why It’s Used

This function uses the tfconfig/v2 Sentinel import.

# What tfconfig/v2 provides

It gives Sentinel access to:

* Terraform configuration (not state, not plan changes)

* All:

  * resources
  * data sources
  * modules
  * arguments

# Key difference from tfplan/v2

|    Import        |            Purpose                    |
| ---------------- | ------------------------------------- |
|   tfconfig/v2    |    What is defined in .tf files       |
|   tfplan/v2      |    What will change during apply      |

This function works on configuration, not runtime changes.

# 6. Understanding tfconfig.resources

This is the most important concept here.

# tfconfig.resources contains:

* Both resources AND data sources
* Across:

  * root module
  * child modules
  * nested modules

Each entry includes:

* Type (azurerm_image, aws_ami, etc.)
* Mode:

  * "managed" → resources
  * "data" → data sources

* Full address

Example address: module.network.module.subnet.data.azurerm_image.my_image

# 7. How the Function Works Internally (Conceptual Flow)

Even without code, the logic is always like this:

# Step 1: Look at all config resources

tfconfig.resources

This is a map of everything defined in Terraform.

# Step 2: Filter only data sources

Each item has: resource.mode == "data"

This removes real resources and keeps only data sources.

# Step 3: Match the requested type

resource.type == type

This ensures:

* Only azurerm_image
* Or only aws_ami
* Etc.

# Step 4: Return a flat map

* Indexed by full Terraform address
* Count indices removed
* Easy to iterate in policies

Example return value:

{
  "data.azurerm_image.img1": {...},
  "module.vm.data.azurerm_image.img2": {...}
}

# 8. What “Flat Map Indexed by Address” Means

# Flat Map

No nesting by module:

map[address] = datasource

# Why this is important

* Easy to loop:

for config.find_datasources_by_type("azurerm_image") as addr, ds
{
  # validate ds
}

# 9. What “Excluding Indices Representing Counts” Means

Terraform allows:

data "aws_ami" "example"
{
  count = 2
}

Terraform internally creates:

data.aws_ami.example[0]
data.aws_ami.example[1]

This function:

* Strips [0], [1]
* Returns a single logical datasource

This avoids:

* Duplicate validation
* False failures

# 10. What the Function Does NOT Do

It does not:

* Print anything
* Modify resources
* Enforce policies by itself
* Validate values

It only collects and returns data

# 11. How This Is Used in a Real Sentinel Policy

Example (Azure-focused): import "tfconfig-functions" as config

images = config.find_datasources_by_type("azurerm_image")

allowed_galleries = 
[
  "approvedGallery1",
  "approvedGallery2",
]

main = rule 
{
  all images as _, img 
  {
    img.config.gallery_name in allowed_galleries
  }
}

# 12. Difference Between Data Sources vs Resources (Critical)

|         Aspect             |    Resource    |   Data Source     |
| -------------------------- | ---------------| ----------------- |
|   Creates infrastructure   |    ✅         |    ❌             |
|   Reads existing infra     |    ❌         |    ✅             |
|   mode value               |   "managed"    |   "data"          |
|   Example                  |   azurerm_vm   |   azurerm_image   |

# 13. Why This Matters for Enterprise Policies

This function enables:

* Image governance
* Security compliance
* Approved catalogs
* Multi-cloud enforcement

Without it:

* Policies would be incomplete
* Data-based infra would bypass controls
