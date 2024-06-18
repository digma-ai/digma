#!/bin/bash

# Check if an argument was provided
if [ $# -eq 0 ]; then
  echo "Please specify a namespace"
  exit 1
fi

namespace="$1"

# Get the list of StatefulSet names in the namespace
echo "Getting all statefulsets in the namespace: $namespace"
statefulset_names=$(kubectl get statefulsets -n $namespace -o jsonpath='{.items[*].metadata.name}')

# Loop through each StatefulSet and scale replicas to 0
for sts in $statefulset_names; do
	echo "Updating replicas to 0 of $sts"
  	kubectl scale statefulset $sts --replicas=0 -n $namespace
done


# Delete all PVCs
echo "Deleting all PVCs in the namespace: $namespace"
kubectl delete pvc --all -n $namespace

echo "Done"