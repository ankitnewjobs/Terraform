# Time Resource

# Wait for 90 seconds after creating the above Azure Virtual Machine Instance 

resource "time_sleep" "wait_90_seconds" 
{
  depends_on = [azurerm_linux_virtual_machine.mylinuxvm]
  create_duration = "90s"
}

# Terraform NULL RESOURCE

# Sync App1 Static Content to Webserver using Provisioners

resource "null_resource" "sync_app1_static" 
{
  depends_on = [time_sleep.wait_90_seconds]
  triggers = {
    always-update = timestamp()
  }

# Connection Block for Provisioners to connect to Azure VM Instance

  connection 
{
    type = "ssh"
    host = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
    user = azurerm_linux_virtual_machine.mylinuxvm.admin_username
    private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
  }

# File Provisioner: Copies the app1 folder to /tmp

  provisioner "file"
{
    source = "apps/app1"
    destination = "/tmp"
  }

# Remote-Exec Provisioner: Copies the /tmp/app1 folder to Apache Webserver /var/www/html directory

  provisioner "remote-exec" 
{
    inline = [
      "sudo cp -r /tmp/app1 /var/www/html"
    ]    
  }
}

----------------------------------------------------------------------------------------------------------------------------------------

# Explanation: - 

### Time Sleep Resource

resource "time_sleep" "wait_90_seconds" 
{
  depends_on     = [azurerm_linux_virtual_machine.mylinuxvm]
  create_duration = "90s"
}

- Purpose: This introduces an artificial delay of 90 seconds after the VM has been created.  
- depends_on: Ensures this resource runs *only after* the VM `mylinuxvm` is created.  
- create_duration = "90s": Terraform waits for 90 seconds before continuing further.  
- Why? Often, when provisioning files or executing remote commands immediately after VM creation, the VM might not yet be fully ready to accept SSH connections. 
  This delay helps prevent connection errors.

### Null Resource with Provisioners

resource "null_resource" "sync_app1_static" 
{
  depends_on = [time_sleep.wait_90_seconds]
  triggers = {
    always-update = timestamp()
  }

- null_resource: This represents a “dummy” resource in Terraform used mainly to execute local actions or provisioners without actually creating cloud infrastructure.  
- depends_on = [time_sleep.wait_90_seconds]: Ensures this step runs only after the 90-second wait has finished.  
- triggers: A mechanism to force Terraform to re-run this resource when the specified values change.  
  - always-update = timestamp() means that every time you run Terraform, timestamp() generates a new value, which triggers the null_resource to always re-run (useful when you always want to copy fresh files).

### Connection Block

  connection 
{
    type        = "ssh"
    host        = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
    user        = azurerm_linux_virtual_machine.mylinuxvm.admin_username
    private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
  }

- type = "ssh": Specifies SSH as the remote connection type.  
- host: Uses the VM’s public IP address.  
- user: Uses the admin username defined for the VM.  
- private_key: Loads the private key stored in terraform-azure.pem for authentication (instead of using a password).  
- Purpose: Let Terraform provisioners (file/remote-exec) connect to the VM over SSH.

### File Provisioner

  provisioner "file"
{
    source      = "apps/app1"
    destination = "/tmp"
  }

- Purpose: Copies files or directories from the local Terraform machine to the remote VM.  
- source: apps/app1 is a local folder where the static content for App1 resides.  
- destination: /tmp is a temporary directory on the remote VM.  
So the entire app1 folder will end up inside /tmp on the VM.

### Remote-Exec Provisioner

  provisioner "remote-exec"
{
    inline = [
      "sudo cp -r /tmp/app1 /var/www/html"
    ]    
  }

- remote-exec: Runs commands inside the remote VM after connection.  
- inline: Specifies shell commands to run. In this case:  
  - sudo cp -r /tmp/app1 /var/www/html: Copies the uploaded app1 folder from /tmp into the Apache webserver directory /var/www/html.  
- Result: The web server now serves the app1 static content.

