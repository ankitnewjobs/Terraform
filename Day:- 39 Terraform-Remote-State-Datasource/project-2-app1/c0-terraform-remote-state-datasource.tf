# Terraform Remote State Datasource

data "terraform_remote_state" "project1" {
  backend = "azurerm"
  config = {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "network-terraform.tfstate"
  }
}

/* 

1. Resource Group Name
data.terraform_remote_state.project1.outputs.resource_group_name

2. Resource Group Location
data.terraform_remote_state.project1.outputs.resource_group_location

3. Network Interface ID
data.terraform_remote_state.project1.outputs.network_interface_id
*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code snippet is using the terraform_remote_state data source to retrieve the state of a previously applied Terraform configuration.

## **Understanding the terraform_remote_state Data Source

### What is terraform_remote_state?

- Terraform manages infrastructure using a state file that keeps track of resources it has created.
- The terraform_remote_state data source allows one Terraform configuration to access the outputs of another configuration stored remotely.
- In this case, the remote state is stored in an Azure Storage Account.

## Breaking Down the Code

### 1. Declaring the terraform_remote_state Data Source

data "terraform_remote_state" "project1" 
{
  backend = "azurerm"
  config = {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "network-terraform.tfstate"
  }
}

### Explanation of Each Parameter

|              Parameter                       |                                       Description                                                                                          
|----------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| backend = "azurerm"                          | Specifies that the remote state is stored in Azure Blob Storage (AzureRM backend).                                                   |
| resource_group_name = "terraform-storage-rg" | The name of the Azure Resource Group that contains the storage account.                                                              |
| storage_account_name = "terraformstate201"   | The Azure Storage Account Name where the Terraform state is stored.                                                                  |
| container_name = "tfstatefiles"              | The container name inside the storage account where state files are kept.                                                            |
| key = "network-terraform.tfstate"            | The file name of the Terraform state for the network module. This key is used to locate the state file within the storage container. |

### 2. Accessing Outputs from the Remote State

The code snippet also includes examples of retrieving specific output values from the remote Terraform state:

data.terraform_remote_state.project1.outputs.resource_group_name

- Retrieves the name of the resource group from the outputs section of the remote Terraform state.

data.terraform_remote_state.project1.outputs.resource_group_location

- Retrieves the location (Azure region) of the resource group from the remote state.

data.terraform_remote_state.project1.outputs.network_interface_id

- Retrieves the network interface ID from the remote state.

## Why Use terraform_remote_state?

- Reusability: It allows multiple Terraform configurations to share infrastructure data.
- Avoids Duplication: Resources defined in one module can be accessed in another module without re-declaring them.
- Enables Modular Infrastructure: Large infrastructures can be split into separate modules, and dependencies can be linked using remote state.

## Example Use Case

Imagine you have two Terraform projects:

1. Project 1 (Networking Module)

   - Deploys a Virtual Network, Subnets, and Network Interfaces.
   - Stores its Terraform state in Azure Storage.

2. Project 2 (Compute Module)

   - Needs to create Virtual Machines but requires the Network Interface ID from Project 1.
