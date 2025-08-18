# Resource: Azure Linux Virtual Machine

resource "azurerm_linux_virtual_machine" "mylinuxvm" 
{
  name                = local.vm_name
  computer_name       = local.vm_name # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [ azurerm_network_interface.myvmnic.id ]
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

  # local-exec provisioner-1 (Creation-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec"
{
    command = "echo ${azurerm_linux_virtual_machine.mylinuxvm.public_ip_address} >> creation-time.txt"
    working_dir = "local-exec-output-files/"
  }

  # local-exec provisioner-2 - (Destroy-Time Provisioner - Triggered during Destroy Resource)
  provisioner "local-exec"
{
    when    = destroy
    command = "echo Destroy-time provisioner Instanace Destroyed at `date` >> destroy-time.txt"
    working_dir = "local-exec-output-files/"
  }
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" 

- resource: Defines a resource type (azurerm_linux_virtual_machine) to be created in Azure.
- "mylinuxvm": This is the local Terraform resource name, which you can reference elsewhere inside Terraform code.

### 1. VM Basics

- name: The Azure VM name (fetched from locals).
- computer_name: The hostname inside the VM (same as VM name).
- resource_group_name: References the previously created resource group.
- location: Uses the same location as the resource group.
- size: Defines the VM SKU/size (Standard_DS1_v2 = 1 vCPU, 3.5GB RAM).

### 2. Authentication (Admin Login)

- Sets the admin username that will be used to log in to the VM.
- Attaches the VM to a network interface (NIC) called myvmnic.

### 3. SSH Key Authentication

- Instead of passwords, login is done through SSH key authentication.
- file() reads the public key file generated earlier (terraform-azure.pub).
- This ensures secure and passwordless login.

### 4. OS Disk Configuration

- os_disk: Defines the VM’s operating system disk.
- name: Unique name generated using a random string.
- caching: ReadWrite mode for balanced performance.
- storage_account_type: Standard_LRS (Locally Redundant Standard Storage).

### 5. Operating System Image

- Specifies the base VM image from Azure Marketplace.
- Publisher: "Red Hat" (RHEL OS).
- Offer: "RHEL".
- SKU: "83-gen2" → RHEL 8.3 Generation 2 VM.
- Version: Always use the latest available version.

### 6. Cloud-init / Custom Data

- custom_data: Cloud-init script to automatically configure the VM on startup.
- The script is read, Base64 encoded, and passed to Azure.
- Example use: install packages, configure software, run initial setup.

### 7. Tags

- Attaches standard metadata/tags to the VM (like environment, project, etc.).

### 8. Provisioners

#### Creation-Time Provisioner

- Runs a local command on the machine where Terraform is executed, not inside the VM.
- Here, it writes the VM’s public IP address to a file called creation-time.txt.
- Stores it in a directory local-exec-output-files/.

#### Destroy-Time Provisioner

- Triggered only when the resource is destroyed.
- Appends a message to destroy-time.txt.
- Helps in logging or notifying when the VM gets deleted.
