# Terraform Block

terraform
{
  required_version = ">= 1.0.0"
  required_providers 
{
    azurerm = 
{
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }  
    random = 
{
      source = "hashicorp/random"
      version = ">= 3.0"
    }           
  }

# Enable the below Backend block during Step-05

 /*
  backend "remote" 
{
    hostname      = "app.terraform.io"
    organization  = "hcta-azure-demo1"  # Organization should already exist in Terraform Cloud
    workspaces 
{
      name = "state-migration-demo1" 
      # Two cases: 
      # Case-1: If workspace already exists, should not have any state files in the states tab
      # Case-2: If the workspace does not exist, during migration, it will be created

    }
  }  
*/
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# 1. The Terraform block itself

terraform
{
  ...
}

* The terraform {} block is a global configuration for your Terraform project.

* Inside it, you define:

  * Which Terraform CLI version is required?
  * Which providers (Azure, AWS, random, etc.) and their versions you need.
  * Optional backend settings (where to store the state file).

# 2. required_version

  required_version = ">= 1.0.0"

* This says: “To run this code, Terraform CLI must be version 1.0.0 or higher.”
* If someone tries to run it with Terraform 0.14, for example, Terraform will abort and say the version is too old.

* Why this is useful:

  * Prevents breaking changes from older/newer Terraform versions.
  * Ensures the whole team is using a minimum compatible version.

Version constraint syntax:

* >= 1.0.0  → 1.0.0 or any later version
* ~> 1.5.0  → 1.5.x only
* = 1.6.2   → exactly 1.6.2

# 3. required_providers block

This tells Terraform:

1. Which providers does the configuration use?
2. Where to download them from.
3. Which versions of those providers are acceptable?

# Structure

* required_providers { ... } is a map whose keys are provider names (azurerm, random).
* For each provider key, you give:

  * source: the address of the provider in the Terraform Registry.
  * version: which versions of that provider are allowed.

# azurerm provider

   azurerm = 
{
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }  

* azurerm is the Azure Resource Manager provider.

* source = "hashicorp/azurerm": This tells Terraform to download the provider from the official HashiCorp namespace on the Terraform Registry.

* version = ">= 2.0":

  * Use provider version 2.0 or newer.
  * This avoids super-old versions (v1.x), but allows upgrades within 2.x and above.

> Note: In real projects, you often pin more tightly (e.g., ~> 2.99.0) to avoid surprises from breaking changes, but this example is being flexible for learning.

# random provider

    random = 
{
      source = "hashicorp/random"
      version = ">= 3.0"
    } 

* A random provider is used to generate random values (e.g., random strings, passwords, suffixes for resource names).

* source = "hashicorp/random": Official provider from HashiCorp.

* version = ">= 3.0": Need version 3.0 or newer.

Why define it here even if you haven’t used it yet?

* Terraform needs to know all providers it should download during terraform init.
* If later in your code you use resource "random_string" ..., Terraform already knows where to get that provider from.

# 4. Backend block (currently commented out)

# Enable the below Backend block during Step-05

 /*
  backend "remote" 
{
    hostname      = "app.terraform.io"
    organization  = "hcta-azure-demo1"  # Organization should already exist in Terraform Cloud
    workspaces 
{
      name = "state-migration-demo1" 

      # Two cases: 
      # Case-1: If workspace already exists, should not have any state files in the states tab
      # Case-2: If the workspace does not exist, during migration, it will be created

    }
  }  
*/

First, notice:

* The whole backend block is inside /* ... */, which is a multi-line comment in HCL.
* That’s why it’s currently inactive.
* The comment above says: “Enable the below Backend block during Step-05” – so probably earlier steps use the local backend, and in Step-05 you switch to this remote backend.

# What is a backend?

* A backend controls where Terraform stores its state file (terraform.tfstate).
* By default, Terraform uses the local backend (keeps state on your local disk).
* With a remote backend, the state is kept in some remote storage (S3, Azure Storage, Terraform Cloud, etc.).

* Remote state is important for:

  * Team collaboration.
  * Locking (to prevent two people running terraform apply at the same time on the same state).
  * Backups and persistence.

# backend "remote" – Terraform Cloud

  backend "remote" 
{
    hostname      = "app.terraform.io"
    organization  = "hcta-azure-demo1"
    workspaces 
{
      name = "state-migration-demo1"
    }
  }  

* backend "remote":

  * This is the backend type that integrates with Terraform Cloud / Terraform Enterprise.
  * hostname = "app.terraform.io": This is the hostname for Terraform Cloud (SaaS offering by HashiCorp).

* organization = "hcta-azure-demo1":

  * Name of your Terraform Cloud organization.
  * That org must already exist in your Terraform Cloud account.

# Workspaces block

    workspaces 
{
      name = "state-migration-demo1" 

      # Two cases: 
      # Case-1: If workspace already exists, should not have any state files in the states tab
      # Case-2: If the workspace does not exist, during migration, it will be created
    }

* workspaces { name = "state-migration-demo1" }: Tells Terraform to use a specific workspace in Terraform Cloud called state-migration-demo1.

* A Terraform Cloud workspace is like a separate “environment” that holds:

  * Its own state file.
  * Variables, run history, etc.

The comments explain migration behaviour:

1. Case-1: Workspace already exists

   * Workspace state-migration-demo1 is already created in Terraform Cloud.
   * But it should not have any state files yet.
   * This is important because when you migrate state from local → remote, Terraform will upload your existing local terraform.tfstate into this workspace.
   * If the state already exists there, it can cause conflicts.

2. Case-2: Workspace does not exist

   * If state-migration-demo1 does not exist yet:

     * During terraform init with -migrate-state (or when configuring backend), Terraform Cloud can create the workspace for you.

   * Then it will upload your existing state into that newly created workspace.

# Why is the backend commented out initially?

Typical workflow in tutorials/labs:

1. Start with local backend (no backend block):

   * Terraform stores state locally for simplicity.
   * You create some resources (e.g., Azure resources).

2. Later, enable remote backend (uncomment this block in Step-05):

   * You run terraform init again.
   * Terraform detects backend change (local → remote).
   * It offers to migrate your state to Terraform Cloud.

   * After migration:

     * Your state is now in Terraform Cloud.
     * All plan/apply uses the remote state.

This is exactly what the “state migration demo” naming hints at.

# 5. Putting it all together: This block configures:

* Terraform CLI requirements: Use Terraform version 1.0.0 or higher.

* Providers:

  * azurerm provider from "hashicorp/azurerm", version 2.0+.
  * random provider from "hashicorp/random", version 3.0+.

* Backend (commented, for later migration):

  * Switch state storage to Terraform Cloud at app.terraform.io.
  * Use organization hcta-azure-demo1.
  * Use workspace state-migration-demo1 to store the state file once migration is done.
