# 1. Output Values - Resource Group

output "resource_group_id" 
{
  description = "Resource Group ID"
 # Attribute Reference
  value = azurerm_resource_group.myrg.id 
}
output "resource_group_name" 
{
  description = "Resource Group name"
  # Argument Reference
  value = azurerm_resource_group.myrg.name  
}

# 2. Output Values - Virtual Network

output "virtual_network_name" 
{
  description = "Virutal Network Name"
  value = azurerm_virtual_network.myvnet.name 
  #sensitive = true
}

# 3. Output Values - Virtual Machine

output "vm_public_ip_address" 
{
  description = "My Virtual Machine Public IP"
  value = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}

# 4. Output Values - Virtual Machine Admin User

output "vm_admin_user"
{
  description = "My Virtual Machine Admin User"
  value = azurerm_linux_virtual_machine.mylinuxvm.admin_username
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# Output Values — Resource Group

* output "resource_group_id" defines an output variable named resource_group_id.
* Description helps document what the output represents.
* The value is taken from the ID attribute of an Azure resource group named myrg defined somewhere else in your configuration, like:

    resource "azurerm_resource_group" "myrg" 
{
    name     = "my-resource-group"
    location = "East US"
  }
  
* azurerm_resource_group.myrg.id → This is a Terraform attribute reference that fetches the unique resource ID assigned by Azure (like /subscriptions/.../resourceGroups/my-resource-group).

output "resource_group_name" 
{
  description = "Resource Group name"
  # Argument Reference
  value = azurerm_resource_group.myrg.name  
}

# Explanation:

* Similar to the above, but this outputs the name of the resource group instead of the ID.
* .name is an argument reference — it was given by you when you defined the resource.

# Output Values — Virtual Network

* Outputs the name of the Virtual Network resource.
* azurerm_virtual_network.myvnet refers to the VNet resource block defined somewhere like:

    resource "azurerm_virtual_network" "myvnet"
{
    name                = "my-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.myrg.location
    resource_group_name = azurerm_resource_group.myrg.name
  }
  
* The optional sensitive = true flag (commented out here) would hide this value from appearing in terminal output — useful for secrets or credentials.

# Output Values — Virtual Machine Public IP

* Outputs the public IP address of your Linux virtual machine.
* The VM resource is likely defined as:

    resource "azurerm_linux_virtual_machine" "mylinuxvm"
{
    name                = "my-linux-vm"
    resource_group_name = azurerm_resource_group.myrg.name
    network_interface_ids = [azurerm_network_interface.myvmnic.id]
    admin_username      = "azureuser"
    ...
  }
  
* .public_ip_address is a computed attribute returned after Azure creates the VM.

# Output Values — Virtual Machine Admin User

* Outputs the administrator username of the Linux VM.
* It’s the value you defined under admin_username inside your VM resource.
* Example:

    admin_username = "azureuser"
  ```
* This can be useful for connecting to the VM later.

# Summary Table

|      Output Name       |    Description          |                    Value Source                              |             Purpose                |
| ---------------------- | ----------------------- | ------------------------------------------------------------ | ---------------------------------- |
|   resource_group_id    |   Resource Group ID     |   azurerm_resource_group.myrg.id                             |   Shows unique Azure ID of the RG  |
|   resource_group_name  |   Resource Group Name   |   azurerm_resource_group.myrg.name                           |   Displays RG name                 |
|   virtual_network_name |   Virtual Network Name  |   azurerm_virtual_network.myvnet.name                        |   Displays VNet name               |
|   vm_public_ip_address |   VM Public IP          |   azurerm_linux_virtual_machine.mylinuxvm.public_ip_address  |   Used for SSH/RDP                 |
|   vm_admin_user        |   VM Admin Username     |   azurerm_linux_virtual_machine.mylinuxvm.admin_username     |   Displays VM login username       |
 
# Terraform CLI Tip

After running terraform apply, you can see the outputs using: terraform output

Or view a specific one: terraform output vm_public_ip_address

# Example Folder Structure

terraform-project/
├── network/
│   ├── main.tf
│   ├── outputs.tf
│   ├── backend.tf
│   └── variables.tf
└── vm/
    ├── main.tf
    ├── backend.tf
    └── variables.tf

* network/ creates foundational infrastructure and exposes outputs.

* vm/ consumes those outputs using terraform_remote_state.

cd network/
terraform init
terraform apply

# Apply Order

* You must apply in this sequence:

cd network/

terraform init
terraform apply

cd ../vm/

terraform init
terraform apply

Terraform in vm/ will automatically read the outputs from the remote state in network/.
