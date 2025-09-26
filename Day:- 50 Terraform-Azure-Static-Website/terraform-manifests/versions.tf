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
    random = 
{
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

#### 1. terraform { ... }

This block configures settings that apply to Terraform itself. It tells Terraform:

* What version of Terraform CLI do you need?
* What providers will you use and where will you fetch them from?

#### 2. required_version = ">= 1.0.0"

* This sets a minimum Terraform version that is allowed to run this configuration.

* In this case:

  * Any Terraform version 1.0.0 or higher can be used.
  * If you try running it with version 0.14, Terraform will throw an error.
  * This ensures your code won’t break on older Terraform versions.

#### 3. required_providers { ... }

This section defines the providers Terraform needs.
A provider is a plugin that Terraform uses to interact with an API (like Azure, AWS, Kubernetes, GitHub, etc.).

Inside, we define each provider we’ll use:

* Source → where to download the provider plugin from.
* Version → which version of the provider to use.

#### 4. azurerm provider

* azurerm → This is the Azure Resource Manager provider, used to create/manage resources in Microsoft Azure.
* source = "hashicorp/azurerm" → The provider comes from HashiCorp’s official registry (Terraform Registry).
* version = ">= 2.0" → This means:

  * Use version 2.0 or higher of the AzureRM provider.
  * For example, 2.50.0, 3.0.0 etc. are valid.
  * If the installed version is below 2.0.0, Terraform will refuse to run.

#### 5. random provider

* random → This provider is used to generate random values like strings, numbers, or UUIDs.
  * Example: a random password, a unique resource name, etc.

* source = "hashicorp/random" → Download from HashiCorp’s registry.
* version = ">= 3.0" → Must use version **3.0 or newer.

