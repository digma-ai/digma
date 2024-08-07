#!/bin/bash
analytics_url="$1"
token="$2"
user="$3"
pwd="$4"

echo analytics_url=$analytics_url
echo token=$token
echo user=$user
echo pwd=***

fetch_environments() {
  curl -k -s  --location "${analytics_url}/Environments" --header 'accept: application/json' --header "Digma-Access-Token: Token $token" --header "Authorization: Bearer $accessToken"| jq -r '.[].id'
}
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

  environments=$(fetch_environments)

  for environment in $environments; do
      encoded_env=$(jq -nr --arg str "$environment" '$str | @uri')
      curl -k -s -o "$folder/${environment}_insights.json" --location "${analytics_url}/Insights/get_insights_view?Page=0&PageSize=100&ShowDismissed=false&ShowUnreadOnly=false&DirectOnly=false&Environment=${encoded_env}&InsightViewType=Issues" --header 'accept: application/json' --header "Digma-Access-Token: Token $token" --header "Authorization: Bearer $accessToken"
  done

fi


zip -r "$folder.zip" "$folder"
rm -rf "$folder"
