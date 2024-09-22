#!/bin/bash
analytics_url="$1"
token="$2"
user="$3"
pwd="$4"

echo analytics_url=$analytics_url
echo token=$token
echo user=$user
echo pwd=***

curr_datetime=$(date +'%Y-%m-%d_%H-%M-%S')
folder=response/$curr_datetime
mkdir -p $folder


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

location="$analytics_url/<path>"
body='{}'
curl -X POST -k -s -o "$folder/services_issues.json"  --location "$location" \
--header "Content-Type: application/json" --header "Digma-Access-Token: Token $token" --header "Authorization: Bearer $accessToken" -d $body

