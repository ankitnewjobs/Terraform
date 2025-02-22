# Create Virtual Network

resource "azurerm_virtual_network" "myvnet" {
  count = 4
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}-${count.index}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

Let's examine the Terraform code for creating an Azure Virtual Network (VNet) using the azurerm_virtual_network resource in detail.

## 1. Resource Block

resource "azurerm_virtual_network" "myvnet" {

- The resource block is used to define an infrastructure resource in Terraform.  
- azurerm_virtual_network specifies the type of resource being created. This is a built-in Terraform provider for Azure, representing an Azure Virtual Network.  
- "myvnet" is the logical name used within the Terraform configuration to reference this specific resource. It does not affect the Azure resource itself but is useful for internal references.  

## 2. Count Meta-Argument

count = 4

- The count argument is used to create multiple instances of the resource.  
- In this case, count = 4 means Terraform will create 4 virtual networks.  
- Each instance can be referenced with count.index, which is a zero-based index (0, 1, 2, 3).

## 3. Name Attribute

name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}-${count.index}"

- This defines the name of each virtual network.  

- The interpolation syntax ${} allows the use of variables within strings.  

- The final name is constructed using the following variables:  
  - ${var.business_unit} → Defaults to "hr"  
  - ${var.environment} → Defaults to "poc" 
  - ${var.virtual_network_name} → Defaults to "myvnet" 
  - ${count.index} → Appends the instance number (0, 1, 2, 3)  

Example of generated names:

hr-poc-myvnet-0
hr-poc-myvnet-1
hr-poc-myvnet-2
hr-poc-myvnet-3

## 4. Address Space

address_space = ["10.0.0.0/16"]

- This specifies the CIDR block for the virtual network, defining the IP address range for the entire VNet.  
- 10.0.0.0/16 allows 65,536 IP addresses, ranging from 10.0.0.0 to 10.0.255.255.  
- You can create subnets within this address space.  

## 5. Location Attribute

location = azurerm_resource_group.myrg.location

- Specifies the Azure region where the virtual network will be deployed.  
- Instead of hardcoding a region like "East US", it references the location of the resource group defined elsewhere in the code (azurerm_resource_group.myrg).  
- This ensures that the VNet is deployed in the same region as the resource group, maintaining consistency.  

## 6. Resource Group Name

resource_group_name = azurerm_resource_group.myrg.name

- Specifies the Azure Resource Group where the VNet will be created.  
- This references the name of the existing resource group azurerm_resource_group.myrg.  

## Final Example of Created VNets

Assuming the following variable defaults: 

- business_unit = "hr" 
- environment = "poc" 
- virtual_network_name = "myvnet" 
- count = 4

Terraform will create 4 virtual networks with the following properties:  

| Instance Index | Name             | Address Space  | Location | Resource Group   |
|----------------|------------------|----------------|----------|------------------|
| 0              | hr-poc-myvnet-0  | 10.0.0.0/16    | East US   | myrg            |
| 1              | hr-poc-myvnet-1  | 10.0.0.0/16    | East US   | myrg            |
| 2              | hr-poc-myvnet-2  | 10.0.0.0/16    | East US   | myrg            |
| 3              | hr-poc-myvnet-3  | 10.0.0.0/16    | East US   | myrg            |

## How to Apply This Code?

1. Initialize Terraform: terraform init

2. Preview the Plan: terraform plan

3. Apply the Configuration: terraform apply

## Key Takeaways:

1. Dynamic Resource Creation: The count argument allows you to create multiple resources without duplicating code.  
2. Interpolation: Variables like ${var.business_unit} and ${count.index} enable flexible resource naming.  
3. Resource Dependencies: By referencing azurerm_resource_group.myrg, the VNet is automatically deployed in the correct location and resource group.  

## Possible Improvements:

1. Address Space per VNet: You might want to vary the address space for each VNet using count.index like this:  

address_space = ["10.${count.index}.0.0/16"]

2. Avoid Hardcoding: Instead of using East US for location, always reference variables or existing resources for flexibility.
