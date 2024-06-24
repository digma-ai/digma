# Terraform Kubernetes Deployment on AWS

This project contains Terraform scripts to deploy a Kubernetes cluster on AWS. 

## Prerequisites

1. [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
2. AWS CLI configured with appropriate permissions.
3. An AWS account.

## Setup Instructions

### Step 1: Customize Variables
Customize the variables in the terraform.tfvars for your deployment.

### Step 2: Initialize Terraform
Initialize the Terraform working directory. This step downloads the necessary providers and sets up the environment:
```
terraform init
```

### Step 3: Plan the Deployment (Optional)
Run the terraform plan command to see what resources will be created:

```
terraform plan
```

### Step 4: Apply the Configuration
Apply the Terraform configuration to deploy the Kubernetes cluster:

```
terraform apply
```

### Step 5: Access the Kubernetes Cluster
Once the deployment is complete, you can configure your kubectl to access the cluster. The necessary kubeconfig file can be found in the outputs of the Terraform apply.

```
aws eks --region <your-aws-region> update-kubeconfig --name <your-cluster-name>

```
Replace \<your-aws-region> and \<your-cluster-name> with the appropriate values.


### Cleanup
To destroy the resources created by this Terraform configuration, run:

```
terraform destroy
```

### Troubleshooting

```
TF_LOG=DEBUG terraform apply
```