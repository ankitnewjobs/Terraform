---
title: Terraform Cloud and Sentinel Policies
description: Learn about Terraform Cloud and Sentinel Policies
---

## Step-01: Introduction
- We are going to learn the following in this section
- Verify if Trial plan for 30 days on hcta-azure-demo1 organization which will enable **Team & Governance** features of Terraform Cloud
- Implement `CLI-Driven workflow using Terraform Cloud` for multiple Azure Resources
1. azurerm_resource_group
2. azurerm_linux_virtual_machine
3. azurerm_virtual_network
4. azurerm_public_ip
5. azurerm_network_interface
- Understand about following  5 sentinel policies
1. allowed-providers.sentinel
2. enforce-mandatory-tags.sentinel
3. limit-proposed-monthly-cost.sentinel
4. restrict-vm-publisher.sentinel
5. restrict-vm-size.sentinel
- Understand about defining `sentinel.hcl`
- Create Github repository for Sentinel Policies to use them as Policy Sets in Terraform Cloud
- Create Policy Sets in Terraform Cloud and Apply to demo workspace
- Test if sentinel policies applied and worked successfully.  
- Understand about [Terraform Sentinel policy Enforcement Levels](https://www.terraform.io/docs/cloud/sentinel/enforce.html)
1. advisory
2. soft-mandatory
3. hard-mandatory

## Step-02: Review Terraform manifests
1. c1-versions.tf
2. c2-variables.tf
3. c3-locals.tf
4. c4-resource-group.tf
5. c5-virtual-network.tf
6. c6-linux-virtual-machine.tf
7. c7-outputs.tf
8. dev.auto.tfvars

## Step-03: Review the Git-Repo-Files-Sentinel
- First Review the Terraform Governance guides - Third Generation (As on today)
- [Terraform Governance Guides](https://github.com/hashicorp/terraform-guides/tree/master/governance)
1. common-functions folder
2. azure-functions folder
3. terraform-generic-sentinel-policies

## Step-04: Review 5 Sentinel Policies and sentinel.hcl
1. allowed-providers.sentinel
2. enforce-mandatory-tags.sentinel
3. limit-proposed-monthly-cost.sentinel
4. restrict-vm-publisher.sentinel
5. restrict-vm-size.sentinel
6. sentinel.hcl


## Step-03: Create CLI-Driven Workspace on Terraform Cloud
### Step-03-01: Verify Trial plan in hcta-azure-demo1 organization
- Login to Terraform Cloud
- Goto -> Organizations (hcta-azure-demo1) -> Settings -> Plan & Billing
- Verify `Current Plan`
```t
Free Trial
You are currently trialing Terraform Cloud's premium features, including improved team management , Sentinel policies , and cost estimation .
Your plan will change to Free on July 15th 2021 . Click here to select your next plan.
```

### Step-03-02: Create CLI-Driven Workspace in organization hcta-azure-demo1
- Login to [Terraform Cloud](https://app.terraform.io/)
- Select Organization -> hcta-azure-demo1
- Click on **New Workspace**
- **Choose your workflow:** CLI-Driven Workflow
- **Workspace Name:** sentinel-azure-demo1
- Click on **Create Workspace**

### Step-03-03: Update c1-versions.tf with Terraform Backend in Terraform Block
```t
  # Terraform Backend pointed to TF Cloud
  backend "remote" {
    organization = "hcta-azure-demo1-internal"

    workspaces {
      name = "sentinel-azure-demo1"
    }
  }
```


## Step-04: Terraform Cloud to Authenticate to Azure using Service Principal with a Client Secret
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

## Step-05: Configure Environment Variables in Terraform Cloud
- Go to Organization -> hcta-azure-demo1 -> Workspace ->  cli-driven-azure-demo -> Variables
- Add Environment Variables listed below
```t
ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```


## Step-06: Create Github Repository for Sentinel Policies (Policy Sets)
### Step-06-01: Create new github Repository
- **URL:** github.com
- Click on **Create a new repository**
- **Repository Name:** terraform-sentinel-policies-azure
- **Description:** Terraform Cloud and Sentinel Policies Demo on Azure
- **Repo Type:** Public / Private
- **Initialize this repository with:**
- **CHECK** - Add a README file
- **CHECK** - Add .gitignore 
- **Select .gitignore Template:** Terraform
- **CHECK** - Choose a license  (Optional)
- **Select License:** Apache 2.0 License
- Click on **Create repository**

## Step-06-02: Clone Github Repository to Local Desktop
```t
# Clone Github Repo
git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git
git clone https://github.com/stacksimplify/terraform-sentinel-policies.git
```

## Step-06-03: Copy files from terraform-sentinel-policies folder to local repo & Check-In Code

- **Source Location:** Git-Repo-Files-Sentinel
- **Destination Location:** Copy all folders and files from `Git-Repo-Files-Sentinel` newly cloned github repository folder in your local desktop `terraform-sentinel-policies-azure`
- **Check-In code to Remote Repository**
```t
# GIT Status
git status

# Git Local Commit
git add .
git commit -am "Sentinel Policies First Commit"

# Push to Remote Repository
git push

# Verify the same on Remote Repository
https://github.com/stacksimplify/terraform-sentinel-policies-azure.git
```

## Step-07: Create Policy Sets in Terraform Cloud
- Go to Terraform Cloud -> Organization (hcta-azure-demo1) -> Settings -> Policy Sets
- Click on **Connect a new Policy Set**
- Use existing VCS connection from previous section **github-terraform-modules** which we created using OAuth App concept
- **Choose Repository:** terraform-sentinel-policies-azure.git
- **Description:** Demo Sentinel Policies
- **Additional Options** - **Policies Path:** terraform-generic-sentinel-policies
- **Scope of Policies:** Policies enforced on selected workspaces
- **Workspaces:** sentinel-azure-demo1
- Click on **Connect Policy Set**


## Step-08: Execute Terraform Commands
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


# Terrafrom Initialize
terraform init

# Terraform Apply
terraform apply 

# Observation
1) Primarily verify Sentinel Policies in Terraform Cloud
2) Verify Sentinel Enforcement Mode `advisory` for `limit-proposed-monthly-cost`
3) Everything should pass and we should go to next level to confirm changes
```

## Step-09: Verify Sentinel Enforcement Mode soft-mandatory
```t
# Change "limit-proposed-monthly-cost" sentinel policy to soft-mandatory in sentinel.hcl
policy "limit-proposed-monthly-cost" {
    source = "./limit-proposed-monthly-cost.sentinel"
    enforcement_level = "soft-mandatory"
}

