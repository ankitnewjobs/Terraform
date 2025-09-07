# terraform import azurerm_resource_group.example /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example

# terraform import azurerm_resource_group.example /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP_NAME>

# terraform import azurerm_resource_group.myrg /subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourceGroups/myrg1

/*

# Resource Group

resource "azurerm_resource_group" "myrg" 
{
   name = "myrg1"
   location = "eastus"
   tags = {
     "Tag1" = "My-Tag-1"
   }
}

*/

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Terraform Import Commands Explained

- terraform import azurerm_resource_group.example /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example

- terraform import azurerm_resource_group.example /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP_NAME>

- terraform import azurerm_resource_group.myrg /subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourceGroups/myrg1

# These commands do the following:

- Terraform import is a command that allows Terraform to track resources created outside of Terraform by importing their current state.

- azurerm_resource_group.example is the Terraform resource address: the first part (azurerm_resource_group) is the resource type, and the second part (example or myrg) is the resource name as declared in the .tf configuration.

- /subscriptions/…/resourceGroups/… is the Azure Resource ID, a unique identifier for the actual Resource Group in Azure.

When this command is run, Terraform updates its state file to include this resource so future Terraform plans and applications recognize it as managed by Terraform.

## General Import Pattern

- The pattern: - terraform import azurerm_resource_group.<terraform_resource_name> /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP_NAME>
  
  - Is used to import any Azure Resource Group into the Terraform state file.

## Corresponding Terraform Resource Block

- resource "azurerm_resource_group" "myrg": - Declares a resource with type azurerm_resource_group and the name myrg.

- Attributes:

   - name: The Azure resource group name (myrg1).

   - location: The Azure region (eastus).

   - tags: Optional tags for resource classification or organization within Azure.

## How Import Works with the Resource Block

- The resource must be declared in the Terraform code (even if empty) with the same name (for example, "myrg") before executing terraform import.

- After import, the Terraform state will reflect the actual state of the imported resource.

- It is important to ensure the configuration matches the actual Azure resource’s properties after importing—otherwise, running terraform plan will show differences and may try to update the resource.

## Typical Workflow

1. Define the resource block in Terraform configuration (.tf file) with at least the resource type and name.

2. Run Terraform import using the correct Azure resource ID and corresponding Terraform resource address.

3. Optionally, update the .tf file to match the current state of the Azure resource (location, tags, etc.)

4. Run terraform plan to verify synchronization.

## Key Points

- Import is only for state: It doesn’t automatically generate .tf files—manual editing is still required for full configuration reproducibility.

- Resource IDs must be exact: The Azure Resource ID must match the real resource to prevent import errors.

- Resource name consistency: The symbolic resource name (e.g., myrg) must match between the .tf file and the import command.

- Use Case: Useful for adopting Terraform in an environment with pre-existing Azure resources without recreating them.
