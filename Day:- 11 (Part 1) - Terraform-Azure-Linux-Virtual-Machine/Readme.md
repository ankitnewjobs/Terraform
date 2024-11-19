---
title: Provision Azure Linux VM using Terraform
description: Learn to Provision Azure Linux VM using Terraform
---

## Step-01: Introduction
- We will create the below Azure Resources using Terraform
1. Azure Resource Group
2. Azure Virtual Network
3. Azure Subnet
4. Azure Public IP
5. Azure Network Interface
6. [Azure Linux Virtual Machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)
7. `random_string` Resource
- We will use Azure `custom_data` argument in `azurerm_linux_virtual_machine` to install a simple webserver during the creation of VM.
- [Terraform file Function](https://www.terraform.io/docs/language/functions/file.html)
- [Terraform filebase64 Function](https://www.terraform.io/docs/language/functions/filebase64.html)

## Step-02: Create SSH Keys for Azure Linux VM
```t
# Create Folder
cd terraform-manifests/
mkdir ssh-keys

# Create SSH Key
cd ssh-ekys
ssh-keygen \
    -m PEM \
    -t rsa \
    -b 4096 \
    -C "azureuser@myserver" \
    -f terraform-azure.pem 
Important Note: If you give passphrase during generation, during everytime you login to VM, you also need to provide passphrase.

# List Files
ls -lrt ssh-keys/

# Files Generated after above command 
Public Key: terraform-azure.pem.pub -> Rename as terraform-azure.pub
Private Key: terraform-azure.pem

# Permissions for Pem file
chmod 400 terraform-azure.pem
```  

## Step-03: c1-versions.tf - Create Terraform & Provider Blocks 
- Create Terraform Block
- Create Provider Block
- Create Random Resource Block
```t
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Provider Block
provider "azurerm" {
 features {}          
}

# Random String Resource
resource "random_string" "myrandom" {
  length = 6
  upper = false 
  special = false
  number = false   
}
```
## Step-04: c2-resource-group.tf
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg-1"
  location = "East US"
}
```

## Step-05: c3-vritual-network.tf - Virtual Network Resource
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

## Step-06: c3-vritual-network.tf  - Azure Subnet Resource
```t
# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
```
## Step-07: c3-vritual-network.tf  - Azure Public IP Resource
```t

# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label = "app1-vm-${random_string.myrandom.id}"
  tags = {
    environment = "Dev"
  }
}
``` 
## Step-08: c3-vritual-network.tf  - Network Interface Resource
```t

# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  name                = "vmnic"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
}
```

## Step-09: c4-linux-virtual-machine.tf
```t
# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  name                = "mylinuxvm-1"
  computer_name       = "devlinux-vm1" # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.myvmnic.id
  ]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
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

## Step-10: app1-cloud-init.txt
```t
#cloud-config
package_upgrade: false
packages:
  - httpd
write_files:
  - owner: root:root 
    path: /var/www/html/index.html
    content: |
      <h1>Welcome to StackSimplify - APP-1</h1>
  - owner: root:root 
    path: /var/www/html/app1/index.html
    content: |
      <!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - APP-1</h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>      
runcmd:
  - sudo systemctl start httpd  
  - sudo systemctl enable httpd
  - sudo systemctl stop firewalld
  - sudo mkdir /var/www/html/app1 
  - [sudo, curl, -H, "Metadata:true", --noproxy, "*", "http://169.254.169.254/metadata/instance?api-version=2020-09-01", -o, /var/www/html/app1/metadata.html]
```

## Step-11: Execute Terraform commands to Create Resources using Terraform
```t
# Initialize Terraform
terraform init

# Terraform Validate
terraform validate

# Terraform Plan 
terraform plan

# Terraform Apply 
terraform apply 
```

## Step-12: Verify the Resources
- Verify Resources
1. Azure Resource Group
2. Azure Virtual Network
3. Azure Subnet
4. Azure Public IP
5. Azure Network Interface
6. Azure Virtual Machine
```t
# Connect to VM and Verify 
ssh -i ssh-keys/terraform-azure.pem azureuser@<PUBLIC-IP>

# Access Application
http://<PUBLIC_IP>
http://<PUBLIC_IP>/app1
http://<PUBLIC_IP>/app1/metadata.html
```


## Step-13: Destroy Terraform Resources
```t
# Destroy Terraform Resources
terraform destroy

# Remove Terraform Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## References 
1. [Azure Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
2. [Azure Virtual Network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
3. [Azure Subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
4. [Azure Public IP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)
5. [Azure Network Interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)
6. [Azure Virtual Machine]
7. (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)


-----------------------------------------------------------------------------------------------------------------------

### Detailed Explanation:

### Step-01: Introduction

In this tutorial, you will learn to create a set of Azure resources using Terraform. The primary resources include:

1. Azure Resource Group: A logical container for managing related resources.
2. Azure Virtual Network: A private network in Azure that allows for secure communication between resources.
3. Azure Subnet: A sub-network within a Virtual Network that segments the network logically.
4. Azure Public IP: Assigns an IP address accessible from the internet.
5. Azure Network Interface (NIC): Connects a Virtual Machine (VM) to the Azure network.
6. Azure Linux Virtual Machine: Deploys a virtualized instance running Linux.
7. random_string` Resource: Generates random strings to create unique resource names.

