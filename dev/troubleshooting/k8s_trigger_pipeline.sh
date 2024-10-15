#!/bin/bash
namespace="$1"
environment="$2"
spanCodeObjectId="$3"
pipelineType="$4" #SpanPipeline,EndpointPipeline,MethodPipeline,EnvironmentPipeline,ServiceNamePipeline

echo $(date +'%H:%M:%S') connecting to pod..
pod=$(kubectl get pods -n $namespace -l app=digma-scheduler -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n $namespace $pod -- /bin/sh -c "

apt-get update > /dev/null 2>&1;
apt-get install -y curl > /dev/null 2>&1;

echo execute $pipelineType. env=$environment span=$spanCodeObjectId
curl -sS -w \"%{http_code}\n\" -X 'POST' \
  'http://localhost:5000/api/Pipelines/execute' \
  -H 'accept: */*' \
  -H 'Content-Type: application/json-patch+json' \
  -d '{
  \"environment\": \"$environment\",
  \"pipelineType\": \"$pipelineType\",
  \"spanCodeObjectId\": \"$spanCodeObjectId\"
}'
"

#EXAMPLE
#./k8s_trigger_pipeline.sh 'digma' '<environment>' '<spanCodeObjecID>' "EndpointPipeline"
