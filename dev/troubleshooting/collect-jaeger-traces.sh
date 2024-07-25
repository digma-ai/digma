#!/bin/bash
# Parse command-line arguments
AUTO="false"
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --jaeger_url)
      JAEGER_URL="$2"
      shift 2
      ;;
    --analytics_url)
      ANALYTICS_URL="$2"
      shift 2
      ;;
    --access_token)
      ACCESS_TOKEN="$2"
      shift 2
      ;;
    --loopback)
      LOOPBACK="$2"
      shift 2
      ;;
    --limit)
      LIMIT="$2"
      shift 2
      ;;
    --auto)
      AUTO="true"
      shift 1
      ;;
    *)
      echo "Unknown parameter passed: $1"
      usage
      ;;
  esac
done

if [ -z "$JAEGER_URL" ]; then
  JAEGER_URL='http://localhost:17686'
fi

if [ -z "$ANALYTICS_URL" ]; then
  ANALYTICS_URL='https://localhost:5051'
fi

if [ -z "$LOOPBACK" ]; then
  LOOPBACK='5m'
fi

if [ -z "$LIMIT" ]; then
  LIMIT=50
fi

echo "JAEGER_URL=$JAEGER_URL"
echo "ANALYTICS_URL=$ANALYTICS_URL"
echo "ACCESS_TOKEN=$ACCESS_TOKEN"
echo "LIMIT=$LIMIT"
echo "LOOPBACK=$LOOPBACK"
echo "AUTO=$AUTO"

folder=jager_export
mkdir -p $folder
# Function to fetch services from Jaeger
fetch_services() {
  curl -s "$JAEGER_URL/api/services" | jq -r '.data[]'
}
start_collecting_jaeger_traces(){
    analytics_url=$1
    access_token=$2
    url="${analytics_url}/api/diagnostic/force-send-traces-jaeger"
    response=$(curl -sS -k --location $url --header "Digma-Access-Token: Token $access_token")
    echo start collecting traces from jaeger: $response
}
export_service_traces(){
    service=$1
    file=$folder/${service}_traces.json
    curl -s -G "$JAEGER_URL/api/traces" \
    --data-urlencode "service=${service}" \
    --data-urlencode "limit=$LIMIT" \
    --data-urlencode "lookback=$LOOPBACK" > $file
}

if [ "$AUTO" = "true" ]; then
    start_collecting_jaeger_traces "$ANALYTICS_URL" "$ACCESS_TOKEN"
    echo "Waiting for 5 minutes..."
    sleep 300  # Wait for 300 seconds (5 minutes)
    echo "5 minutes have passed."

    progress=0
    services=$(fetch_services)
    services_count=$(echo "$services" | wc -l)
    services_count="${services_count// /}"

    for service in $services; do
        ((progress++))
        echo "Downloading traces for service: $service... $progress/$services_count"
        export_service_traces "$service"
    done
    tar -cvf $folder.tar $folder  > /dev/null
    rm -rf "$folder" > /dev/null
    echo tar file created $folder.tar
    exit 0
fi









# Function to display the menu
display_menu() {
  echo "Select a service from the list below:"
  PS3="Enter your choice (or press enter to refresh the list): "
  select service in "${services[@]}"; do
    if [ -n "$service" ]; then
      export_service_traces "$service"
      echo "exported to: $folder"
      # You can add further actions for the selected service here
      break
    else
      echo "Invalid selection, please try again."
    fi
  done
}

# Main loop
while true; do
  services=($(fetch_services))
  if [ ${#services[@]} -eq 0 ]; then
    echo "No services found. Please make sure Jaeger is running and accessible."
    exit 1
  fi

  display_menu
done