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
      #version = "~> 2.0"             
      #version = ">= 2.0.0, < 2.60.0"
      #version = ">= 2.0.0, <= 2.64.0"   
      #version = "~> 2.64" # For Production grade              
    }
  }
}
# Provider Block
provider "azurerm" 
{
features {}
}


/*

Play with Terraform CLI Version (We installed the 1.0.0 version)
  required_version = "~> 0.14.3" - Will fail
  required_version = "~> 0.14"   - Will fail  
  required_version = "= 0.14.4"  - Will fail
  required_version = ">= 0.13"   - will pass
  required_version = "= 1.0.0"   - will pass
  required_version = "1.0.0"     - will pass 
  required_version = ">= 1.0.0"   - will pass     


Play with Provider Version (as of today latest version is 2.64.0)

      version = "~> 2.0"             
      version = ">= 2.0.0, < 2.60.0"
      version = ">= 2.0.0, <= 2.64.0"     
*/

-----------------------------------------------------------------------------------------------------------------------

## Explanation 

This Terraform code snippet defines the necessary configuration for specifying the required Terraform version and the `azurerm` provider, which is used to interact with Azure resources. Let's go through each part in detail:

### 1. Terraform Block

terraform 
{
  required_version = ">= 1.0.0"
  required_providers 
{
    azurerm = 
{
      source = "hashicorp/azurerm"
      version = ">= 2.0"
      #version = "~> 2.0"             
      #version = ">= 2.0.0, < 2.60.0"
      #version = ">= 2.0.0, <= 2.64.0"   
      #version = "~> 2.64" # For Production grade              
    }
  }
}


#### Key Components:

- required_version = ">= 1.0.0":

- This line specifies that the Terraform configuration requires Terraform CLI version 1.0.0 or newer. If the Terraform CLI version running this configuration is older than 1.0.0, Terraform will exit with an error.
  
- This is useful for ensuring compatibility with the features and syntax used in this configuration file.

- required_providers:

  - Specifies the providers needed for this configuration, along with their version constraints. Here, the only required provider is `azurerm`, which is used to manage Azure resources.
 
- Provider Source (source = "hashicorp/azurerm"):
  
- Defines where Terraform will retrieve the provider plugin. "hashicorp/azurerm" indicates that this provider is hosted on the Terraform Registry by HashiCorp.
  
- Provider Version:

- version = ">= 2.0"`**: Requires azurerm version 2.0 or newer.
   
- The commented lines provide alternative version constraints for different scenarios:
      
- version = "~> 2.0": Allows any version in the 2. x series, such as 2.0, 2.1, and so on, but not 3.0 or higher.

- version = ">= 2.0.0, < 2.60.0": Allows versions from 2.0.0 up to but not including 2.60.0.
     
- version = ">= 2.0.0, <= 2.64.0": Allows versions from 2.0.0 up to and including 2.64.0.
    
- version = "~> 2.64": Restricts the provider to versions in the 2.64.x series, which is suitable for production as it limits updates to patch versions only, reducing the risk of breaking changes.

### 2. Provider Block

provider "azurerm"
{
  features {}
}


- Provider Block: Configures the azurerm provider.
  
- features` Block: This block is required by the azurerm provider, even if it is empty. It enables various features specific to the Azure provider but doesn’t require any configurations in this case. The features block will initialize the provider with default settings.

### 3. Comments for Version Testing

/*

Play with Terraform CLI Version (We installed the 1.0.0 version)
  required_version = "~> 0.14.3" - Will fail
  required_version = "~> 0.14"   - Will fail  
  required_version = "= 0.14.4"  - Will fail
  required_version = ">= 0.13"   - will pass
  required_version = "= 1.0.0"   - will pass
  required_version = "1.0.0"     - will pass 
  required_version = ">= 1.0.0"  - will pass     

These comments provide a testing guide for required_version by showing how different constraints interact with a locally installed Terraform CLI version (1.0.0):
  
- Versions Below 1.0.0: Constraints like ~> 0.14.3, ~> 0.14, and = 0.14.4 will fail because they are older than 1.0.0.
  
- Versions Equal or Greater than 1.0.0: Constraints like = 1.0.0, 1.0.0, and >= 1.0.0 will pass because they match or exceed 1.0.0.


Play with Provider Version (as of today latest version is 2.64.0)

      version = ~> 2.0"             
      version = >= 2.0.0, < 2.60.0"
      version = >= 2.0.0, <= 2.64.0"     
/


These comments explain version constraints for the azurerm provider, assuming the latest version available is 2.64.0:
 
- version = "~> 2.0": Accepts any 2.x version, such as 2.1, 2.5, etc., up to but not including 3.0.
  
- version = ">= 2.0.0, < 2.60.0": Allows versions from 2.0.0 to just below 2.60.0.
  
- version = ">= 2.0.0, <= 2.64.0": Accepts all versions from 2.0.0 up to 2.64.0 inclusively.

### Summary

This configuration ensures:

- A specific minimum version of Terraform CLI (1.0.0 or newer).

- Specific constraints for the azurerm provider, allowing the flexibility to specify production-grade versions.

- Testing options to understand how different version constraints behave when specified in the configuration.

This setup provides a robust starting point for managing Azure resources with Terraform while ensuring compatibility across Terraform and provider versions.
