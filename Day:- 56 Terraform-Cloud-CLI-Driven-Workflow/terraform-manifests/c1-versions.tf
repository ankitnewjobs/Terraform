# Terraform Block

terraform
{
  required_version = ">= 1.0.0"
  required_providers 
{
    azurerm =
{
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }

  # Update Terraform Cloud Backend Block Information below

  backend "remote"
{
    organization = "hcta-azure-demo1"
    workspaces
{
      name = "cli-driven-azure-demo"
    }

    #hostname = "value"  # defaults to app.terraform.io, but for Enterprise customers, it is going to be where you hosted TF Cloud-related binary
    #token = "value" # Hard Code TF Cloud Token - Not recommended use from TF CLI only 
  }
}

# Provider Block

provider "azurerm"
{
  features {}
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# 1. terraform { ... } block – global settings

terraform
{
  required_version = ">= 1.0.0"

* terraform {} block: Configures Terraform itself (not cloud resources).

* required_version:

  * Ensures you only run this code with Terraform version 1.0.0 or higher.
  * If someone runs Terraform init with 0.14 or 0.12, Terraform will stop with an error instead of doing something unexpected.

# 2. required_providers – which providers and versions to use

  required_providers 
{
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }

* required_providers tells Terraform:

  * Which providers does this configuration use?
  * Where to download them from.
  * Which version range is allowed?

Here:

* azurerm is the local name of the provider you use elsewhere in the code (e.g., provider "azurerm" {} or resource "azurerm_resource_group" ...).
* source  = "hashicorp/azurerm":

  * This tells Terraform Registry location: namespace hashicorp, provider azurerm.
  * Terraform will download it from the public Terraform Registry.
  * version = ">= 2.0":

  * Any azurerm version 2.0 or higher is allowed (2.x, 3.x, etc., depending on constraints).
  * Version constraints help avoid breaking changes when providers update.

# 3. backend "remote" – storing state in Terraform Cloud

  backend "remote"
{
    organization = "hcta-azure-demo1"
    workspaces
{
      name = "cli-driven-azure-demo"
    }

    # hostname = "value"
    # token = "value"
  }
}

The backend defines where Terraform stores the state file (terraform.tfstate) and how it performs operations.

# backend "remote":

* This uses Terraform Cloud/Enterprise as the backend (remote state).
* Instead of storing state locally on your machine, Terraform keeps it in Terraform Cloud.

Fields:

* organization = "hcta-azure-demo1"

  * This is the Terraform Cloud organization under your account.

  * workspaces { name = "cli-driven-azure-demo" }

  * Inside that organization, Terraform will use the workspace called cli-driven-azure-demo.

  * That workspace will hold:

    * State file
    * Runs/history
    * Variables, etc. (depending on how you use it)

* hostname (commented)

    # hostname = "value"
  
  * Defaults to app.terraform.io (Terraform Cloud SaaS).
  * For Terraform Enterprise (self-hosted), you’d set it to your own hostname.

* token (commented)

    #token = "value"
  
  * This would be your Terraform Cloud API token.
  * Hard-coding it in the file is not recommended.
  * Better: login via terraform login or use environment variables/credentials file.

So overall: this block wires your local Terraform CLI to a Terraform Cloud workspace, where state and possibly runs are managed.

# 4. provider "azurerm" { ... } – how to connect to Azure

# Provider Block

provider "azurerm" 
{
  features {}
}

* provider "azurerm":

  * This tells Terraform how to talk to Azure.
  * The name must match the name you used in required_providers (azurerm).

* features {}:

  * This block is required by the Azurerm provider.
  * It’s used to enable/disable certain behavior or sub-features.
  * Leaving it empty uses defaults, which is common in simple setups.

Authentication details (like subscription ID, tenant ID, client ID, client secret, etc.) are usually not in this block. Instead, they come from:

* Environment variables (e.g., ARM_CLIENT_ID, ARM_TENANT_ID, etc.), or
* Azure CLI login (az login), or
* Managed Identity, depending on the provider config and environment.

# 5. How does this all work together during terraform init

When you run terraform init:

1. Terraform checks:

   * Is the CLI version >= 1.0.0?

2. It downloads: The azurerm provider from hashicorp/azurerm with version >= 2.0.

3. It configures the backend:

   * Connects to Terraform Cloud
   * Uses org hcta-azure-demo1
   * Uses workspace cli-driven-azure-demo

4. Then, with provider "azurerm" { features {} }, it’s ready to talk to Azure and create/manage resources.
