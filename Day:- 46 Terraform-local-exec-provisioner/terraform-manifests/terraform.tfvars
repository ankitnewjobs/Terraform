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

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

- In Terraform/most configs, lines starting with # are comments.

- Example:
  - # Generic Variables is just a header to indicate which variables are general-purpose.
  - #environment = "dev" shows a variable that’s currently commented out (so not being used at the moment).

#### 2. Generic Variables

business_unit = "it"
#environment = "dev"

- business_unit → A logical grouping label (“it” for Information Technology). Often used in naming or tagging conventions, e.g., rg-it-eastus.
- environment (commented) → Would represent deployment stage (dev, test, prod, etc.). It’s commented out, so it's currently inactive.

#### 3. Resource Variables

These define resource names and configuration values for Azure infrastructure (judging by resource_group, eastus, etc.).

resoure_group_name  = "rg"

- Name of the resource group in Azure where all related resources are organized.
- "rg" is a shorthand name; in real infra, you’d use something more descriptive (e.g., rg-it-dev-eastus).

resoure_group_location = "eastus"

- Defines the Azure region where resources will be deployed. "eastus" is one of Azure’s geographic regions.

virtual_network_name   = "vnet"

- Name of the Virtual Network (VNet), which provides private IP space for resources.

subnet_name = "subnet"

- A subnet inside the virtual network. Subnets enable the division of a VNet into smaller IP ranges, allowing for the segmentation of workloads.

publicip_name = "publicip"

- Name of the Public IP Address resource. This would allow external (internet) access to a VM, load balancer, or other service.

network_interface_name = "nic"

- Defines the name of the Network Interface Card (NIC) resource, which connects a VM’s network layer to the subnet and optionally to a public IP.

virtual_machine_name = "vm"

- Name of the Virtual Machine (VM) that will be deployed, which uses:
  - The NIC (to connect to the network),
  - The subnet (inside the VNet for routing),
  - The resource group & region.
