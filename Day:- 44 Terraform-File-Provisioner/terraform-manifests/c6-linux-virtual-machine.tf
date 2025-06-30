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

# PLAY WITH /tmp folder in Virtual Machine with File Provisioner

  # Connection Block for Provisioners to connect to Azure Virtual Machine

  connection
{
    type = "ssh"
    host = self.public_ip_address
    user = self.admin_username
    private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
  }  

  # File Provisioner-1: Copies the file-copy.html file to /tmp/file-copy.html

  provisioner "file"
{
    source = "apps/file-copy.html"
    destination = "/tmp/file-copy.html"
  }

  # File Provisioner-2: Copies the string in content into /tmp/file.log

  provisioner "file" 
{
    content = "VM Host name: ${self.computer_name}"
    destination = "/tmp/file.log"
  }

  # File Provisioner-3: Copies the app1 folder to /tmp - FOLDER COPY

  provisioner "file"
{
    source = "apps/app1"
    destination = "/tmp"
  }

  # File Provisioner-4: Copies all files and folders in apps/app2 to /tmp - CONTENTS of FOLDER WILL BE COPIED

  provisioner "file" 
{
    source = "apps/app2/"
    destination = "/tmp"
  }

/*

# Enable this during Step-05-01 Test-1

 # File Provisioner-5: Copies the file-copy.html file to /var/www/html/file-copy.html where "azureuser" don't have permission to copy

 # This provisioner will fail but we don't want to taint the resource, we want to continue on_failure

  provisioner "file"
{
    source      = "apps/file-copy.html"
    destination = "/var/www/html/file-copy.html"
    #on_failure  = continue  # Enable this during Step-05-01 Test-2
   } 
*/   
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

##  Resource Block: azurerm_linux_virtual_machine

This defines a Linux VM resource in Azure using the AzureRM provider.

###  Basic Configuration

|    Attribute         |              Description                           |
| -------------------- | ---------------------------------------------------|
|  name                |  VM name, retrieved from local.vm_name.            |
|  computer_name       |  Hostname inside the OS, same as the VM name.      |
|  resource_group_name |  The resource group where the VM will be deployed. |
|  location            |  Azure region from the resource group.             |
|  size                |  VM SKU  "Standard\_DS1\_v2" (1 vCPU, 3.5GB RAM).  |
|  admin_username      |  Admin user for SSH login.                         |

name                = local.vm_name
computer_name       = local.vm_name
resource_group_name = azurerm_resource_group.myrg.name
location            = azurerm_resource_group.myrg.location
size                = "Standard_DS1_v2"
admin_username      = "azureuser"

### Network Interface Attachment

network_interface_ids = [ azurerm_network_interface.myvmnic.id ]

* Attaches the VM to a network interface created earlier.

###  SSH Key Authentication

admin_ssh_key 
{
  username   = "azureuser"
  public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
}

* Specifies the public SSH key file used for secure login.

### OS Disk Settings

os_disk 
{
  name                 = "osdisk${random_string.myrandom.id}"
  caching              = "ReadWrite"
  storage_account_type = "Standard_LRS"
}

* os_disk: Defines disk properties.
* Uses a random string to make the disk name unique.
* Disk caching is set to ReadWrite and uses Standard HDD (LRS).

### Image Selection

source_image_reference 
{
  publisher = "RedHat"
  offer     = "RHEL"
  sku       = "83-gen2"
  version   = "latest"
}

* The VM will be created using the latest RHEL 8.3 Gen2 image.

### Custom Initialization (Cloud-Init)

custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")

* Base64-encoded file is provided to the VM's cloud-init process to run initialization scripts at first boot.

### Tags

tags = local.common_tags

* Adds metadata tags (for cost tracking, environment labeling, etc.).

## Connection Block (Provisioners)

connection 
{
  type        = "ssh"
  host        = self.public_ip_address
  user        = self.admin_username
  private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
}

* Defines how Terraform connects to the VM for provisioning:

  * SSH via public IP
  * Username: azureuser
  * Private key: used for authentication

## File Provisioners

These copy files or folders from your local machine to the VM.

### Provisioner 1 – Copy a Single File

provisioner "file" 
{
  source      = "apps/file-copy.html"
  destination = "/tmp/file-copy.html"
}

* Uploads file-copy.html into /tmp/.

### Provisioner 2 – Create a File from a String

provisioner "file" 
{
  content     = "VM Host name: ${self.computer_name}"
  destination = "/tmp/file.log"
}

* Creates a log file with the VM hostname.

###  Provisioner 3 – Copy a Folder

provisioner "file" 
{
  source      = "apps/app1"
  destination = "/tmp"
}

* Uploads the entire app1 folder to /tmp/app1.

### Provisioner 4 – Copy Folder Contents Only

provisioner "file"
{
  source      = "apps/app2/"
  destination = "/tmp"
}

* Only the contents of app2/ are copied (not the folder itself).

### (Optional) Provisioner 5 – Copy to Restricted Path

provisioner "file" 
{
  source      = "apps/file-copy.html"
  destination = "/var/www/html/file-copy.html"
  #on_failure  = continue
}
