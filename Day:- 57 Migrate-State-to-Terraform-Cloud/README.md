---
title: Migrate State to Terraform Cloud
description: Learn about migrating State to Terraform Cloud
---

## Step-01: Introduction
- We are going to migrate State to Terraform Cloud

## Step-02: Review Terraform Manifests
1. c1-versions.tf
2. c2-variables.tf
3. c3-static-website.tf
4. c4-outputs.tf

## Step-03: Execute Terraform Commands (First provision using local backend)
- First provision infra using local backend
- `terraform.tfstate` file will be created in local working directory
- In next steps, migrate it to Terraform Cloud
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve


# Upload Static Content
1. Go to Storage Accounts -> staticwebsitexxxxxx -> Containers -> $web
2. Upload files from folder "static-content"

# Verify 
1. Azure Storage Account created
2. Static Website Setting enabled
3. Verify the Static Content Upload Successful
4. Access Static Website
https://staticwebsitek123.z13.web.core.windows.net/
```

## Step-04: Review your local state file
-  Review your local `terraform.tfstate` file once


## Step-05: Update remote backend in c1-versions.tf Terraform Block
```t
# Template
  backend "remote" {
    hostname      = "app.terraform.io"
    organization  = "<YOUR-ORG-NAME>"

    workspaces {
      name = "<SOME-NAME>"
    }
  }

# Replace Values
  backend "remote" {
    hostname      = "app.terraform.io"
    organization  = "hcta-azure-demo1"  # Organization should already exists in Terraform Cloud

    workspaces {
      name = "state-migration-demo1" 
      # Two cases: 
      # Case-1: If workspace already exists, should not have any state files in states tab
      # Case-2: If workspace not exists, during migration it will get created
    }
  }
```


## Step-06: Migrate State file to Terraform Cloud and Verify
```t
# Terraform Login
terraform login
Observation: 
1) Should see message |Success! Terraform has obtained and saved an API token.|
2) Verify Terraform credentials file
cat /Users/<YOUR_USER>/.terraform.d/credentials.tfrc.json
cat /Users/kdaida/.terraform.d/credentials.tfrc.json
Additional Reference:
https://www.terraform.io/docs/cli/config/config-file.html#credentials-1
https://www.terraform.io/docs/cloud/registry/using.html#configuration

# Terraform Initialize
terraform init
Observation: 
1) During reinitialization, Terraform presents a prompt saying that it will copy the state file to the new backend. 
2) Enter yes and Terraform will migrate the state from your local machine to Terraform Cloud.

## Sample Output
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ terraform init

Initializing the backend...
Acquiring state lock. This may take a few moments...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "remote" backend. No existing state was found in the newly
  configured "remote" backend. Do you want to copy this state to the new "remote"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes
Successfully configured the backend "remote"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of hashicorp/null from the dependency lock file
- Reusing previous version of hashicorp/azurerm from the dependency lock file
- Reusing previous version of hashicorp/random from the dependency lock file
- Using previously-installed hashicorp/azurerm v2.63.0
- Using previously-installed hashicorp/random v3.1.0
- Using previously-installed hashicorp/null v3.1.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ 


# Verify in Terraform Cloud
1) New workspace should be created with name "state-migration-demo1"
2) Verify "states" tab in workspace, we should find the state file
```

## Step-07: Terraform Cloud to Authenticate to Azure using Service Principal with a Client Secret
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

## Step-08: Configure Environment Variables in Terraform Cloud
- Go to Organization -> hcta-azure-demo1 -> Workspace ->  state-migration-demo1 -> Variables
- Add Environment Variables listed below
```t
ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```
 
## Step-08: Delete local terraform.tfstate
- First take backup and put it safe and delete it
```t
# Take backup
cp terraform.tfstate terraform.tfstate_local

# Delete
rm terraform.tfstate
``` 

## Step-09: Apply a new run from Terraform CLI
- Make a change and do  `terraform apply`
```t
# Add new resource (c3-static-website.tf)
# Create New Resource Group
resource "azurerm_resource_group" "resource_group2" {
  name     = "myrg2021"
  location = "eastus"
}

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply 

