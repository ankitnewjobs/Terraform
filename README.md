
# Terraform Complete Hands-On Guides 
Terraform Complete Hands-On Guides.

![My Terraform Associate Certificate](https://github.com/user-attachments/assets/617ee4e7-1b87-4c2e-9023-abce9eafd2b7) 

--------------------------------------------------------------------------------------------------------

# Terraform

- Website: https://www.terraform.io
- Forums: [HashiCorp Discuss](https://discuss.hashicorp.com/c/terraform-core)
- Documentation: [https://www.terraform.io/docs/](https://www.terraform.io/docs/)
- Tutorials: [HashiCorp's Learn Platform](https://learn.hashicorp.com/terraform)
- Certification Exam: [HashiCorp Certified: Terraform Associate](https://www.hashicorp.com/certification/#hashicorp-certified-terraform-associate)



<img alt="Terraform" src="https://www.datocms-assets.com/2885/1629941242-logo-terraform-main.svg" width="600px">

# Introduction
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

-------------------------------------------------------------------------------------------------------
# Architecture

# Guide to a Well-Structured Terraform Project

- Why care about Terraform project structure? Simple—it keeps things organized so you can scale up, work well with your team, and keep everything secure. No fuss, just a setup that works.

This setup follows a layered structure, separating resources by environment (development, staging, production, etc.) and using centralized modules for reusable components.

Modules are kept in a central repository, allowing environments to source specific versions for controlled updates and consistent configurations.

![Enviornment Directory Structure](https://media.beehiiv.com/cdn-cgi/image/fit=scale-down,format=auto,onerror=redirect,quality=80/uploads/asset/file/b606769d-187c-4f5f-b340-fb861e98ec86/directory_1.png?t=1730702748) 
  
# Main.tf

Defines core resources for the environment by referencing modules from the central repository. Each module is tagged to ensure a specific version is used.

Example:

![Main.tf]("C:\Users\Hp\OneDrive\Desktop\main.jpg") 

# Backends

A backend determines where Terraform should store its state snapshots.

As described above, the local backend also executes operations on behalf of most other backends. It uses a state manager (either statemgr.Filesystem if the local backend is being used directly, or an implementation provided by whatever backend is being wrapped) to retrieve the current state for the workspace specified in the operation, then uses the config loader to load and do initial processing/validation of the configuration specified in the operation. It then uses these, along with the other settings given in the operation, to construct a terraform.Context, which is the main object that actually performs Terraform operations.

# The key features of Terraform are:

 **Infrastructure as Code**: Infrastructure is described using a high-level configuration syntax. This allows a blueprint of your data center to be versioned and treated as you would any other code. Additionally, infrastructure can be shared and re-used.

 **Execution Plans**: Terraform has a "planning" step where it generates an execution plan. The execution plan shows what Terraform will do when you call to apply. This lets you avoid any surprises when Terraform manipulates infrastructure.

 **Resource Graph**: Terraform builds a graph of all your resources, and parallelizes the creation and modification of any non-dependent resources. Because of this, Terraform builds infrastructure as efficiently as possible, and operators get insight into dependencies in their infrastructure.

 **Change Automation**: Complex changesets can be applied to your infrastructure with minimal human interaction. With the previously mentioned execution plan and resource graph, you know exactly what Terraform will change and in what order, avoiding many possible human errors.

For more information, refer to the [What is Terraform?](https://www.terraform.io/intro) page on the Terraform website.

--------------------------------------------------------------------------------------------------

## Getting Started & Documentation

Documentation is available on the [Terraform website](https://www.terraform.io):

 [Introduction](https://www.terraform.io/intro)
 [Documentation](https://www.terraform.io/docs)

If you're new to Terraform and want to get started creating infrastructure, please check out our [Getting Started guides](https://learn.hashicorp.com/terraform#getting-started) on HashiCorp's learning platform. There are also [additional guides](https://learn.hashicorp.com/terraform#operations-and-development) to continue your learning.

Show off your Terraform knowledge by passing a certification exam. Visit the [certification page](https://www.hashicorp.com/certification/) for information about exams and find [study materials](https://learn.hashicorp.com/terraform/certification/terraform-associate) on HashiCorp's learning platform.

----------------------------------------------------------------------------------------------------------------------

## Developing Terraform

This repository contains only the Terraform core, which includes the command line interface and the main graph engine. Providers are implemented as plugins, and Terraform can automatically download providers that are published on [the Terraform Registry](https://registry.terraform.io). HashiCorp develops some providers, and other organizations produce others. For more information, see [Extending Terraform](https://www.terraform.io/docs/extend/index.html).

To learn more about compiling Terraform and contributing suggested changes, refer to [the contributing guide](.github/CONTRIBUTING.md).

To learn more about how we handle bug reports, refer to the [bug triage guide](./BUGPROCESS.md).

------------------------------------------------------------------------------------------------------

# Hit the Star! ⭐

If you're planning on using this Terraform repository for learning, please consider giving it a star⭐                      
Thank you!

------------------------------------------------------------------------------------------------------

# For Doubts and Queries 
Feel free to connect with me on LinkedIn through this profile: 
https://www.linkedin.com/in/ankit-ranjan05/

-------------------------------------------------------------------------------------------------------
 Original Repository: https://github.com/stacksimplify/hashicorp-certified-terraform-associate-on-azure

----------------------------------------------------------------------------------------------------------
## Project Maintainers & Contributors  

![1](https://github.com/ankitnewjobs/Azure-Practices-Examples/assets/154872782/0eb590e7-50e0-49f0-9439-77537cde2b8b)

**Ankit Ranjan**


------------------------------------------------------------
