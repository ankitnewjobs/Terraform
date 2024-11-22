# Resource: Azure Linux Virtual Machine

resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  count = 2
  name                = "mylinuxvm-${count.index}"
  computer_name       = "devlinux-${count.index}" # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [ element(azurerm_network_interface.myvmnic[*].id, count.index)]  
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk${count.index}"
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
}

------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

This Terraform code provisions two Azure Linux Virtual Machines (VMs) using the `azurerm_linux_virtual_machine` resource. Below is a detailed explanation of each component in the resource definition:

### Resource Block

resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  count = 2
  
}

- Purpose: Creates two identical Linux VMs.
- count: Specifies that two VMs should be created (indexed as `0 and 1).

### Attributes

#### VM Naming and Hostname

name          = "mylinuxvm-${count.index}"
computer_name = "devlinux-${count.index}"

- name: Unique name for each VM using count.index (e.g., mylinuxvm-0 and mylinuxvm-1).
- computer_name: Hostname of the VM in the OS, dynamically set (e.g., devlinux-0 and devlinux-1).

#### Resource Group and Location

resource_group_name = azurerm_resource_group.myrg.name
location            = azurerm_resource_group.myrg.location

- resource_group_name: Associates the VMs with the existing resource group (myrg).
- location: Specifies the Azure region, derived from the resource group.

#### VM Size

size = "Standard_DS1_v2"

- Purpose: Specifies the size of the VM (vCPU, memory, disk performance).

- Standard_DS1_v2: A general-purpose VM size with:
  - 1 vCPU
  - 3.5 GiB memory
  - Suitable for development and testing.

#### Administrator Credentials

admin_username = "azureuser"

- Purpose: Sets the admin username for accessing the VM.
- Value: The username is set to Azureuser.

#### Network Interface

network_interface_ids = [element(azurerm_network_interface.myvmnic[*].id, count.index)]

- Purpose: Attaches a network interface to each VM.

- Key Details:

  - Uses the element() function to assign the appropriate NIC to each VM.
  - azurerm_network_interface.myvmnic[*].id: References the list of NICs created earlier.
  - count.index ensures that VM 0 gets NIC 0, and VM 1 gets NIC 1.

#### SSH Key Authentication

admin_ssh_key {
  username   = "azureuser"
  public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
}

- Purpose: Configures SSH key-based authentication for the VM.

- Key Details:

  - username: Matches the admin username.
  - public_key: Path to the public SSH key file (terraform-azure.pub) stored locally.

### Disk Configuration

os_disk {
  name = "osdisk${count.index}"
  caching              = "ReadWrite"
  storage_account_type = "Standard_LRS"
}

- Purpose: Configures the VM's operating system disk.

- Key Attributes:

  - name: Unique name for each disk, e.g., osdisk0 and osdisk1.
  - caching: Set to ReadWrite for improved read and write operations performance.
  - storage_account_type: The disk type is Standard_LRS (Locally Redundant Storage), which is cost-effective and reliable.

### Operating System

source_image_reference {
  publisher = "RedHat"
  offer     = "RHEL"
  sku       = "83-gen2"
  version   = "latest"
}

- Purpose: Specifies the operating system image for the VM.

- Key Details:

  - publisher: The OS publisher, here RedHat.
  - offer: The specific product offering, here RHEL (Red Hat Enterprise Linux).
  - sku: Stock Keeping Unit, representing a specific version of RHEL (83-gen2).
  - version: Uses the latest version available in Azure Marketplace.

### Custom Data (Cloud-Init Script)

custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")

- Purpose: Provides a cloud-init script to initialize the VM on boot.

- Key Details:

  - filebase64: Encodes the script file (app1-cloud-init.txt) into base64 format.
  - Usage: Commonly used to install software, configure the VM, or run setup commands.

### Infrastructure Overview

This configuration creates two Linux VMs with the following properties:

- Networking:
  - Each VM has a unique NIC linked to a public IP and a private IP (from the subnet).

- Disk:
  - Each VM has a unique OS disk, configured with locally redundant storage.

- OS:
  - Red Hat Enterprise Linux (RHEL), version 8.3, is used.

- Authentication:
  - SSH key-based access with a pre-defined public key.

- Custom Initialization:
  - Each VM runs a custom cloud-init script (app1-cloud-init.txt) at startup.

This setup is typically used for scalable Linux-based workloads, where VMs are provisioned for development, testing, or running applications.
