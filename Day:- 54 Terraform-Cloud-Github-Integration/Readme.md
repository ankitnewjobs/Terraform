---
title: Terraform Cloud & Github Integration
description: Learn more about Terraform Cloud & Github Integration
---

## Step-01: Introduction
- Create Github Repository on github.com
- Clone Github Repository to local desktop
- Copy & Check-In Terraform Configurations in to Github Repository
- Create Terraform Cloud Account
- Create Organization
- Create Workspace by integrating with Github.com Git Repo we recently created
- Learn about Workspace related Queue Plan, Runs, States, Variables and Settings


## Step-02: Create new github Repository
- **URL:** github.com
- Click on **Create a new repository**
- **Repository Name:** terraform-cloud-azure-demo1
- **Description:** Terraform Cloud Azure Demo1
- **Repo Type:** Public / Private
- **Initialize this repository with:**
- **CHECK** - Add a README file
- **CHECK** - Add .gitignore 
- **Select .gitignore Template:** Terraform
- **CHECK** - Choose a license
- **Select License:** Apache 2.0 License
- Click on **Create repository**

## Step-03: Review .gitignore created for Terraform
- Review .gitignore created for Terraform projects

## Step-04: Clone Github Repository to Local Desktop
```t
# Clone Github Repo
git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git
git clone https://github.com/stacksimplify/terraform-cloud-azure-demo1.git
```

## Step-05: Copy files from terraform-manifests to local repo & Check-In Code
- List of files to be copied
1. c1-versions.tf
2. c2-variables.tf
3. c3-locals.tf
4. c4-resource-group.tf
5. c5-virtual-network.tf
6. c6-linux-virtual-machine.tf
7. c7-outputs.tf
8. dev.auto.tfvars
9. ssh-keys folder
10. app-scripts folder

- Verify locally before commiting to GIT Repository
```t
# Terraform Init
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Clean-Up files
rm -rf .terraform 
```
- Check-In code to Remote Repository
```t
# GIT Status
git status

# Git Local Commit
git add .
git commit -am "TF Files First Commit"

# Push to Remote Repository
git push

# Verify the same on Remote Repository
https://github.com/stacksimplify/terraform-cloud-azure-demo1.git
```

## Step-06: Sign-Up for Terraform Cloud - Free Account & Login
- **SignUp URL:** https://app.terraform.io/signup/account
- **Username:**
- **Email:**
- **Password:** 
- **Login URL:** https://app.terraform.io

## Step-07: Create Organization and Enable Free Trial
### Step-07-01: Create Organization
- **Organization Name:** hcta-azure-demo1
- **Email Address:** stacksimplify@gmail.com
- Click on **Create Organization**
### Step-07-02: Enable Free Trial for this Organization
- Go to Organization -> hcta-azure-demo1 -> Settings -> Plan & Billing
- Click on `Start your free trial This organization is eligible for a 30 day free trial of Terraform Cloud's paid features. Click here to get started`
- Select `Trial Plan`
- Click on `Start your Free Trial`

## Step-08: Create New Workspace
- Get in to newly created Organization
- Click on **New Workspace**
- **Choose your workflow:** V
  - Version Control Workflow
- **Connect to VCS**
  - **Connect to a version control provider:** github.com
  - NEW WINDOW: **Authorize Terraform Cloud:** Click on **Authorize Terraform Cloud Button**
  - NEW WINDOW: **Install Terraform Cloud**
  - **Select radio button:** Only select repositories
  - **Selected 1 Repository:** stacksimplify/terraform-cloud-azure-demo1
  - Click on **Install**
- **Choose a Repository**
  - stacksimplify/terraform-cloud-azure-demo1
- **Configure Settings**
  - **Workspace Name:** terraform-cloud-azure-demo1 (Whatever populated automically leave to defaults) 
  - **Workspace Description:** Terraform Cloud Azure Demo1
  - **Advanced Settings:** 
    - **Terraform Working Directory:** terraform-manifests
    - REST ALL LEAVE TO DEFAULTS
