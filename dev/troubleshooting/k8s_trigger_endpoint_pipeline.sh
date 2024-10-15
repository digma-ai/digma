#!/bin/bash
namespace="$1"
environment="$2"
endpointSpanCodeObjectId="$3"
span_code_object_ids="$4"
echo namespace: $namespace
echo environment: $environment
echo endpointSpanCodeObjectId: $endpointSpanCodeObjectId
echo span_code_object_ids: $span_code_object_ids


echo $(date +'%H:%M:%S') connecting to pod..
pod=$(kubectl get pods -n $namespace -l app=digma-scheduler -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n $namespace $pod -- /bin/sh -c "

apt-get update > /dev/null 2>&1;
apt-get install -y curl > /dev/null 2>&1;
url='http://localhost:5000/api/Pipelines/execute'

echo execute EndpointPipeline. env=$environment span=$endpointSpanCodeObjectId
curl -sS -w \"%{http_code}\n\" -X 'POST' \
  \$url \
  -H 'accept: */*' \
  -H 'Content-Type: application/json-patch+json' \
  -d '{
  \"environment\": \"$environment\",
  \"pipelineType\": \"EndpointPipeline\",
  \"spanCodeObjectId\": \"$endpointSpanCodeObjectId\"
}'

# Loop through each span_code_object_id and make the same HTTP call
IFS=',' read -ra span_ids <<< \"$span_code_object_ids\"
for span_id in \"\${span_ids[@]}\"
do
  echo execute Pipeline for span_id=\$span_id
  curl -sS -w \"%{http_code}\n\" -X 'POST' \
    \$url \
    -H 'accept: */*' \
    -H 'Content-Type: application/json-patch+json' \
    -d '{
    \"environment\": \"$environment\",
    \"pipelineType\": \"SpanPipeline\",
    \"spanCodeObjectId\": \"'\$span_id'\"
  }'
done

"

#EXAMPLE
#./k8s_trigger_pipeline.sh 'digma' '<environment>' '<spanCodeObjecID>' "EndpointPipeline"
