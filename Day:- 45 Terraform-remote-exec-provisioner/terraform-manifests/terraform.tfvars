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

#### 1. Comments

- # Generic Variables
- # Resource Variables

  - What It Means: 

    These lines are comments, not code. They help developers understand and organize the code.

    - # Generic Variables declares that the next few lines are more general configuration variables.
    - # Resource Variables means that the next set of variables is related to specific resource names for the cloud infrastructure.

#### 2. business_unit = "it"

- Purpose:   Stores the business unit this infrastructure is related.

- Value:  "it" suggests this is for the IT department.

- Usage: This can be used for naming, tagging, or organizing cloud resources.

#### 3. #environment ="dev"

- Purpose: Would store the environment type (like dev, test, prod), but it's commented out (disabled).  
- Usage: If you remove the #, this variable could help to differentiate resources based on their deployment environment.

#### 4. resoure_group_name = "rg"

- Purpose: The name for the resource group.
- Resource Group: In Azure, a Resource Group is a logical container for multiple resources (VMs, networks, databases, etc.).
- Value: "rg" is a placeholder; usually, you’d use something more descriptive.

#### 5. resoure_group_location = "eastus"

- Purpose: The location/region where resources will be deployed.
- Value: "eastus" refers to the US East Azure region.

#### 6. virtual_network_name = "vnet"

- Purpose: The name of the virtual network in Azure.
- Value: "vnet" as a placeholder; normally, you might have more details in the name

#### 7. subnet_name = "subnet"

- Purpose:  The name used for the subnet within the virtual network.
- Value: "subnet" is generic—should be customized for clarity.

#### 8. publicip_name = "publicip"

- Purpose: The name for the public IP address resource for the VM or services.
- Value: "publicip" again, placeholder.

#### 9. network_interface_name = "nic"

- Purpose: The name used for the network interface that connects the VM to the network.
- Value: "nic" is a common abbreviation for network interface card.

#### 10. virtual_machine_name = "vm"

- Purpose: The name for the virtual machine being deployed.
- Value: "vm" is very generic, typically you’d use more detail to distinguish it.
