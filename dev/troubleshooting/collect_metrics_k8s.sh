#!/bin/bash


#Prerequisite metrics api ->
#kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml


# Check if namespace is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

NAMESPACE=$1
OUTPUT_FILE="pod_resources_$NAMESPACE.txt"

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
  echo "kubectl not found. Please install kubectl and try again."
  exit 1
fi

# Get CPU and memory usage of all pods in the specified namespace and save to file
echo "Fetching CPU and memory usage for all pods in namespace '$NAMESPACE'..."
kubectl top pods -n $NAMESPACE > $OUTPUT_FILE

if [ $? -eq 0 ]; then
  echo "Resource usage saved to $OUTPUT_FILE"
else
  echo "Failed to fetch resource usage"
fi
