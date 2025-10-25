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
}

# Provider Block

provider "azurerm"
{
 features {}          
}

# Random String Resource

resource "random_string" "myrandom"
{
  length = 6
  upper = false 
  special = false
  number = false   
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# Terraform Block

# Purpose: This block defines Terraform settings, such as:

* Which Terraform version to use
* Which providers does your code depend on
* where those providers should be downloaded from

Think of this block as Terraform’s “project configuration”.

terraform
{
required_version = ">= 1.0.0"

- This enforces that Terraform CLI version 1.0.0 or higher must be used to run this configuration.

- If someone tries to run it with an older Terraform version (e.g., 0.14), it will throw an error.
  
* Why this is important: Different Terraform versions may change syntax or provider behavior. Locking a version ensures consistency across team members and environments.

required_providers 
{
  azurerm = 
{
    source  = "hashicorp/azurerm"
    version = ">= 2.0"
  }
}

* This tells Terraform: I need the AzureRM provider, published by HashiCorp, and it must be version 2.0 or later.

* Provider = plugin that knows how to talk to a specific platform, like Azure, AWS, or GCP.

* The source "hashicorp/azurerm" tells Terraform where to download it from, the official Terraform Registry (registry.terraform.io/hashicorp/azurerm).

* The version constraint ensures consistent API behavior.

If you don’t lock the provider version, future updates may break your configuration due to backward-incompatible changes.

random = 
{
source  = "hashicorp/random"
version = ">= 3.0"
}

- Similarly, this defines the random provider, another HashiCorp-maintained plugin.

- It’s used to generate random strings, IDs, passwords, etc.

- In this file, you use it to create a random string later.

# In summary: The Terraform block configures Terraform’s dependencies and versioning, like your project’s “manifest” or “requirements.txt”.

# Provider Block

provider "azurerm"
{
  features {}
}

# Purpose: This tells Terraform which provider to use and how to configure it.

Here, the provider is azurerm → the Azure Resource Manager provider, which allows Terraform to create and manage Azure resources (like VMs, networks, etc.).

# Explanation of Attributes:

* provider "azurerm" → Declares that all Azure resources in this configuration will use this provider.

* features {} → A required block (even if empty) to initialize the provider.

# Why it’s required: AzureRM provider expects a features block, even if you don’t enable any specific features, to explicitly initialize the provider.

# Behind the scenes:

When you run terraform init, Terraform:

* Downloads the AzureRM provider plugin.

* Configures it using credentials from environment variables or your Azure CLI (az login).

* Prepares to communicate with Azure’s REST APIs to create resources.

# Random String Resource

resource "random_string" "myrandom" 
{
  length  = 6
  upper   = false 
  special = false
  number  = false   
}

# Purpose:

This creates a random 6-character lowercase string that can be used anywhere in your Terraform configuration, for example:

* generating unique resource names (Azure requires globally unique names for some services)

* randomizing suffixes

* simulating environment IDs

#  Line-by-Line Explanation

* resource "random_string" "myrandom"

  * resource → keyword that defines a piece of infrastructure (in this case, a random string).
  
  * "random_string" → resource type (from the random provider).
  
  * "myrandom" → logical name for referencing this resource in other places, like ${random_string.myrandom.result}.

* length = 6 → The generated string will be exactly 6 characters long.

* upper = false → No uppercase letters (only lowercase).

* special = false → No special characters (like @, #, $).

* number = false → No numbers (only alphabetic characters).

So, this will generate a lowercase 6-letter string, e.g.: "qkjhfs"

# Output Access

If you define an output:

output "random_value"
{
  value = random_string.myrandom.result
}

Then running terraform apply might show: random_value = "jqmpxa"

You can then use that string dynamically in resource names:

resource "azurerm_resource_group" "example" 
{
  name     = "rg-${random_string.myrandom.result}"
  location = "East US"
}

→ Creates a Resource Group like: rg-jqmpxa

Let’s summarize what happens when you run this configuration:

|     Command       |                                                    What Happens                                                       |
| ----------------- | --------------------------------------------------------------------------------------------------------------------- |
|   terraform init  |   Initializes Terraform, downloads the azurerm and random providers.                                                  |
|   terraform plan  |   Compares the desired state (code) with the actual Azure state, shows that a random string needs to be created.      |
|   terraform apply |   Executes the plan → creates the random string resource → stores it in the Terraform state file (terraform.tfstate). |