# GIT Status
git status

# Git Local Commit
git add .
git commit -am "soft-mandatory Commit"

# Push to Remote Repository
git push



# Terraform Apply
terraform apply 

# Observation
1) Primarily verify Sentinel Policies in Terraform Cloud
2) "limit-proposed-monthly-cost.sentinel" policy check should fail and tell us we have option to "override" and continue
```

## Step-10: Verify Sentinel Enforcement Mode hard-mandatory
```t
# Change "limit-proposed-monthly-cost" sentinel policy to hard-mandatory in sentinel.hcl
policy "limit-proposed-monthly-cost" {
    source = "./limit-proposed-monthly-cost.sentinel"
    enforcement_level = "hard-mandatory"
}

# GIT Status
git status

# Git Local Commit
git add .
git commit -am "hard-mandatory Commit"

# Push to Remote Repository
git push

# Terraform Apply
terraform apply 

# Observation
1) Primarily verify Sentinel Policies in Terraform Cloud
2) "limit-proposed-monthly-cost.sentinel" policy check should fail and Terraform Execution should stop there.
3) We don't have an option to continue or override and go to next step. 
```


## Step-11: Clean-Up & Destroy
```t
# Terraform Destroy
terraform destroy -auto-approve

# Clean-Up files
rm -rf .terraform*


# Rollback in Repo
policy "limit-proposed-monthly-cost" {
    source = "./limit-proposed-monthly-cost.sentinel"
    enforcement_level = "advisory"
}

# GIT Status
git status

# Git Local Commit
git add .
git commit -am "hard-mandatory Commit"

