aws_region       = "eu-west-1"
environment_name = "digma"
vpc_cidr         = "172.16.0.0/16"
cluster_version  = "1.30"
node_group_name  = "digma-eks-managed-node"
instance_types   = ["c7g.2xlarge"]
ami_type         = "AL2_ARM_64"