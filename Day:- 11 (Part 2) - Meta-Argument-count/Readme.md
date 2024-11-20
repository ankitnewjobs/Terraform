---
title: Terraform Resource Meta-Argument count
description: Learn Terraform Resource Meta-Argument count
---

## Step-01: Introduction
- [Resources: Count Meta-Argument](https://www.terraform.io/docs/language/meta-arguments/count.html)
- Understand Resource Meta-Argument `count`
- Also implement count and count index practically 
- In general, 1 Azure VM Instance Resource in Terraform equals to 1 VM Instance in Real Azure Cloud
- 5 Azure VM Instance Resources = 5 Azure VM Instances in Azure Cloud
- With `Meta-Argument count` this is going to become super simple. 
- Lets see how. 
- Learn about [Terraform element Function](https://www.terraform.io/docs/language/functions/element.html)
- Learn about [Terarform Splat Expression](https://www.terraform.io/docs/language/expressions/splat.html)
- Learn about [Terraform Length Function](https://www.terraform.io/docs/language/functions/length.html)
- Learn about [Terraform Console](https://www.terraform.io/docs/cli/commands/console.html)


## Step-02: Simple Example - Review terraform-manifests-v1
- Folder Path: terraform-manifests-v1
- c1-versions.tf
- c2-resource-group.tf
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg-${count.index}"
  location = "East US"
  count = 3
}
```

## Step-03: Execute Terraform Commands
```t
# Change Directory
cd terraform-manifests-v1

# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan 
terraform plan

# Terraform Apply 
terraform apply 

# Terraform Destroy
terraform destroy -auto-approve

# Verify
1. We should see 3 Resource groups created.
2. Verify the count.index number for each resource group
```

## Step-04: Review Terraform Configs V2
- **Usecase:** Create two Azure Linux VMs using Meta-Argument `count`
1. We need two Public IPs for two VMs
2. We need two Network Interfaces two VMs
- We are going to learn the following concepts over the process
- Learn about [Terraform Console](https://www.terraform.io/docs/cli/commands/console.html)
- Learn about [Terraform Length Function](https://www.terraform.io/docs/language/functions/length.html)
- Learn about [Terraform element Function](https://www.terraform.io/docs/language/functions/element.html)
- Learn about [Terarform Splat Expression](https://www.terraform.io/docs/language/expressions/splat.html)

- **Folder Path:** terraform-manifests-v2
- c1-versions.tf: No changes
- c2-resource-group.tf: No changes
- c3-virtual-network.tf: Has changes for Network Interface
- c4-linux-virtual-machine.tf: Has changes

## Step-05: terraform-manifests-v2 - c3-virtual-network.tf
- For Public IP resource add `count=2`
```t
# Create Azure Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  count = 2
  name                = "mypublicip-${count.index}"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-vm-${count.index}-${random_string.myrandom.id}"  
}
```

## Step-06: Understand about Splat Expression
- [Terarform Splat Expression](https://www.terraform.io/docs/language/expressions/splat.html)
- [Terraform element Function](https://www.terraform.io/docs/language/functions/element.html)
```t
# Terraform console
terraform console
element(["kalyan", "reddy", "daida"], 0)
element(["kalyan", "reddy", "daida"], 1)
element(["kalyan", "reddy", "daida"], 2)

# To get last element from list
length(["kalyan", "reddy", "daida"])
element(["kalyan", "reddy", "daida"], length(["kalyan", "reddy", "daida"])-1)
```

## Step-07: terraform-manifests-v2 - c3-virtual-network.tf
- For Network Interface resource add `count=2`
- Associate Public IP using `Element Function` and `Splat Expression`
```t
# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  count = 2
  name                = "vmnic-${count.index}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = element(azurerm_public_ip.mypublicip[*].id, count.index)
  }
}
```

## Step-08: c4-linux-virtual-machine.tf 
- For Linux Virtual machine resource add `count=2`
- Associate Network interface to VM using `Element Function` and `Splat Expression`
```t
# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  count = 2
  name                = "mylinuxvm-${count.index}"
  computer_name       = "devlinux-${count.index}" # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [element(azurerm_network_interface.myvmnic[*].id, count.index)]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk${count.index}"
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


## Step-09: Execute Terraform Commands
```t
# Change Directory
cd terraform-manifests-v2

# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan 
terraform plan

# Terraform Apply 
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

## Step-10: Destroy Terraform Resources
```t
# Destroy Terraform Resources
terraform destroy

# Remove Terraform Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## References
- [Resources: Count Meta-Argument](https://www.terraform.io/docs/language/meta-arguments/count.html)

-----------------------------------------------------------------------------------------------------------------------
# Explanaition:- 

The steps detailed above provide a practical walkthrough for understanding and implementing the count meta-argument in Terraform. Here's a structured explanation:


### Step 01: Introduction

This step introduces essential Terraform concepts:

1. Count Meta-Argument: This allows the creation of multiple instances of a resource by specifying the number of desired instances in the count argument.

2. Practical Examples: A single Azure VM resource corresponds to one VM in Azure, but using count, multiple VMs can be created in a simplified manner.

3. Additional Concepts to Learn:

   - Element Function: Retrieves an element from a list based on an index.
   - Splat Expression: Extracts a list of attributes or elements from a resource.
   - Length Function: Calculates the number of items in a list.
   - Terraform Console: A CLI tool for evaluating Terraform expressions interactively.


### Step 02: Simple Example

The configuration (in terraform-manifests-v1) demonstrates creating 3 Azure Resource Groups using the count. Key aspects:

- Each resource group is named dynamically (myrg-${count.index}).
- The count.index variable enables unique indexing for each instance.


### Step 03: Executing Terraform Commands

The basic Terraform workflow is outlined:

1. Initialize: Set up the working directory and download provider plugins.
2. Validate: Check the syntax and configuration correctness.
3. Plan: Preview the resources that will be created.
4. Apply: Create the resources in Azure.
5. Destroy: Clean up all the resources.
6. Verification: Ensure the specified number of resources is created and check indexing using count.index.


### Step 04: Creating Multiple Azure Linux VMs

The terraform-manifests-v2 folder expands on a count by provisioning:

1. Two Public IPs: Using count = 2 in the Public IP resource.
2. Two Network Interfaces: Associated with the Public IPs dynamically using the element function and splat expression.
3. Two Linux Virtual Machines: Linked with the Network Interfaces using similar dynamic indexing logic.

### Step 05: Network Configuration (c3-virtual-network.tf)

The configuration uses:
- Public IP Resource: Creates 2 IP addresses with dynamic naming and associations.
- Splat Expression: azurerm_public_ip.mypublicip[*].id retrieves the list of IDs for all created Public IPs.
- Element Function: Associates each VM's network interface with a specific Public IP.

### Step 06: Exploring Console and Functions

- The terraform console tool is used to test expressions, such as retrieving elements from a list or calculating the list's length.
  
- Example:
  
  - element(["kalyan", "reddy", "daida"], 0) returns "kalyan".
  - Retrieve the last element dynamically using:
    
    element(["kalyan", "reddy", "daida"], length(["kalyan", "reddy", "daida"])-1)
    

### Step 07: Network Interface Configuration

The Network Interface resource links to Public IPs using:

- count = 2: Ensures two instances are created.
- Dynamic assignment of Public IPs to interfaces using:
  public_ip_address_id = element(azurerm_public_ip.mypublicip[*].id, count.index)
  
### Step 08: Linux VM Configuration (c4-linux-virtual-machine.tf)

The Linux VM resource demonstrates:

- Associating network interfaces using:
  
  network_interface_ids = [element(azurerm_network_interface.myvmnic[*].id, count.index)]
  
- Dynamic resource naming and configuration based on count.index.
- Use of custom data for initializing VMs.

### Step 09: Deployment

1. Run Terraform commands (init, validate, plan, apply) to provision:

   - Resource Group
   - Virtual Network
   - Subnet
   - 2 Public IPs
   - 2 Network Interfaces
   - 2 Linux Virtual Machines

3. Verify resources in Azure Portal.

4. Access deployed applications using the assigned public IPs.

### Step 10: Clean Up

- Destroy all resources using terraform destroy.
- Remove residual Terraform state files.
