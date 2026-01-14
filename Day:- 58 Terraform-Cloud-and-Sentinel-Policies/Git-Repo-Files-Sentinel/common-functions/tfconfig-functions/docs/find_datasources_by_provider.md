# find_datasources_by_provider
This function finds all data sources created by a specific provider in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_datasources_by_provider = func(provider)`

## Arguments
* **provider**: the provider of data sources to find, given as a string.

## Common Functions Used
None

## What It Returns
This function returns a single flat map of data sources indexed by the complete [addresses](https://www.terraform.io/docs/internals/resource-addressing.html) of the data sources (excluding indices representing their counts). The map is actually a filtered sub-collection of the [`tfconfig.resources`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-resources-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
allAWSDatasources = config.find_datasources_by_provider("aws")

allAzureDatasources = config.find_datasources_by_provider("azurerm")

allGoogleDatasources = config.find_datasources_by_provider("google")

allVMwareDatasources = config.find_datasources_by_provider("vsphere")
```
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

Great question — Sentinel feels confusing at first because it looks simple but behaves differently from general-purpose languages. I’ll explain **Sentinel-specific concepts** clearly, with Terraform-focused examples, in **plain English**.

---

## 1️⃣ Collections in Sentinel

In Sentinel, a **collection** is a group of values. There are **three main types** you’ll work with:

### 1. Lists

* Ordered collection
* Accessed by index
* Example:

```sentinel
servers = ["web", "api", "db"]
```

* `servers[0]` → `"web"`

Use lists when:

* Order matters
* You loop sequentially

---

### 2. Maps (Most Important for Terraform)

* Key-value pairs
* Keys are usually strings
* **No guaranteed order**

```sentinel
tags = {
  "env" = "prod",
  "owner" = "platform"
}
```

* `tags["env"]` → `"prod"`

👉 **Terraform imports (`tfconfig`, `tfplan`) are almost always maps**, not lists.

---

### 3. Sets

* Unordered
* No duplicate values
* Less common in Terraform policies

```sentinel
allowed_regions = ["eastus", "westus"] as set
```

---

## 2️⃣ Terraform Collections in Sentinel

When you import Terraform data:

```sentinel
import "tfconfig/v2" as tfconfig
```

You get **large nested maps**, for example:

```sentinel
tfconfig.resources
```

### What `tfconfig.resources` actually is

* A **map**
* Key → resource address (string)
* Value → resource object

Example (simplified):

```sentinel
{
  "azurerm_storage_account.example" = {
    provider = "azurerm",
    type = "azurerm_storage_account",
    mode = "managed"
  },
  "data.azurerm_client_config.current" = {
    provider = "azurerm",
    mode = "data"
  }
}
```

📌 **Key takeaway**
You almost always:

* Loop over maps
* Filter maps
* Build new maps

---

## 3️⃣ Looping in Sentinel (Map Iteration)

Sentinel uses **`for` expressions**, not traditional loops.

### Loop over a map

```sentinel
for tfconfig.resources as address, resource {
  ...
}
```

* `address` → key (string)
* `resource` → value (object)

This is extremely common in policies.

---

## 4️⃣ Filtering Collections (Core Sentinel Skill)

Sentinel filters collections using **`filter` expressions**.

### Basic filtering syntax

```sentinel
filtered = filter original as key, value {
  condition
}
```

Only entries where `condition` is `true` are kept.

---

### Example: Filter Azure resources only

```sentinel
azure_resources = filter tfconfig.resources as addr, r {
  r.provider == "azurerm"
}
```

Result:

* Same map structure
* Only Azure resources remain

📌 Sentinel **never modifies the original collection**

* It always creates a **new filtered map**

---

## 5️⃣ Data Sources vs Managed Resources

Sentinel distinguishes them using the **`mode` field**.

| Mode        | Meaning           |
| ----------- | ----------------- |
| `"managed"` | `resource` blocks |
| `"data"`    | `data` blocks     |

Example:

```sentinel
data_sources = filter tfconfig.resources as addr, r {
  r.mode == "data"
}
```

---

## 6️⃣ Combining Conditions (Very Common)

Sentinel uses `and`, `or`, `not` (not `&&`, `||`, `!`).

```sentinel
filter tfconfig.resources as addr, r {
  r.provider == "azurerm" and
  r.mode == "data"
}
```

This finds:

* Azure data sources only

---

## 7️⃣ Address Keys (Why They Matter)

The **map key** is usually the Terraform address:

```text
data.azurerm_client_config.current
```

Sentinel uses this as the index:

```sentinel
result["data.azurerm_client_config.current"]
```

📌 Addresses are:

* Stable
* Unique
* Ideal for indexing

---

## 8️⃣ Flat Maps (What Docs Mean)

When Sentinel docs say:

> “returns a flat map indexed by addresses”

They mean:

* One-level map
* No nested maps
* Keys = Terraform addresses
* Values = resource objects

Example:

```sentinel
{
  "data.azurerm_subscription.primary" = {...},
  "data.azurerm_client_config.current" = {...}
}
```

---

## 9️⃣ Common Sentinel Gotchas 🚨

### ❌ No mutation

This is **invalid**:

```sentinel
tfconfig.resources["x"] = y
```

Sentinel is **immutable** — you always create new collections.

---

### ❌ No `null`

* Sentinel uses `undefined`
* You must check with `is undefined`

```sentinel
r.tags is not undefined
```

---

### ❌ No traditional loops

You can’t do:

```sentinel
for (...) { ... }
```

Everything is expression-based.

---

## 🔁 How This Applies to `find_datasources_by_provider`

That function will:

1. Take a provider name (`"azurerm"`)
2. Look at `tfconfig.resources` (map)
3. Filter:

   * `mode == "data"`
   * `provider == input`
4. Return a **flat map**
5. Keys remain Terraform addresses

---

## 🧠 Mental Model to Remember

> **Sentinel = filter and transform Terraform maps**

Once you master:

* Maps
* Filtering
* Terraform imports

Sentinel policies become straightforward.
