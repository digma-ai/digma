#!/bin/bash
namespace="$1"
analytics_url="$2"
token="$3"
user="$4"
pwd="$5"

echo namespace=$namespace
echo analytics_url=$analytics_url
echo token=$token
echo user=$user
echo pwd=***


curr_datetime=$(date +'%Y-%m-%d_%H-%M-%S')
folder=logs/$curr_datetime
mkdir -p $folder

echo "collecting logs to $folder"
if [[ -n "$analytics_url" ]]; then
  http_status=$(curl -k -sS -w "%{http_code}" --location "$analytics_url/about" --header "Digma-Access-Token: Token $token" -o "$folder/about.json")
  if [ "$http_status" != "200" ]; then
      echo "Connection error $analytics_url ($http_status)"
      exit 1
  fi

response=$(curl -k -X 'POST' \
  "$analytics_url/Authentication/login" \
  -H 'accept: */*' \
  -H 'Content-Type: application/json-patch+json' \
  -H "Digma-Access-Token: Token $token" \
  -d "{
  \"username\": \"$user\",
  \"password\": \"$pwd\"
}")
echo $response
accessToken=$(echo "$response" | jq -r '.accessToken')

curl -k -s -o "$folder/topics-throttling-state.json"  --location "$analytics_url/PerformanceMetrics/topics-throttling-state" \
--header "Digma-Access-Token: Token $token" --header "Authorization: Bearer $accessToken"

curl -k -s -o "$folder/topics-lag.json"  --location "$analytics_url/PerformanceMetrics/topics-lag" \
--header "Digma-Access-Token: Token $token" --header "Authorization: Bearer $accessToken"

curl -k -s -o "$folder/performance-metrics.json"  --location "$analytics_url/PerformanceMetrics" \
--header "Digma-Access-Token: Token $token" --header "Authorization: Bearer $accessToken"

curl -k -s -o "$folder/load-status.json"  --location "$analytics_url/load-status" \
--header "Digma-Access-Token: Token $token" --header "Authorization: Bearer $accessToken"

curl -k -s -o "$folder/usage-stats.json" -X POST  --location "$analytics_url/CodeAnalytics/user/usage_stats" \
--header "Digma-Access-Token: Token $token" --header "Authorization: Bearer $accessToken" --header 'Content-Type: application/json' -d '{}'

curl -k -s -o "$folder/diagnostic-log.json"  --location "$analytics_url/api/Diagnostic/logs" \
--header "Digma-Access-Token: Token $token" --header "Authorization: Bearer $accessToken"

curl -k -s -o "$folder/large-trace.json"  --location "$analytics_url/api/Diagnostic/large-trace" \
--header "Digma-Access-Token: Token $token" --header "Authorization: Bearer $accessToken"

curl -k -s -o "$folder/ignored-spans.json"  --location "$analytics_url/api/Diagnostic/ignored-spans" \
--header "Digma-Access-Token: Token $token" --header "Authorization: Bearer $accessToken"

fi

if [[ -n "$namespace" ]]; then

  kubectl get deployments -n "$namespace" -o jsonpath='{range .items[*]}{"Deployment: "}{.metadata.name}{"\n"}{range .spec.template.spec.containers[*]}{"Container: "}{.name}{"\n"}{range .env[*]}{.name}{"="}{.value}{"\n"}{end}{"\n"}{end}{end}' > "$folder/deployment_env_vars.txt"
  kubectl get pods -n "$namespace" --no-headers -o custom-columns="POD:metadata.name,RESTARTS:status.containerStatuses[*].restartCount" > "$folder/pod_restarts.txt"
  # Get the list of pods in the namespace
  pods=$(kubectl get pods -n "$namespace" -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
  total_pods=$(echo "$pods" | wc -l)
  total_pods="${total_pods// /}"

  progress=0
  # Loop through each pod and download logs
  for pod in $pods; do
    ((progress++))
      echo "Downloading logs from pod $pod... $progress/$total_pods"
      output_file="${pod}_logs.txt"
      cpu_usage=$(kubectl get pod $pod -n $namespace -o jsonpath='{.status.containerStatuses[*].usage.cpu}')
      memory_usage=$(kubectl get pod $pod -n $namespace -o jsonpath='{.status.containerStatuses[*].usage.memory}')

      echo "CPU Usage: $cpu_usage" >> "$folder/$output_file"
      echo "Memory Usage: $memory_usage" >> "$folder/$output_file"
      echo "Output->" >> "$folder/$output_file"
      kubectl logs "$pod" -n "$namespace" >> "$folder/$output_file"
      if [ $? -ne 0 ]; then
        echo "Error: Failed to download logs from pod $pod."
      fi
  done
fi

zip -r "$folder.zip" "$folder"
rm -rf "$folder"
