# Generic Variables

business_unit = "it"
#environment = "dev"

# Resource Variables

resoure_group_name = "rg"
resoure_group_location = "eastus"
virtual_network_name = "vnet"
subnet_name = "subnet"
publicip_name = "publicip"
network_interface_name = "nic"
virtual_machine_name = "vm"

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### 1. Generic Variables

business_unit = "it"
#environment = "dev"

* business_unit = "it"

  This defines a **generic variable** that indicates the business unit for which this infrastructure is being deployed. 
  In this case, it’s set to "it" (perhaps Information Technology).

* #environment = "dev"
  This line is commented out, so it's not active. But it implies the presence of an environment-specific variable.
  If uncommented, `environment = "dev" could be used to deploy infrastructure to a development environment (dev, qa, staging, prod).

### 2. Resource Variables

These are variable names likely used for naming Azure resources.

resoure_group_name = "rg"
resoure_group_location = "eastus"

* resoure_group_name = "rg"
  This defines the name of the Azure Resource Group. Resource groups in Azure are logical containers that group resources like VMs, networks, databases, etc.

* resoure_group_location = "eastus"
  Defines the Azure region where the resource group and its associated resources will be deployed. eastus refers to the East US region.

 virtual_network_name = "vnet"
  subnet_name = "subnet"

* virtual_network_name = "vnet"
  Sets the name for the Virtual Network (VNet). VNets in Azure enable communication between resources, such as VMs.

* subnet_name = "subnet"
  Defines the name of the subnet inside the VNet. Subnets divide a VNet into smaller segments, often used to organize or isolate workloads.

 publicip_name = "publicip"

* publicip_name = "publicip"
  Defines the name of the Public IP Address resource. This is typically assigned to a VM or load balancer to allow access from the internet.

network_interface_name = "nic"

* network_interface_name = "nic"
  Defines the name of the Network Interface (NIC). NICs are attached to VMs and connect them to VNets and subnets.

virtual_machine_name = "vm"

* virtual_machine_name = "vm"
  Sets the name of the Virtual Machine resource. This is the actual compute instance that will run your OS and applications

### Summary Table

|     Variable Name          |    Value    |                Description                             |
| -------------------------- | ----------- | ------------------------------------------------ ----- |
|  business_unit             |  "it"       |  Indicates the business unit (used for naming/tagging) |
|  environment (commented)   |  "dev"      |  Specifies the environment type (e.g., dev, prod)      |
|  resoure_group_name        |  "rg"       |  Name of the Azure Resource Group                      |
|  resoure_group_location    |  "eastus"   |  Region where resources will be deployed               |
|  virtual_network_name      |  "vnet"     |  Name of the Virtual Network                           |
|  subnet_name               |  "subnet"   |  Name of the Subnet within the VNet                    |
|  publicip_name             |  "publicip" |  Name of the Public IP resource                        |
|  network_interface_name    |  "nic"      |  Name of the Network Interface Card (NIC)              |
|  virtual_machine_name      |   "vm"      |  Name of the Virtual Machine                           |

