#!/bin/bash
analytics="$1"
collector="$2"
jaeger="$3"

if [[ "$collector" == *":5050" ]]; then
  collector="${collector%:5050}"
  collector=$collector:5049
fi

echo "Testing analytics: $analytics/about"

HTTP_STATUS=$(curl -k -o /dev/null -sS -w "%{http_code}\n" --location "$analytics/about" 2>&1)
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
echo "Testing collector: $collector/health"

HTTP_STATUS=$(curl -XPOST -k -o /dev/null -sS -w "%{http_code}\n" --location "$collector/health"  -H "Content-Type: application/json" 2>&1)
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
echo "Testing jaeger:  $jaeger/search"
HTTP_STATUS=$(curl -k -o /dev/null -sS -w "%{http_code}\n" --location "$jaeger/search" 2>&1)
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