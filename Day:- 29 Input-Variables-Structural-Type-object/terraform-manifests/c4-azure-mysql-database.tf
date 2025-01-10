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
  threat_detection_policy {
    enabled = var.tdpolicy.enabled
    retention_days = var.tdpolicy.retention_days
    email_account_admins = var.tdpolicy.email_account_admins
    email_addresses = var.tdpolicy.email_addresses
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

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation:- 

This Terraform script creates an Azure MySQL Database Server and a MySQL Database within it. 

### Azure MySQL Database Server

#### 1. Resource Definition

resource "azurerm_mysql_server" "mysqlserver" {

This defines an Azure MySQL Server resource in Terraform. 

The identifier azurerm_mysql_server.mysqlserver is used to reference this resource throughout the configuration.

#### 2. Server Configuration

- Name:
  
  name = "${var.business_unit}-${var.environment}-${var.db_name}"
  
  - Dynamically constructs the server name using input variables (business_unit, environment, and db_name).
  - Example: If business_unit = "finance", environment = "prod", and db_name = "mydb", the server name will be finance-prod-mydb.

- Location:
  
  location = azurerm_resource_group.myrg.location
  
  - Uses the location of the resource group (azurerm_resource_group.myrg) where the server will reside.

- Resource Group:
  
  resource_group_name = azurerm_resource_group.myrg.name
  
  - Associates the server with the resource group (myrg).

#### 3. Administrator Login

administrator_login = var.db_username
administrator_login_password = var.db_password

- Specifies the admin credentials for the MySQL server using variables (db_username and db_password).

#### 4. SKU Configuration

sku_name = "GP_Gen5_2"

- Defines the SKU (pricing tier) for the server. In this case:
  - General Purpose Tier, 2 vCores.
  - Suitable for production workloads with balanced performance and cost.

- Note:
  - The supported values for sku_name are listed in the comment for reference:
    
    B_Gen4_1, B_Gen4_2, GP_Gen5_4, etc.
    
  - The Basic Tier (B_Gen5_2) is commented out because the Threat Detection Policy isn’t supported for the Basic Tier.

#### 5. Storage and Version

storage_mb = var.db_storage_mb
version = "8.0"

- Configures:
  - storage_mb: Storage size in MB, passed via variable.
  - version: Specifies MySQL version (e.g., 8.0).

#### 6. Additional Settings

auto_grow_enabled = var.db_auto_grow_enabled
backup_retention_days = 7
geo_redundant_backup_enabled = false
infrastructure_encryption_enabled = false
public_network_access_enabled = true
ssl_enforcement_enabled = false
tags = var.common_tags

- Auto-grow: Whether to enable auto-scaling of storage.
- Backup Retention: Retains backups for 7 days.
- Geo-Redundant Backup: Disables geo-redundancy for backups.
- Encryption: Infrastructure encryption is disabled.
- Public Network Access: Enables access to the server over the public internet.
- SSL: Disables SSL enforcement.
- Tags: Applies tags for resource management.

#### 7. Threat Detection Policy

threat_detection_policy {
  enabled = var.tdpolicy.enabled
  retention_days = var.tdpolicy.retention_days
  email_account_admins = var.tdpolicy.email_account_admins
  email_addresses = var.tdpolicy.email_addresses
}

- Configures a Threat Detection Policy for the server.

- Uses input variables (tdpolicy) for flexibility.
  
  - Fields:
    - enabled: Whether threat detection is enabled.
    - retention_days: Number of days to retain threat detection data.
    - email_account_admins: Sends alerts to account admins.
    - email_addresses: List of email recipients.

### Azure MySQL Database

#### 1. Resource Definition

resource "azurerm_mysql_database" "webappdb1" {

Defines a MySQL database within the server.

#### 2. Database Configuration

name = "webappdb1"
resource_group_name = azurerm_resource_group.myrg.name
server_name = azurerm_mysql_server.mysqlserver.name
charset = "utf8"
collation = "utf8_unicode_ci"

- Name:
  - Specifies the database name as `webappdb1`.

- Resource Group:
  - Associates the database with the same resource group as the server.

- Server Name:
  - Links the database to the server created earlier.

- Charset & Collation:
  - Configures database character set (utf8) and collation (utf8_unicode_ci).

### Summary

This configuration:

1. Creates an Azure MySQL Server with General Purpose Tier, MySQL version 8.0, and storage defined via input variables.
2. Implements a flexible Threat Detection Policy using an object variable (tdpolicy).
3. Creates a database (webappdb1) within the server with UTF-8 encoding and collation.

### Key Benefits

- Dynamic and Flexible:
  - Uses variables for key configurations, making it reusable and environment-agnostic.

- Security:
  - Includes Threat Detection Policy to monitor suspicious activities.

- Scalability:
  - Enables auto-grow for storage.

- Production-Ready:
  - Configures a robust MySQL server suitable for general-purpose workloads.
