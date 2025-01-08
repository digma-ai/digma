#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 --url <URL> --user <USER> --pwd <PASSWORD> [--create-user] [--token <TOKEN>] [--create-environment <CREATE_ENVIRONMENT>]"
    exit 1
}
create_user=false
# Parse arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --url)
        url="$2"
        shift # past argument
        shift # past value
        ;;
        --user)
        user="$2"
        shift
        shift
        ;;
        --pwd)
        pwd="$2"
        shift
        shift
        ;;
        --token)
        token="$2"
        shift
        shift
        ;;
        --create-environment)
        createEnvironment="$2"
        shift
        shift
        ;;
        --recreate-environment)
        recreateEnvironment="$2"
        shift
        shift
        ;;
        --create-user)
        create_user=true
        shift
        ;;
        *)
        echo "Unknown argument: $1"
        usage
        ;;
    esac
done

# Validate mandatory arguments
if [[ -z "$url" || -z "$user" || -z "$pwd" ]]; then
    echo "Error: Missing mandatory arguments."
    usage
fi

if [ "$create_user" = true ]; then
    echo -n "creating user.."
    response=$(curl -s -w "HTTPSTATUS:%{http_code}" -X 'POST' \
    "$url/Authentication/register" \
    -H 'accept: */*' \
    -H "Digma-Access-Token: Token $token" \
    -H 'Content-Type: application/json-patch+json' \
    -d "{
    \"email\": \"$user\",
    \"password\": \"$pwd\"
    }")

    http_status=$(echo "$response" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
    response_body=$(echo "$response" | sed -e 's/HTTPSTATUS:.*//')
    echo "http_status: $http_status"
    if [ "$http_status" -ne 200 ]; then
        echo "Failed with status code: $http_status"
        echo "Response: $response_body"
        exit 1
    fi

    is_succeed=$(echo "$response_body" | jq -r '.isSucceed')
    # Check if "isSucceed" is false
    if [ "$is_succeed" = "false" ]; then
        echo "Response: $response_body"
        exit 1
    fi
    echo "http_status: $http_status"
fi

echo -n "login.."
response=$(curl -s -w "HTTPSTATUS:%{http_code}" -X 'POST' \
  "$url/Authentication/login" \
  -H 'accept: */*' \
  -H "Digma-Access-Token: Token $token" \
  -H 'Content-Type: application/json-patch+json' \
  -d "{
  \"username\": \"$user\",
  \"password\": \"$pwd\"
}")

http_status=$(echo "$response" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
response_body=$(echo "$response" | sed -e 's/HTTPSTATUS:.*//')
echo "http_status: $http_status"
# Check the HTTP status code
if [ "$http_status" -ne 200 ]; then
  echo "Failed with status code: $http_status"
  echo "Response: $response_body"
  exit 1
fi

accessToken=$(echo "$response_body" | jq -r '.accessToken')
userId=$(echo "$response_body" | jq -r '.userId')

if [ -n "$createEnvironment" ]; then
   echo -n "creating public environment $createEnvironment .."
   response=$(curl -s -w "HTTPSTATUS:%{http_code}" -X 'POST' \
    "$url/Environments" \
    -H 'accept: text/plain' \
    -H 'Content-Type: application/json-patch+json' \
    -H "Digma-Access-Token: Token $token" \
    -H "Authorization: Bearer $accessToken" \
    -d "{
    \"environment\": \"$createEnvironment\",
    \"type\": 1,
    \"userId\": \"$userId\" 
    }")
    
    http_status=$(echo "$response" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
    response_body=$(echo "$response" | sed -e 's/HTTPSTATUS:.*//')
    echo "http_status: $http_status"
    # Check the HTTP status code
    if [ "$http_status" -ne 200 ]; then
    echo "Failed with status code: $http_status"
    echo "Response: $response_body"
    exit 1
    fi

    errors_empty=$(echo "$response_body" | jq -r '.errors | length == 0')
    # Print the response if errors list is not empty
    if [ "$errors_empty" = "false" ]; then
        echo "Response: $response_body"
    fi
fi

if [ -n "$recreateEnvironment" ]; then
   echo "recreating public environment $recreateEnvironment .."

   response=$(curl -s -w "HTTPSTATUS:%{http_code}" -X 'GET' \
    "$url/Environments" \
    -H 'accept: text/plain' \
    -H "Digma-Access-Token: Token $token" \
    -H "Authorization: Bearer $accessToken")
   http_status=$(echo "$response" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
   response_body=$(echo "$response" | sed -e 's/HTTPSTATUS:.*//')

   echo "Get environments: $http_status"
   # Check the HTTP status code
   if [ "$http_status" -ne 200 ]; then
   echo "Failed with status code: $http_status"
   echo "Response: $response_body"
   exit 1
   fi
   environmentId=$(echo "$response_body" | jq -r ".[] | select(.name == \"$recreateEnvironment\" and .type == \"Public\") | .id")
   environmentId=$(echo -n "$environmentId" | jq -sRr @uri)
   response=$(curl -s -w "HTTPSTATUS:%{http_code}" -X 'DELETE' \
    "$url/Environments/$environmentId" \
    -H 'accept: text/plain' \
    -H "Digma-Access-Token: Token $token" \
    -H "Authorization: Bearer $accessToken")
   http_status=$(echo "$response" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
   response_body=$(echo "$response" | sed -e 's/HTTPSTATUS:.*//')
   echo "Delete environment: $http_status"
   # Check the HTTP status code
   if [ "$http_status" -ne 200 ]; then
   echo "Failed with status code: $http_status"
   echo "Response: $response_body"
   exit 1
   fi
   response=$(curl -s -w "HTTPSTATUS:%{http_code}" -X 'POST' \
    "$url/Environments" \
    -H 'accept: text/plain' \
    -H 'Content-Type: application/json-patch+json' \
    -H "Digma-Access-Token: Token $token" \
    -H "Authorization: Bearer $accessToken" \
    -d "{
    \"environment\": \"$recreateEnvironment\",
    \"type\": 1,
    \"userId\": \"$userId\" 
    }")
    
    http_status=$(echo "$response" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
    response_body=$(echo "$response" | sed -e 's/HTTPSTATUS:.*//')
    echo "Create environment: $http_status"
    # Check the HTTP status code
    if [ "$http_status" -ne 200 ]; then
    echo "Failed with status code: $http_status"
    echo "Response: $response_body"
    exit 1
    fi

    errors_empty=$(echo "$response_body" | jq -r '.errors | length == 0')
    # Print the response if errors list is not empty
    if [ "$errors_empty" = "false" ]; then
        echo "Response: $response_body"
    fi
fi
