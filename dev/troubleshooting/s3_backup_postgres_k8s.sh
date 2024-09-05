#!/bin/bash
namespace="$1"
presigned_url="$2"
curr_datetime=$(date +'%Y-%m-%d_%H-%M-%S')


echo "${curr_datetime} postgres backup to s3"

postgres_pod=$(kubectl get pods -n $namespace -l app=postgres -o jsonpath='{.items[0].metadata.name}')
    kubectl exec -n $namespace -it $postgres_pod -- sh -c "
pg_dump -U postgres -d digma_analytics -F c -f /postgres-data.dump && \
cd / && \
curl -s ${presigned_url}  | bash -s "postgres-data.dump"
"

