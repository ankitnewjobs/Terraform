---
title: Terraform Resource Meta-Argument depends_on
description: Learn Terraform Resource Meta-Argument depends_on
---

## Step-01: Introduction
- We will create the below Azure Resources using Terraform
1. Azure Resource Group
2. Azure Virtual Network
3. Azure Subnet
4. Azure Public IP
5. Azure Network Interface
- Use `depends_on` Resource Meta-Argument attribute when creating Azure Public IP


## Step-02: c1-versions.tf - Create Terraform & Provider Blocks 
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
## Step-03: c2-resource-group.tf
```t
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg-1"
  location = "East US"
}
```

## Step-04: c3-vritual-network.tf - Virtual Network Resource
```t
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

## Step-05: c3-vritual-network.tf  - Azure Subnet Resource
```t
# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
```
## Step-06: c3-vritual-network.tf  - Azure Public IP Resource
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
## Step-07: c3-vritual-network.tf  - Network Interface Resource
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

## Step-08: Execute Terraform commands in terraform-manifests-v1
```t
# Change Directory
cd terraform-manifests-v1

# Initialize Terraform
terraform init

# Terraform Validate
terraform validate

# Terraform Plan 
terraform plan

# Terraform Apply 
terraform apply 

# Observation
1. Public IP Resource will get created in parallel with Virtual Network Resource

# Terraform Destroy 
terraform destroy -auto-approve

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Step-09: c3-virtual-network.tf - depends_on for azurerm_public_ip
-  We will review this in `terraform-manifests-v2` folder
```t

# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  # Add Explicit Dependency to have this resource created only after Virtual Network and Subnet Resources are created. 
  depends_on = [
    azurerm_virtual_network.myvnet,
    azurerm_subnet.mysubnet
  ]
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

## Step-10: Execute Terraform commands in terraform-manifests-v2
```t
# Change Directory
cd terraform-manifests-v2

# Initialize Terraform
terraform init

# Terraform Validate
terraform validate

# Terraform Plan 
terraform plan

# Terraform Apply 
terraform apply 

# Observation
1. Public IP Resource will get created only afer Virtual Network and Subnet Resource got created.
2. As we have defined explicit dependency `depends_on` in Public IP Resource, it will wait till those two other resources got created. 
3. Important Point to remember is "Explicitly specifying a dependency is only necessary when a resource or module relies on some other resource's behavior but doesn't access any of that resource's data in its arguments."

