# Node.js Application Infrastructure with Terraform

## Overview

This Terraform project manages the cloud infrastructure necessary to host a Node.js application on AWS. The setup includes:

- **Application Load Balancer (ALB)** located in the public subnet for handling incoming traffic.
- **ECS Fargate** for containerized application deployment in a private subnet.
- **RDS MySQL** as a relational database in the private subnet.

The project is structured into modular directories for base setup, database, roles, and compute resources to ensure clear separation of concerns and ease of management.

## Architecture

![AWS Architecture Diagram](/readme-docs/arch.png)

## Prerequisites

Before you can run this project, you need to set up the following:
- An **AWS Account**: Ensure you have access to an AWS account with permissions to manage ECS, RDS, and related AWS services.
- **Git**: Required for version control. If you need to install Git, follow the instructions on the [Git website](https://git-scm.com/downloads).
- **Terraform CLI**: For local development with Terraform.
- **Terraform Cloud for Business (HCP) Account**: This account will manage your Terraform state files and run operations securely. Sign up and create your organization at [Terraform Cloud](https://app.terraform.io/signup/account).
- **Terraform API Key**: Store your Terraform Cloud API key as a secret in your GitHub repository to authenticate the Terraform operations initiated by GitHub Actions.

## Project Structure

- `1_base`: Contains foundational resources like VPC, subnets, and security groups.
- `2_db`: Manages the RDS MySQL database setup.
- `3_roles`: Defines IAM roles and policies.
- `4_compute`: Configures the ECS Fargate services and tasks.
- `variables`: Includes environment-specific variables (`develop.tfvars` for development, `master.tfvars` for production).

## Running the Project

### Using CI/CD
To deploy the infrastructure:
1. **Start the Workflow**: Trigger the GitHub Actions workflow manually from the Actions tab in your GitHub repository. Select the workflow that corresponds to your deployment needs (development or production).
   - **YOU MUST EXECUTE THEM IN THE NUMBERED ORDER**
3. **Workflow Execution**: The workflow uses the appropriate `.tfvars` file based on the branch (develop or master) to apply Terraform configurations.
4. **Dynamic Configuration**: Terraform workspaces are used to manage state files and outputs dynamically across different environments. These outputs are then used to populate variables in subsequent Terraform runs.
5. **Clean Up**: The workflows titled "Destroy" will clean up your infrastructure. Similar to infrastructure deployment, **RUN THE WORKFLOWS IN THE NUMBERED ORDER**.

GitHub Actions handle the Terraform operations, provisioning resources as defined in the configuration files using Terraform Cloud. There is no need to run Terraform commands locally, as all operations are handled through CI/CD.

### Local Environment
To deploy the infrastructure locally:
1. **Clone the Repository**
   ```bash
   git clone https://github.com/EzrielAsItGets/aws-app-demo.git
   cd aws-app-demo
   ```
2. **Log In to Terraform HCP via CLI**: Run `terraform login` and enter the API Key, or create one if you haven't already.
3. **Create Terraform Workspace**: Create a workspace for each module in this format: `terraform workspace new <project_name>-<module_layer>-<region>`. Then run `terraform workspace select <workspace>` to select the workspace.
4. **Update providers.tf**: Update the terraform organization to the one you created in Terraform HCP.
5. **Initialilze Terraform Environment**: Navigate to the layer you'd like to deploy via `cd <terraform_module>`. Then run `terraform init` to download the necessary Terraform providers and set up the environment.
6. **Apply Terraform**: Run `terraform apply -auto-approve -var-file=<branch>.tf -var "aws_region=<region>` to apply the infrastructure.

## Contributing

Contributions to this project are welcome! Please fork the repository and submit a pull request with your proposed changes.

For any queries or enhancements, feel free to open an issue in the repository.

