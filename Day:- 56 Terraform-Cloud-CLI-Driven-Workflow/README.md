---
title: Terraform Cloud - CLI-Driven Workflow
description: Learn about Terraform Cloud - CLI-Driven Workflow
---

## Step-01: Introduction
- Learn and practically implement `CLI-Driven Workflow` in Terraform Cloud

## Step-02: Review Terraform Configuration Files
- c1-versions.tf
- c2-variables.tf
- c3-static-website.tf
- c4-outputs.tf

## Step-03: Create Workspace with CLI Driven Workflow
- Login to [Terraform Cloud](https://app.terraform.io/)
- Select Organization -> hcta-azure-demo1
- Click on **New Workspace**
- **Choose your workflow:** CLI-Driven Workflow
- **Workspace Name:** cli-driven-azure-demo
- **Workspace Description:** Terraform Cloud CLI Driven Workflow Azure Demo
- Click on **Create Workspace**

## Step-04: Add backend block in Terraform Settings c1-versions.tf
```t
terraform {
  backend "remote" {
    organization = "hcta-azure-demo1"

    workspaces {
      name = "cli-driven-azure-demo"
    }
  }
}
```

## Step-05: Verify c3-static-website.tf
```t
# Before
  source  = "app.terraform.io/hcta-azure-demo1/staticwebsiteprivate/azurerm"
# After
  source  = "app.terraform.io/<YOUR_ORGANIZATION>/<YOUR_MODULE_NAME_IF_DIFFERENT>/azurerm"
  source  = "app.terraform.io/<YOUR_ORGANIZATION>/staticwebsitepr/azurerm"   
```

## Step-06: Execute Terraform Commands
```t
# Terraform Login
terraform login
Token Name: clidemoapitoken1
Token value: wtMhS66BJORvLg.atlasv1.GzmOyLo8ih9RDP3j6zXMLjBB0lyIYKiLo8Mu7aSYvfwCmu1X6pIBWh0y1ZJziYgQU2c
Observation: 
1) Should see message |Retrieved token for user stacksimplify
2) Verify Terraform credentials file
cat /Users/<YOUR_USER>/.terraform.d/credentials.tfrc.json
cat /Users/kdaida/.terraform.d/credentials.tfrc.json
Additional Reference:
https://www.terraform.io/docs/cli/config/config-file.html#credentials-1
https://www.terraform.io/docs/cloud/registry/using.html#configuration

# Terraform Initialize
terraform init
Observation: 
1. Should pass and download Private Registry modules from Terraform Cloud and providers
2. Verify Private Registry module downloaded. 

# Terraform Validate
terraform validate

# Terraform Format
terraform fmt

# Terraform Plan
terraform plan
Observation: 
1. Should fail with error due to Azure Provider credential configuration not done on Terraform Cloud for this respective workspace

# Sample Output
Initializing Terraform configuration...
╷
│ Error: Error building AzureRM Client: obtain subscription() from Azure CLI: Error parsing json result from the Azure CLI: Error waiting for the Azure CLI: exit status 1: ERROR: Please run 'az login' to setup account.
│ 
│   with module.azure_static_website.provider["registry.terraform.io/hashicorp/azurerm"],
│   on .terraform/modules/azure_static_website/main.tf line 2, in provider "azurerm":
│    2: provider "azurerm" {

```


## Step-08: Terraform Cloud to Authenticate to Azure using Service Principal with a Client Secret
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

## Step-09: Configure Environment Variables in Terraform Cloud
- Go to Organization -> hcta-azure-demo1 -> Workspace ->  cli-driven-azure-demo -> Variables
- Add Environment Variables listed below
```t
ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```


## Step-10: Execute Terraform Commands
```t
# Terraform Plan
terraform plan
Observation: 
1. Open Plan using link specified in CLI output
Example: https://app.terraform.io/app/hcta-azure-demo1-internal/cli-driven-azure-demo/runs/run-XNpEAoCPCQQSaqb3
2. Terraform plan should pass now. 


# Terraform Apply
terraform apply 
Observation:
1. Go to Terraform Cloud -> Organization: hcta-azure-demo1 -> Workspace: cli-driven-azure-demo -> Runs Tab
2. Review the plan
3. Provide confirmation "yes" in Terraform CLI (Terminal)
4. Observe TF Cloud Runs tab

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



## Step-11: Verify the following
- Select Organization -> hcta-azure-demo1
- **Workspace Name:** cli-driven-azure-demo
- Runs
- States
```t
# Key Observation
1. Running the Terraform Commands on your local desktop but they are running on Terraform Cloud and you can see the same in Runs
2. State is also maintained in Terraform Cloud. 
```

## Step-12: Destroy and Clean-Up
```t
# Terraform Destroy
terraform destroy 

# Delete Terraform files 
rm -rf .terraform*
```

## Additional References
- [CLI Configuration File](https://www.terraform.io/docs/cli/config/config-file.html#credentials)

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

You are:

1. Writing Terraform code locally.
2. Storing state and running plans/applies via Terraform Cloud (remote backend).
3. Letting Terraform Cloud authenticate to Azure using a Service Principal (client ID/secret).
4. Using a private module from the Terraform Cloud private registry to deploy a static website on Azure.

Now, let’s go through the steps.

# Step-02: Terraform Configuration Files

You have 4 main .tf files:

* c1-versions.tf – Terraform & provider versions, backend, etc.
* c2-variables.tf – Input variables (e.g., resource names, locations).
* c3-static-website.tf – Actual resources/module for the static website.
* c4-outputs.tf – Outputs (like website URL).

# Step-03: Creating the Workspace (CLI-Driven)

You create a Terraform Cloud Workspace:

* Org: hcta-azure-demo1
* Workspace name: cli-driven-azure-demo
* Workflow type: CLI-Driven

> CLI-driven means: You run terraform plan/apply from your terminal, but state & runs are still stored/visible in Terraform Cloud.

# Step-04: Backend Block in c1-versions.tf

* What this does:

* terraform { backend "remote" { ... } }
  Configures Terraform to use the Terraform Cloud/Enterprise backend called remote.

* organization = "hcta-azure-demo1"
  This is your Terraform Cloud org.

* workspaces { name = "cli-driven-azure-demo" }
  This ties your local code to that specific workspace.

Result:

* When you run terraform init, Terraform:

  * Connects to Terraform Cloud.
  * Uses the workspace cli-driven-azure-demo.
  * Stores state in that workspace instead of a local terraform.tfstate.

# Step-05: Module Source – Private Registry

# Before
  source  = "app.terraform.io/hcta-azure-demo1/staticwebsiteprivate/azurerm"

# After
  source  = "app.terraform.io/<YOUR_ORGANIZATION>/<YOUR_MODULE_NAME_IF_DIFFERENT>/azurerm"
  source  = "app.terraform.io/<YOUR_ORGANIZATION>/staticwebsitepr/azurerm"   

This is inside c3-static-website.tf, where you use a Terraform module, something like:

module "azure_static_website" 
{
  source = "app.terraform.io/hcta-azure-demo1/staticwebsiteprivate/azurerm"
  # ... other inputs
}

What source mean here:

* app.terraform.io → You’re using a module from Terraform Cloud Private Registry.
* hcta-azure-demo1 → The organization where the module is hosted.
* staticwebsiteprivate or staticwebsitepr → The module name in that org’s private registry.
* azurerm → The provider for which this module is written (this is part of the registry naming convention).

The “After” section generalizes it so you can adapt it for your org/module name.

So this line tells Terraform:

> “Download and use the module hosted in Terraform Cloud Private Registry under this org and module name, which is built for the azurerm provider.”

# Step-06: Terraform CLI Commands (Initial Flow)

# 1. terraform login: terraform login

* Opens a browser (or asks for a token).
* You create a Terraform Cloud token (e.g., clidemoapitoken1) and paste it.
* Terraform saves this token to a local config file:

  * ~/.terraform.d/credentials.tfrc.json

Example checks: cat /Users/<YOUR_USER>/.terraform.d/credentials.tfrc.json

> The long token string in your snippet is just a demo example.
> In real life: never share or commit real tokens.

This step ensures your CLI can talk to Terraform Cloud (for backend and private registry).

# 2. terraform init: terraform init

What happens:

* Reads terraform { ... } block:

  * Sets up the remote backend (Terraform Cloud workspace).
    
* Downloads:

  * Providers (e.g., azurerm).
  * Modules (including private registry modules specified with source = "app.terraform.io/...).

You should see:

1. Successful backend initialization.
2. Private registry module downloaded into .terraform/modules.

# 3. terraform validate: terraform validate

* Checks that your Terraform configuration is syntactically valid and internally consistent (variable types, missing arguments, etc.).
* It does not talk to Azure or actually plan changes. Just a code sanity check.

# 4. terraform fmt: terraform fmt

* Formats all .tf files to standard Terraform style (indentation, spacing, etc.).
* Helps keep your code readable and consistent.

# 5. terraform plan – first attempt: terraform plan

Here you get an error:

Error building AzureRM Client: obtain subscription() from Azure CLI:
ERROR: Please run az login to set up your account.

Why?

* The azurerm provider tries to authenticate using Azure CLI (because no explicit ARM_* env vars are set yet).
* Terraform Cloud (remote runs / remote backend context) does not have your Azure CLI session.
* So it fails: “Please run az login”.

This is expected before you configure proper Azure credentials for Terraform Cloud.

# Step-08: Create Service Principal for Azure (Client Secret Auth)

To let Terraform Cloud authenticate to Azure, you use a Service Principal (SPN) with a client secret.

# 1. Log in to Azure CLI: az login

* Opens browser or device code login.
* Authenticates your local CLI as you (a user).

# 2. List subscriptions: az account list

* Shows your subscriptions and IDs.
* You note the "id" of the subscription you want Terraform to use → SUBSCRIPTION_ID.

# 3. Set active subscription: az account set --subscription="SUBSCRIPTION_ID."

Ensures subsequent az commands run under that subscription.

# 4. Create Service Principal: az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"

This creates:

* An Azure AD Service Principal with the Contributor role on that subscription.
  
* Output:

{
  "appId": "99a2bb50-e5a1-4d72-acd3-e4697ecb5308",
  "displayName": "azure-cli-2021-06-15-15-41-54",
  "name": "http://azure-cli-2021-06-15-15-41-54",
  "password": "0ed3ZeK0DijKvhat~a5NnaQ_bpG_uv_-Xh",
  "tenant": "c81f465b-99f9-42d3-a169-8082d61c677a"
}

Mapping:

* appId → ARM_CLIENT_ID
* password → ARM_CLIENT_SECRET
* tenant → ARM_TENANT_ID
* SUBSCRIPTION_ID you noted earlier → ARM_SUBSCRIPTION_ID

So you now have the 4 values Terraform needs.

# 5. Verify SP works

az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID
az account list-locations -o table
az logout

* This proves that the service principal can log in and query Azure.

# Step-09: Configure Environment Variables in Terraform Cloud

In Terraform Cloud UI for your workspace (cli-driven-azure-demo), you add environment variables:

ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"

(Replace with your real values.)

Why?

* The azurerm provider can automatically pick up these ARM_ environment vars.
* When Terraform Cloud runs a plan/apply:

  * It reads these env vars.
  * It authenticates using the Service Principal instead of Azure CLI login.

These should be marked as sensitive in Terraform Cloud, so they’re not shown in plain text.

# Step-10: Terraform Plan & Apply (after credentials)

# 1. terraform plan again: terraform plan

# 2. terraform apply: terraform apply

# Step-11: Verify Runs & State in Terraform Cloud

# Step-12: Destroy & Clean-Up: terraform destroy