# Terraform Destroy 
terraform destroy -auto-approve

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
```



## References 
1. [Azure Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
2. [Azure Virtual Network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
3. [Azure Subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
4. [Azure Public IP](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)
5. [Azure Network Interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)
6. [Azure Virtual Machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)

-----------------------------------------------------------------------------------------------------------------------

Explanations: - 

### Step-01: Introduction

- Azure Resource Group: This container holds related resources for an Azure solution. It allows you to manage and organize these resources collectively based on their lifecycle and access control.

- Azure Virtual Network (VNet): Provides an isolated, private network in the Azure cloud. It allows resources such as virtual machines and other services to securely communicate with each other.

- Azure Subnet: A subdivision of an Azure VNet. Subnets help organize and segment the VNet into smaller, manageable networks, enabling better control over traffic flow.

- Azure Public IP: An IP address that allows external communication to resources hosted in Azure. It can be either static (remains constant) or dynamic (changes over time).

- Azure Network Interface (NIC): Connects a virtual machine (VM) to a subnet within a VNet. It holds configuration details, such as IP addresses and security settings, enabling network connectivity for the VM.

depends_on Meta-Argument: An explicit way to define resource creation order. This is necessary when resources don't reference each other directly but should be created in a specific order to avoid issues.

### Step-02: c1-versions.tf - Create Terraform & Provider Blocks

- Terraform Block: The block where you specify the version of Terraform and its required providers. This ensures compatibility and sets up the Terraform environment.
  
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
  
  - required_version: Ensures that the Terraform version is compatible with your scripts.
  - required_providers: Specifies the providers needed for the deployment. Providers are plugins used by Terraform to interact with different services (e.g., Azure, AWS).

- Provider Block:
  
  provider "azurerm" {
    features {}
  }
  
  - azurerm Provider: This block configures Terraform to interact with Azure. The features {} attribute is necessary for Azure provider initialization, even if left empty.

- Random String Resource:
  
  resource "random_string" "myrandom" {
    length = 6
    upper = false
    special = false
    number = false
  }
    
  - random_string Resource: Generates a random string. It's useful for creating unique names for resources to avoid conflicts.

### Step-03: c2-resource-group.tf

- Resource Group:
  
  resource "azurerm_resource_group" "myrg" {
    name = "myrg-1"
    location = "East US"
  }
  
  - azurerm_resource_group: A core resource type in Azure, representing a logical group that helps manage and organize various related resources.
    
  - name: The name of the resource group.
  - location: The Azure region where the resources will be created (e.g., East US).

### Step-04: c3-virtual-network.tf - Virtual Network Resource

- Virtual Network:
  
  resource "azurerm_virtual_network" "myvnet" {
    name = "myvnet-1"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.myrg.location
    resource_group_name = azurerm_resource_group.myrg.name
  }
  
  - azurerm_virtual_network: A resource representing a private network in Azure.
  - address_space: Specifies the range of IP addresses for the VNet, defining its network boundaries.
  - location: Inherits the location from the resource group.
  - resource_group_name: Links the VNet to the specified resource group.

### Step-05: c3-virtual-network.tf - Azure Subnet Resource

- Subnet:
  
  resource "azurerm_subnet" "mysubnet" {
    name = "mysubnet-1"
    resource_group_name = azurerm_resource_group.myrg.name
    virtual_network_name = azurerm_virtual_network.myvnet.name
    address_prefixes = ["10.0.2.0/24"]
  }
  
  - azurerm_subnet: A logical subdivision within a VNet.
  - address_prefixes: Defines the IP range within the subnet, typically a subset of the VNet's address space.

### Step-06: c3-virtual-network.tf - Azure Public IP Resource

- Public IP:
  
  resource "azurerm_public_ip" "mypublicip" {
    name = "mypublicip-1"
    resource_group_name = azurerm_resource_group.myrg.name
    location = azurerm_resource_group.myrg.location
    allocation_method = "Static"
    domain_name_label = "app1-vm-${random_string.myrandom.id}"
    tags = {
      environment = "Dev"
    }
  }
  
  - azurerm_public_ip: Represents a public IP address used for external communication.
  - allocation_method: Specifies whether the IP is Static (remains the same) or Dynamic.
  - domain_name_label: A custom DNS label for the IP, which forms part of the FQDN.
  - tags: Key-value pairs for categorizing and organizing resources (e.g., environment = "Dev").

### Step-07: c3-virtual-network.tf - Network Interface Resource

- Network Interface:
  
  resource "azurerm_network_interface" "myvmnic" {
    name = "vmnic"
    location = azurerm_resource_group.myrg.location
    resource_group_name = azurerm_resource_group.myrg.name

    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.mysubnet.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.mypublicip.id
    }
  }
  
  - azurerm_network_interface: Connects VMs to the VNet.
  - ip_configuration:
  - subnet_id: Associates the NIC with a specific subnet.
  - private_ip_address_allocation: Can be Dynamic (auto-assigned) or Static (fixed).
  - public_ip_address_id: Links a public IP to the NIC for external communication.

### Step-08: Execute Terraform commands

- Commands Explained:
  
  - terraform init: Initializes the working directory by downloading provider plugins.
  - terraform validate: Checks the configuration for syntax errors.
  - terraform plan: Generates an execution plan, showing what Terraform will do.
  - terraform apply: Applies the configuration and creates resources.
  - terraform destroy: Deletes all the resources defined in the configuration.
  - rm -rf .terraform, rm -rf terraform.tfstate: Cleans up the working directory by removing state files and Terraform configurations.

### Step-09: c3-virtual-network.tf - depends_on for azurerm_public_ip

- depends_on:
  
  - Used to explicitly specify that a resource must be created only after other resources.
  - Ensures that resources like the public IP are not created until the VNet and subnet are in place.
  - Example:
    
    resource "azurerm_public_ip" "mypublicip" {
      depends_on = [
        azurerm_virtual_network.myvnet,
        azurerm_subnet.mysubnet
      ]
      
    }
    

### Step-10: Execute Terraform commands in terraform-manifests-v2

- Key Observations:
  
  - By using depends_on, Terraform waits for dependencies to complete before creating the dependent resource.
  - Explicit dependencies are only required when there is no direct reference between resources, but ordering is still necessary.

This detailed breakdown should help you understand each component's role and the reasons behind their configurations in Terraform and Azure deployments.
