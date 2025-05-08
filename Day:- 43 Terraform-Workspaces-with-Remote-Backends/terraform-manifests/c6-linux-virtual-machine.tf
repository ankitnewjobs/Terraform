# Resource: Azure Linux Virtual Machine

resource "azurerm_linux_virtual_machine" "mylinuxvm" 
{
  name                = local.vm_name
  computer_name       = local.vm_name # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.myvmnic.id
  ]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk
{
    name = "osdisk${random_string.myrandom.id}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference 
{
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
  tags = local.common_tags
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 


This block creates a Linux Virtual Machine in Azure, specifically using the Red Hat Enterprise Linux 8.3 (Gen2) image.

It: - 

* Uses a custom hostname and public SSH key for access
* Attaches a NIC
* Boots with a cloud-init script
* Tags the resource appropriately

##  Full Explanation

resource "azurerm_linux_virtual_machine" "mylinuxvm" 

* This declares a Linux VM resource.
* "mylinuxvm" is the Terraform local name used for referencing the VM elsewhere.

###  General VM Settings

  name          = local.vm_name
  computer_name = local.vm_name

* name: The Azure resource name for the VM.
* computer_name: The internal hostname of the VM. Often the same as the VM name.

  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location

* These define the resource group and region in which the VM is deployed.

  size = "Standard_DS1_v2"

* This sets the VM SKU (size). Here, it uses Standard_DS1_v2, which has:

  * 1 vCPU
  * 3.5 GB RAM
  * Suitable for dev/test or low-load workloads.

### User and Authentication

  admin_username = "azureuser" (  Username for the default login to the VM. )

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

* SSH key-based login is used instead of a password.
* public_key: Reads an existing public SSH key from the local module path.

Best Practice: Never use passwords for production VMs — always prefer SSH keys.

### Networking

  network_interface_ids = 
[
    azurerm_network_interface.myvmnic.id
  ]

* Connects the VM to an existing Azure Network Interface (NIC) for network access.
* The NIC itself should be associated with a subnet and possibly a public IP.

### OS Disk Settings

  os_disk
{
    name                 = "osdisk${random_string.myrandom.id}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

* Defines the operating system disk for the VM.
* name: Uniquely named using a random string.
* Standard_LRS: Standard locally redundant storage (cheaper, widely used).

### Operating System Image

  source_image_reference 
{
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }

* This specifies the image used to create the VM.
* RHEL 8.3, Gen2 VM format.
* latest: Ensures VM gets the newest available version of the OS image.

### Cloud-init Script

  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")

* Injects cloud-init data (used during first boot to install software, update OS, configure services, etc.).
* filebase64(): Required because Azure expects this data in base64 format.

# Example Use: Automatically install Apache, configure users, or set up monitoring agents.

### Tags

  tags = local.common_tags

* Applies common tags (like env, owner, cost_center) for tracking and governance.

## Summary

|     Component          |       Description                     |
| ------------------------| ------------------------------------- |
|  admin_username         |  Login user                            |
|  admin_ssh_key          |  Public key-based authentication       |
|  os_disk                |  Defines OS disk storage & caching     |
|  source_image_reference |  OS image (RHEL 8.3)                   |
|  network_interface_ids  |  Attaches NIC (with subnet, public IP) |
|  custom_data            |  Runs cloud-init during first boot     |
|  tags                   |  Helps with billing, visibility        |
