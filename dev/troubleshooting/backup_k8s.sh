#!/bin/bash
namespace="$1"

curr_datetime=$(date +'%Y-%m-%d_%H-%M-%S')
folder=backups/$curr_datetime
mkdir -p $folder

mkdir -p $folder/postgres
echo "postgres backup to $folder/postgres"

postgres_pod=$(kubectl get pods -n $namespace -l app=postgres -o jsonpath='{.items[0].metadata.name}')
kubectl cp -n $namespace $postgres_pod:/var/lib/postgresql/data $folder/postgres
