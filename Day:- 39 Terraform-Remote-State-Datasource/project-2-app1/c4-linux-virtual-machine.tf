# Resource: Azure Linux Virtual Machine

resource "azurerm_linux_virtual_machine" "mylinuxvm" 
{
  name                = local.vm_name
  computer_name       = local.vm_name # Hostname of the VM
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  #resource_group_name = azurerm_resource_group.myrg.name
  #location            = azurerm_resource_group.myrg.location
  #network_interface_ids = [azurerm_network_interface.myvmnic.id]
  # Getting Data using Terraform Remote State Datasource from Project-1
  resource_group_name = data.terraform_remote_state.project1.outputs.resource_group_name
  location = data.terraform_remote_state.project1.outputs.resource_group_location
  network_interface_ids = [data.terraform_remote_state.project1.outputs.network_interface_id]
  admin_ssh_key 
{
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

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

Let's break down the Terraform code for provisioning an Azure Linux Virtual Machine (VM) using the azurerm_linux_virtual_machine resources.

###  High-Level Purpose

This block of code creates a Linux VM in Azure. 

Instead of hardcoding all values, it reuses some data from another Terraform project using the Terraform remote state data source.

## Code Breakdown

# Resource: Azure Linux Virtual Machine

resource "azurerm_linux_virtual_machine" "mylinuxvm" 
{

- Resource Type: azurerm_linux_virtual_machine is used to create a Linux VM on Azure.
- Resource Name: "mylinuxvm" is the name given to this Terraform resource (used for referencing it elsewhere).

### Basic Configuration

  name                = local.vm_name
  computer_name       = local.vm_name # Hostname of the VM
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"

- name: The name of the VM resource in Azure, pulled from a local variable local.vm_name.
- computer_name: The hostname seen within the OS. Usually matches the VM name.
- size: Specifies the VM size (CPU/RAM). Standard_DS1_v2 = 1 vCPU, 3.5 GB RAM.
- admin_username: Admin username used to log in (not password-based here).

###  Getting Info from Another Project (Terraform Remote State)

  # Getting Data using Terraform Remote State Datasource from Project-1

  resource_group_name = data.terraform_remote_state.project1.outputs.resource_group_name
  location            = data.terraform_remote_state.project1.outputs.resource_group_location
  network_interface_ids = [data.terraform_remote_state.project1.outputs.network_interface_id]

- This code uses the output from another Terraform state (project1) to reuse resources:

  - resource_group_name: Which RG to deploy in.
  - location: Azure region.
  - network_interface_ids: Associates an existing NIC (from Project-1) with this VM.

This prevents duplication of infrastructure and promotes modularity.

### Admin SSH Key

  admin_ssh_key 
{
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

- Sets up SSH-based authentication.
- public_key: Reads the SSH public key file for secure login.
- ${path.module} is the current module directory.

###  OS Disk Configuration

  os_disk 
{
    name                 = "osdisk${random_string.myrandom.id}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

- Defines the OS disk attached to the VM.
- Disk name includes a randomly generated string.
- Standard_LRS: Standard locally redundant storage.
- ReadWrite caching improves performance for read/write-heavy workloads.

### OS Image

  source_image_reference
{
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }

- Specifies the image used to provision the VM.
- Red Hat Enterprise Linux version 8.3, Gen2 image.
- Gets the latest patch version automatically.

### Custom Script (Cloud-Init)

  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")

- Sends a cloud-init script to the VM during provisioning.
- Used for bootstrapping: installing packages, running updates, etc.
- filebase64 encodes it (as Azure expects base64-encoded content).

### Tags

  tags = local.common_tags

- Applies tags to the resource, likely for cost management or organization.
- Pulled from a local variable (local.common_tags).

###  Commented-Out Lines

  #resource_group_name = azurerm_resource_group.myrg.name
  #location            = azurerm_resource_group.myrg.location
  #network_interface_ids = [azurerm_network_interface.myvmnic.id]

- These lines were probably used before remote state integration.
- Now replaced with values pulled from project1's remote state.

##  Summary

|    Component       |       Description                   |
|--------------------|-------------------------------------|
| VM Name & Hostname | Taken from local.vm_name            |
| Region & RG        | From remote state of Project-1      |
| NIC                | Uses pre-created NIC from Project-1 |
| OS                 | RedHat Enterprise Linux 8.3 Gen2    |
| Auth               | SSH key-based                       |
| Disk               | OS disk with ReadWrite caching      |
| Init Script        | Cloud-init via custom_data          |
| Tags               | Common tags from locals             |
