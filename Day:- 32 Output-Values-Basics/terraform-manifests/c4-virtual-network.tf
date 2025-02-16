# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Explanation: - 

This **Terraform code** defines an **Azure Virtual Network (VNet)** using the `azurerm_virtual_network` resource block. It dynamically names the VNet, assigns an address space, and associates it with a specific **Azure Resource Group**.

---

## **1. Purpose of This Resource**
- **Creates an Azure Virtual Network (VNet)** that acts as a private network within Azure.
- **Allows subnetting** by defining an address space.
- **Associates the VNet with a specific Resource Group and Region**.
- **Uses input variables** for dynamic configurations.

---

## **2. Breakdown of Each Line**

### **Terraform Resource Block**
```terraform
resource "azurerm_virtual_network" "myvnet" {
```
- `resource` → Defines a new **Azure Virtual Network**.
- `"azurerm_virtual_network"` → The Terraform **resource type** for Azure VNets.
- `"myvnet"` → The local **Terraform identifier** for this VNet (used for references within Terraform).

---

### **Dynamic Naming of the Virtual Network**
```terraform
name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
```
- The **name** is constructed dynamically using Terraform **variables**:
  ```terraform
  "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  ```
- Example:
  - If variables are:
    ```terraform
    business_unit = "it"
    environment = "dev"
    virtual_network_name = "vnet"
    ```
  - The final name will be:
    ```
    it-dev-vnet
    ```

---

### **Defining the Address Space**
```terraform
address_space = ["10.0.0.0/16"]
```
- **Defines the CIDR block** for the VNet.
- `["10.0.0.0/16"]`:
  - Provides **65,536** IP addresses.
  - Covers IP range from `10.0.0.0` to `10.0.255.255`.
  - **Subnets** will be created within this range.

---

### **Assigning the Location**
```terraform
location = azurerm_resource_group.myrg.location
```
- Uses the location from the **Resource Group (`myrg`)**.
- Ensures the VNet is deployed in the **same region** as the Resource Group.
- Example:
  - If the **Resource Group is in `"East US"`**, the VNet will also be in `"East US"`.

---

### **Linking to a Resource Group**
```terraform
resource_group_name = azurerm_resource_group.myrg.name
```
- **Associates the VNet** with the existing Resource Group (`myrg`).
- Example:
  - If the **Resource Group Name** is `"it-dev-rg"`, the VNet will be created inside `"it-dev-rg"`.

---

## **3. Example of a Fully Resolved Configuration**
Let’s assume the following variables:
```terraform
business_unit = "it"
environment = "dev"
virtual_network_name = "vnet"
resoure_group_name = "rg"
resoure_group_location = "East US"
```
The resolved configuration will be:
```terraform
resource "azurerm_virtual_network" "myvnet" {
  name                = "it-dev-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = "it-dev-rg"
}
```
This means:
✅ A Virtual Network named **"it-dev-vnet"** will be created.  
✅ It will be in the **"East US"** region.  
✅ It will belong to the **Resource Group "it-dev-rg"**.  
✅ It will have an **IP range of 10.0.0.0/16**.

---

## **4. Why Is This Code Useful?**
| **Feature** | **Benefit** |
|------------|------------|
| **Dynamic Naming** | Works for multiple environments (dev, test, prod) without hardcoding. |
| **Resource Group Reference** | Ensures the VNet is created in the correct location. |
| **CIDR Definition** | Provides a structured network layout for future subnetting. |
| **Infrastructure as Code (IaC)** | Enables automation and repeatable deployments. |

---

## **5. Next Steps: What Happens After VNet Creation?**
1. **Subnets** can be created inside the VNet.
2. **Network Security Groups (NSGs)** can be associated with subnets.
3. **VMs, Load Balancers, and other Azure resources** can connect to this VNet.

---

## **6. Summary**
This Terraform block **dynamically creates a Virtual Network** by:
✔ Naming it using **business unit, environment, and a custom name**.  
✔ Defining an **IP range** (`10.0.0.0/16`) for subnetting.  
✔ Ensuring it is placed in the **same region as the Resource Group**.  
✔ Associating it with an **existing Resource Group**.

This approach makes the VNet **scalable, reusable, and easy to manage**! 🚀
