# Resource: Azure Linux Virtual Machine

resource "azurerm_linux_virtual_machine" "mylinuxvm" 
{
  name                = local.vm_name
  computer_name       = local.vm_name # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = 
[
    azurerm_network_interface.myvmnic.id
  ]
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

# PLAY WITH /tmp folder in Virtual Machine with File Provisioner

  # Connection Block for Provisioners to connect to Azure Virtual Machine

  connection 
{
    type = "ssh"
    host = self.public_ip_address # Understand what is "self"
    user = self.admin_username
    private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
  }  

# File-Provisioner-1: Copies the file-copy.html file to /tmp/file-copy.html

  provisioner "file"
{
    source      = "apps/file-copy.html"
    destination = "/tmp/file-copy.html"
  }

# Remote-exec Provisioner-1: Copies the file to Apache Webserver /var/www/html directory
  provisioner "remote-exec"
{
    inline = 
[
      "sleep 120", # Will sleep for 120 seconds to ensure Apache web server is provisioned using custom_data
      "sudo cp /tmp/file-copy.html /var/www/html"
    ]
  }
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Resource Block

resource "azurerm_linux_virtual_machine" "mylinuxvm" 
{
  ...
}

- This block defines an Azure Linux VM resource named mylinuxvm.

## Main Configuration

- name, computer_name: - Both are set to local.vm_name. This sets both the Azure resource and the actual hostname for the VM.

- resource_group_name, location: - The VM will reside in the resource group and Azure region specified by another resource (azurerm_resource_group.myrg).

- size: - Sets the hardware size to Standard_DS1_v2 (1 vCPU, 3.5GB RAM).

- admin_username: - Default admin username for SSH login set to "azureuser".

## Networking

- network_interface_ids: - List containing NIC resource ID(s), specifically from azurerm_network_interface.myvmnic, connecting the VM to a virtual network.

## Authentication

admin_ssh_key 
{
  username   = "azureuser"
  public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
}
```
This block specifies the SSH public key (read from a file) for secure, passwordless login for azureuser.

## OS Disk

os_disk 
{
  name                 = "osdisk${random_string.myrandom.id}"
  caching              = "ReadWrite"
  storage_account_type = "Standard_LRS"
}

- name: Dynamically sets OS disk name using a random string for uniqueness.  
- caching: Set to allow both reading and writing.  
- storage_account_type: Chooses standard Azure storage (locally redundant).

## Source Image

source_image_reference 
{
  publisher = "RedHat"
  offer     = "RHEL"
  sku       = "83-gen2"
  version   = "latest"
}

- Specifies the base image as Red Hat Enterprise Linux 8.3 (generation 2) from the official publisher.

## Custom Data

custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")

Sends a base64-encoded cloud-init script to run on first boot, used for initial VM configuration (e.g., installing packages, running scripts).

## Tags

tags = local.common_tags: - Applies pre-defined tags stored in a local map.

## Connection Block

connection
{
  type        = "ssh"
  host        = self.public_ip_address
  user        = self.admin_username
  private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
}

- Purpose: Used by provisioners to remotely connect to the VM after deployment.
- self.public_ip_address: self refers to the current VM resource, so this retrieves its assigned public IP.
- user, private_key: Specifies the SSH username and corresponding private key for connection.

## File Provisioner

provisioner "file"
{
  source      = "apps/file-copy.html"
  destination = "/tmp/file-copy.html"
}

Uploads apps/file-copy.html from your local machine to /tmp/file-copy.html on the VM.

## Remote-Exec Provisioner

provisioner "remote-exec" 
{
  inline = [
    "sleep 120",
    "sudo cp /tmp/file-copy.html /var/www/html"
  ]
}

- Waits 120 seconds (allows time for the Apache web server to be installed/configured via custom_data).

- Then, it copies the uploaded file into the default web root for Apache.

### Summary Table

|    Section      |                       Purpose                                             |
|-----------------|---------------------------------------------------------------------------|
|  VM Resource    |  Declares an Azure VM with networking, size, and RHEL image               |
|  SSH Key        |  Sets up secure authentication using SSH key pair                         |
|  OS Disk        |  Configures storage for the operating system                              |
|  Provisioners   |  Runs actions after deployment (copy files, execute commands remotely)    |
|  Cloud-init     |  Runs scripts for first-boot app/server setup                             |
|  Tags           |  Applies labels for resource management and cost allocation               |

