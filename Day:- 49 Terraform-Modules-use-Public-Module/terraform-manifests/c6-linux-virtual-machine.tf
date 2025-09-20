# Resource: Azure Linux Virtual Machine

resource "azurerm_linux_virtual_machine" "mylinuxvm"
{
  name                = local.vm_name
  computer_name       = local.vm_name # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.myvmnic.id]
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

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### Resource Definition

resource "azurerm_linux_virtual_machine" "mylinuxvm" 

- Creates an Azure Linux Virtual Machine using the Terraform azurerm provider.

- "mylinuxvm" is the Terraform resource name, which you use to reference this VM elsewhere in your configuration.

### Basic Properties

  name                = local.vm_name
  computer_name       = local.vm_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"


- name: Actual Azure resource name pulled from the local variable local.vm_name.
- computer_name: Hostname inside the OS, also set to the same local.vm_name.
- resource_group_name: The VM is deployed into a resource group created earlier (azurerm_resource_group.myrg).
- location: Inherits the same region as the resource group.
- size: VM SKU type (Standard_DS1_v2, 1 vCPU, 3.5 GB RAM).
- admin_username: Default login user "azureuser".

### Network Configuration

  network_interface_ids = [azurerm_network_interface.myvmnic.id]

- Attaches the VM to an existing network interface (myvmnic).

- You can attach multiple NICs, but here, only one is used.

### SSH Key Authentication

  admin_ssh_key
{
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

- Configures SSH authentication for azureuser.
- Public key is read from a file inside the Terraform module path at ssh-keys/terraform-azure.pub.
- No password authentication is configured, which is more secure.

### OS Disk Configuration

  os_disk 
{
    name = "osdisk${random_string.myrandom.id}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

- name: Disk name will include a random string (random_string.myrandom.id) for uniqueness.
- caching: Set to ReadWrite, good for most workloads.
- storage_account_type: Standard_LRS (Locally Redundant Storage, HDD-based). Cheap, reliable disk option.

### Source Image Reference

  source_image_reference
{
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }

- Specifies the OS image for the VM.
- publisher: RedHat
- offer: RHEL (Red Hat Enterprise Linux)
- sku: 83-gen2 (RHEL 8.3 Gen2-based image)
- version: latest (always provisions the most current version of RHEL 8.3).

### Cloud-Init (Custom Data Script)

  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")

- Uses cloud-init to configure the VM at boot automatically.
- The script at app-scripts/app1-cloud-init.txt is base64-encoded before being passed.
- Typically includes package installations, app deployment scripts, or configuration steps.

### Tags

  tags = local.common_tags

- Attaches metadata key-value pairs defined in local.common_tags (for example: Environment, Owner, Project).
- Helps with billing, organization, and policy management.
