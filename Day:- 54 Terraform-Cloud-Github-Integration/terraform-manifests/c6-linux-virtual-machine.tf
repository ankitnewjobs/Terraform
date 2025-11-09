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

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

Nice — let’s walk through this `azurerm_linux_virtual_machine` block line-by-line and explain what each part does, why it’s there, and a few practical notes / improvements.

# What this resource is

This is a Terraform resource that creates an Azure **Linux VM** (managed compute) using the `azurerm` provider. It ties together compute, disk, networking, image choice, SSH access and cloud-init (custom_data).

---

## Top-level attributes

* `resource "azurerm_linux_virtual_machine" "mylinuxvm" { ... }`
  Declares a managed Linux VM named `mylinuxvm` in Terraform state. The logical/local name inside Terraform is `mylinuxvm`.

* `name = local.vm_name`
  The VM name in Azure. `local.vm_name` is a local value defined elsewhere in the config. This is the name shown in the Azure portal and used for the VM resource.

* `computer_name = local.vm_name`
  The hostname that will be set inside the VM (the OS-level hostname). Usually matches `name`.

* `resource_group_name = azurerm_resource_group.myrg.name`
  The resource group where the VM will be created. Terraform will use the `myrg` resource defined elsewhere (`azurerm_resource_group.myrg`).

* `location = azurerm_resource_group.myrg.location`
  Azure region for the VM. Re-uses the RG location to keep resources co-located.

* `size = "Standard_DS1_v2"`
  The VM SKU / size (CPU, memory). Hard-coded here — commonly replaced with a variable so it’s configurable.

* `admin_username = "azureuser"`
  Linux admin user. This will be the non-root account created by Azure image provisioning (and the account the SSH key is tied to).

* `network_interface_ids = [ azurerm_network_interface.myvmnic.id ]`
  List of NIC resource IDs attached to the VM. This ties the VM to an `azurerm_network_interface` defined elsewhere (myvmnic). Because you use the NIC resource ID, Terraform will automatically create a dependency so the NIC exists before VM creation.

---

## `admin_ssh_key` block

```
admin_ssh_key {
  username   = "azureuser"
  public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
}
```

* Enables **SSH key** authentication for the `azureuser` account.
* `public_key` uses `file()` to read the public key file at module path `ssh-keys/terraform-azure.pub`. `path.module` resolves to the directory of the current Terraform module.
* This is preferred over passwords for security. If the file path is wrong you get a `file not found` failure.

**Notes**

* Ensure the public key file contains a single valid OpenSSH public key (e.g., starts with `ssh-rsa` or `ssh-ed25519`).
* Keep the private key secure — not stored in Terraform configuration or state.

---

## `os_disk` block

```
os_disk {
  name = "osdisk${random_string.myrandom.id}"
  caching              = "ReadWrite"
  storage_account_type = "Standard_LRS"
}
```

* `name`: name for the managed OS disk (here concatenating a random string for uniqueness). `random_string.myrandom.id` likely comes from a `random_string` resource.
* `caching`: OS disk caching mode (`ReadWrite`, `ReadOnly`, `None`). Affects performance characteristics.
* `storage_account_type`: managed disk tier. Common values: `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`. Choose based on performance/price needs.

**Notes**

* For better performance on production workloads, consider `Premium_LRS` or `StandardSSD_LRS`.
* The managed disk is created and handled by Azure — you don't need separate storage accounts.

---

## `source_image_reference` block

```
source_image_reference {
  publisher = "RedHat"
  offer     = "RHEL"
  sku       = "83-gen2"
  version   = "latest"
}
```

* Defines which Marketplace image to use for the VM.

  * `publisher` — publisher name (RedHat).
  * `offer` — offer id (RHEL).
  * `sku` — SKU (e.g., `83-gen2`).
  * `version` — `latest` uses the newest available image version.

**Notes / Caveats**

* Using `version = "latest"` improves you getting the newest image but reduces reproducibility (image could change next apply). For reproducible builds, pin to a specific version.
* Some images require marketplace terms acceptance or subscription access; ensure the subscription can use that image in the chosen region.
* Not all SKUs are available in every region — you can get an error if the image isn’t available.

---

## `custom_data`

```
custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
```

* `custom_data` passes a base64-encoded string to the VM that cloud-init or the platform can use to bootstrap the VM (install packages, run scripts, configure users, etc.).
* `filebase64(...)` reads the file and encodes it to base64 automatically (Azure expects custom_data base64-encoded for some VM types).
* File here: `app-scripts/app1-cloud-init.txt` — usually a cloud-init YAML script.

**Notes**

* Cloud-init runs with root privileges on first boot, so be careful what you put there.
* If the file is large, Azure may enforce size limits on custom data.

---

## `tags = local.common_tags`

* Attaches tags (key/value map) to the VM for cost center, automation, or identification. `local.common_tags` presumably defined elsewhere for consistent tagging across resources.

---

## Implied / external dependencies referenced in this block

* `azurerm_resource_group.myrg` — resource group resource.
* `azurerm_network_interface.myvmnic` — network interface (needs subnet, IP config, NSG, etc).
* `random_string.myrandom` — used to render a unique OS disk name.
* Files under `${path.module}/ssh-keys/` and `app-scripts/` must exist where Terraform runs.

---

## Practical tips, best practices, and pitfalls

1. **Avoid hardcoding sensitive or environment-specific values**

   * Make `size`, `admin_username`, `image` fields driven by variables so different environments can reuse the module.

2. **SSH keys**

   * Use `admin_ssh_key` (key-based) instead of `admin_password`. Do not commit private key into VCS. Keep the public key readable to Terraform.

3. **Pin images for reproducibility**

   * `version = "latest"` is convenient, but pin to a specific version or use an image ID if you need repeatable images.

4. **Managed identity / access**

   * For production, consider attaching a `user_assigned_identity` or `system_assigned_identity` for secure access to Azure resources rather than embedding secrets in cloud-init.

5. **Disk tiering**

   * Choose `StandardSSD_LRS` or `Premium_LRS` for better IOPS if the application needs it.

6. **Cloud-init size & errors**

   * If cloud-init fails, check the VM serial/boot log in Azure or examine the VM boot diagnostics. Common errors: malformed YAML, scripts failing, missing packages.

7. **Marketplace images / permissions**

   * Some paid images may require accepting terms. Terraform can accept terms via `azurerm_marketplace_agreement` if needed (or ensure the subscription already accepted them via portal).

8. **Quotas & region availability**

   * VM SKU or image might not be available in the selected region or your subscription may hit quota limits (cores); check Azure quota and available SKUs.

9. **State and sensitive data**

   * Terraform state will contain resource metadata (but not private keys if you use `file()` for public key). But avoid writing secrets to state (e.g., avoid setting admin password as literal).

---

## Example minimal related resources (context)

These are examples — they are not required but show what the referenced resources might look like.

```hcl
resource "azurerm_resource_group" "myrg" {
  name     = "rg-example"
  location = "eastus"
}

resource "azurerm_network_interface" "myvmnic" {
  name                = "nic-example"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.my-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my-pip.id
  }
}

resource "random_string" "myrandom" {
  length  = 6
  special = false
  upper   = false
}
```

---

## Quick troubleshooting checklist

* `file(...)` or `filebase64(...)` path errors → verify file path relative to module.
* SSH public key format errors → ensure a valid OpenSSH public key.
* Image not available or marketplace not accepted → check region and subscription acceptance.
* Quota/capacity errors → check VM cores or SKU availability.
* Cloud-init syntax failure → validate YAML and test commands locally.


