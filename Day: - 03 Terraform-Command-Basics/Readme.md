
## Terraform Command Basics

### Step 1: Introduction to Basic Terraform Commands
Terraform is a powerful infrastructure as a code tool, and understanding its core commands is essential for managing cloud resources efficiently. The basic commands include:

1. **Terraform init**: Initializes a new or existing Terraform configuration. It sets up the working directory, downloads required provider plugins, and prepares the backend.
   
2. **Terraform validate**: This function validates the configuration files for syntax and logical errors. It ensures that the code is formatted correctly and will work as expected.

3. **Terraform plan**: This function generates an execution plan that shows what actions Terraform will take to achieve the desired state defined in the configuration files. It provides a preview before making any changes.

4. **Terraform apply**: Applies the changes required to reach the desired state of the configuration. It creates or updates resources as specified in the Terraform files.

5. **Terraform destroy**: This command removes all the resources defined in the Terraform configuration. It is used to clean up and avoid incurring unnecessary costs.

[![Image](https://stacksimplify.com/course-images/azure-terraform-workflow-1.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/azure-terraform-workflow-1.png)

[![Image](https://stacksimplify.com/course-images/azure-terraform-workflow-2.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/azure-terraform-workflow-2.png)

### Step 2: Review Terraform Manifests
Before running Terraform commands, you need to set up your Azure environment:

- **Pre-Conditions 1**: Retrieve available Azure regions to decide where to create resources.
   ```bash
   az account list-locations -o table
   ```

- **Pre-Conditions 2**: Authenticate with Azure using the CLI if you haven’t already.
   ```bash
   az login
   az account list
   az account set --subscription="SUBSCRIPTION_ID"
   ```

**Terraform Configuration Example**:
Here’s a basic configuration for using Azure with Terraform:
```hcl
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }    
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "my_demo_rg1" {
  location = "eastus"
  name     = "my-demo-rg1"  
}
```
- [Azure Regions](https://docs.microsoft.com/en-us/azure/virtual-machines/regions)
  
- [Azure Regions Detailed](https://docs.microsoft.com/en-us/azure/best-practices-availability-paired-regions#what-are-paired-regions)

### Step 3: Terraform Core Commands
1. **Initialize the working directory**:
   ```bash
   terraform init
   ```

2. **Validate the configuration**:
   ```bash
   terraform validate
   ```

3. **Generate an execution plan**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply 
   ```

### Step 4: Verify Resources in Azure
After applying your configuration:
- Navigate to the Azure Management Console and check the Resource Groups section.
- Ensure that your newly created resource group appears.
- Review the `terraform.tfstate` file to understand the current state of your infrastructure.

### Step 5: Destroy Infrastructure
When you no longer need the resources:
```bash
terraform destroy
```
**Observation Steps**:
1. Check Azure Management Console to confirm the resource group has been deleted.
2. Inspect the `terraform.tfstate` file to verify that the resource group information has been removed.
3. Look at the `terraform.tfstate.backup` file, which should contain the resource group details before deletion.

**Cleanup**: Remove all Terraform-related files:
```bash
rm -rf .terraform*
rm -rf terraform.tfstate*
```

### Step 6: Conclusion
In this section, you learned the fundamental Terraform commands essential for managing infrastructure. By understanding and practicing `terraform init`, `validate`, `plan`, `apply`, and `destroy`, you can effectively automate resource management on Azure.

--- 


