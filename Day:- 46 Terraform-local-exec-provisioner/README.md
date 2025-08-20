---
title: Terraform local-exec Provisioner
description: Learn Terraform local-exec Provisioner
---

## Step-01: Introduction
- Understand about [local-exec Provisioner](https://www.terraform.io/docs/language/resources/provisioners/local-exec.html)
- The `local-exec` provisioner invokes a local executable after a resource is created. 
- This invokes a process on the machine running Terraform, not on the resource. 

## Step-02: Review local-exec provisioner code
- We will create one provisioner during creation-time. It will output private ip of the instance in to a file named `creation-time.txt`
- We will create one more provisioner during destroy time. It will output destroy time with date in to a file named `destroy-time.txt`
- **c6-linux-virtual-machine.tf**
```t
  # local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    command = "echo ${azurerm_linux_virtual_machine.mylinuxvm.public_ip_address} >> creation-time.txt"
    working_dir = "local-exec-output-files/"
    #on_failure = continue
  }

  # local-exec provisioner - (Destroy-Time Provisioner - Triggered during Destroy Resource)
  provisioner "local-exec" {
    when    = destroy
    command = "echo Destroy-time provisioner Instanace Destroyed at `date` >> destroy-time.txt"
    working_dir = "local-exec-output-files/"
  }  
```


## Step-03: Review Terraform manifests & Execute Terraform Commands
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
Verify the file in folder "local-exe-output-files/creation-time.txt"
```

## Step-04: Clean-Up Resources & local working directory
```t
# Terraform Destroy
terraform destroy -auto-approve

# Verify
Verify the file in folder "local-exec-output-files/destroy-time.txt"

# Delete Terraform files 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## 🔹 Step-01: Introduction

- The local-exec provisioner is a way for Terraform to run shell commands on the same machine where Terraform itself is running (your laptop, CI/CD server, etc.) after a resource is created or destroyed.
  
- It is important: It does not run on the resource (like inside a VM). Instead, the commands are executed locally.
  
- Use cases:
  - Writing resource information (like IP addresses) to a file
  - Triggering scripts (bash, PowerShell, etc.)
  - Running curl commands, sending notifications, etc.

## Step-02: Code Breakdown (Provisioners in Terraform)

File: c6-linux-virtual-machine.tf

# local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)

provisioner "local-exec" 
{
  command     = "echo ${azurerm_linux_virtual_machine.mylinuxvm.public_ip_address} >> creation-time.txt"
  working_dir = "local-exec-output-files/"
  #on_failure = continue
}

-------------------------------------------------------------------------------------------------------------------------------------

### Explanation:

- provisioner "local-exec" → Defines a local-exec provisioner block within a resource.

- command → The exact shell command to run: - echo ${azurerm_linux_virtual_machine.mylinuxvm.public_ip_address} >> creation-time.txt

    - Terraform fetches the public IP address of the VM (mylinuxvm) from the Azure resource.
    - It appends (>>) this IP address to a file called creation-time.txt.

- working_dir → The folder where the command will be executed (local-exec-output-files/).

- #on_failure = continue (commented out): - If enabled, even if the provisioner fails, Terraform would continue with the resource creation (does not stop).

Effect: After the VM is created, Terraform will generate/append to local-exec-output-files/creation-time.txt with the instance’s public IP.

# local-exec provisioner - (Destroy-Time Provisioner - Triggered during Destroy Resource)

provisioner "local-exec" 
{
  when    = destroy
  command = "echo Destroy-time provisioner Instanace Destroyed at date >> destroy-time.txt"
  working_dir = "local-exec-output-files/"
}

### Explanation:

- This provisioner runs during resource destruction (when Terraform applies or destroys the VM).

- when = destroy → specifies that this provisioner should trigger when the VM is destroyed.

- command: - Runs: echo Destroy-time provisioner Instance Destroyed at \date\ >> destroy-time.txt

  - It will append a timestamp message to destroy-time.txt marking when the VM was destroyed.

- working_dir → again, operations happen inside local-exec-output-files/.

Effect: When the VM is destroyed, a log entry is saved in local-exec-output-files/destroy-time.txt, including the current date/time.

## Step-03: Workflow Execution Commands

# Terraform Initialize

terraform init

- Downloads provider plugins (e.g., Azure provider) and sets up the working directory.

# Terraform Validate

terraform validate: - Ensures syntax and structure are correct.

# Terraform Format

terraform fmt: - Formats .tf files to Terraform’s standard style.

# Terraform Plan

terraform plan: - Shows what Terraform will do (what resources it will create/change/destroy).

# Terraform Apply

terraform apply -auto-approve: - Creates resources in Azure (+ runs local-exec provisioners during creation).
- -auto-approve skips the confirmation prompt.

# Verify

Verify the file in the folder "local-exe-output-files/creation-time.txt"

- After applying, check that the output file contains the VM’s public IP.

## 🔹 Step-04: Cleanup & Verification

# Terraform Destroy

terraform destroy -auto-approve

- Destroys the Azure VM, NIC, VNet, etc.
- Runs the destroy-time provisioner (writes a timestamp to destroy-time.txt).

# Verify

Verify the file in the folder "local-exec-output-files/destroy-time.txt"

- Ensure the destroy log file was created and contains the timestamp.

# Delete Terraform files 

rm -rf .terraform
rm -rf terraform.tfstate

- Cleans up local state and Terraform cache files.

## Visual Flow

1. terraform apply  
   Create resources → local-exec (create-time) runs → save VM Public IP to creation-time.txt

2. terraform destroy
    Destroy resources → local-exec (destroy-time) runs → save destroy timestamp to destroy-time.txt
