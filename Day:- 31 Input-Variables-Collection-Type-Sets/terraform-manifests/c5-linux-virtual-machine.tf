# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  for_each = var.environment
  name                = "mylinuxvm-${each.key}"
  computer_name       = "${var.business_unit}-${each.key}" # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg[each.key].name
  location            = azurerm_resource_group.myrg[each.key].location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.myvmnic[each.key].id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk${each.key}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    #disk_size_gb = 20
  }
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
}


# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  for_each = var.environment
  name                = "mylinuxvm-${each.key}"
  computer_name       = "${var.business_unit}-${each.key}" # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg[each.key].name
  location            = azurerm_resource_group.myrg[each.key].location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.myvmnic[each.key].id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk${each.key}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    #disk_size_gb = 20
  }
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
}

-----------------------------------------------------------------------------------------------------------------------------------------

# Explanation:- 

This Terraform configuration defines an Azure Linux Virtual Machine (VM) for multiple environments (dev1, qa1, staging1, prod1). 
The VM is configured with SSH authentication, OS disk settings, a specific RedHat image, and cloud-init custom data.

## 1. Creating an Azure Linux Virtual Machine

resource "azurerm_linux_virtual_machine" "mylinuxvm"
{
  for_each = var.environment
  name                = "mylinuxvm-${each.key}"
  computer_name       = "${var.business_unit}-${each.key}" # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg[each.key].name
  location            = azurerm_resource_group.myrg[each.key].location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.myvmnic[each.key].id]

### Explanation:
- for_each = var.environment 
  - Creates a separate VM for each environment.
  
- name = "mylinuxvm-${each.key}"

  - Example names:

    - mylinuxvm-dev1
    - mylinuxvm-qa1
    - mylinuxvm-staging1
    - mylinuxvm-prod1
  
- computer_name = "${var.business_unit}-${each.key}" 
  - This is the hostname inside the VM.

  - Example hostnames:

    - hr-dev1
    - hr-qa1
  
- resource_group_name & location  
  - The VM is deployed inside the corresponding Azure Resource Group.

- size = "Standard_DS1_v2"
  - Specifies the VM size (Standard_DS1_v2 → 1 vCPU, 3.5 GB RAM).

- network_interface_ids = [azurerm_network_interface.myvmnic[each.key].id] 
  - Associates the VM with its corresponding Network Interface (NIC).

## 2. SSH Authentication

  admin_ssh_key
{
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

### Explanation:
- admin_ssh_key block 
  - Sets up SSH authentication for secure access.

- username = "azureuser" 
  - The default admin user for logging into the VM.

- public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  - Reads an existing SSH public key from the file system.
  - The key is stored in ${path.module}/ssh-keys/terraform-azure.pub.
  - Ensure that the key exists before applying Terraform.

## 3. OS Disk Configuration

  os_disk 
{
    name = "osdisk${each.key}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    #disk_size_gb = 20
  }

### Explanation:

- name = "osdisk${each.key}" 
  - Assign a unique name for each environment.

  - Example:

    - osdisk-dev1
    - osdisk-qa1
  
- caching = "ReadWrite" 
  - Enables read and write caching for better performance.

- storage_account_type = "Standard_LRS" 
  - Uses Standard_LRS (Locally Redundant Storage) for cost efficiency.
  - Change to Premium_LRS for better performance.

- disk_size_gb = 20 (commented out) 
  The default size is 30 GB.
  - Uncomment to explicitly set the disk size.

## 4. VM Image Selection

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }

### Explanation:

- Defines the base OS image for the VM.
- RedHat Enterprise Linux (RHEL) 8.3 (Gen2) is used.
- The latest ensures the VM always gets the latest available version.

## 5. Cloud-Init Custom Data

  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
}

### Explanation:

- custom_data allows running scripts on VM startup (cloud-init).
- Encodes the file (app1-cloud-init.txt) in Base64.
- Used for provisioning applications, configuring users, and initializing services.

## Final Output

For each environment (dev1, qa1, staging1, prod1), Terraform will create:

1. Linux Virtual Machine** (mylinuxvm-dev1, mylinuxvm-qa1, etc.).
2. OS Disk (osdisk-dev1, osdisk-qa1, etc.).
3. Attaches Network Interface (hr-dev1-myvnet-myvmnic).
4. Uses SSH authentication with a pre-existing key.
5. Executes a startup script using cloud-init.

## Improvements & Fixes

### 1. Fix Duplicate Resource Definition

The same resource azurerm_linux_virtual_machine.mylinuxvm is declared twice.  
- Solution: Remove the duplicate resource block.

### 2. Ensure the SSH Key Exists

Ensure that the SSH key file terraform-azure.pub exists inside the SSH-keys folder.

### 3. Validate Cloud-Init Script

Check the app1-cloud-init.txt file to ensure:
- It's a valid YAML file.
- It contains proper commands and permissions.

## Summary

- Creates a VM for each environment (dev1, qa1, staging1, prod1).
- Uses for_each for dynamic deployments.
- Configures SSH authentication.
- Attaches a network interface.
- Deploys RedHat 8.3 (Gen2) as the OS.
- Runs startup scripts via cloud-init.
