# Azure Static Website using Storage Account
- This module provisions an Azure Storage Account for static website hosting.
- This is just for Terraform demos
- Private Module - 1.0.0

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# 1. Azure Static Website using Storage Account

This is a comment in the code (most likely in a Terraform file such as main.tf or README.md).

It tells you that the purpose of this Terraform module is to create a static website hosted on Azure Storage.

Static websites on Azure Storage support:

* HTML/CSS/JS files
* Client-side SPA (React, Angular, Vue)
* No backend code (like Node.js or Python), since the site is static

To enable static site hosting, Terraform will configure:

* static_website { } block inside the Storage Account resource
* index_document = "index.html"
* error_404_document = "404.html" (optional)

# 2. This module provisions an Azure Storage Account for static website hosting.

This line explains what the Terraform module actually performs.

The module likely contains resources such as:

resource "azurerm_storage_account" "static_site"
{
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website 
  {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

What this does:

* Creates an Azure Storage Account
* Enables the Static Website feature
* Makes Azure generate a public endpoint like:
  https://<storage-account-name>.z13.web.core.windows.net/

This is where your static site files will be uploaded (usually via az storage blob upload or Terraform scripts using provisioning).

# 3. This is just for Terraform demos

This line explains the intended use.

It suggests:

* The module is created for learning or demonstration purposes.
* It may not include production-level features such as:

  * HTTPS custom domain support
  * CDN integration
  * Private endpoint configuration
  * Advanced logging/monitoring
  * Networking restrictions

It is probably a simple, lightweight module to show:

* How Terraform provisions resources
* How modules are structured
* How variables, outputs, and resource blocks work

# 4. Private Module - 1.0.0

This line indicates:

# Module Type: Private

* The code is not public in Terraform Registry
* Probably stored in:

  * A private GitHub repository
  * Azure DevOps Repo
  * A private Terraform Cloud module registry

Usage might look like:

module "static_site" 
{
  source = "git::https://github.com/org/terraform-azure-static-website.git"
  version = "1.0.0"
}

# Module Version: 1.0.0

This follows Semantic Versioning:

|   Version   |             Meaning                      |
| ----------- | ---------------------------------------- |
|   1.0.0     |   First stable production-ready version  |
|   0.x.y     |   Experimental or developing stage       |

Versioning helps:

* Lock modules for consistent builds
* Avoid breaking changes on updates
* Track improvements (e.g., 1.1.0, 2.0.0 etc.)
