#!/bin/bash

# Run helm status command and store the output
release=$1
namespace=$2
output=$(helm status $release -n $namespace)

# Extract values using grep and awk
collector_http=$(echo "$output" | grep "^\[HTTP\]" | awk '{$1=""; print $0}' | sed 's/^[ \t]*//')
collector_grpc=$(echo "$output" | grep "^\[gRPC\]" | awk '{$1=""; print $0}' | sed 's/^[ \t]*//')

api=$(echo "$output" | grep -A1 "^DIGMA API:" | tail -n1 | sed -n 's/^URL:[ \t]*//p')
ui=$(echo "$output" | grep -A1 "^UI:" | tail -n1 | sed -n 's/^URL:[ \t]*//p')
jaeger=$(echo "$output" | grep -A1 "^Jaeger:" | tail -n1 | sed -n 's/^URL:[ \t]*//p')



# Print the extracted variables
echo "api: $api"
echo "collector_http: $collector_http"
echo "collector_grpc: $collector_grpc"
echo "ui: $ui"
echo "jaeger: $jaeger"

echo ''
echo -n "test api connectivity..."
status_code=$(curl -s -o /dev/null -w "%{http_code}" "$api/healthz")
if [ "$status_code" -eq 200 ]; then
  echo "passed!"
else
  echo "The URL did not return status code 200. Status code: $status_code"
fi

echo -n "test collector http connectivity..."
status_code=$(curl -s -o /dev/null -w "%{http_code}" "$collector_http/v1/traces")
if [ "$status_code" -eq 405 ]; then
  echo "passed!"
else
  echo "The URL did not return status code 405. Status code: $status_code"
fi

echo -n "test collector grpc connectivity..."
status_code=$(curl -s -o /dev/null -w "%{http_code}" "$collector_grpc")
if [ "$status_code" -eq 415 ]; then
  echo "passed!"
else
  echo "The URL did not return status code 405. Status code: $status_code"
fi

echo -n "test ui connectivity..."
status_code=$(curl -s -o /dev/null -w "%{http_code}" "$ui/health")
if [ "$status_code" -eq 200 ]; then
  echo "passed!"
else
  echo "The URL did not return status code 200. Status code: $status_code"
fi

echo -n "test jaeger connectivity..."
status_code=$(curl -s -o /dev/null -w "%{http_code}" "$jaeger/health")
if [ "$status_code" -eq 200 ]; then
  echo "passed!"
else
  echo "The URL did not return status code 200. Status code: $status_code"
fi
