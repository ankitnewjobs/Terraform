# Resource: Azure Linux Virtual Machine

resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  name                = local.vm_name
  computer_name       = local.vm_name # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [ azurerm_network_interface.myvmnic.id ]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk${random_string.myrandom.id}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
  tags = local.common_tags
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code provisions an Azure Linux Virtual Machine (azurerm_linux_virtual_machine) using Infrastructure as Code (IaC).

## 1. Defining an Azure Linux Virtual Machine

### Resource Block: azurerm_linux_virtual_machine

Terraform uses this resource to define and configure a Linux-based virtual machine in Azure.

resource "azurerm_linux_virtual_machine" "mylinuxvm" 

- The resource type is azurerm_linux_virtual_machine, which means the VM will run a Linux operating system.
- The resource name is mylinuxvm, a unique identifier within the Terraform configuration.

## 2. Basic Configuration

These properties define the basic identity and placement of the VM.

  name                = local.vm_name
  computer_name       = local.vm_name # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location

- name: The logical name of the VM in Azure, stored in the local.vm_name variable.
- computer_name: The hostname of the VM (how it appears inside the OS). It matches vm_name.
- resource_group_name: The VM is created in the specified Azure resource group (myrg).
- location: Ensures deployment in the same Azure region as the resource group.

## 3. VM Size Selection

  size = "Standard_DS1_v2"

- Defines the VM size or SKU.

- "Standard_DS1_v2" offers 1 vCPU, 3.5GB RAM, and supports Premium SSD.

## 4. Network Configuration

  network_interface_ids = [ azurerm_network_interface.myvmnic.id ]

- Associates the VM with a network interface card (NIC).
- The NIC (myvmnic) allows the VM to communicate over the Azure Virtual Network (VNet).
- The public IP address (from NIC) enables external access.

## 5. Admin Credentials & SSH Key Authentication

  admin_username = "azureuser"

- Defines the Linux user (azureuser) for SSH login.

  admin_ssh_key
{
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

- admin_ssh_key: Sets up SSH key-based authentication (recommended for security).
- public_key: Loads an existing SSH public key from the file terraform-azure.pub.
- file("${path.module}/ssh-keys/terraform-azure.pub"): Reads the SSH key stored in the Terraform module directory.

> Security Best Practice: Using SSH keys eliminates the need for password-based authentication, reducing security risks.

## 6. OS Disk Configuration

  os_disk 
{
    name = "osdisk${random_string.myrandom.id}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

- name: The OS disk is dynamically named (osdisk + random ID) to ensure uniqueness.
- caching = "ReadWrite": Optimizes performance for read/write operations.
- storage_account_type = "Standard_LRS":
  - Uses Standard HDD (LRS) for cost-efficiency.
  - If better performance is needed, Premium_LRS (SSD) is preferred.

## 7. OS Image Selection

  source_image_reference 
{
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }

- Specifies the OS image for the VM.
- publisher = "RedHat" → The VM uses Red Hat Enterprise Linux (RHEL).
- offer = "RHEL" → The selected OS is RHEL.
- sku = "83-gen2" → Specifies RHEL 8.3 (Generation 2).
- version = "latest" → Always provisions the latest available version.

## 8. Cloud-Init for Bootstrapping

  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")

- Uses Cloud-Init to run scripts at first boot.

- custom_data:
  - Loads a startup script from app1-cloud-init.txt.
  - Encode the script in Base64 for Azure compatibility.

> Example Use Case: Installing dependencies, configuring users, setting up Docker, or deploying applications automatically on the first startup.

## 9. Tagging for Resource Management

  tags = local.common_tags

- Assign metadata tags to help with organization and cost tracking.
- local.common_tags: Likely contains standard labels like environment, owner, etc.

## Summary

| Feature        |             Description                        |
|----------------|------------------------------------------------|
| Compute        | Uses a "Standard_DS1_v2" VM size.              |
| Network        | Connects to a NIC (myvmnic).                   |
| Authentication | Uses an SSH key (no passwords).                |
| OS Disk        | Uses Standard LRS HDD storage.                 |
| OS Image       | Deploys RHEL 8.3 (Gen 2).                      |
| Cloud-Init     | Executes custom scripts on startup.            |
| Tagging        | Uses local.common_tags for resource management.|
