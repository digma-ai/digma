#!/bin/bash

# Check if correct number of arguments provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <namespace>"
    exit 1
fi

# Input parameters
NAMESPACE=$1
NEW_STORAGE_SIZE=60Gi

PVC_NAME=$(kubectl get pvc --selector=app=embedded-jaeger -n $NAMESPACE -o custom-columns=:metadata.name| tr -d '\n')


# Fetch the current PVC definition
echo "Fetching current PVC definition for $PVC_NAME in namespace $NAMESPACE..."
kubectl get pvc "$PVC_NAME" -n "$NAMESPACE" -o yaml > pvc-backup.yaml

# Check if PVC exists
if [ $? -ne 0 ]; then
    echo "Error: PVC $PVC_NAME not found in namespace $NAMESPACE."
    exit 1
fi

# Update the storage size in the fetched YAML file
echo "Modifying storage size to $NEW_STORAGE_SIZE..."
sed -i '' "s/storage:.*Gi/storage: $NEW_STORAGE_SIZE/g" pvc-backup.yaml

# Apply the changes
echo "Applying changes to PVC..."
kubectl apply -f pvc-backup.yaml

# Clean up the backup file if successful
if [ $? -eq 0 ]; then
    echo "PVC $PVC_NAME successfully updated to $NEW_STORAGE_SIZE."
    rm pvc-backup.yaml
else
    echo "Failed to apply changes to PVC."
fi
