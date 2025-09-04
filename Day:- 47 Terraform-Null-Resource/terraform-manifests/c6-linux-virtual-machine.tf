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

### 1. Resource Type and Name

resource "azurerm_linux_virtual_machine" "mylinuxvm" 

- azurerm_linux_virtual_machine → Terraform resource for provisioning a Linux VM on Azure.  
- "mylinuxvm" is the logical Terraform name (Terraform identifier, not the Azure resource name).  
- This creates one Linux VM.

### 2. Naming & Grouping

  name                = local.vm_name
  computer_name       = local.vm_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location

- name → The Azure resource name of the VM (must be unique in the RG). Pulled from local.vm_name.
- computer_name → The hostname inside the VM OS (what you see with hostname after login).
- resource_group_name → Deploys into an existing azurerm_resource_group.myrg.
- location → The Azure region is inherited from the resource group (eastus, westeurope, etc.).


### 3. Size/Flavor

  size = "Standard_DS1_v2"

- Defines VM type (vCPUs, RAM, disk throughput).  
- Standard_DS1_v2 → 1 vCPU, 3.5 GB RAM, entry-level VM.  

### 4. Admin Access

  admin_username = "azureuser"

- Primary login username for connecting to the VM.

  admin_ssh_key
{
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

- Sets up SSH key authentication (preferred over passwords).  
- file(...) loads your public key file from the module’s ssh-keys folder.  
- When you ssh azureuser@<vm-ip>, this public key allows access (matching your private key).

### 5. Networking

  network_interface_ids = [azurerm_network_interface.myvmnic.id]

- The VM attaches to an existing Network Interface Card (NIC) created earlier in Terraform (myvmnic).  
- You can attach multiple NICs via a list; here it’s just one.

### 6. OS Disk

- OS disk settings:
  - name: Unique disk name (osdisk + random string).
  - caching = "ReadWrite": Optimizes system performance (writes and reads cached).
  - Standard_LRS: Standard HDD/SSD (cheaper), vs Premium_LRS for SSDs.

### 7. OS Image Selection

  - Defines which OS image the VM uses:
  - publisher = "RedHat"
  - offer = "RHEL" (Red Hat Enterprise Linux)
  - sku = "83-gen2" (RHEL 8.3 Generation 2 VM)
  - version = "latest" ensures always the latest patch release.

- Equivalent CLI: az vm image list --publisher RedHat -o table.

### 8. Bootstrapping with Cloud-init

  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")

- custom_data is passed as a cloud-init script (base64 encoded).  
- Runs at VM’s first boot to configure software automatically.  
  Example: install packages, configure services.  
- In this case, loads instructions from app-scripts/app1-cloud-init.txt.

### 9. Tags

  tags = local.common_tags

- Adds metadata/labels for organization (e.g., "Environment" = "Dev", "Owner" = "TeamA"),
- locals { common_tags = { env = "dev", project = "terraform" } }

## 🖼 Putting It Together: Lifecycle

1. Terraform creates the NIC (azurerm_network_interface.myvmnic) → attaches virtual network & subnet.

2. Terraform provisions the **Linux VM:
   - Links that NIC.
   - Uses RHEL 8.3 OS image.
   - Creates an OS disk.
   - Injects your cloud-init script for bootstrapping.
   - Enables SSH login using your provided public key.

3. After terraform apply, you can:
   
   ssh -i ssh-keys/terraform-azure ubuntu@<vm-public-ip>
   
