---
title: Terraform remote-exec Provisioner
description: Learn Terraform remote-exec Provisioner
---
## Step-01: Introduction
- Understand about [remote-exec Provisioner](https://www.terraform.io/docs/language/resources/provisioners/remote-exec.html)
- The `remote-exec` provisioner invokes a script on a remote resource after it is created. 
- This can be used to run a configuration management tool, bootstrap into a cluster, etc. 

## Step-02: Create / Review Provisioner configuration
- **Usecase:** 
1. We will copy a file named `file-copy.html` using `File Provisioner` to "/tmp" directory
2. Using `remote-exec provisioner`, using linux commands we will in-turn copy the file to Apache Webserver static content directory `/var/www/html` and access it via browser once it is provisioned
```t
 # Copies the file-copy.html file to /tmp/file-copy.html
  provisioner "file" {
    source      = "apps/file-copy.html"
    destination = "/tmp/file-copy.html"
  }

# Copies the file to Apache Webserver /var/www/html directory
  provisioner "remote-exec" {
    inline = [
      "sleep 120",  # Will sleep for 120 seconds to ensure Apache webserver is provisioned using custom_data
      "sudo cp /tmp/file-copy.html /var/www/html"
    ]
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
1) Login to Azure VM Instance
ssh -i ssh-keys/terraform-azure.pem azureuser@PUBLIC_IP_ADDRESSS_OF_YOUR_VM
ssh -i ssh-keys/terraform-azure.pem azureuser@54.197.54.126

2) Verify /tmp for file named file-copy.html all files copied (ls -lrt /tmp/file-copy.html)
3) Verify /var/www/html for a file named file-copy.html (ls -lrt /var/www/html/file-copy.html)
4) Access via browser http://<Public-IP>/file-copy.html
```
## Step-04: Clean-Up Resources & local working directory
```t
# Terraform Destroy
terraform destroy -auto-approve

# Delete Terraform files 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

-------------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

## Step-01: Introduction

- The remote-exec Provisioner in Terraform lets you run commands or scripts on a remote machine (such as a VM) immediately after it's been created.
- Typical use cases include running configuration management tools, joining a cluster, or preparing a machine for application deployment.
- The remote-exec provisioner requires a connection method (like SSH for Linux VMs), which is specified in your resource block configuration.
 
## Step-02: Provisioner Configuration

Use Case:

1. Use Terraform's file provisioner to copy a local HTML file (file-copy.html) onto a remote VM's /tmp directory.
2. Use the remote-exec provisioner to copy that HTML file from `/tmp` to the Apache web server's static content directory (/var/www/html), making it accessible via the browser.

Terraform Code Explained:

# Copies the file-copy.html file to /tmp/file-copy.html

provisioner "file" 
{
  source      = "apps/file-copy.html"
  destination = "/tmp/file-copy.html"
}

# Copies the file to the Apache Webserver /var/www/html directory

provisioner "remote-exec" 
{
  inline = [
    "sleep 120",  # Will sleep for 120 seconds to ensure Apache webserver is provisioned using custom_data
    "sudo cp /tmp/file-copy.html /var/www/html"
  ]
}

Explanation:

- The file provisioner block uploads the local HTML file (apps/file-copy.html) to the path /tmp/file-copy.html on the target VM.
- The remote-exec provisioner executes a list of shell commands (inline). Here:
  - "sleep 120" waits for 120 seconds. This pause is strategic to ensure the Apache server is fully set up before the file is moved, guarding against timing issues.
  - "sudo cp /tmp/file-copy.html /var/www/html" copies the uploaded file into Apache's web root so it becomes accessible as a web page.
- The use of sudo is necessary because /var/www/html typically requires elevated permissions.

## Step-03: Review, Apply, and Verify

Terraform Workflow:

terraform init                  # Initialize Terraform (downloads plugins/modules)
terraform validate              # Check configuration for errors
terraform fmt                   # Format code for readability and best practices
terraform plan                  # Preview the changes before applying 
terraform apply -auto-approve   # Apply the plan automatically without interactive approval

Post-Deployment Verification:

1. Log in to the VM using SSH (replace with your public IP and key): ssh -i ssh-keys/terraform-azure.pem azureuser@
   
2. Verify that the file exists in /tmp: ls -lrt /tmp/file-copy.html
   
3. Verify it was moved to the Apache directory: ls -lrt /var/www/html/file-copy.html
   
4. Access the HTML file via browser: http:///file-copy.html
   
   You should see your HTML file rendered, confirming successful provisioning.

## Step-04: Clean-Up Resources

To destroy all cloud resources and clean your workspace:

terraform destroy -auto-approve         # Deletes all resources managed by your Terraform configuration
rm -rf .terraform* terraform.tfstate*   # Deletes local state files and configuration caches

This ensures no billing for unused cloud resources and keeps your local system tidy.
