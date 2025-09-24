
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

# Guide to a Well-Structured Terraform Project

- Why care about Terraform project structure? Simple—it keeps things organized so you can scale up, work well with your team, and keep everything secure. No fuss, just a setup that works.

This setup follows a layered structure, separating resources by environment (development, staging, production, etc.) and using centralized modules for reusable components.

Modules are kept in a central repository, allowing environments to source specific versions for controlled updates and consistent configurations.

![Enviornment Directory Structure](https://media.beehiiv.com/cdn-cgi/image/fit=scale-down,format=auto,onerror=redirect,quality=80/uploads/asset/file/b606769d-187c-4f5f-b340-fb861e98ec86/directory_1.png?t=1730702748) 
  
# Main.tf

Defines core resources for the environment by referencing modules from the central repository. Each module is tagged to ensure a specific version is used.

Example:

<img width="1848" height="1014" alt="image" src="https://github.com/user-attachments/assets/96f3e376-de57-442d-8f91-cc9e97aa3bd6" />
 

# variables. tf

Declares input variables, making the configuration adaptable. For example, instance_type might vary between environments (e.g., t2.micro in dev, t3.large in prod).

Example:

<img width="972" height="1242" alt="image" src="https://github.com/user-attachments/assets/f19411ae-9274-43c0-9c8d-0318aa8a4559" />

# provider. tf

Configures the cloud provider and backend for remote state storage, which tracks deployed resources. This setup is crucial for collaborative workflows.

Example:

<img width="1048" height="1014" alt="image" src="https://github.com/user-attachments/assets/15b51efc-f3dc-4eb5-a027-4fe13a80b503" />

# outputs. tf

Defines output values, making it easy to retrieve information, like IP addresses or resource IDs, after deployment.

Example:

<img width="848" height="710" alt="image" src="https://github.com/user-attachments/assets/e8092908-fc24-4e7b-a34a-83a8fb975a4b" />

# dev. tfvars (Environment-Specific Variables)

Contains values for variables declared in variables. tf, tailored to this environment. Each environment (dev, staging, prod) will have its own .tfvars file.

Example:

<img width="666" height="562" alt="image" src="https://github.com/user-attachments/assets/f5d0521e-3408-486f-a1ab-c4df5a30b69f" />

# Centralized Modules Repository Breakdown

Modules are organized into folders by type (e.g., network, compute) within a separate repository. This structure allows consistent usage across environments by sourcing each module from a specific version tag in the central repository.

# Modules Directory Structure:

![Module Directory Structure](https://media.beehiiv.com/cdn-cgi/image/fit=scale-down,format=auto,onerror=redirect,quality=80/uploads/asset/file/a70941e1-5fb2-4a29-a70b-a671150e9298/directory_2.png?t=1730702773)

--------------------------------------------------------------------------------------------------

## Getting Started & Documentation

Documentation is available on the [Terraform website](https://www.terraform.io):

 [Introduction](https://www.terraform.io/intro)
 [Documentation](https://www.terraform.io/docs)

If you're new to Terraform and want to get started creating infrastructure, please check out our [Getting Started guides](https://learn.hashicorp.com/terraform#getting-started) on HashiCorp's learning platform. There are also [additional guides](https://learn.hashicorp.com/terraform#operations-and-development) to continue your learning.

Show off your Terraform knowledge by passing a certification exam. Visit the [certification page](https://www.hashicorp.com/certification/) for information about exams and find [study materials](https://learn.hashicorp.com/terraform/certification/terraform-associate) on HashiCorp's learning platform.

----------------------------------------------------------------------------------------------------------------------

## Points to consider while using modules:

1. Use versioned module tags.

2. Centralize module source in a remote repository.

3. Refactor modules for reusability as the project scales.

4. Avoid hardcoding values; use variables for flexibility.

5. Keep module logic focused on a single responsibility.

6. Define clear input and output variables for each module.

7. Document module usage and parameters in a README.

8. Test modules independently before applying them in environments.

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
