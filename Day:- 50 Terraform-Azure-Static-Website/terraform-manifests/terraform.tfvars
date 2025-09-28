location                          = "eastus"
resource_group_name               = "myrg1"
storage_account_name              = "staticwebsite"
storage_account_tier              = "Standard"
storage_account_replication_type  = "LRS"
storage_account_kind              = "StorageV2"
static_website_index_document     = "index.html"
static_website_error_404_document = "error.html"

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### 1. location = "eastus"

* Defines the Azure region where your resources will be created.
* "eastus" means East US data center.
* All Azure resources must belong to a specific location, and you usually keep them in the same region for performance, cost efficiency, and compliance.

### 2. resource_group_name = "myrg1"

* Specifies the name of the Resource Group.
* A Resource Group (RG) is a logical container in Azure that holds related resources (VMs, storage accounts, databases, etc.).
* Here, the RG is named myrg1.
* Helps in managing, monitoring, and deleting resources as a group.

### 3. storage_account_name = "staticwebsite"

* Defines the name of the Azure Storage Account.
* A Storage Account is a service for storing data objects like blobs, files, queues, and tables.
* Must be globally unique across all of Azure (not just your subscription).

  * Example: if a static website is already taken, your deployment will fail.

### 4. storage_account_tier = "Standard"

* Sets the performance tier of the storage account:

  * Standard: Uses HDD-based storage – cheaper, general-purpose workloads.
  * Premium: Uses SSD-based storage – higher performance, lower latency.

* Here, Standard is chosen (best for static websites, backup, and general storage).

### 5. storage_account_replication_type = "LRS"

* Defines the replication strategy to protect your data:

  * LRS (Locally Redundant Storage): Keeps 3 copies of data within one datacenter (cheapest, but not zone- or region-redundant).
  * ZRS (Zone Redundant Storage): Copies across availability zones.
  * GRS (Geo Redundant Storage): Copies to a secondary region (high durability).
  * RA-GRS (Read-Access GRS): Same as GRS, but allows read access to secondary.

* Here, LRS is used for cost efficiency (suitable for non-critical workloads like static websites).

### 6. storage_account_kind = "StorageV2"

* Defines the type of storage account:

  * Storage (classic) → Legacy, not recommended.
  * BlobStorage → Blob-only storage (specialized).
  * StorageV2 → General-purpose v2 account (recommended).

* StorageV2 supports:

  * Blobs, Files, Queues, and Tables.
  * Advanced features like static website hosting, lifecycle management, and soft delete.

### 7. static_website_index_document = "index.html"

* Specifies the default landing page of your static website.
* When users visit the storage account’s static website endpoint (like https://<account-name>.z13.web.core.windows.net/), Azure will serve index.html.
* This is similar to the home page of a traditional web server.

### 8. static_website_error_404_document = "error.html"

* Specifies the custom error page shown when a requested file doesn’t exist (404 Not Found).

* For example:

  * If user visits https://<account-name>.z13.web.core.windows.net/doesnotexist.html
  * Azure will return error.html instead of a generic 404.

## Putting It All Together

This snippet is essentially parameter definitions for an Azure deployment:

* Deploy everything in East US (eastus).
* Create a Resource Group (myrg1).
* Inside it, provision a Storage Account (staticwebsite) with:

  * Standard tier (low cost, HDD-based).
  * LRS replication (3 local copies).
  * StorageV2 kind (modern, general-purpose v2).

* Enable Static Website Hosting with:

  * index.html as the homepage.
  * error.html as the error page.

