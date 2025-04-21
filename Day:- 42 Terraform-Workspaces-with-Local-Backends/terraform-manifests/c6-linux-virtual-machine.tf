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
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

##  DETAILED BREAKDOWN

### resource "azurerm_linux_virtual_machine" "mylinuxvm" { ... }

Creates a Linux-based VM named mylinuxvm. This is a fully managed compute instance in Azure.

### name and computer_name

name          = local.vm_name
computer_name = local.vm_name

- name: The resource name in Azure.
- computer_name: The hostname of the virtual machine inside the OS.

Practical Tip_: Aligning both values ensures consistency across cloud and OS-level naming.

### resource_group_name & location

resource_group_name = azurerm_resource_group.myrg.name
location            = azurerm_resource_group.myrg.location

- Associates the VM with the correct Azure resource group and region.
- These are references to a azurerm_resource_group you’ve likely created earlier.

### size = "Standard_DS1_v2"

- Specifies the VM size — i.e., the amount of CPU, RAM, and disk performance:
- Standard_DS1_v2 = 1 vCPU, 3.5 GiB RAM, commonly used for dev/test environments.

You can change this based on workload size (e.g., Standard_D2s_v3 for more power)._

### admin_username = "azureuser"

This defines the login username for the virtual machine.

### network_interface_ids

network_interface_ids = [ azurerm_network_interface.myvmnic.id ]

This attaches the VM to a Network Interface Card (NIC) that:

- Connects to a subnet
- Has a public IP (if configured)
- Enables internet access and communication

You can attach multiple NICs in advanced scenarios, like load balancing or multi-subnet setups._

### SSH Authentication Block

admin_ssh_key
{
  username   = "azureuser"
  public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
}

This is key-based login using SSH — the recommended secure method (as opposed to passwords).

- username: Must match admin_username.
- public_key: Reads your public SSH key from the file and injects it into the VM’s .ssh/authorized_keys.

Ensure you have the private key (terraform-azure) locally to SSH into the machine.

### OS Disk Configuration

os_disk 
{
  name                 = "osdisk${random_string.myrandom.id}"
  caching              = "ReadWrite"
  storage_account_type = "Standard_LRS"
}

Creates the boot disk for the VM.

- name: Uses a unique suffix using a random string resource for uniqueness.
- Caching: Improves performance by caching reads/writes.
- Standard_LRS: Standard locally-redundant storage — budget-friendly option.

For production, you may switch to Premium_LRS for higher IOPS.

### Base Image Selection

source_image_reference
{
  publisher = "RedHat"
  offer     = "RHEL"
  sku       = "83-gen2"
  version   = "latest"
}

Specifies the VM OS image from Azure’s marketplace.

- RedHat RHEL 8.3 Generation 2 is used here — this could be changed to Ubuntu, CentOS, etc.
- version = "latest" ensures you always get the latest patched image.

This is similar to choosing an OS version while launching a VM manually in the Azure portal.

### Custom Data (Cloud-init Script)

custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")

This reads and encodes a cloud-init script that:

- Runs automatically during VM provisioning.
- Can install packages, configure services, copy files, etc.

You can do initial setup here, like installing Docker, Nginx, setting firewall rules, etc._\

### Tags

tags = local.common_tags

Applies common metadata tags like:

- Service = Demo Services
- Owner = Kalyan Reddy Daida

Tags help you manage billing, reporting, and access control in large environments.

## FLOW OF DEPLOYMENT

This VM depends on:
1. Random String Resource (for uniqueness)
2. SSH Key File
3. NIC (which itself depends on Subnet, Public IP, and VNet)
4. Custom Cloud-init Script File
