# Resource-1: Azure Resource Group

resource "azurerm_resource_group" "myrg"
{
  name = "myrg1"
  location = "eastus"
  tags = 
{
    "tag1" = "my-tag-1"
    "tag2" = "my-tag-2"
    "tag3" = "my-tag-3"
  }
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

#### resource "azurerm_resource_group" "myrg"

- This line defines a Terraform resource block.
- azurerm_resource_group is the resource type, which comes from the AzureRM provider. It is used to create Azure Resource Groups.
- "myrg" is the local name or label for this resource within your Terraform configuration. You use this label to reference the resource elsewhere in your code.

#### name = "myrg1"

- Specifies the actual name of the Resource Group that will be created in Azure.
- In this case, the Resource Group will be named myrg1.

#### location = "eastus"

- Defines the Azure region where the resource group will be created.
- eastus is a region in the US East data center of Azure.

#### tags = { ... }

- Tags are key-value pairs used for resource categorization, cost tracking, and management.
- They are optional, but a good practice for governance.
- In this case, the resource group is being tagged with:
  - "tag1" = "my-tag-1"
  - "tag2" = "my-tag-2"
  - "tag3" = "my-tag-3"

### Example Output

When you apply this Terraform configuration using terraform apply, Azure will create:
- A Resource Group named myrg1
- In the eastus region
- With three custom tags attached

###  Why Is This Useful?

Resource groups in Azure:
- Serve as containers for managing multiple resources (VMs, databases, storage, etc.)
- Help organize resources by lifecycle and permissions
- Allow you to apply role-based access control (RBAC) and policies
