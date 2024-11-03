
# Terraform Complete Hands-On Guides 
Terraform Complete Hands-On Guides.

![My Terraform Associate Certificate](https://github.com/user-attachments/assets/617ee4e7-1b87-4c2e-9023-abce9eafd2b7) 

-------------------------------------------------------------------------------------------------------

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

# Terraform Request Flow

- The following diagram shows an approximation of how a user command is executed in Terraform:

![Terraform Architecture](https://github.com/user-attachments/assets/7206cd1b-f4b2-47ed-b89f-e6136f76fa3c)
  
# CLI (command package)

Each time a user runs the terraform program, aside from some initial bootstrapping in the root package (not shown in the diagram) execution transfers immediately into one of the "command" implementations in the command package. The mapping between the user-facing command names and their corresponding command package types can be found in the commands.go file in the root of the repository.

The full flow illustrated above does not actually apply to all commands, but it applies to the main Terraform workflow commands terraform plan and terraform apply, along with a few others.

For these commands, the role of the command implementation is to read and parse any command line arguments, command line options, and environment variables that are needed for the given command and use them to produce a backend.Operation object that describes an action to be taken.

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

This repository contains only the Terraform core, which includes the command line interface and the main graph engine. Providers are implemented as plugins, and Terraform can automatically download providers that are published on [the Terraform Registry](https://registry.terraform.io). HashiCorp develops some providers, and others are developed by other organizations. For more information, see [Extending Terraform](https://www.terraform.io/docs/extend/index.html).

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

## Terraform Learning Days                                                
- [Day 01](https://github.com/ankitnewjobs/Terraform-Complete-Hands-On-Guides/blob/main/Day%2001%3A-%20Infrastructure-as-Code-IaC-Basics/Concept.md)
- [Day 02](https://github.com/ankitnewjobs/Terraform/blob/main/Day%2002%3A-%20Install-Tools-Terraform-CLI-Azure-CLI-VSCode-IDE/Concept.md)
- [Day 03](https://github.com/ankitnewjobs/Terraform/blob/main/Day%3A-%2003%20Terraform-Command-Basics/Terraform-Manifests/Azure-resource-group.tf)
- [Day 04](https://github.com/ankitnewjobs/Terraform/blob/main/Day%3A-%2004%20Terraform-Language-Syntax/Terraform-Manifest/Top-Level-Blocks-samples.tf)
-------------------------------------------------------------------------

## Project Maintainers & Contributors  

![1](https://github.com/ankitnewjobs/Azure-Practices-Examples/assets/154872782/0eb590e7-50e0-49f0-9439-77537cde2b8b)

**Ankit Ranjan**


------------------------------------------------------------
