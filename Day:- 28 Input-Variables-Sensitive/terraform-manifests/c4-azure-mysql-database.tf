# Azure MySQL Database Server
resource "azurerm_mysql_server" "mysqlserver" {
  name                = "${var.business_unit}-${var.environment}-${var.db_name}"  # This needs to be globally unique within Azure.
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  administrator_login          = var.db_username
  administrator_login_password = var.db_password

  sku_name   = "B_Gen5_2"
  storage_mb = var.db_storage_mb
  version    = "8.0"

  auto_grow_enabled                 = var.db_auto_grow_enabled
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = false
  #ssl_minimal_tls_version_enforced  = "TLS1_2"  
  tags = var.common_tags
}

# Create Database inside Azure MySQL Database Server
resource "azurerm_mysql_database" "webappdb1" {
  name                = "webappdb1"
  resource_group_name = azurerm_resource_group.myrg.name
  server_name         = azurerm_mysql_server.mysqlserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: 

This code defines two key resources for deploying and managing an Azure MySQL Database Server and an associated MySQL Database using Terraform. 

Let's break it down step by step, discussing both theoretical and practical aspects of the implementation.

### 1. Azure MySQL Database Server

#### Resource Definition

resource "azurerm_mysql_server" "mysqlserver" {
  name                = "${var.business_unit}-${var.environment}-${var.db_name}"  # This needs to be globally unique within Azure.
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  administrator_login          = var.db_username
  administrator_login_password = var.db_password

  sku_name   = "B_Gen5_2"
  storage_mb = var.db_storage_mb
  version    = "8.0"

  auto_grow_enabled                 = var.db_auto_grow_enabled
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = false
  #ssl_minimal_tls_version_enforced  = "TLS1_2"  
  tags = var.common_tags
}

#### Key Attributes and Their Details

##### 1. name

- What It Does: Creates a globally unique name for the MySQL server in Azure.

- How It Works: Combines variables (business_unit, environment, db_name) to ensure uniqueness and readability.

  - Example: "hr-dev-mydb".

- Practical Use: Naming conventions help identify resources easily across environments.

##### 2. Location and resource_group_name

- What It Does:

  - location: Specifies where the MySQL server will be hosted (e.g., eastus).
  - resource_group_name: Indicates the resource group under which the server is managed.

- How It Works: References existing azurerm_resource_group to ensure resources are logically grouped.

- Practical Use: Consistency in region and resource group reduces cost and improves organization.

##### 3. administrator_login and administrator_login_password

- What It Does:

  - administrator_login: Sets the admin username.
  - administrator_login_password: Sets a secure password for the admin.

- How It Works: Pulls values from sensitive variables (var.db_username and var.db_password).

- Practical Use: Ensures secure access to the database server.

##### 4. sku_name

- What It Does: Specifies the pricing tier and performance level for the server.

  - Example: "B_Gen5_2" indicates a basic tier with 2 vCores.

- Practical Use: Allows cost optimization based on performance requirements.

##### 5. storage_mb

- What It Does: Allocates storage space in MB for the database server.

  - Example: 51200 (50GB).

- Practical Use: Adjustable to meet workload demands.

##### 6. version

- What It Does: Specifies the MySQL version to be used (e.g., 8.0).

- Practical Use: Ensures compatibility with application requirements.

##### 7. Configuration Flags

- auto_grow_enabled:

  - What It Does: Automatically increases storage if usage approaches the allocated limit.

  - Practical Use: Prevents outages due to insufficient storage.

- backup_retention_days:

  - What It Does: Retains database backups for 7 days.

  - Practical Use: Ensures recovery options for disaster recovery scenarios.

- geo_redundant_backup_enabled:

  - What It Does: Disables cross-region backup replication.

  - Practical Use: Saves costs when geo-redundancy isn’t required.

- ssl_enforcement_enabled:

  - What It Does: Disables SSL enforcement for database connections.

  - Practical Use: Can be set to true in production for secure connections.

##### 8. tags

- What It Does: Attaches metadata to the resource for categorization and billing.

- Practical Use: Default tags (e.g., CLITool=Terraform) ensure uniform tagging across all resources.

### 2. Create a Database inside the Azure MySQL Server

#### Resource Definition

resource "azurerm_mysql_database" "webappdb1" {
  name                = "webappdb1"
  resource_group_name = azurerm_resource_group.myrg.name
  server_name         = azurerm_mysql_server.mysqlserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

#### Key Attributes and Their Details

##### 1. name

- What It Does: Specifies the name of the database.

  - Example: "webappdb1".

- Practical Use: Allows application-specific databases to be created on the server.

##### 2. resource_group_name and server_name

- What It Does:

  - resource_group_name: Associates the database with the resource group.
  - server_name: Links the database to the parent MySQL server.

- How It Works: References the previously created azurerm_mysql_server resource.

##### 3. charset and collation

- What It Does:

  - charset: Specifies the character encoding for the database (utf8 for wide compatibility).
  - collation: Defines the collation rules (e.g., utf8_unicode_ci for case-insensitive sorting).

- Practical Use: Ensures the database supports the application’s language and sorting requirements.

### Practical Workflow

1. Define Variables: Populate required variables for server and database creation.
   
   terraform apply -var="db_name=mydb" -var="db_username=admin" -var="db_password=securepassword"
   
2. Initialize Resources: Terraform validates and plans the configuration:
   
   terraform init
   terraform plan
   
3. Deploy Resources: Apply the plan to provision resources in Azure:
   
   terraform apply

4. Validate Deployment:

   - Check the Azure portal for the resource group, server, and database.
   - Use tools like MySQL Workbench to test connectivity.

### Security Considerations

1. Sensitive Variables:

   - Avoid hardcoding db_password in Terraform code.
   - Use a secure secrets management solution (e.g., Azure Key Vault).

2. SSL Enforcement:

   - Set ssl_enforcement_enabled to true for production environments to secure connections.

3. Access Control:
   - Limit public access (public_network_access_enabled = false) and use private endpoints for secure connectivity.

### Use Cases

1. Web Applications: Host application-specific databases.
2. Data Analysis: Store structured data for analytics pipelines.
3. Testing Environments: Quickly spin up isolated environments for testing.
