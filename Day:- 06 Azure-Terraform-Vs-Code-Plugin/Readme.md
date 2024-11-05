---
title: Azure Terraform VSCode Extension
description: Explore Terraform Azure VSCode Extension
---

### Prerequisite: Configure Azure Cloud Shell

Before getting started, you need to configure Azure Cloud Shell. Cloud Shell is a browser-based shell available within the Azure portal that provides ready-to-use, authenticated access to a shell instance. With Cloud Shell, you don't need to install tools like Azure CLI or Terraform on your local machine, making it an ideal environment for executing cloud commands directly.



### Step 01: Introduction

For students or users who encounter difficulties in setting up Terraform locally on their desktops, using Azure Cloud Shell can be a great alternative. This setup allows you to run Terraform commands directly from the cloud without local configuration issues. Additionally, the **Azure Terraform VS Code Extension** helps you manage Terraform files within VS Code and execute commands in Cloud Shell. You can install this extension to access various Terraform features within VS Code.

- [Azure Terraform VSCode Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureterraform): This extension helps run Terraform commands directly from VS Code, either locally or via Cloud Shell.


### Step 02: Install Graphviz

Graphviz is a graph visualization software that helps you visualize the relationships and dependencies between different resources in your Terraform configurations.

- **Install Graphviz**: To install Graphviz on macOS, use the following command:

- # Install Graphviz: brew install Graphviz
  
    
- **[Download Graphviz](https://graphviz.org/download/)**: Alternatively, you can download the software package for different operating systems directly from the Graphviz website.


### **Step 03: Install NodeJS**

Node.js is required by some VS Code extensions and plugins to handle backend logic and scripting, especially for integration with Terraform.

- **[Download NodeJs](https://nodejs.org/en/)**: Visit the Node.js website to download the installation package for your OS and follow the steps to install it locally.


### **Step 04: Install the Azure Terraform Visual Studio Code Extension**

The **Azure Terraform Visual Studio Code Extension** provides a convenient way to work with Terraform in VS Code, enabling you to execute commands either locally or through Azure Cloud Shell.

- **Supported Commands**:
  
    - init: Initializes a new or existing Terraform configuration.
    - Plan: Create a plan for infrastructure changes.
    - apply: Applies the changes required to reach the desired state of the configuration.
    - validate Validates the configuration.
    - refresh: Refreshes the state file.
    - destroy: Destroys the infrastructure managed by Terraform.
    - Visualization: Generates a visual representation of the configuration.
    - push: Syncs local Terraform files with Azure Cloud Shell.
    - Execute Test: Runs tests (if any are defined).

Some commands will require dependencies installed locally, so make sure you have the necessary setup.

### **Step 05: VS Code - Integrated Terminal: Run Terraform Commands**

To run Terraform commands from VS Code's integrated terminal:

1. **Set Terminal to Integrated Mode**:
    
    - Go to **VS Code Settings** > **Extensions** > **Azure Terraform** > **Azure Terraform: Terminal** and select **Integrated**.
   
2. **Open the Terraform Project**:
    
    - Open the `06-Azure-Terraform-VsCode-Plugin/terraform-manifests` directory in a new VS Code window.

3. **Run Commands**:
    
    - Use the shortcut `CMD + SHIFT + P` to open the command palette, and run the following commands:
        - `Azure Terraform: init`
        - `Azure Terraform: validate`
        - `Azure Terraform: plan`
        - `Azure Terraform: apply`
        - `Azure Terraform: destroy`
        - `Azure Terraform: visualize`

4. **Visualize Terraform Graph**:
    
    - Review the generated **Terraform Graph** (requires Graphviz) to see dependencies among resources.

### **Step 06: VS Code - CloudShell Terminal: Run Terraform Commands**

To run commands via Cloud Shell in VS Code:

1. **Set Terminal to CloudShell Mode**:

     - Go to **VS Code Settings** > **Extensions** > **Azure Terraform** > **Azure Terraform: Terminal** and select **CloudShell**.

3. **Access Cloud Shell Storage**:

     - If you haven't used Cloud Shell before, you'll need to create storage when prompted.

5. **Open the Terraform Project**:

     - Open the `06-Azure-Terraform-VsCode-Plugin/terraform-manifests` directory in VS Code.

7. **Run Commands**:

     - Run the following commands via Cloud Shell:
        - Azure Terraform: Push
        - Azure Terraform: init
        - Azure Terraform: validate
        - Azure Terraform: plan
        - Azure Terraform: apply
        - Azure Terraform: destroy

9. **Push and Plan Changes**:
    
    - Modify the c1-versions.tf file, then use `Azure Terraform: Push` to sync changes with Cloud Shell and run Azure Terraform: plan to see the updated plan.


### **Step 07: Clean-Up**

After completing your work, clean up any temporary Terraform files.


# Remove Terraform state and cache files

- rm -rf .terraform*

- rm -rf terraform.tfstate

### **References**

- **[Azure Terraform VSCode Extension Documentation](https://docs.microsoft.com/en-us/azure/developer/terraform/configure-vs-code-extension-for-terraform)**: Official guide to configuring and using the Azure Terraform extension in VS Code.

- **[Graphviz Documentation](https://graphviz.org/download/)**: Detailed instructions for installing and using Graphviz for visualizations. 

This setup helps you efficiently manage Terraform workflows in both local and cloud-based environments.
