#!/bin/bash

# Default values
DIGMA_URL="https://localhost:5050"
ENV_NAME="Local"
ENV_TYPE="Private"
DIGMA_DEPLOYMENT="Local"

USER_ID=""

# Function to display help
show_help() {
    echo "Usage: ./setup_otel.sh --service_name <SERVICE_NAME> [options]"
    echo ""
    echo "Mandatory arguments:"
    echo "  --service_name            The name of the your application service (Required)"
    echo ""
    echo "Optional arguments:"
    echo "  --digma_collector_url     URL for the Digma collector (default: https://localhost:5050)"
    echo "  --env_name                The environment name (default: Local)"
    echo "  --public_env              Set the environment type to Public (default: Private)"
    echo "  --user_id                 User ID (required for Private environment in centralized deployments)"
    echo "                            You can find your user_id value by selecting the 'How to setup'"
    echo "                            option in the environment tab menu in the observability panel."
    echo "  --digma_deployment        Digma deployment type: can be 'Local' or 'Central' (default: 'Local')"
    echo "  --help                    Show this help message"
    exit 0
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --digma_collector_url) DIGMA_URL="$2"; shift ;;
        --service_name) SERVICE_NAME="$2"; shift ;;
        --env_name) ENV_NAME="$2"; shift ;;
        --public_env) ENV_TYPE="Public";;
        --user_id) USER_ID="$2"; shift ;;
        --digma_deployment_type) DIGMA_DEPLOYMENT="$2"; shift ;;
        --help) show_help ;;
        *) echo "Unknown parameter passed: $1"; show_help ;;
    esac
    shift
done

# Check if mandatory parameters are provided
if [ -z "$SERVICE_NAME" ]; then
    echo "Error: --service_name is required."
    show_help
fi

if [ "$ENV_TYPE" = "Private" ] && "$DIGMA_DEPLOYMENT" = "Central" ] && [ -z "$USER_ID" ]; then
    echo "Error: --user_id is required when --env_name is Local and --digma_deployment is Central."
    echo "You can find your user_id value by selecting the 'How to setup'"
    echo "option in the environment tab menu in the observability panel."
    show_help
fi

# Download agent files if they don't already exist
echo "Downloading the agent files if needed..."

if [ ! -f /tmp/otel/opentelemetry-javaagent.jar ]; then
    curl -s --create-dirs -O -L --output-dir /tmp/otel https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.1.0/opentelemetry-javaagent.jar
fi

if [ ! -f /tmp/otel/digma-otel-agent-extension.jar ]; then
    curl -s --create-dirs -O -L --output-dir /tmp/otel https://github.com/digma-ai/otel-java-instrumentation/releases/latest/download/digma-otel-agent-extension.jar
fi

if [ ! -f /tmp/otel/digma-agent.jar ]; then
    curl -s --create-dirs -O -L --output-dir /tmp/otel https://github.com/digma-ai/digma-agent/releases/latest/download/digma-agent.jar
fi

# Set environment variables
echo "Setting observability environment variables..."
export JAVA_TOOL_OPTIONS="-javaagent:/tmp/otel/digma-agent.jar \
-javaagent:/tmp/otel/opentelemetry-javaagent.jar \
-Dotel.javaagent.extensions=/tmp/otel/digma-otel-agent-extension.jar \
-Dotel.exporter.otlp.traces.endpoint=$DIGMA_URL \
-Dotel.traces.exporter=otlp -Dotel.exporter.otlp.protocol=grpc \
-Dotel.metrics.exporter=none -Dotel.logs.exporter=none \
-Dotel.instrumentation.common.experimental.controller.telemetry.enabled=true \
-Dotel.instrumentation.common.experimental.view.telemetry.enabled=true \
-Dotel.instrumentation.experimental.span-suppression-strategy=none \
-Dotel.instrumentation.jdbc-datasource.enabled=true"

export OTEL_SERVICE_NAME=$SERVICE_NAME
export OTEL_RESOURCE_ATTRIBUTES="digma.environment=$ENV_NAME,digma.environment.type=$ENV_TYPE"

echo "Successfully configured this environment for observability"
echo "Traces will be sent to a $DIGMA_DEPLOYMENT Digma deployment at $DIGMA_URL"
# Final message
echo "You can run your Java app normally and observability data will be analyzed by Digma."
