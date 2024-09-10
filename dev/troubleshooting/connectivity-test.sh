#!/bin/bash
analytics="$1"
collector="$2"
jaeger="$3"

echo "Testing analytics: $analytics"

HTTP_STATUS=$(curl -k -o /dev/null -sS -w "%{http_code}\n" --location "$analytics:5051/about" 2>&1)
if [ $? -ne 0 ]; then
  echo "$HTTP_STATUS"
else
    # Check if curl failed to resolve the host
    if [[ $HTTP_STATUS == *"Could not resolve host"* ]]; then
        echo "Could not resolve host: $analytics"
        exit 1
    fi
    # Check the HTTP status code
    if [[ $HTTP_STATUS == 404 ]]; then
        echo "Error 404: Not Found"
    else
        echo "Connected! ($HTTP_STATUS)"
    fi
fi


echo ''
echo "Testing collector:  $collector"

HTTP_STATUS=$(curl -XPOST -k -o /dev/null -sS -w "%{http_code}\n" --location "$collector:5049/health"  -H "Content-Type: application/json" 2>&1)
if [ $? -ne 0 ]; then
  echo "$HTTP_STATUS"
else
    # Check if curl failed to resolve the host
    if [[ $HTTP_STATUS == *"Could not resolve host"* ]]; then
        echo "Could not resolve host: $collector"
        exit 1
    fi

    # Check the HTTP status code
    if [[ $HTTP_STATUS == 404 ]]; then
        echo "Error 404: Not Found"
    else
        echo "Connected! ($HTTP_STATUS)"
    fi
 fi


echo ''
echo "Testing jaeger:  $jaeger"
HTTP_STATUS=$(curl -k -o /dev/null -sS -w "%{http_code}\n" --location "$jaeger:17686/search" 2>&1)
if [ $? -ne 0 ]; then
  echo "$HTTP_STATUS"
else
    # Check if curl failed to resolve the host
    if [[ $HTTP_STATUS == *"Could not resolve host"* ]]; then
        echo "Could not resolve host: $jaeger"
        exit 1
    fi

    # Check the HTTP status code
    if [[ $HTTP_STATUS == 404 ]]; then
        echo "Error 404: Not Found"
    else
        echo "Connected! ($HTTP_STATUS)"
    fi
fi