- Click on **Create Workspace**  
- You should see this message `Configuration uploaded successfully`

## Step-09: Terraform Cloud to Authenticate to Azure using Service Principal with a Client Secret
- [Azure Provider: Authenticating using a Service Principal with a Client Secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret) 
```t
# Azure CLI Login
az login

# Azure Account List
az account list
Observation:
1. Make a note of the value whose key is "id" which is nothing but your "subscription_id"

# Set Subscription ID
az account set --subscription="SUBSCRIPTION_ID"
az account set --subscription="82808767-144c-4c66-a320-b30791668b0a"

# Create Service Principal & Client Secret
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/82808767-144c-4c66-a320-b30791668b0a"

# Sample Output
{
  "appId": "99a2bb50-e5a1-4d72-acd3-e4697ecb5308",
  "displayName": "azure-cli-2021-06-15-15-41-54",
  "name": "http://azure-cli-2021-06-15-15-41-54",
  "password": "0ed3ZeK0DijKvhat~a5NnaQ_bpG_uv_-Xh",
  "tenant": "c81f465b-99f9-42d3-a169-8082d61c677a"
}

# Observation
"appId" is the "client_id" defined above.
"password" is the "client_secret" defined above.
"tenant" is the "tenant_id" defined above.

# Verify
az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID
az login --service-principal -u 99a2bb50-e5a1-4d72-acd3-e4697ecb5308 -p 0ed3ZeK0DijKvhat~a5NnaQ_bpG_uv_-Xh --tenant c81f465b-99f9-42d3-a169-8082d61c677a
az account list-locations -o table
az logout
```

## Step-10: Configure Environment Variables in Terraform Cloud
- Go to Organization -> hcta-azure-demo1 -> Workspace ->  hcta-azure-demo1 -> Variables
- Add Environment Variables listed below
```t
ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

## Step-11: Click on Queue Plan
- Go to Workspace -> Runs -> Queue Plan
- Review the plan generated in **Full Screen**
- Review Cost Estimation Report
- Click on **Confirm & Apply**
- **Add Comment:** First Run Approved

## Step-12: Review Terraform State
- Go to Workspace -> States
- Review the state file

## Step-13: Make changes in local Git Repo - Add New Tags
- Go to Local Desktop -> Local Repo -> c3-locals.tf -> Add new tag for all Resources
```t
# Change c3-locals.tf
Uncomment tag named `Tag1 = "Terraform-Cloud-Demo1"`

# GIT Status
git status

# Git Local Commit
git add .
git commit -am "Tag Added"

# Push to Remote Repository
git push

# Verify Terraform Cloud
Go to Workspace -> Runs 
Observation: 
1) New plan should be queued ->  Click on Current Plan and review logs in Full Screen
2) Click on **Confirm and Apply**
3) Add Comment: Approved new tag changes
4) Verify Apply Logs in Full Screen
5) Review the update state in  Workspace -> States
6) Verify if new tags got created in Azure Portal.

# Access Application
http://<PUBLIC-IP>
```


## Step-14: Make changes in local Git Repo - When Workspace in Lock State
- Go to Local Desktop -> Local Repo -> c3-locals.tf -> Add new tag for all Resources
```t
# Change c3-locals.tf
Uncomment tag named `Tag2 = "Terraform-Cloud-Demo1-Workspace-Locked"`

# GIT Status
git status

# Git Local Commit
git add .
git commit -am "Tag Added - Workspace Locked"

# Push to Remote Repository
git push

# Verify Terraform Cloud
Go to Workspace -> Runs 
Message: Workspace locked by user stacksimplify. It must be unlocked before Terraform can execute.

# Unlock Workspace 
Unlock the workspace.

