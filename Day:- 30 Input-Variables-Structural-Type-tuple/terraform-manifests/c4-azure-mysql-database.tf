# Azure MySQL Database Server

resource "azurerm_mysql_server" "mysqlserver" {
  name                = "${var.business_unit}-${var.environment}-${var.db_name}" 
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  administrator_login          = var.db_username
  administrator_login_password = var.db_password

  #sku_name   = "B_Gen5_2" # Basic Tier
  sku_name = "GP_Gen5_2"   # General Purpose Tier
  /*
  expected sku_name to be one of [B_Gen4_1 B_Gen4_2 B_Gen5_1 B_Gen5_2 GP_Gen4_2 GP_Gen4_4 GP_Gen4_8 GP_Gen4_16 GP_Gen4_32 GP_Gen5_2 GP_Gen5_4 GP_Gen5_8 GP_Gen5_16 GP_Gen5_32 GP_Gen5_64 MO_Gen5_2 MO_Gen5_4 MO_Gen5_8 MO_Gen5_16 MO_Gen5_32], got 
  */
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

/*
  threat_detection_policy {
    enabled = true
    retention_days = 10
    email_account_admins = true
    email_addresses = [ "dkalyanreddy@gmail.com", "stacksimplify@gmail.com" ]
  }  
*/
/* #Structure Type: object()
  threat_detection_policy {
    enabled = var.tdpolicy.enabled
    retention_days = var.tdpolicy.retention_days
    email_account_admins = var.tdpolicy.email_account_admins
    email_addresses = var.tdpolicy.email_addresses    
  }
*/  
  threat_detection_policy {
    enabled = var.tdpolicy[0]
    retention_days = var.tdpolicy[1]
    email_account_admins = var.tdpolicy[2]
    email_addresses = var.tdpolicy[3]
  }  
}

# Create Database inside Azure MySQL Database Server

resource "azurerm_mysql_database" "webappdb1" {
  name                = "webappdb1"
  resource_group_name = azurerm_resource_group.myrg.name
  server_name         = azurerm_mysql_server.mysqlserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

--------------------------------------------------------------------------------------------------------------------------------------

# Explanation:- 

This Terraform configuration defines resources to deploy and manage an Azure MySQL Database Server and a MySQL Database inside it.

Here's a detailed breakdown:

### Resource: azurerm_mysql_server

This resource defines the Azure MySQL Server with specific configurations:

#### 1. Naming

name = "${var.business_unit}-${var.environment}-${var.db_name}"

- Dynamically generates the server name using variables for the business unit, environment, and database name.

- Example: "hr-dev-mydb" if:
  - business_unit = "hr",
  - environment = "dev", and
  - db_name = "mydb".

#### 2. Location and Resource Group

location            = azurerm_resource_group.myrg.location
resource_group_name = azurerm_resource_group.myrg.name

- Ensures the MySQL Server is deployed in the same location and resource group as the referenced azurerm_resource_group resource.

#### 3. Administrator Credentials

administrator_login          = var.db_username
administrator_login_password = var.db_password

- Uses the db_username and db_password variables for admin credentials.
- Both are sensitive variables to enhance security.

#### 4. SKU (Performance Tier)

sku_name = "GP_Gen5_2" 

The general Purpose Tier is selected for moderate workloads with consistent performance.

- Possible values:

  - Basic Tier: B_Gen4_1, B_Gen5_2, etc.
  - General Purpose: GP_Gen4_2, GP_Gen5_8, etc.
  - Memory Optimized: MO_Gen5_4, MO_Gen5_32, etc.

#### 5. Storage and Version

storage_mb = var.db_storage_mb
version    = "8.0"

- storage_mb: Sets database storage size in MB (e.g., 5120 for 5 GB). 
- version: Specifies MySQL version (8.0 here).

#### 6. Features and Settings

- Auto-Grow: Automatically adjusts storage as needed:
  
  auto_grow_enabled = var.db_auto_grow_enabled
  
- Backup: Configures backup retention and geo-redundancy:
  
  backup_retention_days = 7
  geo_redundant_backup_enabled = false
  
- Infrastructure Encryption: Additional encryption layer for sensitive data:
  
  infrastructure_encryption_enabled = false
  
- Network Access:

  - Allows public access to testing/dev environments:
  
    public_network_access_enabled = true
    
  - SSL Enforcement is disabled for simplicity in dev environments:
    
    ssl_enforcement_enabled = false
    
    - Can be enforced in production with:
      
      ssl_enforcement_enabled = true
      ssl_minimal_tls_version_enforced = "TLS1_2"
      

#### 7. Tags

tags = var.common_tags

- Adds consistent tags to the MySQL server, e.g., "CLITool": "Terraform".

#### 8. Threat Detection Policy

Defines security policies for the database:

- Uses tuple variables to define policy attributes:
  
  threat_detection_policy {
    enabled = var.tdpolicy[0]
    retention_days = var.tdpolicy[1]
    email_account_admins = var.tdpolicy[2]
    email_addresses = var.tdpolicy[3]
  }
  
- Example: 
  
  var.tdpolicy = [true, 30, true, ["admin@example.com", "security@example.com"]]
  
### Resource: azurerm_mysql_database

Defines a MySQL database inside the Azure MySQL Server.

#### 1. Naming

name = "webappdb1"

- The database is explicitly named webappdb1.

#### 2. Dependencies

- Resource Group:
  
  resource_group_name = azurerm_resource_group.myrg.name
  
- MySQL Server:
  
  server_name = azurerm_mysql_server.mysqlserver.name
  

#### 3. Charset and Collation

- Charset: Specifies the database's character set:
  
  charset = "utf8"
  
- Collation: Defines how string comparisons are handled:

  collation = "utf8_unicode_ci"

### How This Works

1. Resource Deployment:

   - Deploys the Azure MySQL Server with admin credentials, storage, backup policies, and threat detection enabled.
   - A MySQL database (webappdb1) is created inside the server.

2. Dynamic Configuration:
   - Variables ensure flexibility and reusability across environments (e.g., dev, prod).

3. Security Features:
   - Secure credentials via sensitive variables.
   - Optional threat detection policies for enhanced monitoring.

4. Network and SSL:
   - Public access is enabled for development but can be disabled for production.
   - TLS enforcement can be applied.

### Potential Improvements

1. Parameterize All Fields:
   - Fields like backup_retention_days and ssl_minimal_tls_version_enforced can also be variables for more flexibility.

2. Environment-Specific Configurations:
   - Use terraform.tfvars files to define different settings for environments like dev and prod.

3. Enable Infrastructure Encryption:
   - Set infrastructure_encryption_enabled = true for sensitive workloads.