# Verify in Terraform Cloud
1) Verify in Runs Tab in TF Cloud
2) Verify States Tab in TF Cloud
```

## Step-10: Destroy & Clean-Up
-  Destroy Resources from cloud this time instead of `terraform destroy` command
- Go to Organization (hcta-azure-demo1) -> Workspace(state-migration-demo1) -> Settings -> Destruction and Deletion
- Click on **Queue Destroy Plan**
```t
# Clean-Up files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Step-11: Rollback changes for Students seamless demo
```t
# Change-1: c1-versions.tf
- Comment "backend" block which will be enabled during step-05
# Change-2: c3-static-website.tf
- Comment "new Resource Group Resource" block which will be enabled during step-09
```

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# Step-01 & Step-02: Introduction + Manifests

You have these Terraform files:

1. c1-versions.tf

   * Contains terraform block (required version, required providers)
   * Also, where you will later add the backend "remote" block.

2. c2-variables.tf

   * Declares variable blocks used in your configuration (like resource_group_name, location, etc.).

3. c3-static-website.tf

   * Main resource definitions: resource group, storage account, static website config, etc.

4. c4-outputs.tf

   * output blocks that print useful values after apply (e.g., resource group name, storage account endpoint).

Currently, you are using the default local backend because no backend block is configured.

# Step-03: First Provision Using Local Backend

Commands:

terraform init
terraform validate
terraform plan
terraform apply -auto-approve

# What each one does

# terraform init

* Downloads the required providers (e.g., hashicorp/azurerm, hashicorp/random, etc.).
* Sets up .terraform/ directory.
* Since no backend block is defined, Terraform uses local backend by default.
* No remote communication with Terraform Cloud yet.

# terraform validate

* Checks your syntax & internal consistency.
* Does not hit Azure; it just verifies the config.

# terraform plan

* Reads your config files.
* If no existing terraform.tfstate file:

  * It plans to create all resources.
  * 
* Connects to Azure using whatever credentials you have locally (env vars, Azure CLI login, etc.).
* Shows an execution plan but doesn’t change anything yet.

# terraform apply -auto-approve

* Executes the plan: calls Azure APIs to create the resources.
  
* After success, it writes the current infrastructure state into a local file:
        terraform.tfstate in your working directory.

This state file contains:

* Resource addresses
* Resource IDs in Azure
* Attributes (name, location, etc.)

# Upload Static Content & Verify

Manual steps in Azure Portal:

1. Go to Storage Accounts -> staticwebsitexxxxxx -> Containers -> $web
2. Upload files from the static-content folder

Then confirm:

* Storage Account exists
* Static website enabled
* Content uploaded
* You can access the URL like: https://staticwebsitek123.z13.web.core.windows.net/

This confirms that Terraform-created infra works and your local state accurately reflects reality.

# Step-04: Review terraform.tfstate

Before migration, you open terraform.tfstate and see:

* "version", "terraform_version"
* "resources" array with entries like:

  * type: "azurerm_storage_account"
  * name: "staticwebsite"
  * attributes: "name", "resource_group_name", "primary_web_endpoint", etc.

This is the source of truth for what Terraform thinks exists in Azure.

You’ll soon move this state from your local machine → Terraform Cloud.

# Step-05: Add Remote Backend in c1-versions.tf

You add:

backend "remote" 
{
  hostname      = "app.terraform.io"
  organization  = "hcta-azure-demo1"

  workspaces 
  {
    name = "state-migration-demo1"
  }
}

# What this means

* backend "remote" tells Terraform: “Don’t keep state locally anymore. Use Terraform Cloud as the backend.”

* hostname = "app.terraform.io": Use Terraform Cloud SaaS as the backend host.

* organization = "hcta-azure-demo1": This must already exist in Terraform Cloud.

* workspaces { name = "state-migration-demo1" }: This is the workspace that will hold your state:

  * Case 1: Workspace exists, but is empty → state will be uploaded to it.
  * Case 2: Workspace doesn’t exist → it will be created during init/migration.

At this point, you’ve only edited the config. Terraform hasn’t migrated anything yet.
Migration occurs at the next Terraform init.

