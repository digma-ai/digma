#!/bin/bash

NAMESPACE=$1
RELEASE_NAME=$2
TIMEOUT=300 # Timeout in seconds
INTERVAL=5  # Polling interval in seconds

# Store original replica counts
#declare -A original_replicas


# Function to save original replica counts
save_original_replicas() {
  local resource_type=$1
  echo "Saving original replica counts for $resource_type..."
  for resource in $(kubectl get $resource_type -n $NAMESPACE -l app.kubernetes.io/instance=$RELEASE_NAME -o name); do
    replicas=$(kubectl get $resource -n $NAMESPACE -o jsonpath='{.spec.replicas}')
    resource_name=$(echo "$resource" | awk -F'/' '{print $2}')
    original_replicas["$resource_name"]=$replicas
    echo "$resource_name: $replicas replicas"
  done
}

# Function to scale down resources of a specific type
scale_down() {
  local resource_type=$1
  echo "Scaling down $resource_type..."
  kubectl get $resource_type -n $NAMESPACE -l app.kubernetes.io/instance=$RELEASE_NAME -o name | xargs -n 1 kubectl scale --replicas=0 -n $NAMESPACE
}

# Function to wait for all resources of a specific type to scale down
wait_for_scaling() {
  local resource_type=$1
  local start_time=$(date +%s)

  echo "Waiting for $resource_type to scale down..."
  while true; do
    local remaining=$(kubectl get $resource_type -n $NAMESPACE -l app.kubernetes.io/instance=$RELEASE_NAME -o jsonpath='{.items[*].status.replicas}' | tr ' ' '\n' | awk '{s+=$1} END {print s+0}')
    if [ "$remaining" -eq 0 ]; then
      echo "All $resource_type scaled down."
      break
    fi

    # Check timeout
    local current_time=$(date +%s)
    if [ $((current_time - start_time)) -ge $TIMEOUT ]; then
      echo "Timeout while waiting for $resource_type to scale down."
      exit 1
    fi

    sleep $INTERVAL
  done
}

# Function to scale resources back to their original replica counts
scale_up() {
  local resource_type=$1
  echo "Scaling $resource_type back to original replica counts..."
  for resource in $(kubectl get $resource_type -n $NAMESPACE -l app.kubernetes.io/instance=$RELEASE_NAME -o name); do
    replicas=${original_replicas[$resource]:-0}
    echo "  Scaling $resource to $replicas replicas..."
    kubectl scale --replicas=$replicas -n $NAMESPACE $resource
  done
}

# Main workflow
echo "Scaling down all resources for release $RELEASE_NAME in namespace $NAMESPACE..."

# Save and scale down Deployments
#save_original_replicas "deployment"
scale_down "deployment"
wait_for_scaling "deployment"

# Save and scale down StatefulSets
#save_original_replicas "statefulset"
scale_down "statefulset"
wait_for_scaling "statefulset"

# Save and scale down ReplicaSets
#save_original_replicas "replicaset"
scale_down "replicaset"
wait_for_scaling "replicaset"

echo "All resources for release $RELEASE_NAME have been scaled down."

echo "Deleting PVCs..."

kubectl get pvc -n $NAMESPACE -l app.kubernetes.io/instance=$RELEASE_NAME
kubectl delete pvc -n $NAMESPACE -l app.kubernetes.io/instance=$RELEASE_NAME

echo "Waiting for PVCs to be fully deleted..."
while kubectl get pvc -n $NAMESPACE -l app.kubernetes.io/instance=$RELEASE_NAME 2>/dev/null | grep -q pvc; do
  echo "PVCs still terminating..."
  sleep 5
done

echo "All PVCs for release $RELEASE_NAME have been deleted."

# Scale resources back up
#echo "Scaling resources back to their original replica counts..."
#scale_up "deployment"
#scale_up "statefulset"
#scale_up "replicaset"
