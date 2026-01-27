# find_outputs_in_module
This function finds all outputs in a specific module in the Terraform configuration of the current plan's workspace using the [tfconfig/v2](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html) import.

## Sentinel Module
This function is contained in the [tfconfig-functions.sentinel](../../tfconfig-functions.sentinel) module.

## Declaration
`find_outputs_in_module = func(module_address)`

## Arguments
* **module_address**: the address of the module containing outputs to find, given as a string. The root module is represented by "". A module named `network` called by the root module is represented by "module.network". if that module contained a module named `subnets`, it would be represented by "module.network.module.subnets".

## Common Functions Used
None

## What It Returns
This function returns a single flat map of outputs indexed by the address of the module and the name of the output. The map is actually a filtered sub-collection of the [`tfconfig.outputs`](https://www.terraform.io/docs/cloud/sentinel/import/tfconfig-v2.html#the-outputs-collection) collection.

## What It Prints
This function does not print anything.

## Examples
Here are some examples of calling this function, assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias `config`:
```
allRootModuleOutputs = config.find_outputs_in_module("")

allNetworkOutputs = config.find_outputs_in_module("module.network")
```
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# `# find_outputs_in_module`

This is the **name of the function** being documented.
The function is called **`find_outputs_in_module`**.

---

* This function finds all outputs in a specific module in the Terraform configuration of the current plan's workspace using the tfconfig/v2 import.`

In simple terms:

* The function looks at your **Terraform configuration**
* It focuses on **outputs** (values declared using `output {}` blocks)
* It searches **inside a specific module**
* It uses Terraform Cloud/Enterprise’s **Sentinel `tfconfig/v2` data**, which represents your Terraform code structure (not runtime values)

So this function is about **reading Terraform configuration**, not applying infrastructure.

---

### `## Sentinel Module`

This is a section header saying:

> Which Sentinel module contains this function?

---

### `This function is contained in the tfconfig-functions.sentinel module.`

Meaning:

* The function is **defined inside a Sentinel file**
* The file name is `tfconfig-functions.sentinel`
* You must import this file to use the function

---

### `## Declaration`

This section shows **how the function is declared**.

---

### `find_outputs_in_module = func(module_address)`

This tells you:

* `find_outputs_in_module` is a **function**
* It takes **one argument**
* The argument is named `module_address`

In Sentinel terms:

> “This function expects a string that tells it which module to look into.”

---

### `## Arguments`

This section explains each parameter.

---

### `module_address: the address of the module containing outputs to find, given as a string.`

Meaning:

* You must pass a **string**
* That string identifies **which Terraform module** to inspect

---

### `The root module is represented by "".`

Important rule:

* An **empty string** (`""`) means:
  👉 *Look at outputs in the root module*

---

### `A module named network called by the root module is represented by "module.network".`

Terraform module addressing rule:

* If your Terraform has:

  ```hcl
  module "network" { ... }
  ```
* Then its address is:

  ```
  module.network
  ```

---

### `if that module contained a module named subnets, it would be represented by "module.network.module.subnets".`

Nested module explanation:

* Terraform modules can call other modules
* Addresses are chained using `module.<name>`

Example structure:

```
root
 └─ module.network
     └─ module.subnets
```

Address string:

```
module.network.module.subnets
```

---

### `## Common Functions Used`

This section would list helper functions if any were used.

---

### `None`

Meaning:

* This function does **not depend on other custom helper functions**
* It only uses Sentinel built-ins and `tfconfig/v2`

---

### `## What It Returns`

This section explains the output.

---

### `This function returns a single flat map of outputs indexed by the address of the module and the name of the output.`

Plain English:

* The function returns a **map (dictionary / key-value pairs)**
* The keys include:

  * The module address
  * The output name
* The map is **flat**, not nested

Example (conceptual):

```text
{
  "module.network.vpc_id": <output object>,
  "module.network.cidr": <output object>
}
```

---

### `The map is actually a filtered sub-collection of the tfconfig.outputs collection.`

Meaning:

* Terraform exposes **all outputs** via `tfconfig.outputs`
* This function:

  * Takes that full list
  * Filters it
  * Keeps only outputs belonging to the requested module

So it does **filtering**, not generation.

---

### `## What It Prints`

This section clarifies logging behavior.

---

### `This function does not print anything.`

Meaning:

* No `print()` calls
* No logs
* It silently returns data

---

### `## Examples`

This section shows how to call the function.

---

### `assuming that the tfconfig-functions.sentinel file that contains it has been imported with the alias config`

Meaning:

* Somewhere you have:

  ```sentinel
  import "tfconfig-functions.sentinel" as config
  ```

---

### `allRootModuleOutputs = config.find_outputs_in_module("")`

Explanation:

* Calls the function
* Passes an empty string → root module
* Stores all root module outputs in `allRootModuleOutputs`

---

### `allNetworkOutputs = config.find_outputs_in_module("module.network")`

Explanation:

* Looks only inside `module.network`
* Returns outputs defined **inside that module only**

---

## 2. Important clarification (very important)

⚠️ **This is NOT the function code itself**
This is **documentation describing the function**.

So I **cannot explain it line-by-line internally** (loops, filters, conditionals, etc.) because the **actual Sentinel code is missing**.

---

## 3. What to do next (recommended)

If you want a **true line-by-line explanation of how it works internally**, please paste the actual function code from:

```
tfconfig-functions.sentinel
```

It will look something like:

```sentinel
find_outputs_in_module = func(module_address) {
  ...
}
