# Resource: Azure Linux Virtual Machine

resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  #for_each = toset(["vm1", "vm2"])  
  for_each = azurerm_network_interface.myvmnic #for_each chaining
  name                = "mylinuxvm-${each.key}"
  computer_name       = "devlinux-${each.key}" # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
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

------------------------------------------------------------------------------------------------------------------------------------------

# Explanations: -

This Terraform code creates multiple Linux virtual machines (VMs) on Azure using the azurerm_linux_virtual_machine resource. The configuration dynamically provisions VMs by leveraging `for_each` chaining.

Below is a detailed explanation of the code:

### Resource: azurerm_linux_virtual_machine

This resource creates a Linux VM in Azure. Multiple VMs are instantiated using for_each chaining, where the number of VMs matches the number of network interfaces created earlier.

#### 1. Dynamic Creation with for_each


for_each = azurerm_network_interface.myvmnic


1. What is Happening?

   - The for_each expression iterates over the network interfaces defined in the azurerm_network_interface.myvmnic resource.
   - Each key in the azurerm_network_interface.myvmnic resource (e.g., vm1, vm2) will create a corresponding Linux VM.

2. Purpose:

   - This technique links each VM to a specific network interface dynamically, ensuring proper configuration and reducing duplication in code.

#### 2. Naming and Identification

name                = "mylinuxvm-${each.key}"
computer_name       = "devlinux-${each.key}"

1. VM Name:
   - The name of the VM (mylinuxvm-vm1, mylinuxvm-vm2) is dynamically generated based on the key from the for_each loop.

2. Hostname (computer_name):
   - Sets the internal hostname of the VM (e.g., devlinux-vm1, devlinux-vm).

#### 3. Network Configuration

network_interface_ids = [azurerm_network_interface.myvmnic[each.key].id]


1. What is This?
   - Each VM is assigned a specific network interface from the azurerm_network_interface resource (e.g., vmnic-vm1, vmnic-vm2).

2. Why Is This Important?
   - Properly connects the VM to the virtual network and subnet via the pre-created network interface.

#### 4. Admin User and SSH Key

admin_username = "azureuser"
admin_ssh_key {
  username   = "azureuser"
  public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
}

1. Admin Username:
   - Specifies the admin username for accessing the VM (azureuser).

2. SSH Key Authentication:
   - The admin_ssh_key block defines secure SSH access for the VM.
   - The public_key is loaded from a file (terraform-azure.pub) located in the ssh-keys directory of the module's path.

3. Purpose:
   - Configures secure, key-based authentication for managing the VM.

#### 5. OS Disk Configuration

os_disk {
  name = "osdisk${each.key}"
  caching              = "ReadWrite"
  storage_account_type = "Standard_LRS"
}

1. Disk Name:
   - Each VM's OS disk is named uniquely (e.g., osdiskvm1, osdiskvm2) using the loop key.

2. Disk Caching:
   - Set to ReadWrite for optimized disk operations during read/write workloads.

3. Storage Type:
   - Uses Standard_LRS (locally redundant storage), which is cost-effective and suitable for most general-purpose workloads.

#### 6. Source Image

source_image_reference {
  publisher = "RedHat"
  offer     = "RHEL"
  sku       = "83-gen2"
  version   = "latest"
}

1. Image Specification:
   - The VM is created using a Red Hat Enterprise Linux (RHEL) image.
   - Publisher: Specifies the image publisher (RedHat).
   - Offer: Defines the image offer (RHEL).
   - SKU: Identifies the specific version of the image (83-gen2).
   - Version: Uses the latest available version of the specified SKU.

2. Purpose:
   - Ensures a consistent and reliable Linux environment for VMs using a certified RHEL image.

#### 7. Custom Data

custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")

1. What is custom_data?
   - Allows you to pass a base64-encoded script file (app1-cloud-init.txt) to the VM.

2. Purpose:
   - The script executes during VM initialization (cloud-init) and is typically used for:
     - Installing required packages.
     - Configuring the environment.
     - Bootstrapping the application.

### Workflow Summary

1. for_each Chaining:
   - Dynamically creates VMs for each network interface (vmnic-vm1, vmnic-vm2).

2. VM Customization:
   - Each VM has unique:
     - Name.
     - Hostname.
     - Network interface.
     - OS disk.

3. Secure Access:
   - Uses SSH keys for secure, password-less access.

4. RHEL Image:
   - Ensures a reliable and enterprise-grade Linux environment.

5. Cloud-Init Script:
   - Automates initial configuration during boot.

### Real-World Application

This configuration is ideal for setting up:

1. Scalable Linux Environments:
   - Quickly deploy multiple VMs with minimal configuration changes.
   
2. Cloud-Native Applications:
   - Use cloud-init to bootstrap applications on each VM.

3. Networking-Integrated VMs:
   - Seamlessly connects VMs to virtual networks with public/private IPs for internal and external communication.

4. Production or Test Environments:
   - Easily create repeatable and consistent infrastructure across multiple VMs.
