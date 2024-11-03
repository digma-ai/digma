#!/bin/bash

# Check if namespace is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

NAMESPACE=$1

echo "Checking for errors in deployments within namespace: $NAMESPACE"

# Get pods in the specified namespace with error statuses
kubectl get pods -n "$NAMESPACE" --field-selector=status.phase=Running \
  | awk '$3=="CrashLoopBackOff" || $3=="Error" {print $1}' \
  | while read -r pod; do
      echo "Error found in pod: $pod"
      kubectl describe pod "$pod" -n "$NAMESPACE" | grep -i "reason\|message"
      echo "Logs for pod $pod:"
      kubectl logs "$pod" -n "$NAMESPACE" --previous
      echo "------------------------"
  done
