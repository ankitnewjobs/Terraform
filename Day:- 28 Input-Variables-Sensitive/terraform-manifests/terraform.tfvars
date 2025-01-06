# Generic Variables

business_unit = "it"
environment = "dev"

# Resource Group Variables

resoure_group_name = "rg"
resoure_group_location = "eastus"

# DB Variables

db_name = "mydb201"
db_storage_mb = 5120
db_auto_grow_enabled = true

-----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: 

This Terraform configuration snippet declares generic variables and assigns values that will be used for resource provisioning. 

These variables provide flexibility, enabling dynamic configurations and supporting reusability. 

Below, each section is explained in detail to enhance conceptual clarity.

### 1. Generic Variables

#### Code Snippet

business_unit = "it"
environment = "dev"

#### Explanation

These variables define high-level metadata about the infrastructure environment:

- business_unit:

  - Definition: Identifies the business domain or department responsible for the resources.
  - Example Value: "It" indicates that the resources are associated with the IT department.

  - Practical Use:
    - Helps in organizing and tagging resources.
    - Useful for billing and tracking costs by business units.

- environment:

  - Definition: Represents the environment where the resources are deployed.
  - Example Value: "dev" indicates a development environment.

  - Practical Use:
    - Differentiates between environments (e.g., dev, test, prod).
    - Ensures separate configurations and reduces the risk of overwriting production resources.

#### Conceptual Clarity

- Why Use Generic Variables?

  - Enables environment-specific configurations without duplicating code.
  - Helps maintain consistency across projects.

### 2. Resource Group Variables

#### Code Snippet

resoure_group_name = "rg"
resoure_group_location = "eastus"

#### Explanation

These variables define properties for an Azure Resource Group, a logical container for Azure resources.

- resoure_group_name:

  - Definition: The name of the resource group.
  - Example Value: "rg" is a placeholder name; in a real-world scenario, it might be "rg-it-dev".

  - Practical Use:

    - Groups-related resources for easier management.
    - Serves as the boundary for access control and cost tracking.

- resoure_group_location:

  - Definition: The Azure region where the resource group is created.
  - Example Value: "eastus" represents the East US Azure data center.

  - Practical Use:
    - Ensures resources are deployed closer to users for reduced latency.
    - Enables compliance with regional data residency requirements.

#### Conceptual Clarity

- Why Resource Group Variables?

  - Facilitates easy change of location or naming conventions without altering multiple resource definitions.
  - Promotes a modular infrastructure setup by centralizing resource group details.

### 3. Database (DB) Variables

#### Code Snippet

db_name = "mydb201"
db_storage_mb = 5120
db_auto_grow_enabled = true

#### Explanation

These variables configure the database properties.

1. db_name:

   - Definition: Specifies the name of the database.
   - Example Value: "mydb201" is the database name.

   - Practical Use:
     - Identifies the database uniquely within the MySQL server.
     - Should follow Azure naming conventions to avoid conflicts.

2. db_storage_mb:

   - Definition: Sets the maximum allocated storage for the database in megabytes.
   - Example Value: 5120 (equivalent to 5GB).

   - Practical Use:
     - Determines storage capacity based on the workload.
     - Prevents performance bottlenecks by allocating sufficient space.

3. db_auto_grow_enabled:

   - Definition: Enables or disables automatic storage growth when usage exceeds the allocated limit.
   - Example Value: true indicates that auto-grow is enabled.

   - Practical Use:
     - Ensures uninterrupted database operations by automatically increasing storage.
     - Useful for unpredictable workloads where data growth is uncertain.

#### Conceptual Clarity

- Why Use DB Variables?

  - Allows flexible database configurations tailored to application needs.
  - Prevents manual interventions by enabling features like auto-grow.

### Putting It All Together

#### Scenario: Resource Naming Convention

- By combining variables:
  
  resource_name = "${var.business_unit}-${var.environment}-${var.resoure_group_name}-${var.db_name}"
  
  Example Output: "it-dev-rg-mydb201"

#### Advantages of This Approach

1. Centralized Configuration:

   - All values are stored in one place, making updates and maintenance easier.

2. Environment-Specific Flexibility:

   - Changing environment = "prod" automatically updates the configuration for the production environment.

3. Scalability:

   - Variables can be reused across multiple Terraform files or modules, ensuring consistency.

### Practical Considerations

1. Best Practices:

   - Use descriptive variable names to avoid ambiguity.
   - Document variable purposes for team collaboration.
   - Ensure sensitive variables (e.g., passwords) are handled securely.

2. Validation:

   - Add validation rules to variables to enforce constraints. For example:
     
     variable "db_storage_mb" {
       type        = number
       default     = 5120
       description = "Database storage in MB"
       validation {
         condition     = var.db_storage_mb >= 1024
         error_message = "Storage must be at least 1024 MB."
       }
     }
     
3. Dynamic Updates:

   - Use terraform.tfvars or .auto.tfvars files for dynamic updates in different environments.
