---
title: Terraform Multiple Provider Blocks on Azure Cloud
description: Learn how to use multiple Terraform provider blocks on Azure Cloud
---

### Detailed Explanation: Multiple Provider Configurations in Terraform

Terraform allows you to define multiple configurations for the same provider to manage resources across different environments, regions, or configurations. This flexibility is crucial when managing complex infrastructures spread across multiple geographic locations or needing varied settings for different resources.

#### Step-01: Introduction

The primary focus is understanding and implementing multiple configurations for the same provider. This practice helps in deploying resources in different regions or with specific settings within the same infrastructure as the code project.

#### Step-02: Defining Multiple Provider Configurations

Terraform typically uses a default provider configuration. However, there are scenarios where you may need to specify distinct settings for different resources. To achieve this, Terraform allows you to create additional provider configurations with unique settings and identifiers (aliases).

1. **Default Provider Configuration**

   - This is the standard configuration that resources will use if no explicit provider is specified.
 
   Example:
   
       Provider-1 for East US (Default Provider)
   
     provider "azurerm" {

      features {}

     }
   

2. **Additional Provider Configuration with an Alias**

    - You can create another provider configuration with different settings and give it an alias. The alias helps to reference this specific configuration in resource definitions.
   
  Example:
   
     # Provider-2 for West US Region

    provider "azurerm" {
       features {
         virtual_machine {
           delete_os_disk_on_deletion = false
         }
       }
       alias = "provider2-westus"
       # client_id, client_secret, environment, and subscription_id can be optionally set here.
     }
     

#### Step-03: Referencing the Non-Default Provider in Resources

When a resource needs to use a specific provider configuration (non-default), you reference it with the provider attribute. The format used is <PROVIDER_NAME>.<ALIAS_NAME>.

**Example of Referencing a Non-Default Provider**
 
  Provider-2: Create a resource group in the West US region using the "provider2-westus" provider

   resource "azurerm_resource_group" "myrg2" 
   {
    name     = "myrg-2"
    location = "West US"
    provider = azurerm.provider2-westus
  }
  
In this example, azurerm.provider2-westus tells Terraform to use the provider configuration with the alias = "provider2-westus".

#### Step-04: Executing Terraform Commands

After setting up your configuration, you need to execute the following Terraform commands:

1. **Initialize Terraform**
   
   terraform init
   
   - This command initializes your working directory, downloads necessary plugins, and prepares the environment.

2. **Validate Terraform Configuration**
   
   terraform validate
   
   - This checks the syntax and logical consistency of the Terraform files.

3. **Generate a Plan**
   
   terraform plan
   
   - The plan command provides a preview of the actions Terraform will take when applying the configuration.

4. **Apply the Configuration**
   
   terraform apply -auto-approve
   
   - This command creates the resources as defined in the configuration files. The `-auto-approve` flag bypasses manual approval.

5. **Verification**

   - After applying, verify that the resources were created successfully:
   
     1. Check the resource group in the East US region (default provider).
     2. Check the resource group in the West US region (referenced provider).

#### Step-05: Clean-Up

To remove resources and clean up your working environment, run the following commands:

1. **Destroy Resources**
   
   terraform destroy -auto-approve
   
   - This removes all resources created by the configuration.

2. **Delete Terraform State Files and Directories**
   
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   
   - These commands delete Terraform's state files and cache, ensuring a clean start for future projects or configurations.

By defining multiple provider configurations, you can manage infrastructure efficiently across different regions and settings within the same code base. Aliases allow for easy reference, enabling more complex and customizable deployments.

## References

- [Provider Meta Argument](https://www.terraform.io/docs/configuration/meta-arguments/resource-provider.html)

- [Azure Provider - Argument and Attribute References](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