Observation: 
1) New plan should be queued ->  Click on Current Plan and review logs in Full Screen
2) Click on **Confirm and Apply**
3) Add Comment: Approved new tag changes
4) Verify Apply Logs in Full Screen
5) Review the update state in  Workspace -> States
6) Verify if new tags got created in Azure Portal.
```

## Step-15: Review Workpace Settings
- Goto -> Workspace -> Settings
1. General Settings
2. Locking
3. Notifications
4. Run Triggers
5. SSH Key
6. Version Control

## Step-15: Destruction and Deletion
- Goto -> Workspace -> Settings -> Destruction and Deletion
- click on **Queue Destroy Plan** to delete the resources on cloud 
- Goto -> Workspace -> Runs -> Click on **Confirm & Apply**
- **Add Comment:** Approved for Deletion

## Step-16: Comment c3-locals.tf
- Comment both tags (Tag1, Tag2) in c3-locals.tf for student seamless demo 
```t
  common_tags = {
    Service = local.service_name
    Owner   = local.owner
    #Tag1 = "Terraform-Cloud-Demo1"
    #Tag2 = "Terraform-Cloud-Demo1-Workspace-Locked"
  }
```

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

# Step-01: Introduction

This section defines the overall goal to:

1. Host Terraform configuration files in GitHub.
2. Use Terraform Cloud as the backend to run plans and apply automatically.
3. Connect Terraform Cloud to Azure securely through Service Principal authentication.

The idea is to shift from local Terraform execution (terraform apply on your machine) to remote execution in Terraform Cloud, where everything is automated, auditable, and team-friendly.

# Step-02: Create GitHub Repository

Purpose: To store Terraform configuration files in a version-controlled Git repository, which Terraform Cloud will monitor for any changes.

Important points:

* The repository name (terraform-cloud-azure-demo1) represents your demo project.
* .gitignore ensures sensitive or generated files (like .terraform, terraform.tfstate) are not committed.
* Adding a license (Apache 2.0) allows open usage and contribution.

Why it matters: Terraform Cloud connects directly to this repository, so any change in code triggers a new plan and applies automatically.

# Step-03: Review .gitignore

Terraform’s .gitignore ensures files such as:

* .terraform/
* *.tfstate
* *.tfvars
* Crash logs and backups are ignored, protecting sensitive information and reducing clutter in version control.

# Step-04: Clone GitHub Repository Locally

git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git

# Explanation: 

This copies the remote GitHub repository onto your local machine so you can work on it. You can use Visual Studio Code or any editor to modify Terraform configurations locally before pushing them back.

# Step-05: Copy Terraform Configuration Files

You copy Terraform files, such as:

* c1-versions.tf → specifies Terraform version and provider.
* c2-variables.tf → defines input variables.
* c3-locals.tf → defines reusable local values.
* c4-resource-group.tf to c6-linux-virtual-machine.tf → actual resource definitions.
* c7-outputs.tf → defines what Terraform outputs after deployment.
* dev.auto.tfvars → holds variable values automatically loaded during execution.
* ssh-keys and app-scripts → supporting files for VM access and provisioning.

Local verification:

terraform init      # Initializes providers and modules
terraform validate  # Checks for syntax or logical errors
terraform plan      # Previews what Terraform will do

Clean up before pushing: rm -rf .terraform  # Remove local cache files

Then commit and push:

git add.
git commit -am "TF Files First Commit"
git push

# Step-06: Sign-Up for Terraform Cloud

Create a free Terraform Cloud account at [https://app.terraform.io](https://app.terraform.io)

This platform allows:

* Remote state storage
* Policy enforcement
* Collaboration (team visibility)
* Automatic CI/CD integration with GitHub

# Step-07: Create Organization & Enable Free Trial

Terraform Cloud organizes everything under Organizations (like a company or project group).

Steps:

1. Create an organization (e.g., hcta-azure-demo1).
2. Enable the 30-day free trial to access paid features like private networking, advanced RBAC, and cost estimation.

# Step-08: Create a Workspace

A Workspace in Terraform Cloud is where all Terraform runs, states, and variables live.

Steps:

* Choose the Version Control Workflow (Terraform will automatically run on code commits).
* Connect to GitHub → authorize Terraform Cloud.
* Select the repository (terraform-cloud-azure-demo1).
* Configure settings:

  * Name: terraform-cloud-azure-demo1
  * Working directory: terraform-manifests (the folder where .tf files are stored)
  * Leave others as default.
    
* Click Create Workspace.

# Result: Terraform Cloud fetches the configuration from GitHub and prepares for your first run.

# Step-09: Authenticate Terraform Cloud with Azure

Terraform needs permission to create Azure resources; this is achieved using a Service Principal.

Commands explained:

az login
az account list                 # Find your subscription ID
az account set --subscription <SUBSCRIPTION_ID>

az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"

You’ll receive:

* appId → Client ID
* password → Client Secret
* tenant → Tenant ID
* Subscription ID → from previous command

These four values will authenticate Terraform to Azure.

# Step-10: Configure Environment Variables

In Terraform Cloud → Workspace → Variables tab:

Set these environment variables:

|   Variable Name         |       Description                |
| ----------------------- | -------------------------------- |
|   ARM_CLIENT_ID         |   Azure Service Principal App ID |
|   ARM_CLIENT_SECRET     |   Service Principal Password     |
|   ARM_SUBSCRIPTION_ID   |   Azure Subscription ID          |
|   ARM_TENANT_ID         |   Azure Tenant ID                |

# Step-11: Queue Plan

After Terraform Cloud loads the configuration:

* Go to Runs → Queue Plan
  
* Terraform Cloud executes:

  * terraform plan remotely
  * Displays results, cost estimates

* Click Confirm & Apply → resources will be created in Azure

# Step-12: Review Terraform State

Navigate to Workspace → States.

This shows your current state stored remotely in Terraform Cloud — a safer and centralized alternative to local `terraform.tfstate`.

# Step-13: Update Infrastructure (Add New Tags)

When you update any .tf file (like adding tags in c3-locals.tf) and push it to GitHub:

* Terraform Cloud automatically detects the commit.
* Triggers a new plan.
* Once reviewed, click Confirm & Apply again to update resources in Azure.

This demonstrates GitOps behavior — infrastructure changes managed via Git commits.

# Step-14: Workspace Locking

Sometimes you or another user may lock a workspace (to prevent simultaneous changes).

If you push changes during this state:

* Terraform Cloud shows: "Workspace locked by user..."
* You must unlock it before Terraform can queue a new plan.

After unlocking, repeat the plan → apply steps.

# Step-15: Workspace Settings Overview

You can configure:

1. General Settings: Name, working directory, VCS info.
2. Locking: Manage workspace locks.
3. Notifications: Slack/email integration for run events.
4. Run Triggers: Chain multiple workspaces together.
5. SSH Keys: For private module or repo access.
6. Version Control: Change GitHub repository link.

# Step-16: Destruction and Deletion

When done testing:

* Go to Settings → Destruction and Deletion
* Click Queue Destroy Plan
* Terraform will remove all Azure resources cleanly and update the state file.

# Step-17: Comment Out Demo Tags

To reset your project for future demos, comment out the tag lines in `c3-locals.tf`:

common_tags =
{
  Service = local.service_name
  Owner   = local.owner
  #Tag1 = "Terraform-Cloud-Demo1"
  #Tag2 = "Terraform-Cloud-Demo1-Workspace-Locked"
}

## Summary of Key Learnings

|        Concept            |                  Purpose                              |
| ------------------------- | ------------------------------------------------------- |
|     GitHub Repo           |     Source of truth for Terraform code                |
|     Terraform Cloud       |     Automates plans, applies, and manages state       |
|     Service Principal     |     Secure Azure authentication                       |
|     Environment Variables |     Pass secrets to Terraform Cloud safely            |
|     Workspace             |     Terraform execution and state management unit     |
|     Locking               |     Prevents parallel conflicting runs                |
|     Remote State          |     Centralized and secure state management           |
|     VCS Integration       |     Enables GitOps workflow (auto-trigger on commits) |

