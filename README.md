# ECS Wordpress Demo

## Goal

This project sets up a WordPress container on an ECS cluster using Terraform to provision the infrastructure on AWS, and Packer with Ansible provisionner to create the Wordpress docker images and use RDS as Database.

The development of this project is still in progress. Remaining tasks left to make it work are to create a proper docker image of the Wordpress, and add the proper configuration to make the ECS Wordpress to use the RDS as database.

## Approach

<img width="771" alt="ecs-terraform-packer" src="https://user-images.githubusercontent.com/46226051/225768628-32fa9394-4990-4458-a0d5-4fc04cb40336.png">


Terraform provision the AWS Infrastructure to host and run the Wordpress instance:

1. network.tf to create:
    - VPC and its attached Internet Gateway
    - Public subnet (for ECS) and 2 private subnets (for RDS) as it needs two availability zone.
    - Security Groups
2. secret-manager.tf to create and store:
    - RDS instance db password
    - Wordpress Salts
3. rds.tf to provision our Wordpress database.
4. ecr.tf to create the repository to host our custom Docker image.
5. ecs.tf to define our Wordpress cluster specs and deploy the service.

Packer will create the Wordpress docker image. Its folder contains:

1. packer.pkr.hcl configuration file. It is using a shell provisionner to install packages from a script, and ansible provisionner to build the custom image, then push it to the ECR.
2. ansible folder containing:
    - playbook.yml to install and copy required wordpress files.
    - templates folder with our custom wp-config.php and others files if needed.

## How to Run the Project

1. Create or use an existing IAM user on AWS and create an Access Key to set it up in your environment variables:

    ```bash
    export AWS_ACCESS_KEY_ID="your_access_key"
    export AWS_SECRET_ACCESS_KEY="your_secret_key"
    ```

2. Install terraform, packer and awscli and Docker (see [Docker website](https://docs.docker.com/desktop/install/mac-install/)):

    `brew install terraform packer awscli`

3. Clone the Git repository.

    `https://github.com/CindyPh7/ecs-wordpress.git`

4. Go to Terraform folder:

    `cd terraform`

    `terraform init`

    `terraform apply`

5. Once Terraform have deployed the infrastructure, you can get the ECR repository URL and set it up in your environment variables

    `AWS_REPOSITORY_LOGIN_URL=”AWS_ECR_URL”`

    `{aws_account_id}.dkr.ecr.{region}.amazonaws.com/{repository}`

    `example: 1234.dkr.ecr.us-west-1.amazonaws.com/wordpress-demo-ecr/wordpress`

6. Go to Packer folder and run
    `cd ../packer`

    `packer builder .`

## What components interact with each other

The project includes the following components:

- Packer with Ansible provisionner to create our custom Wordpress image.
- Terraform to provision the infrastructure on AWS.
- AWS Secret Manager to generate and store sensitive data.
- AWS ECR to store our docker images.
- AWS RDS as database.
- AWS ECS to run Wordpress containers.

I first run Terraform code to provision the infrastructure part: 
It will deploy the VPC in the region of my choice (us-west-1), and set up a public subnet and a private subnet in the avaibility zone a (us-west-1a), and an additionnal private subnet in the avaibility zone b (us-west-1b).  I will also create the "wordpress_sg" security group to allow http traffic (port 80), and "rds_sg" security group to allow traffic to the RDS (port 3306) as ingress, and egress for each.
Secret Manager will create will generate a random Secret and store it. It will do the same for Wordpress Salts, by generating a 64-bit length secret for each environment variables to set (for the wp-config.php file).
It will create a definition task to define specs of the service that we want to deploy and the service that will execute the task.
And then, the ECR will be created to be able to push the docker iamge to out registry. 

By running Packer, it will create the image and push it to the ECR. Because the ECS is already deployed with the infrastructure, it will launch the service once it get the image.


## Encountered Problems


I have encountered problems while creating the Wordpress container image with Packer and Ansible provisionner as it's not common to create docker images with Packer.

I also had issues with the ECS task definition and ECS service to get the proper rights to run service and pull the image from the ECR.

I have first set up the project with an Application Load Balancer but I had routing issues.

## Improvements for HA/Automated Architecture

To achieve the best HA/automated architecture, it is recommended to:

- Implement auto-scaling to automatically adjust the number of ECS instances based on demand.
- Set up Wordpress static on S3

## Ideas for Improving Infrastructure

To improve the infrastructure, it is recommended to:

- Use Load balancer to set up SSL and split traffic.
- Improve networking rules to secure. In the RDS security group, if we cannot predict a fix IP for running Wordpress services, we may allow only the public subnet range CIDR.
- Use a backend for Terraform tfstate (can be stored on a S3 bucket) to prevent multiple terraform runs and get one source of trust.
- Refactor the Terraform code into modules to re-use the code of each component for other project or if it needs to be deployed in different environments (DEV, QA, PROD).
- Implement monitoring and logging solutions such as AWS CloudWatch or Prometheus Grafana to gain insights into application performance and troubleshoot issues.
- Implement automated backups and disaster recovery solutions for the RDS database.
- Implement continuous integration and deployment (CI/CD) pipelines using tools like GitlabCI to automate the deployment process and reduce the risk of human error.
