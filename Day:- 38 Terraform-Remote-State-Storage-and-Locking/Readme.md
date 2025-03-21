---
title: Terraform Remote State Storage & Locking
description: Learn about Terraform Remote State Storage & Locking
---
## Step-01: Introduction
- Understand Terraform Backends
- Understand about Remote State Storage and its advantages
- This state is stored by default in a local file named `terraform.tfstate`, but it can also be stored remotely, which works better in a team environment.
- Create Azure Storage Account to store `terraform.tfstate` file and enable backend configurations in terraform settings block


## Step-02: Create Azure Storage Account
### Step-02-01: Create Resource Group
- Go to Resource Groups -> Add 
- **Resource Group:** terraform-storage-rg 
- **Region:** East US
- Click on **Review + Create**
- Click on **Create**

### Step-02-02: Create Azure Storage Account
- Go to Storage Accounts -> Add
- **Resource Group:** terraform-storage-rg 
- **Storage Account Name:** terraformstate201 (THIS NAME SHOULD BE UNIQUE ACROSS AZURE CLOUD)
- **Region:** East US
- **Performance:** Standard
- **Redundancy:** Geo-Redundant Storage (GRS)
- In `Data Protection`, check the option `Enable versioning for blobs`
- REST ALL leave to defaults
- Click on **Review + Create**
- Click on **Create**

### Step-02-03: Create Container in Azure Storage Account
- Go to Storage Account -> `terraformstate201` -> Containers -> `+Container`
- **Name:** tfstatefiles
- **Public Access Level:** Private (no anonymous access)
- Click on **Create**


