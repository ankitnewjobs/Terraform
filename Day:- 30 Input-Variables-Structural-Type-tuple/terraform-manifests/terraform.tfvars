# Generic Variables
business_unit = "it"
environment = "dev"

# Resource Group Variables
resoure_group_name = "rg"
resoure_group_location = "eastus"

# DB Variables
db_name = "mydb101"
db_storage_mb = 5120
db_auto_grow_enabled = true
/*tdpolicy = {
    enabled = true
    retention_days = 10
    email_account_admins = true
    email_addresses = [ "dkalyanreddy@gmail.com", "stacksimplify@gmail.com" ]
}*/
tdpolicy = [true, 10, true, [ "dkalyanreddy@gmail.com", "stacksimplify@gmail.com" ]]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Explanation:- 

Detailed Explanation of the Azure MySQL Database Server Terraform Configuration

This configuration defines two resources: 

1. Azure MySQL Database Server (azurerm_mysql_server)
2. Azure MySQL Database (azurerm_mysql_database)

### 1. Azure MySQL Database Server: azurerm_mysql_server

This resource defines a fully managed MySQL Server on Azure.

#### Key Features Explained

1. Naming
   
   name = "${var.business_unit}-${var.environment}-${var.db_name}"
   
   - The name of the MySQL server is dynamically constructed using three variables:

     - var.business_unit: Represents the department or team, e.g., "hr".
     - var.environment: Indicates the environment, e.g., "dev" or "prod".
     - var.db_name: The specific database name.

   Example Output: For business_unit = "hr", environment = "dev", and db_name = "webapp", 
           the resulting name will be the hr-dev-web app.

2. Location and Resource Group
   
   location            = azurerm_resource_group.myrg.location
   resource_group_name = azurerm_resource_group.myrg.name
   
   - location: Ensures the MySQL server is created in the same Azure region as the resource group.
   - resource_group_name: Links the server to the defined resource group (azurerm_resource_group.myrg).

3. Administrator Login Credentials
   
   administrator_login          = var.db_username
   administrator_login_password = var.db_password
   
   - db_username and db_password:
     - Defined as variables for security and flexibility.
     - These are sensitive and should not be hardcoded. 

- Consider using secret management tools like Azure Key Vault or Terraform’s sensitive attribute.

4. Performance Tier (SKU)
   
   sku_name = "GP_Gen5_2"
   
   - SKU Options:
     - B_: Basic tier for light workloads.
     - GP_: General Purpose tier for consistent performance.
     - MO_: Memory Optimized tier for high-performance workloads.

   Example:
   - GP_Gen5_2 offers moderate compute and storage capabilities, ideal for most business applications.

5. Storage and Version
   
   storage_mb = var.db_storage_mb
   version    = "8.0"
   
   - storage_mb: Configurable storage size for the server. For instance, 5120 MB = 5 GB.
   - version: Specifies MySQL version; 8.0 is used here, which is the latest stable version.

6. Additional Features

   A. Auto-Grow Storage
     
     auto_grow_enabled = var.db_auto_grow_enabled
     
     - Automatically expands storage when needed.
     - Useful for environments with unpredictable storage needs.

   B. Backup Retention
     
     backup_retention_days = 7
     
     - Configures the number of days backups are retained (here, 7 days).

   C.  Geo-Redundancy
     
     geo_redundant_backup_enabled = false
     
     - Disables geo-redundant backups to save costs (can be enabled for disaster recovery).

   D. Infrastructure Encryption
     
     infrastructure_encryption_enabled = false
     
     - Adds an extra layer of encryption for sensitive data (disabled here for simplicity).

   E. Public Network Access
     
     public_network_access_enabled = true
     
     - Allows public access, typically used in dev/test environments. Disable in production.

   F. SSL Enforcement
     
     ssl_enforcement_enabled = false
     
     - Enforces SSL/TLS connections. It is disabled here for testing but should be enabled for production.

7. Threat Detection Policy
   
   threat_detection_policy {
     enabled                = var.tdpolicy[0]
     retention_days         = var.tdpolicy[1]
     email_account_admins   = var.tdpolicy[2]
     email_addresses        = var.tdpolicy[3]
   }
   
   - A security feature to detect and notify suspicious activities (e.g., SQL injection).

   - Configured via a tuple variable tdpolicy, with:

     - tdpolicy[0]: Enabled or not (e.g., true).
     - tdpolicy[1]: Retention days for logs (e.g., 30).
     - tdpolicy[2]: Notify account admins (true or false).
     - tdpolicy[3]: List of email addresses for alerts.

### 2. Azure MySQL Database: azurerm_mysql_database

This resource creates a database inside the MySQL server.

#### Key Features Explained

1. Naming
   
   name = "webappdb1"
   
   - Explicitly sets the database name. This can also be parameterized for flexibility.

2. Dependencies
   
   resource_group_name = azurerm_resource_group.myrg.name
   server_name         = azurerm_mysql_server.mysqlserver.name
   
   - Links the database to the resource group and MySQL server created earlier.

3. Charset and Collation
   
   charset   = "utf8"
   collation = "utf8_unicode_ci"
   
   - Charset: Defines the character encoding used by the database (utf8 supports most languages).
   - Collation: Defines sorting and comparison rules (utf8_unicode_ci is case-insensitive).

### Workflow

1. Initialization:
   
   terraform init
   
   - Downloads required providers and sets up the environment.

2. Planning:
   
   terraform plan -var-file="dev.tfvars"
   
   - Previews the resources to be created or modified using variables for the development environment.

3. Deployment:
   
   terraform apply -var-file="dev.tfvars"
   
   - Deploys the Azure MySQL server and database.

4. Verification:
   
   terraform output
   
   - Displays the outputs (e.g., MySQL server name).

### Potential Improvements

1. Environment-Specific Configurations
   - Use separate .tfvars files for different environments (e.g., dev.tfvars, prod.tfvars).

2. Secrets Management
   - Store sensitive variables (db_password) in Azure Key Vault or use Terraform’s sensitive feature.

3. Advanced Security
   - Enable infrastructure encryption and stricter SSL/TLS policies for production environments.

4. Scalability
   - Parameterize sku_name and storage_mb for fine-grained control over performance and costs.
