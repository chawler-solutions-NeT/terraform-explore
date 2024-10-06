# Docker Swarm on AWS with Terraform

## Overview
This project provisions a Docker Swarm cluster on AWS using Terraform. The cluster consists of 3 Manager nodes and 6 Worker nodes, automatically scaling based on instance health.

## Requirements
- Terraform
- AWS CLI configured
- Existing VPC and subnets

## How to Apply the Configuration
1. Update `variables.tf` with your VPC ID, subnet IDs, and desired instance type.
2. Run `terraform init` to initialize the project.
3. Run `terraform apply` to provision the infrastructure.

## Autoscaling and Swarm Initialization
- Managers initialize the Docker Swarm and store the join token in SSM Parameter Store.
- Workers retrieve the token and join the swarm upon boot.

## Assumptions
- You have permissions to create resources in AWS.
- Docker and necessary packages are installed via the user data script.

## Bonus
Security groups are configured to allow traffic only on the required Docker Swarm ports (2377, 7946, 4789).
