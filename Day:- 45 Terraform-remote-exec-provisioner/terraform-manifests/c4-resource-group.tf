# Resource-1: Azure Resource Group

resource "azurerm_resource_group" "myrg" 
{
  name = local.rg_name
  location = var.resoure_group_location
  tags = local.common_tags
}

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

#### 1. resource "azurerm_resource_group" "myrg"

- resource: This keyword declares that you are managing an infrastructure resource.
- "azurerm_resource_group": This specifies the resource type. azurerm_resource_group instructs Terraform to manage an Azure Resource Group.
- "myrg": This is the name/label for this particular resource instance within your Terraform configuration.

#### 2. { ... }: Resource Block Body

- Everything within the curly brackets defines properties for your resource.

##### a. name = local.rg_name

- name: Required argument—the Azure Resource Group's name.
- local.rg_name: This gets its value from a local value called rg_name. Local values are defined elsewhere in Terraform with the locals block. They help avoid duplication or complex expressions.

##### b. location = var.resoure_group_location

- location: Required argument—the Azure region where the Resource Group will be created (e.g., "East US", "West Europe").
- var.resource_group_location: This references a variable called resource_group_location. The value is supplied via a variables file, an environment variable, or Terraform. tfvars.

##### c. tags = local.common_tags

- tags: Optional argument—key/value pairs assigned to the Resource Group for categorization.
- local.common_tags: Again, refers to a local value that probably contains a map of tags, like { Environment = "Dev", Owner = "Alice" }.

### What does this code do?

- Creates an Azure Resource Group with a specific name, in a specific Azure location, and with applied tags.  
- The name and tags are determined by local values defined elsewhere.  
- The location is set from a variable input.

### Additional Context

Suppose you have these elsewhere in your configuration:

locals
{
  rg_name     = "my-app-rg"
  common_tags = 
{
    Environment = "Development"
    Owner       = "Alice"
  }
}

variable "resource_group_location"
{
  type    = string
  default = "East US"
}

### Summary Table

|  Property    |     Value Source             |          Purpose                      |
|--------------|------------------------------|---------------------------------------|
|  name        |   local.rg_name              |  Name of the Resource Group           |
|  location    |   var.resoure_group_location |  Azure region for Resource Group      |
|  tags        |   local.common_tags          |  Metadata tags for Resource Group     |
