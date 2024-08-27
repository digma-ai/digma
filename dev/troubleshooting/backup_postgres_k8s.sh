#!/bin/bash
namespace="$1"

curr_datetime=$(date +'%Y-%m-%d_%H-%M-%S')
folder=backups/$curr_datetime
mkdir -p $folder

echo "postgres backup to $folder/postgres"

postgres_pod=$(kubectl get pods -n $namespace -l app=postgres -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n $namespace -it $postgres_pod -- sh -c "pg_dump -U postgres -d digma_analytics -F c -f /postgres-data.dump"

kubectl cp -n $namespace $postgres_pod:/postgres-data.dump $folder/postgres-data.dump
