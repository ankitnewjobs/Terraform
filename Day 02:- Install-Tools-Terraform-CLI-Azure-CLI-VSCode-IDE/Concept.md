# Install Terraform, Azure CLI, and VSCode Editor description: Install all the tools required for learning Terraform on Azure Cloud

## Step-01: Introduction

- Install [Terraform CLI](https://www.terraform.io/downloads.html)
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Install [VS Code Editor](https://code.visualstudio.com/download)
- Install [HashiCorp Terraform plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
- Install [Git Client](https://git-scm.com/downloads)

# Step-02: MACOS: Terraform Install

- [Download Terraform MAC](https://www.terraform.io/downloads.html)
- [Install CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Unzip the package
```t
# Copy the binary zip file to a folder
mkdir /Users/<YOUR-USER>/Documents/terraform-install
COPY Package to "terraform-install" folder

# Unzip
unzip <PACKAGE-NAME>
unzip terraform_0.15.4_darwin_amd64.zip

# Copy terraform binary to /usr/local/bin
echo $PATH
mv terraform /usr/local/bin

# Verify Version
terraform version

# To Uninstall Terraform (NOT REQUIRED)
rm -rf /usr/local/bin/terraform
``` 

## Step-03: MACOS: IDE for Terraform - VS Code Editor

- [Microsoft Visual Studio Code Editor](https://code.visualstudio.com/download)
- [Hashicorp Terraform Plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
- Configure [Course Github Repository](https://github.com/stacksimplify/hashicorp-certified-terraform-associate-on-azure) using VS Code Editor


## Step-04: MACOS: Install Azure CLI

- [Azure CLI Install](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Install Azure CLI - MAC](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos)
```t

# Install XCode
brew update 
xcode-select --install
Observation: Verify images for reference in "image-reference" folder

# Sample Error (Without Xcode if we try az cli install it will through this error)
Error: python@3.8: the bottle needs the Apple Command Line Tools installed.
  You can install them, if desired, with:
    xcode-select --install


# AZ CLI Current Version (if installed)
az --version

# Install Azure CLI (if not installed)
brew update 
brew install azure-cli

# Upgrade az cli version
az --version
brew upgrade azure-cli 
[or]
az upgrade
az --version
```

## Step-05: Terraform - Authenticating using the Azure CLI

- [Azure Provider: Authenticating using the Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)
```t
# Azure CLI Login
az login

# List Subscriptions
az account list

# Set Specific Subscription (if we have multiple subscriptions)
az account set --subscription="SUBSCRIPTION_ID"
```

## Step-06: Install Git Client

- [Download Git Client](https://git-scm.com/downloads)
- This is required when we are working with `Terraform Modules`


![{23030C56-488D-41E4-94B9-B2E5A34DEAD3}](https://github.com/user-attachments/assets/d0b95b05-c092-4737-b115-7883e7850232)

![{5D7046F2-AC72-4DD2-872F-077242E4D2D3}](https://github.com/user-attachments/assets/1c3c37d7-86ff-456f-aa61-f792deb89c33)

![1](https://github.com/user-attachments/assets/38849d11-2781-4739-a369-2c3c468f509f)



## Step-07: WindowsOS: Terraform & Azure CLI Install

### Step-07-01: Install Git Client

- [Download Git Client](https://git-scm.com/downloads)

- This is required when we are working with `Terraform Modules`

### Step-07-02: Install Azure CLI

- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)

![{056A45F7-26E2-4F11-A7CE-F2C1475FE416}](https://github.com/user-attachments/assets/9c62450c-2456-4de5-92e0-58bcd838d00b)

![{C463AE66-1830-4209-A7F5-2B4F2CFA2136}](https://github.com/user-attachments/assets/8be50a5c-9e71-441b-b29b-ca2c38aa8f39)

- `Step-05:Terraform - Authenticating using the Azure CLI` will be the same for WindowsOS too. 
```t
# Azure CLI Login
az login

# List Subscriptions
az account list

# Set Specific Subscription (if we have multiple subscriptions)
az account set --subscription="SUBSCRIPTION_ID"
```

### Step-07-03: Install Terraform 

- [Download Terraform](https://www.terraform.io/downloads.html)
- [Install CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Unzip the package
- Create a new folder `terraform-bins`
- Copy the `terraform.exe` to a `terraformbins`
- Set PATH in windows 

### Step-07-04: Configure Course Git Repo 

- [Course Git Repo](https://github.com/stacksimplify/hashicorp-certified-terraform-associate-on-azure)
- Shorten the Course folder name to a smaller one. Please put it in C:\ Drive root path

### Step-07-05: Install Visual Studio Code and Terraform Plugin

- [Microsoft Visual Studio Code Editor](https://code.visualstudio.com/download)
- [Hashicorp Terraform Plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
- Configure [Course Github Repository](https://github.com/stacksimplify/hashicorp-certified-terraform-associate-on-azure) using VS Code Editor

### Step-07-06: WindowsOS: Long Path Issues for Terraform CLI

- [Windows10 Long File Name or Path](https://github.com/hashicorp/terraform/issues/21173)
- [Microsoft fix](https://answers.microsoft.com/en-us/windows/forum/all/windows-10-commands-with-long-path-name-are-not/13f0f7c7-d55c-4c6c-b19d-9dfec099dd45)
- Our fix is to shorten our git repo names to see if that helps

## Step-08: LinuxOS: Terraform & Azure CLI Install

- [Download Terraform](https://www.terraform.io/downloads.html)
- [Linux OS - Terraform Install](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=script)
- `Step-05:Terraform - Authenticating using the Azure CLI` will be the same for LinuxOS too. 
- [Course Git Repo](https://github.com/stacksimplify/hashicorp-certified-terraform-associate-on-azure)