# Push to Remote Repository
git push
```

## Step-12: Roll back changes to have seamless demo to Students
```t
# Change "limit-proposed-monthly-cost" sentinel policy to advisory in sentinel.hcl
policy "limit-proposed-monthly-cost" {
    source = "./limit-proposed-monthly-cost.sentinel"
    enforcement_level = "advisory"
}
```

## References 
- [Terraform & Sentinel](https://www.terraform.io/docs/cloud/sentinel/index.html)
- [Example Sentinel Policies](https://www.terraform.io/docs/cloud/sentinel/examples.html)
- [Sentinel Foundational Policies](https://github.com/hashicorp/terraform-foundational-policies-library)
- [Sentinel Enforcement Levels](https://docs.hashicorp.com/sentinel/concepts/enforcement-levels)
- [Terraform Governance](https://github.com/hashicorp/terraform-guides/tree/master/governance/third-generation)
)
----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -

# Step-01: Introduction – What this whole setup is about

This section is just the high-level plan:

1. Enable Terraform Cloud trial

   * The 30-day Trial for the hcta-azure-demo1 org unlocks Team & Governance features:

     * Sentinel policies
     * Cost estimation
     * Better RBAC and team features

2. Use CLI-driven Terraform Cloud workflow

   * Instead of storing state locally, your Terraform CLI connects to Terraform Cloud and:

     * Stores state remotely (in TFC backend)
     * Runs Sentinel policy checks during plan/apply
 
   * You’ll deploy multiple Azure resources:

     1. azurerm_resource_group
     2. azurerm_linux_virtual_machine
     3. azurerm_virtual_network
     4. azurerm_public_ip
     5. azurerm_network_interface

3. Learn about 5 Sentinel policies

   These are governance checks that run on every Terraform plan/apply:

   1. allowed-providers.sentinel – restricts which Terraform providers can be used (e.g., only Azure, or only specific versions).
   2. enforce-mandatory-tags.sentinel – forces you to always have certain tags (e.g., Environment, Owner, CostCenter) on resources.
   3. limit-proposed-monthly-cost.sentinel – checks that the estimated monthly cost from the plan doesn’t exceed some limit.
   4. restrict-vm-publisher.sentinel – restricts which VM image publishers are allowed (e.g., only official Microsoft images).
   5. restrict-vm-size.sentinel – restricts allowed VM sizes (e.g., no very large/expensive SKUs).

5. Understand sentinel.hcl

   * This file tells Terraform Cloud:

     * Which policy files to load
     * What enforcement level each policy uses (advisory / soft-mandatory / hard-mandatory)

6. Connect GitHub repo to Terraform Cloud as a Policy Set

   * You store Sentinel policies in a GitHub repo.
   * Terraform Cloud connects to that repo as a Policy Set.
   * That Policy Set is attached to one or more workspaces, so the policies are enforced on their runs.

7. Test enforcement levels

   * Learn the 3 Sentinel enforcement levels:

     1. advisory          –   warns if policy fails, but allows continuing.
     2. soft-mandatory    –   fails by default, but a user with permission can override.
     3. hard-mandatory    –   fails and cannot be overridden; run stops.

# Step-02: Review Terraform manifests

These are the core Terraform files you’ll use:

1. c1-versions.tf

   * Sets:

     * Required Terraform version (e.g., required_version = ">= 1.0.0")
     * Required providers (like azurerm, random, etc.)
     * Backend config (later updated to use Terraform Cloud remote backend).

2. c2-variables.tf

   * Defines input variables (e.g., resource_group_nam, location, VM size, etc.)
   * You can supply these via dev.auto.tfvars or CLI.

3. c3-locals.tf

   * Defines locals: computed values like naming conventions or tags: e.g., local.common_tags or resource name prefixes.

4. c4-resource-group.tf

   * Contains the azurerm_resource_group resource.
   * Uses variables and/or locals for name & location.

5. c5-virtual-network.tf

   * Defines:

     * azurerm_virtual_network
     * possibly azurerm_subnet resources

6. c6-linux-virtual-machine.tf

   * Defines:

     * azurerm_network_interface
     * azurerm_public_ip
     * azurerm_linux_virtual_machine

7. c7-outputs.tf

   * Defines Terraform outputs: e.g:

     * resource group name
     * VM public IP
     * VM ID, etc.

8. dev.auto.tfvars

   * Automatically loaded file for variable values (for dev environment).
   * e.g., resource_group_name="rg-dev-sentinel" etc.

So, Step 2 is simply: “Know which Terraform files are involved and what each one generally does.”

# Step-03: Review Git-Repo-Files-Sentinel

Here they’re pointing you to existing Sentinel policy examples from HashiCorp:

* Terraform Governance Guides repo

  Contains reusable Sentinel examples and helper functions:

  1. common-functions: Shared functions used across multiple policies (e.g., parsing resources, cost data).
       
  2. azure-functions: Helpers specific to Azure resources (like filtering Azure resource types).

   3. terraform-generic-sentinel-policies: Generic policies like allowed providers, mandatory tags, etc.

The idea: Instead of writing everything from scratch, you reuse these examples as a base and tweak them.

# Step-04: Review Sentinel policies and sentinel.hcl

They want you to understand:

1. allowed-providers.sentinel

   * Ensures only certain providers are used (e.g., azurerm).
   * If someone adds aws provider, the policy might fail.

2. enforce-mandatory-tags.sentinel

   * Checks that all applicable resources have specific tags.
   * Typical tags: Environment, Owner, CostCenter.
   * Missing any required tag → policy fails.

3. limit-proposed-monthly-cost.sentinel

   * Uses Terraform’s cost estimation data.
   * If the estimated monthly cost > allowed threshold (say $100), the policy fails.

4. restrict-vm-publisher.sentinel

   * Only allow VM images from approved publishers (e.g., Canonical, Microsoft Windows Server).
   * Prevents people from creating VMs from random images.

5. restrict-vm-size.sentinel

   * Only allow certain SKU sizes (e.g., Standard_B2s, Standard_DS1_v2).
   * Avoids oversized/expensive instances.

6. sentinel.hcl

   * This config file tells TFC:

     * Which policies exist
     * Their paths
     * Their enforcement level
       
       Example structure:

      policy "limit-proposed-monthly-cost"
     {
     source            = "./limit-proposed-monthly-cost.sentinel"
     enforcement_level = "advisory"
   }
  
   You’ll later change enforcement_level from advisory → soft-mandatory → hard-mandatory.

# Step-03 (again): Create CLI-Driven Workspace on Terraform Cloud

They mis-numbered, but conceptually:

# Step-03-01: Verify Trial Plan

* Go to Terraform Cloud → Organization → Settings → Plan & Billing.

* Confirm your org is on a **Free Trial** so that:

  * Sentinel
  * Cost Estimation
  * Team features     are enabled.

# Step-03-02: Create CLI-Driven Workspace

* In Terraform Cloud:

  * Org: hcta-azure-demo1
  * New Workspace → CLI-Driven workflow
  * Name it: sentinel-azure-demo1

* CLI-driven means:

  * You run terraform plan/apply on your local machine.
  * Terraform still uses TFC as the backend & to run policies.

# Step-03-03: Backend Block in c1-versions.tf

backend "remote"
{
  organization = "hcta-azure-demo1-internal"

  workspaces {
    name = "sentinel-azure-demo1"
  }
}

This tells Terraform:

* Use remote backend (Terraform Cloud).
* Use organization hcta-azure-demo1-internal.
* Store state in workspace sentinel-azure-demo1.

So when you run terraform init:

* It connects your local directory to that remote workspace.
* State & runs are visible in Terraform Cloud UI.

# Step-04: Terraform Cloud authentication to Azure via Service Principal

Here, you’re setting up Azure credentials that Terraform Cloud will use.

# Commands explained

1. Log in to Azure interactively (local machine)

az login
az account list

* az login authenticates you as yourself so you can query and configure.
* az account list shows all subscriptions; you note the "id" you want → that’s your SUBSCRIPTION_ID.

2. Set the subscription

az account set --subscription="SUBSCRIPTION_ID"

* Ensures further commands affect that subscription.

3. Create Service Principal (SP) with Contributor role

az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"

* Creates an SP (an “app registration” + service principal) with Contributor access scoped at subscription level.

* Output:

  * appId → client_id
  * password → client_secret
  * tenant → tenant_id

4. Verify SP login

az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID
az account list-locations -o table
az logout

* Ensures the SP works and can query Azure.
* This SP’s details will be passed to Terraform via environment variables in TFC.

# Step-05: Configure Environment Variables in Terraform Cloud

In the TFC workspace (sentinel-azure-demo1):

Set Environment Variables:

ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"

These map directly to the SP you created:

* ARM_CLIENT_ID          ←   SP appId
* ARM_CLIENT_SECRET      ←   SP password
* ARM_SUBSCRIPTION_ID    ←   subscription ID
* ARM_TENANT_ID          ←   tenant id

The AzureRM Provider in Terraform automatically uses these env vars to authenticate.

# Step-06: GitHub Repository for Sentinel Policies

# Step-06-01: Create Repo

You create a repo like:

* Name: terraform-sentinel-policies-azure
* Description: “Terraform Cloud and Sentinel Policies Demo on Azure.”

* Initialize with:

  * README
  * .gitignore for Terraform (ignores .terraform, state files, etc.)
  * Optional license (e.g., Apache 2.0)

This repo will hold your Sentinel policies and sentinel.hcl.

# Step-06-02: Clone Repo

git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git

Now you have a local folder to copy policies into.

# Step-06-03: Copy Files & Push

* Source folder: Git-Repo-Files-Sentinel (provided sample policies)
* Destination: your cloned repo folder terraform-sentinel-policies-azure

* Then:

git status
git add .
git commit -am "Sentinel Policies First Commit"
git push

Now your policies & sentinel.hcl are in GitHub.

# Step-07: Create Policy Sets in Terraform Cloud

In Terraform Cloud:

1. Go to Settings → Policy Sets

2. Connect a new Policy Set

3. Use existing VCS connection (GitHub OAuth app you already configured).

4. Choose repository: terraform-sentinel-policies-azure

5. Set:

   * Description: “Demo Sentinel Policies”
   * Policies Path: terraform-generic-sentinel-policies      (TFC will only look at policies in that subfolder)
 
   * Scope:

     * Apply only to selected workspaces
     * Workspace: sentinel-azure-demo1

Now, whenever that workspace runs a plan/apply, Terraform Cloud:

* Pulls policies from that GitHub repo/path
* Evaluates them against your run

# Step-08: Execute Terraform Commands

On your local machine:

1. Log in to Terraform Cloud: terraform login

* Opens browser → you generate an API token.
* Token saved in ~/.terraform.d/credentials.tfrc.json

2. Initialize: terraform init

* Reads backend block:

  * Connects this folder to the TFC workspace sentinel-azure-demo1.
  * Downloads providers.
  * Configures remote backend.

3. Apply: terraform apply

* Terraform sends plan to Terraform Cloud backend.
* Terraform Cloud:

  * Evaluates your plan.
  * Runs Sentinel policies.
  * Because limit-proposed-monthly-cost is initially advisory:

    * If the cost is high, you get a warning, but the run can continue.

You should verify in the TFC UI that all policies ran and see their statuses.

# Step-09: Enforcement Level = soft-mandatory

You now change the policy’s enforcement level:

policy "limit-proposed-monthly-cost"
{
  source            = "./limit-proposed-monthly-cost.sentinel"
  enforcement_level = "soft-mandatory"
}

Then:

git status
git add .
git commit -am "soft-mandatory Commit"
git push

After pushing, TFC automatically fetches the updated policy.

Now run again: terraform apply

Behavior now:

* If the cost policy fails:

   * Sentinel marks it as soft-mandatory failure.

   * In TFC UI, you see a failed policy but also an “override” option (if your user has permission).

   * You can choose to override and continue the run.

This simulates a governance model where policy is strongly recommended, but there’s an “escape hatch” with approval.

# Step-10: Enforcement Level = hard-mandatory

Change it again:

policy "limit-proposed-monthly-cost"
{
  source            = "./limit-proposed-monthly-cost.sentinel"
  enforcement_level = "hard-mandatory"
}

Git cycle:

git status
git add .
git commit -am "hard-mandatory Commit"
git push

Run: terraform apply

Now, if the policy fails:

* The run stops.
* No override button.
* You must fix either:

  * The Terraform config (e.g., use cheaper resources), or
  * The policy itself (and push a new version).

This model's strict guardrails that no one can bypass through the UI.

# Step-11: Clean-up & Destroy

You clean up both infrastructure and repository settings:

1. Destroy resources: terraform destroy -auto-approve

* Destroys all Azure resources created by this config.
* Keeps state in TFC, but state now reflects “no resources”.

2. Clean local Terraform files: rm -rf .terraform*

* Removes local cache and state metadata.

3. Rollback policy to advisory

policy "limit-proposed-monthly-cost" 
{
  source            = "./limit-proposed-monthly-cost.sentinel"
  enforcement_level = "advisory"
}

Git:

git status
git add .
git commit -am "hard-mandatory Commit"  # (message is a bit misleading, but OK)
git push

Now the repo is back to a gentle advisory policy suitable for future demos.

# Step-12: Final rollback reminder

This is basically repeating the final desired state:

policy "limit-proposed-monthly-cost" 
{
  source            = "./limit-proposed-monthly-cost.sentinel"
  enforcement_level = "advisory"
}

So the next time you (or students) run the demo:

* The cost policy only warns.
* They don’t get blocked or confused by soft/hard mandatory fences.

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: -