## Step-03: Terraform Backend Configuration
- **Reference Sub-folder:** terraform-manifests
- [Terraform Backend as Azure Storage Account](https://www.terraform.io/docs/language/settings/backends/azurerm.html)
- Add the below listed Terraform backend block in `Terrafrom Settings` block in `c1-versions.tf`
```t
# Terraform State Storage to Azure Storage Container
  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "terraform.tfstate"
  } 
```

## Step-04: Review Terraform Configuration Files
1. c1-versions.tf
2. c2-variables.tf
3. c3-locals.tf
4. c4-resource-group.tf
5. c5-virtual-network.tf
6. c6-linux-virtual-machine.tf
7. c7-outputs.tf
8. terraform.tfvars

## Step-05: Test with Remote State Storage Backend
```t
# Initialize Terraform
terraform init
Observation: 
1. Review below message
2. Verify the Azure Storage Account and you should see terraform.tfstate file created
## Sample CLI Output
Initializing the backend...
Successfully configured the backend "azurerm"! Terraform will automatically
use this backend unless the backend configuration changes.

# Validate Terraform configuration files
terraform validate

# Review the terraform plan
terraform plan 
Observation:
1. Acquiring state lock. This may take a few moments...

# Create Resources 
terraform apply -auto-approve

# Verify Azure Storage Account for terraform.tfstate file
Observation: 
1. Finally at this point you should see the terraform.tfstate file in Azure Storage Account. 

# Access Application
http://<Public-IP>
```

## Step-05: Storage Account Container Versioning Test
- Update in `c3-locals.tf` 
- Uncomment Demo tag
```t
  common_tags = {
    Service = local.service_name
    Owner   = local.owner
    Tag = "demo-tag1"  # Uncomment during step-05
  }
```
- Execute Terraform Commands
```t
# Review the terraform plan
terraform plan 

# Create Resources 
terraform apply -auto-approve

# Verify terraform.tfstate file in Azure Storage Account
Observation: 
1. New version of terraform.tfstate file will be created
2. Understand about Terraform State Locking 
3. terraform.tfsate file should be in "leased" state which means no one can apply changes using terraform to Azure Resources.
4. Once the changes are completed "terraform apply", Lease State should be in "Available" state. 
```


## Step-06: Destroy Resources
- Destroy Resources and Verify Storage Account `terraform.tfsate` file Versioning
```t
# Destroy Resources
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform*

# c3-locals.tf - Comment demo tag for students seamless demo
  common_tags = {
    Service = local.service_name
    Owner   = local.owner
    #Tag = "demo-tag1"  
  }
```


## References 
- [Terraform Backends](https://www.terraform.io/docs/language/settings/backends/index.html)
- [Terraform State Storage](https://www.terraform.io/docs/language/state/backends.html)
- [Terraform State Locking](https://www.terraform.io/docs/language/state/locking.html)
- [Remote Backends - Enhanced](https://www.terraform.io/docs/language/settings/backends/remote.html)

------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### Detailed Explanation of the Terraform Code and Steps

This guide walks through setting up Terraform remote state storage using Azure Storage Account and enabling backend configurations. 

## Step-01: Introduction

### Understanding Terraform Backends

- Terraform State File (terraform.tfstate):
 
  - Terraform uses this file to store the current state of the infrastructure.
  - By default, it is stored locally but can be remotely stored to support collaboration in a team environment.
    
- Remote State Storage Advantages:
  
  - Enables state locking (prevents multiple users from making conflicting changes).
  - Helps in team collaboration (state file is centrally stored).
  - Provides versioning (previous states can be retrieved if needed).

- Azure Storage as Backend: Using an Azure Storage Account allows secure storage and management of the Terraform state file.

## Step-02: Create Azure Storage Account

### Step-02-01: Create Resource Group

A resource group is a container that holds all related Azure resources.

- Go to Azure Portal → Resource Groups → Click Add
  
- Enter:
  
  - Resource Group Name: terraform-storage-rg
  - Region: East US
- Click Review + Create, then Create.

### Step-02-02: Create Azure Storage Account: A storage account is needed to store the terraform.tfstate file.

- Go to Storage Accounts → Click Add

- Set the following values:
  
  - Resource Group: terraform-storage-rg
  - Storage Account Name: terraformstate201 (Must be globally unique)
  - Region: East US
  - Performance: Standard
  - Redundancy: Geo-Redundant Storage (GRS) (for high availability)
  - Enable Versioning for Blobs (for tracking state changes)
- Click Review + Create, then Create.

### Step-02-03: Create a Container in the Storage Account

A container is a logical unit to hold blobs.

- Navigate to Storage Account → terraformstate201 → Containers → Click +Container
  
- Set:
  
  - Name: tfstatefiles
  - Public Access Level: Private (no anonymous access)
- Click Create.

## Step-03: Configure Terraform Backend

### **Modify c1-versions.tf to use Remote State Storage

- Add the following backend block inside terraform settings:

# Terraform State Storage to Azure Storage Container

terraform
{
  backend "azurerm" 
  {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "terraform.tfstate"
  } 
}

### Explanation:
- resource_group_name: Specifies the resource group that holds the storage account.
- storage_account_name: Specifies the storage account that stores the Terraform state.
- container_name: Specifies the container inside the storage account.
- key: The filename of the Terraform state file (terraform.tfstate).

## Step-04: Review Terraform Configuration Files

Several Terraform configuration files define the infrastructure:

1. c1-versions.tf → Defines Terraform versions and backend settings.
2. c2-variables.tf → Declares input variables.
3. c3-locals.tf → Defines local values (common tags, naming conventions).
4. c4-resource-group.tf → Creates a resource group.
5. c5-virtual-network.tf → Creates a virtual network.
6. c6-linux-virtual-machine.tf → Deploys a Linux VM.
7. c7-outputs.tf → Defines output values (e.g., VM public IP).
8. terraform.tfvars → Defines variable values.

## Step-05: Initialize Terraform with Remote Backend

### Run Terraform Commands

# Initialize Terraform: terraform init

Observations:

- Terraform downloads necessary provider plugins.
- It configures the backend and confirms remote state storage.
- Terraform checks Azure Storage for an existing terraform.tfstate.

### Validate Configuration: terraform validate

- Ensures that the Terraform code is syntactically correct.

### Plan the Deployment: terraform plan

Observations:

- Terraform acquires a state lock to prevent conflicts.
- It compares the current state with the desired state.

### Apply the Configuration: terraform apply -auto-approve

Observations:

- Deploys resources automatically.
- The state file (terraform.tfstate) is stored in Azure Storage.

### Access the Deployed Application

http://<Public-IP>

- Retrieve the public IP of the deployed VM and access the application.

## Step-06: Storage Account Container Versioning Test

Terraform state versioning ensures that previous versions are available.

### Modify c3-locals.tf

Uncomment the demo-tag1:

common_tags = 
{
  Service = local.service_name
  Owner   = local.owner
  Tag = "demo-tag1"  # Uncomment during step-05
}

### Apply the Changes

terraform plan
terraform apply -auto-approve

Observations:

1. A new version of terraform.tfstate is created.
2. Terraform locks the state (Lease State = "Leased") to prevent concurrent changes.
3. After terraform apply completes, the lease returns to "Available".

## Step-07: Destroy Resources: To clean up the infrastructure:

### Destroy All Resources: terraform destroy -auto-approve

### Remove Terraform State Files Locally: rm -rf .terraform*

### Comment Out the Demo Tag

Revert c3-locals.tf:

common_tags = 
{
  Service = local.service_name
  Owner   = local.owner
  Tag = "demo-tag1"  
}
