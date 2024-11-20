# Resource: Azure Linux Virtual Machine

resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  name = "mylinuxvm-1"
  computer_name = "devlinux-vm1"  # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location = azurerm_resource_group.myrg.location
  size = "Standard_DS1_v2"
  admin_username = "azureuser"
  network_interface_ids = [ azurerm_network_interface.myvmnic.id ]
  admin_ssh_key {
    username = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer = "RHEL"
    sku = "83-gen2"
    version = "latest"
  }
  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
}

------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

Here's a detailed explanation of the given Terraform code for creating an Azure Linux Virtual Machine (VM):

### 1. Resource Block Definition

resource "azurerm_linux_virtual_machine" "mylinuxvm" {

- resource "azurerm_linux_virtual_machine" "mylinuxvm": 
- Specifies that this block defines a Linux VM in Azure. 
- mylinuxvm is the instance name used to reference this resource elsewhere in the configuration.

### 2. Basic VM Configuration

  name = "mylinuxvm-1"
  computer_name = "devlinux-vm1"  # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location = azurerm_resource_group.myrg.location
  size = "Standard_DS1_v2"
  admin_username = "azureuser"

- name = "mylinuxvm-1": The name assigned to the VM in Azure.
- computer_name = "devlinux-vm1": The hostname that will be set for the VM operating system.
- resource_group_name = azurerm_resource_group.myrg.name: The VM is placed in the resource group defined earlier (myrg).
- location = azurerm_resource_group.myrg.location: Specifies the location where the VM will be deployed (same as the resource group).
- size = "Standard_DS1_v2": Specifies the size of the VM, determining the number of vCPUs, RAM, and performance characteristics.
- admin_username = "azureuser": Sets the administrator username for SSH access to the VM.

### 3. Network Interface Attachment

  network_interface_ids = [ azurerm_network_interface.myvmnic.id ]

- network_interface_ids = [ azurerm_network_interface.myvmnic.id ]:
- Attaches the VM to a network interface, allowing it to communicate within the virtual network and access the public network if a public IP is associated.

### 4. Admin SSH Key Configuration

  admin_ssh_key {
    username = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

- admin_ssh_key` block:

  - Configures SSH key-based authentication for secure access.
  - username = "azureuser": Specifies the admin username that the SSH key will be associated with.
  - public_key = file("${path.module}/ssh-keys/terraform-azure.pub")`: Reads the public SSH key from a specified file path within the module's directory. This key is used for secure, passwordless SSH access to the VM.

### 5. OS Disk Configuration
`
  os_disk {
    name = "osdisk"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

- os_disk` block:

  - Configures the operating system disk for the VM.
  - name = "osdisk": The name of the OS disk.
  - caching = "ReadWrite": Specifies the caching mode for the OS disk. ReadWrite allows both read and write operations to be cached.
  - storage_account_type = "Standard_LRS": Sets the storage type to Standard Locally Redundant Storage (LRS), which is cost-effective and maintains three copies of data within a single region.

### 6. Source Image Configuration

  source_image_reference {
    publisher = "RedHat"
    offer = "RHEL"
    sku = "83-gen2"
    version = "latest"
  }

  - source_image_reference block: Specifies the image used to create the VM.
  - publisher = "RedHat": Indicates that the image publisher is Red Hat.
  - offer = "RHEL": Refers to the Red Hat Enterprise Linux (RHEL) offering.
  - sku = "83-gen2": Specifies the SKU (Stock Keeping Unit) of the image, indicating version or edition.
  - version = "latest": Ensures that the VM is created using the latest available version of the specified image.

### 7. Custom Data Configuration

  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")

- custom_data:

  - Provides a way to execute custom initialization scripts at the first boot of the VM.
  - filebase64("${path.module}/app-scripts/app1-cloud-init.txt"):
  - Reads and encodes a script located at app-scripts/app1-cloud-init.txt into base64 format.
  - This script could include commands for software installation, configuration, or other setup tasks that need to run when the VM starts.

### Summary

- This code block provisions a Red Hat Linux VM in Azure.
- The VM is configured with an attached network interface, an SSH key for secure access, and a custom initialization script.
- The OS disk is configured for Standard_LRS storage with read-write caching.
- The VM is created using the latest Red Hat Enterprise Linux image and initialized with a script to customize its setup.