# Step-06: Login to Terraform Cloud & Migrate State

# terraform login

What happens:

1. Terraform opens a browser or gives you a URL to generate an API token in Terraform Cloud.
2. Once you paste the token, Terraform creates a credentials file:

      cat ~/.terraform.d/credentials.tfrc.json
   
   You’ll see:

      {
     "credentials":
    {
       "app.terraform.io":
   {
         "token": "YOUR_LONG_API_TOKEN"
       }
     }
   }
   
This file is how Terraform authenticates to the Terraform Cloud backend.

# terraform init (After Adding Backend Block)

This is the crucial migration step.

When you run: terraform init

Terraform now sees:

* Previously, the backend was local (implicit).
* Now, config includes backend "remote" (Terraform Cloud).
* There is an existing local terraform.tfstate.

So Terraform:

1. Initializes the new backend (connects to app.terraform.io, org hcta-azure-demo1, workspace state-migration-demo1).

2. Notices:

   * There’s an old state in the local backend.
   * There is no state yet in the remote backend.

3. Shows the prompt:

   > Do you want to copy the existing state to the new backend?
   > Enter "yes" to copy and "no" to start with an empty state.

At this moment, nothing is copied yet. It’s just asking.

# When you type yes and press Enter:

* Terraform uploads terraform.tfstate to Terraform Cloud.
* Creates (or uses) the workspace state-migration-demo1.
* Saves state into the workspace’s State tab.
* Marks backend configuration as complete.

You see:

> Successfully configured the backend "remote"!
> Terraform has been successfully initialized!

From now on:

* Terraform plan and Terraform apply will use the remote state.
* Local terraform.tfstate is no longer used (but still temporarily present until you delete it in a later step).

# Verifying in Terraform Cloud

Go to:

* Org: hcta-azure-demo1
* Workspace: state-migration-demo1 → States tab

You should see:

* A state version created around the time you ran terraform init
* Its JSON structure is similar to your old local terraform.tfstate

Now Terraform Cloud is the source of truth.

# Step-07: Configure Azure Authentication via Service Principal

This section ensures Terraform Cloud runs (which execute remotely) can authenticate to Azure. You can’t rely on your local az login anymore because runs don’t happen on your machine.

# Login and Set Subscription

az login
az account list

You copy the "id" of your target subscription → that is your SUBSCRIPTION_ID.

az account set --subscription="SUBSCRIPTION_ID"

This makes sure all subsequent Azure CLI operations are done against that subscription.

#  Create Service Principal (SP)

az ad sp create-for-rbac \
  --role="Contributor" \
  --scopes="/subscriptions/SUBSCRIPTION_ID"

What this does:

* Creates an Azure AD application + service principal.
* Assigns it Contributor role on that subscription.
  
* Outputs:

    {
    "appId": "99a2bb50-e5a1-4d72-acd3-e4697ecb5308",
    "password": "0ed3ZeK0DijKvhat~a5NnaQ_bpG_uv_-Xh",
    "tenant": "c81f465b-99f9-42d3-a169-8082d61c677a"
  }

Mapping:

* appId   → ARM_CLIENT_ID (client ID)
* password → ARM_CLIENT_SECRET
* tenant  → ARM_TENANT_ID

Your own subscription ID is ARM_SUBSCRIPTION_ID.

# Verify the SP Works

az login --service-principal \
  -u CLIENT_ID \
  -p CLIENT_SECRET \
  --tenant TENANT_ID

az account list-locations -o table
az logout

If this succeeds, your SP is valid and has enough permissions.

# Step-08: Configure Env Vars in Terraform Cloud

In Terraform Cloud Web UI:

* Go to Organization hcta-azure-demo1
* Workspace state-migration-demo1
* Variables tab → Environment Variables section

Add:

ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"

(With your real values, of course.)

The azurerm provider understands these env vars automatically. When Terraform Cloud runs a plan/apply, it:

* Injects these env vars into the run environment.
* The provider reads them and authenticates to Azure with your Service Principal.

# Step-08 (second): Backup & Delete Local terraform.tfstate

Now that the state is in Terraform Cloud and confirmed:

