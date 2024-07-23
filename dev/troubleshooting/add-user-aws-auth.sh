#!/bin/bash

# Check if correct number of arguments is provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <username> <userarn>"
  exit 1
fi

# Variables
USERNAME=$1
USERARN=$2
CONFIGMAP_NAME="aws-auth"
NAMESPACE="kube-system"

# Fetch the existing aws-auth ConfigMap
kubectl get configmap $CONFIGMAP_NAME -n $NAMESPACE -o yaml > aws-auth.yaml

# Check if the user already exists in the aws-auth ConfigMap
if grep -q "$USERARN" aws-auth.yaml; then
  echo "User with ARN $USERARN already exists in the aws-auth ConfigMap."
  rm aws-auth.yaml
  exit 0
fi

# Add the new user entry to the mapUsers section of the aws-auth ConfigMap
yq eval ".data.mapUsers += \"- userarn: '$USERARN'\n  username: '$USERNAME'\n  groups:\n    - system:masters\"" aws-auth.yaml -i

# Apply the updated ConfigMap
kubectl apply -f aws-auth.yaml

# Clean up
rm aws-auth.yaml

echo "User $USERNAME with ARN $USERARN has been added to the aws-auth ConfigMap in the system:masters group."
