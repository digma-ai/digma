variable "environment_name" {
  description = "The name of environment Infrastructure, this name is used for vpc and eks cluster."
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}


##EKS VARIABLES.

# variable "service_name" {
#   description = "The name of the Suffix for the stack name"
#   type        = string
# }

variable "cluster_version" {
  description = "The Version of Kubernetes to deploy"
  type        = string
}

# variable "eks_admin_role_name" {
#   type        = string
#   description = "Additional IAM role to be admin in the cluster"
# }

variable "node_group_name" {
  type        = string
  description = "node groups name"
}

variable "instance_types" {
  type = list(string)
}
