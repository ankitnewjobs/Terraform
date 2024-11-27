---
title: Terraform Resource Meta-Argument for_each Chaining
description: Learn Terraform Resource Meta-Argument for_each Chaining
---
## Step-01: Introduction
- Understand about Meta-Argument `for_each`
- Implement `for_each` Chaining
- Because a resource using `for_each` appears as a `map of objects` or `set of strings` when used in expressions elsewhere, you can directly use one resource as the `for_each of another in situations` where there is a `one-to-one relationship` between two sets of objects.
- In our case, we will use the `azurerm_network_interface.myvmnic` resource directly in `azurerm_linux_virtual_machine.mylinuxvm` Resource. 

## Step-02: Review Terraform Manifests
- Copy the `terraform-manifests` from Section `11-Meta-Argument-count\terraform-manifests-v2` and re-implement this usecase using `for_each`. 
- Also apply `for_each` chaining concept
1. c1-versions.tf
2. c2-resource-group.tf
3. c3-virtual-machine.tf: Changes for Public IP and Network Interface Resources with `for_each` same argument in both resources.
4. c4-linux-virtual-machine.tf: `for_each` using Network Interface Resource

## Step-03: c3-virtual-machine.tf -  Azure Public IP Resource
```t
# Create Azure Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  #count = 2  
  for_each = toset(["vm1", "vm2"])
  name                = "mypublicip-${each.key}"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-${each.key}-${random_string.myrandom.id}"  
}
```

## Step-04: c3-virtual-machine.tf - Azure Network Interface Resource
```t
# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  #count = 2
  for_each = toset(["vm1", "vm2"])  
  name                = "vmnic-${each.key}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id = element(azurerm_public_ip.mypublicip.*.id, each.key)
    public_ip_address_id = azurerm_public_ip.mypublicip[each.key].id
  }
}
```

## Step-05: c4-linux-virtual-machine.tf
```t
# Resource: Azure Linux Virtual Machine

resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  #count = 2
  #for_each = toset(["vm1", "vm2"])  
  for_each = azurerm_network_interface.myvmnic #for_each chaining
  # Define Explicit Dependency that if VM Nic exists, then only create VM
  depends_on = [ azurerm_network_interface.myvmnic ]
  name                = "mylinuxvm-${each.key}"
  computer_name       = "devlinux-${each.key}" # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  #network_interface_ids = [element(azurerm_network_interface.myvmnic.*.id, each.key)]
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
```

## Step-06: Observe Linux Virtual Machine for_each Argument
- In `azurerm_linux_virtual_machine` resource we are using the `for_each` argument by referring to Network Interface Resource named `azurerm_network_interface.myvmnic`. This is called `for_each` chaining. 
```t
# for_each chaining
  for_each = azurerm_network_interface.myvmnic 
```

## Step-07: Execute Terraform Commands
```t
# Terraform Init
terraform init

# Terraform Validate
terraform validate

# Terraform Format
terraform fmt

# Terraform Plan
terraform plan
Observation: 
1) 2 Public IP, 2 Network Interface and 2 Linux VM Resources will be generated in plan
2) Review Resource Names ResourceType.ResourceLocalName[each.key]
3) Review Resource Names

# Terarform Apply
terraform apply
 
# Verify
1. Azure Resource Group
2. Azure Virtual Network
3. Azure Subnet
4. Azure Public IP - 2 Resources created as specified in count
5. Azure Network Interface - 2 Resources created as specified in count
6. Azure Linux Virtual Machine - - 2 Resources created as specified in count

# Access Application
http://<PUBLIC_IP-1>
http://<PUBLIC_IP-2>
```

## Step-08: Destroy Terraform Resources
```t
# Destroy Terraform Resources
terraform destroy

# Remove Terraform Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

--------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

The snippet you've provided outlines a step-by-step procedure for creating and managing multiple Linux Virtual Machines (VMs) on Azure using Terraform, emphasizing dynamic resource creation through the for_each argument.

Let me break it down and explain each part in detail:

### Code Block Explanation

The provided Terraform configuration includes key components:

1. Disk Configuration:
   
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    #disk_size_gb = 20
    
    - caching: Specifies caching options for the VM's OS disk (ReadWrite allows reading and writing cached data).
    - storage_account_type: Specifies the storage type for the VM's disk (e.g., Standard_LRS for low-cost HDD storage).
    - disk_size_gb: (commented out) Optionally specifies the disk size in GB.

2. Source Image Reference:
   
    source_image_reference {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "83-gen2"
      version   = "latest"
    }
   
    - Defines the image to be used for creating the VM.
      
    - publisher: The provider of the image (RedHat in this case).
    - offer: The type or category of the image (RHEL - Red Hat Enterprise Linux).
    - sku: The specific stock-keeping unit (SKU) or version.
    - version: latest ensures the newest image version is used.

3. Custom Data:
    
    custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
    
    - Supplies a base64-encoded initialization script (commonly used for cloud-init configuration) to the VM.
    - The script file app1-cloud-init.txt is located in the app-scripts directory under the module path.

### Step 06: Observe Linux Virtual Machine for_each Argument

Terraform uses for_each to dynamically iterate over a collection of items and create resources for each. 


for_each = azurerm_network_interface.myvmnic

- This approach chains the creation of Linux Virtual Machines to the Network Interfaces. 
- Every VM is associated with one Network Interface from the collection azurerm_network_interface.myvmnic.

### Step 07: Execute Terraform Commands

#### 1. Initialization:

terraform init

- Downloads the required Terraform provider plugins and initializes the working directory.

#### 2. Validation:

terraform validate

- Ensures the configuration files are syntactically correct.

#### 3. Formatting:

terraform fmt

- Automatically formats the Terraform configuration files to follow standard conventions.

#### 4. Planning:

terraform plan

- Preview the changes Terraform will make to match the configuration.

Observation:

1. **Resource Creation**:

   - Public IPs: Indicates 2 unique external IPs.
   - Network Interfaces: Each VM is assigned one NIC.
   - Linux VMs: 2 VMs are created based on the NIC count.
   
2. Resource Naming:
   - Resource names follow the pattern ResourceType.ResourceLocalName[each.key], leveraging for_each.

#### 5. Apply Changes:

terraform apply

- Executes the plan and creates the resources.

#### 6. Verification:

- Check for the following resources in the Azure Portal:

  - Resource Group
  - Virtual Network (VNet)
  - Subnets
  - Public IP addresses
  - Network Interfaces
  - Linux Virtual Machines

#### 7. Access Applications:

- Confirm the VMs are functioning by accessing their public IPs:
 
  http://<PUBLIC_IP-1>
  http://<PUBLIC_IP-2>
  ```

### Step 08: Destroy Resources

#### 1. Destroy:

terraform destroy

- Removes all the resources created by the Terraform configuration.

#### 2. Cleanup:

rm -rf .terraform
rm -rf terraform.tfstate

- Deletes the local Terraform state files and the .terraform directory to clean up your working directory.

### Key Concepts in the Workflow

1. Dynamic Resource Creation with for_each:

   - Ensures efficient management of resources by linking VMs to network interfaces dynamically.

3. Idempotence:

    - Terraform’s state ensures repeated executions produce consistent results without duplicating resources.

5. Modularity and Customization:

    - Use of custom_data allows specific initialization of VMs.

7. Resource Verification and Accessibility:

    - Resources are verified both through the Azure portal and by accessing applications running on the VMs.

### Final Notes

This process demonstrates best practices in infrastructure as code (IaC), automating Azure VM deployment while enabling scalability and dynamic configuration. If you need further clarification or additional examples, feel free to ask!
