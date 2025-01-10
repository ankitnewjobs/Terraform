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
tdpolicy = {
    enabled = true,
    retention_days = 10,
    email_account_admins = true,
    email_addresses = [ "ankitranjanjobs@gmail.com", "stacksimplify@gmail.com" ]
  }

---------------------------------------------------------------------------------------------------------------------------------------------

# Explanation:- 

This snippet defines a set of Terraform variables used to configure resources, such as an Azure MySQL Database Server and Database. 

Let’s explore the variables and their purposes in detail:

### 1. Generic Variables

business_unit = "it"
environment = "dev"

#### Purpose:

These variables define the organizational and environmental context for the resources.

- business_unit:
  
  - Represents the business unit responsible for the resources.
  - Example: "It" indicates the IT department.
  
- environment:
  
  - Specifies the environment in which the resources will be deployed.
  - Example: "dev" for a development environment. Other common environments could include staging, qa, or prod.

#### Usage:

- These values are typically combined to create consistent naming conventions for resources.
- Example:
  - A resource named using "${var.business_unit}-${var.environment}-${var.db_name}" will result in: it-dev-mydb101.

### 2. Resource Group Variables

resoure_group_name = "rg"
resoure_group_location = "eastus"

#### Purpose:

These variables configure the Azure Resource Group, which serves as the logical container for related resources.

- resoure_group_name:
  - Specifies the name of the Resource Group.
  - Example: "rg" for a generic name. A more descriptive name could be used for clarity (e.g., "rg-dev-it").

- resoure_group_location:
  - Defines the Azure region where the Resource Group and its resources will be deployed.
  - Example: "eastus" indicates deployment in the East US region.
  - Other common locations include "westus", "centralus", and "westeurope".

### 3. Database Variables

db_name = "mydb101"
db_storage_mb = 5120
db_auto_grow_enabled = true

#### Purpose:

These variables define the configuration of the Azure MySQL Database Server.

- db_name:
   - Specifies the name of the database server or database.
   - Example: "mydb101" for a database named mydb101.

- db_storage_mb:
  - Determines the storage capacity for the database server in megabytes.
  - Example: 5120 corresponds to 5 GB of storage.

- db_auto_grow_enabled:
  - Enables or disables automatic growth of storage as usage increases.
  - Example: true ensures the server can scale its storage dynamically.

### 4. Threat Detection Policy Variables

tdpolicy = {
    enabled = true,
    retention_days = 10,
    email_account_admins = true,
    email_addresses = [ "ankitranjanjobs@gmail.com", "stacksimplify@gmail.com" ]
  }

#### Purpose:

These variables define the Threat Detection Policy for the Azure MySQL Database Server. 
This policy enhances security by monitoring and alerting about unusual database activities.

- tdpolicy:
  - An object variable grouping related settings for the threat detection policy.
  - This encapsulates multiple parameters into a single structure for simplicity and consistency.

#### tdpolicy Fields:

1. enabled:
   - Enables or disables the threat detection policy.
   - Example: true enables the policy.

2. retention_days:
   - Defines how long the threat detection logs will be retained, in days.
   - Example: 10 days of retention.

3. email_account_admins:
   - Determines whether alerts are sent to the database server's account administrators.
   - Example: true enables alerting for account admins.

4. email_addresses:
   - A list of email addresses that will receive threat detection alerts.
   - Example:
     
     email_addresses = [ "ankitranjanjobs@gmail.com", "stacksimplify@gmail.com" ]
          - Sends alerts to the specified recipients.

### How These Variables Are Used

1. Resource Naming:
   
- The business_unit, environment, and db_name variables are combined to create resource names.
   
     - Example:
          name = "${var.business_unit}-${var.environment}-${var.db_name}"
     
     Result: it-dev-mydb101.

2. Azure Resource Group:
   - The resoure_group_name and resoure_group_location determine the container and location for all resources.

3. Database Configuration:
   - The db_storage_mb and db_auto_grow_enabled variables configure storage capacity and scalability.

4. Security:
   
     - The tdpolicy object configures a robust Threat Detection Policy, ensuring:
     - Threat detection is active.
     - Alerts are retained for 10 days.
     - Both administrators and specified recipients receive notifications.

### Why This Approach?

1. Reusability:
   - Variables allow the same configuration to be reused across environments (e.g., dev, staging, prod).

2. Flexibility:
   - Changing the value of a single variable can update multiple resources or settings.

3. Maintainability:
   - Grouping related settings (e.g., tdpolicy) into an object reduces complexity and improves readability.

4. Scalability:
   - Dynamic naming and configuration support the growth of infrastructure without manual intervention.
