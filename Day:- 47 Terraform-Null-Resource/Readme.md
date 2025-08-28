---
title: Terraform Null Resource
description: Learn Terraform Null Resource
---

## Step-01: Introduction
- Understand about [Null Provider](https://registry.terraform.io/providers/hashicorp/null/latest/docs)
- Understand about [Null Resource](https://www.terraform.io/docs/language/resources/provisioners/null_resource.html)
- Understand about [Time Provider](https://registry.terraform.io/providers/hashicorp/time/latest/docs)
- **Usecase:** Force a resource to update based on a changed null_resource
- Create `time_sleep` resource to wait for 90 seconds after Azure Linux VM Instance creation
- Create Null resource with required provisioners
1. File Provisioner: Copy apps/app1 folder to /tmp
2. Remote Exec Provisioner: Copy app1 folder from /tmp to /var/www/htnl
- Over the process we will learn about
1. null_resource
2. time_sleep resource
3. We will also learn how to Force a resource to update based on a changed null_resource using `timestamp function` and `triggers` in `null_resource`


## Step-02: Define null provider in Terraform Settings Block
- Update null provider info listed below in **c1-versions.tf**
```t
    null = {
      source = "hashicorp/null"
      version = ">= 3.0.0"
    }
```

## Step-03: Define Time Provider in Terraform Settings Block
- Update time provider info listed below in **c1-versions.tf**
```t
    time = {
      source = "hashicorp/time"
      version = ">= 0.6.0"
    }  
```

## Step-04: Create / Review the c8-null-resource.tf terraform configuration
### Step-04-01: Create Time Sleep Resource
- This resource will wait for 90 seconds after VM Instance creation.
- This wait time will give VM Instance to provision the Apache Webserver and create all its relevant folders
- Primarily if we want to copy static content we need Apache webserver static folder `/var/www/html`
```t
# Wait for 90 seconds after creating the above Azure Virtual Machine Instance 
resource "time_sleep" "wait_90_seconds" {
  depends_on = [azurerm_linux_virtual_machine.mylinuxvm]
  create_duration = "90s"
}
```
### Step-04-02: Create Null Resource
- Create Null resource with `triggers` with `timestamp()` function which will trigger for every `terraform apply`
- This `Null Resource` will help us to sync the static content from our local folder to VM Instnace as and when required.
- Also only changes will applied using only `null_resource` when `terraform apply` is run. In other words, when static content changes, how will we sync those changes to VM Instance using terraform - This is one simple solution.
- Primarily the focus here is to learn the following
  - null_resource
  - null_resource trigger
  - How trigger works based on timestamp() function ?
  - Provisioners in Null Resource
```t

# Terraform NULL RESOURCE
# Sync App1 Static Content to Webserver using Provisioners
resource "null_resource" "sync_app1_static" {
  depends_on = [ time_sleep.wait_90_seconds ]
  triggers = {
    always-update =  timestamp()
  }

  # Connection Block for Provisioners to connect to Azure VM Instance
  connection {
    type = "ssh"
    host = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address 
    user = azurerm_linux_virtual_machine.mylinuxvm.admin_username
    private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
  }  

 # Copies the app1 folder to /tmp
  provisioner "file" {
    source      = "apps/app1"
    destination = "/tmp"
  }

# Copies the /tmp/app1 folder to Apache Webserver /var/www/html directory
  provisioner "remote-exec" {
    inline = [
      "sudo cp -r /tmp/app1 /var/www/html"
    ]
  }
}
```

## Step-05: Execute Terraform Commands
```t
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Format
terraform fmt

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve

# Verify
ssh -i ssh-keys/terraform-azure.pem azureuser@<PUBLIC-IP>
ls -lrt /tmp
ls -lrt /tmp/app1
ls -lrt /var/www/html
ls -lrt /var/www/html/app1
http://<public-ip>/app1/app1-file1.html
http://<public-ip>/app1/app1-file2.html
```

## Step-06: Create new file locally in app1 folder
- Create a new file named `app1-file3.html`
- Also updated `app1-file1.html` with some additional info
- **file3.html**
```html
<h1>>App1 File3</h1
```
- **file1.html**
```html
<h1>>App1 File1 - Updated</h1
```
- Sample `terraform plan` Output
```log
# Terraform Plan Output
Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # null_resource.sync_app1_static must be replaced
-/+ resource "null_resource" "sync_app1_static" {
      ~ id       = "256904776759333943" -> (known after apply)
      ~ triggers = {
          - "always-update" = "2021-06-14T05:44:33Z"
        } -> (known after apply) # forces replacement
    }

Plan: 1 to add, 0 to change, 1 to destroy.

───────────────────────────────────────────────────────────────
```

## Step-07: Execute Terraform plan and apply commands
```t
# Terraform Plan
terraform plan
Observation: You should see changes for "null_resource.sync_app1_static" because trigger will have new timestamp when you fired the terraform plan command

# Terraform Apply
terraform apply -auto-approve

# Verify
ssh -i ssh-keys/terraform-azure.pem azureuser@<PUBLIC-IP>
ls -lrt /tmp
ls -lrt /tmp/app1
ls -lrt /var/www/html
ls -lrt /var/www/html/app1
http://<public-ip>/app1/app1-file1.html
http://<public-ip>/app1/app1-file3.html
```

## Step-08: Clean-Up Resources & local working directory
```t
# Terraform Destroy
terraform destroy -auto-approve

# Delete Terraform files 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Step-09: Roll back to Demo State
```t
# Change-1: Delete app1-file3.html in apps/app1 folder
# Change-2: app1-file1.html - Remove updated text
```


## References

- [Resource: time_sleep](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep)
  
- [Time Provider](https://registry.terraform.io/providers/hashicorp/time/latest/docs)

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## 🔹 Step-01: Introduction
Here we define the **purpose** of the configuration:

1. **Providers**:
   - **Null Provider:**  
     It provides resources like `null_resource`, mostly used for provisioners or forcing changes without affecting infrastructure.  
   - **Time Provider (time_sleep):**  
     Lets you introduce delays/wait periods into your deployment. Useful when the target resource (like a VM) needs some time to finish initialization.

2. **Use case**:
   - You want to copy application files (`apps/app1`) into an **Azure Linux VM** after it has been provisioned.
   - To ensure the VM has **Apache webserver directories ready (`/var/www/html`)**, you add a delay (`time_sleep`).
   - Then you use a **null_resource** with provisioners:
     - `file` provisioner → copies files from local directory to VM.
     - `remote-exec` provisioner → moves those files into the Apache web server directory.

3. **Key Learning Aspects**:
   - How **null_resource** works.
   - How to use **triggers** with `timestamp()` → which forces Terraform to re-run the resource each time you apply (used to sync updated files).
   - Using `time_sleep` to delay provisioning.

***

## 🔹 Step-02: Define **Null Provider** in `c1-versions.tf`

```t
null = {
  source  = "hashicorp/null"
  version = ">= 3.0.0"
}
```

- This ensures Terraform downloads and uses the **Null Provider**.
- Null provider itself doesn’t directly create infrastructure but is a handy way to run provisioners.

***

## 🔹 Step-03: Define **Time Provider**  

```t
time = {
  source  = "hashicorp/time"
  version = ">= 0.6.0"
}
```

- This adds the **Time Provider** which includes utilities like `time_sleep`.

***

## 🔹 Step-04: Configuration (`c8-null-resource.tf`)
This is the core file.

### 📌 Step-04-01: **time_sleep Resource**
```t
resource "time_sleep" "wait_90_seconds" {
  depends_on      = [azurerm_linux_virtual_machine.mylinuxvm]
  create_duration = "90s"
}
```
- Ensures provisioning waits **90 seconds** after VM creation.  
- Purpose: to allow Apache and `/var/www/html` to be properly available before copying files.

***

### 📌 Step-04-02: **null_resource with triggers and provisioners**

```t
resource "null_resource" "sync_app1_static" {
  depends_on = [ time_sleep.wait_90_seconds ]

  triggers = {
    always-update = timestamp()
  }
```

- `null_resource` doesn’t create infrastructure; here it’s used as a **file syncing mechanism**.
- The **triggers block** with `timestamp()` ensures **a new timestamp each time you apply Terraform**, which means the resource forces recreation → the provisioners re-run.
- This way, any updated local files are pushed to the VM.

***

#### Connection Block
```t
connection {
  type        = "ssh"
  host        = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
  user        = azurerm_linux_virtual_machine.mylinuxvm.admin_username
  private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
}
```
- Defines how the provisioners connect to the VM.
- Uses SSH with a private key (`terraform-azure.pem`).

***

#### File Provisioner
```t
provisioner "file" {
  source      = "apps/app1"
  destination = "/tmp"
}
```
- Copies entire **local folder** (`apps/app1`) → to remote VM `/tmp`.

***

#### Remote Exec Provisioner
```t
provisioner "remote-exec" {
  inline = [
    "sudo cp -r /tmp/app1 /var/www/html"
  ]
}
```
- After copying files to `/tmp`, moves them into **Apache’s default webserver folder** (`/var/www/html`).  
- This makes the files accessible via a web browser.

***

## 🔹 Step-05: Terraform Workflow

```t
terraform init      # Initialize providers (null, time, azurerm, etc.)
terraform validate  # Validate syntax
terraform fmt       # Format code
terraform plan      # Preview what will happen
terraform apply     # Apply changes (deploy VM + sync static files)
```

**Verification**:  
- SSH into VM and check `/tmp/app1` and `/var/www/html/app1`.
- Access in browser → `http://<public-ip>/app1/file1.html`

***

## 🔹 Step-06: Updating Static Content

Suppose you add `app1-file3.html` and update `app1-file1.html`.  

Terraform detects change because `timestamp()` forces replacement:

```log
-/+ resource "null_resource" "sync_app1_static" {
      ~ triggers = {
          - "always-update" = "old-timestamp"
        } -> (new timestamp)
}
```

- This means Terraform will **destroy + recreate only the null_resource**, re-running provisioners to sync changed files.  
- VM remains untouched, only **static content is refreshed**.

***

## 🔹 Step-07: Apply Updates

```t
terraform plan
terraform apply -auto-approve
```

- Only `null_resource.sync_app1_static` gets replaced.
- Files are re-synced → now `/var/www/html/app1` will include new `file3.html` and updated `file1.html`.

***

## 🔹 Step-08: Clean-Up
```t
terraform destroy -auto-approve   # Destroys VM + time_sleep + null_resource
rm -rf .terraform* terraform.tfstate*  # Clean local Terraform files
```

***

## 🔹 Step-09: Rollback
- Delete the `app1-file3.html`.  
- Revert changes in `app1-file1.html`.  
- Run `terraform apply` again → only the `null_resource` is reapplied, rolling back VM’s static content.