cp terraform.tfstate terraform.tfstate_local
rm terraform.tfstate

* terraform.tfstate_local = backup (just in case).
* terraform.tfstate removed so you don’t get confused later.

From now on, Running terraform plan/apply reads/writes only the remote state.

# Step-09: Make a Change and Apply via Remote Backend

You add a new resource to c3-static-website.tf:

resource "azurerm_resource_group" "resource_group2" 
{
  name     = "myrg2021"
  location = "eastus"
}

Then:

terraform plan
terraform apply

What happens now:

1. Terraform CLI sends Plan request to Terraform Cloud backend.
2. Terraform Cloud:

   * Fetches the current state from workspace state-migration-demo1.
   * Runs the plan using your configuration and ARM_* env vars.
     
3. You approve/apply (either via CLI or UI).
4. A new resource group, myrg2021, is created in Azure.
5. The updated state is saved in Terraform Cloud’s States tab.

You can verify:

* Runs tab → See the plan & apply run logs.
* States tab → See the new state version.
* Azure Portal → Confirm myrg2021 exists.

# Step-10: Destroy & Clean-Up

Instead of running terraform destroy locally, you:

* Go to:

  * Org: hcta-azure-demo1
  * Workspace: state-migration-demo1
  * Settings → Destruction and Deletion
    
* Click Queue Destroy Plan

Terraform Cloud:

* Creates a Destroy plan against the current state.
* If you confirm, it removes all the resources from Azure.
* Saves a final state version reflecting deletion.

Then locally you clean up:

rm -rf .terraform*
rm -rf terraform.tfstate*

This removes:

* Provider plugin cache and backend metadata (.terraform/)
* Any leftover state files.

Your local folder is now “clean” again.

# Step-11: Rollback Files for Demo Reuse

To reset the lab so it can be demonstrated again:

1. In c1-versions.tf

   * Comment the backend "remote" block: This returns you to the default local backend for the next time.

2. In c3-static-website.tf

   * Comment out the extra Resource Group (resource_group2)
     So next time, you start from the original minimal infra setup.

Then the cycle can be repeated:

* Init with local backend
* Apply
* Migrate to remote
* etc.

# Terraform State Migration Flow (Diagram)

                  ┌────────────────────────┐
                  │   Local Machine (CLI)  │
                  └────────────────────────┘
                             │
                             │ terraform init/plan/apply
                             ▼
                    ┌──────────────────────┐
                    │  Local Backend (FS)  │
                    │  terraform.tfstate   │
                    └──────────────────────┘
                             │
                             │ Add backend "remote" in config
                             │ terraform init (again)
                             ▼
            ┌──────────────────────────────────────────┐
            │   Migration Prompt (Terraform CLI)       │
            │  "Copy existing state to remote backend?"│
            └──────────────────────────────────────────┘
                             │
                             │ yes
                             ▼
          ┌──────────────────────────────────────────────┐
          │     Terraform Cloud (Remote Backend)         │
          │ Organization: hcta-azure-demo1               │
          │ Workspace: state-migration-demo1             │
          │ Stores: state version, runs, logs            │
          └──────────────────────────────────────────────┘
                             │
                             │ configure ARM_* env vars
                             │ triggers TF Cloud to run plan/apply
                             ▼
          ┌──────────────────────────────────────────────┐
          │         Terraform Cloud Run Environment      │
          │ (Executes plan/apply using Service Principal)│
          │     │                                        │
          │     └─> Azure Provider Auth (ARM_ variables) │
          │             │                                │
          │             ▼                                │
          │       Azure Resource Manager (ARM)           │
          │   (Creates/updates/destroys infrastructure)  │
          └──────────────────────────────────────────────┘
                             │
                             ▼
          ┌──────────────────────────────────────────────┐
          │         Updated Remote State Saved           │
          │       in Terraform Cloud Workspace           │
          └──────────────────────────────────────────────┘

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/dd2e2c02-eb4c-4086-9ab1-d740884b854b" />

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/63d3f8bd-a6c0-4b50-be97-915e3a4f3ae3" />

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/78f85f4e-f2bf-495a-8b2f-7bd3cf498472" />