Terraform's custom_data argument in azurerm_linux_virtual_machine is used for running scripts during the VM creation process to set up a web server automatically. The [Terraform file function]

(https://www.terraform.io/docs/language/functions/file.html) reads local files, and the [Terraform `filebase64` function](https://www.terraform.io/docs/language/functions/filebase64.html) reads and encodes files as Base64.

### Step-02: Create SSH Keys for Azure Linux VM

This step covers generating SSH keys for secure authentication when connecting to the Azure VM.

1. Create a directory to store the keys:
   
   cd terraform-manifests/
   mkdir ssh-keys
   

2. Generate the SSH keys:
   
   ssh-keygen -m PEM -t rsa -b 4096 -C "azureuser@myserver" -f terraform-azure.pem
   
   - This command creates a public and private key pair. If a passphrase is used, it will be needed for future logins.

3. List and rename the public key:
   
   ls -lrt ssh-keys/
   mv terraform-azure.pem.pub terraform-azure.pub
   

4. Set permissions:
   
   chmod 400 terraform-azure.pem
   

### Step-03: Create c1-versions.tf - Terraform and Provider Blocks

This step sets up the configuration for the Terraform provider and required versions.

- Terraform Block defines required versions of Terraform and providers:
   
   terraform {
     required_version = ">= 1.0.0"
     required_providers {
       azurerm = { source = "hashicorp/azurerm", version = ">= 2.0" }
       random  = { source = "hashicorp/random", version = ">= 3.0" }
     }
   }
   

- Provider Block specifies configuration settings for the Azure provider:
   
   provider "azurerm" {
     features {}
   }
   

- Random String Resource generates a unique string to help name resources:
   
   resource "random_string" "myrandom" {
     length = 6
     upper = false
     special = false
     number = false
   }
   

### Step-04: Create c2-resource-group.tf

Defines an Azure Resource Group:

resource "azurerm_resource_group" "myrg" {
  name     = "myrg-1"
  location = "East US"
}


### Step-05: Create c3-virtual-network.tf - Virtual Network Resource

Defines the Virtual Network:

resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}


### Step-06: Create Azure Subnet Resource

Defines the subnet within the Virtual Network:

resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}


### Step-07: Create Azure Public IP Resource

Defines a static public IP address:

resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label   = "app1-vm-${random_string.myrandom.id}"
  tags = {
    environment = "Dev"
  }
}


### Step-08: Create Network Interface Resource

Links the VM to the subnet and public IP:

resource "azurerm_network_interface" "myvmnic" {
  name                = "vmnic"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id
  }
}


### Step-09: Create c4-Linux-virtual-machine.tf

Defines the Linux VM configuration:

resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  name                = "mylinuxvm-1"
  computer_name       = "devlinux-vm1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.myvmnic.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

  os_disk {
    name                 = "osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }

  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
}


### Step-10: Cloud-Init Configuration (app1-cloud-init.txt)

Sets up the web server:

#cloud-config

package_upgrade: false
packages:
  - httpd
write_files:
  - owner: root:root 
    path: /var/www/html/index.html
    content: |
      <h1>Welcome to StackSimplify - APP-1</h1>
  - owner: root:root 
    path: /var/www/html/app1/index.html
    content: |
      <!DOCTYPE html> <html> <body style="background-color:RGB(250, 210, 210);"> <h1>Welcome to Stack Simplify - APP-1</h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>
run cmd:
  - sudo systemctl start httpd
  - sudo systemctl enable httpd
  - sudo systemctl stop firewalld
  - sudo mkdir /var/www/html/app1
  - [sudo, curl, -H, "Metadata:true", --noproxy, "*", "http://169.254.169.254/metadata/instance?api-version=2020-09-01", -o, /var/www/html/app1/metadata.html]


### Step-11: Execute Terraform Commands

Commands to create the infrastructure:

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Preview the plan
terraform plan

# Apply the plan
terraform apply


### Step-12: Verify the Resources

Connect to the VM and access the deployed web application:

# Connect to the VM
ssh -i ssh-keys/terraform-azure.pem azureuser@<PUBLIC-IP>

# Access the web application

http://<PUBLIC_IP>
http://<PUBLIC_IP>/app1
http://<PUBLIC_IP>/app1/metadata.html


### Step-13: Destroy Resources

To remove the resources:

# Destroy resources

terraform destroy

# Clean up Terraform files

rm -rf .terraform
rm -rf terraform.tfstate


This process builds a scalable infrastructure in Azure using Terraform, enhances understanding of IaaC principles, and deploys an automated VM setup with a basic web server.
