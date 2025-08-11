#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 --url <URL> --user <USER> --pwd <PASSWORD> [--create-user] [--token <TOKEN>]"
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
        *)
        echo "Unknown argument: $1"
        usage
        ;;
    esac
done

# Validate mandatory arguments
if [[ -z "$url" || -z "$user" ]]; then
    echo "Error: Missing mandatory arguments."
    usage
fi

if [[ -n "$DIGMA_PASSWORD" ]]; then
    echo "Using password from DIGMA_PASSWORD environment variable"
    pwd="$DIGMA_PASSWORD"
fi

# Prompt for password if not provided
if [[ -z "$pwd" ]]; then
    echo -n "Enter password for user '$user': "
    read -s pwd
    echo ""
fi

if [[ -z "$pwd" ]]; then
    echo "Password is required but not provided. Please run the script with --pwd option or set DIGMA_PASSWORD environment variable." >&2
    echo "Example: DIGMA_PASSWORD=mypassword curl -s https://raw.githubusercontent.com/digma-ai/digma/main/dev/troubleshooting/login_test.sh | bash -s -- --url <URL> --user <USER> --token <TOKEN>" >&2
    exit 1
fi


echo -n "login to $url/Authentication/login"
echo ""
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
