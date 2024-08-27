# Default values
$DIGMA_URL = "https://localhost:5050"
$ENV_NAME = "Local"
$ENV_TYPE = "Private"
$DIGMA_DEPLOYMENT = "Local"
$USER_ID = ""

# Function to display help
function Show-Help {
    Write-Host "Usage: .\setup_otel.ps1 -ServiceName <SERVICE_NAME> [options]"
    Write-Host ""
    Write-Host "Mandatory arguments:"
    Write-Host "  -ServiceName            The name of your application service (Required)"
    Write-Host ""
    Write-Host "Optional arguments:"
    Write-Host "  -DigmaCollectorUrl      URL for the Digma collector (default: https://localhost:5050)"
    Write-Host "  -EnvName                The environment name (default: Local)"
    Write-Host "  -PublicEnv              Set the environment type to Public (default: Private)"
    Write-Host "  -UserId                 User ID (required for Private environment in centralized deployments)"
    Write-Host "                          You can find your user_id value by selecting the 'How to setup'"
    Write-Host "                          option in the environment tab menu in the observability panel."
    Write-Host "  -DigmaDeploymentType    Digma deployment type: can be 'Local' or 'Central' (default: 'Local')"
    Write-Host "  -Help                   Show this help message"
    exit 0
}

# Parse arguments
foreach ($arg in $args) {
    switch -Regex ($arg) {
        '-ServiceName' { $ServiceName = $args[$args.IndexOf($arg) + 1] }
        '-DigmaCollectorUrl' { $DIGMA_URL = $args[$args.IndexOf($arg) + 1] }
        '-EnvName' { $ENV_NAME = $args[$args.IndexOf($arg) + 1] }
        '-PublicEnv' { $ENV_TYPE = "Public" }
        '-UserId' { $USER_ID = $args[$args.IndexOf($arg) + 1] }
        '-DigmaDeploymentType' { $DIGMA_DEPLOYMENT = $args[$args.IndexOf($arg) + 1] }
        '-Help' { Show-Help }
        default { Write-Host "Unknown parameter passed: $arg"; Show-Help }
    }
}

# Check if mandatory parameters are provided
if (-not $ServiceName) {
    Write-Host "Error: -ServiceName is required."
    Show-Help
}

if ($ENV_TYPE -eq "Private" -and $DIGMA_DEPLOYMENT -eq "Central" -and -not $USER_ID) {
    Write-Host "Error: -UserId is required when EnvName is Local and DigmaDeployment is Central."
    Write-Host "You can find your user_id value by selecting the 'How to setup'"
    Write-Host "option in the environment tab menu in the observability panel."
    Show-Help
}

# Download agent files if they don't already exist
Write-Host "Downloading the agent files if needed..."

$otelDir = "C:\tmp\otel"
if (-not (Test-Path $otelDir)) {
    New-Item -Path $otelDir -ItemType Directory | Out-Null
}

if (-not (Test-Path "$otelDir\opentelemetry-javaagent.jar")) {
    Invoke-WebRequest -Uri "https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.1.0/opentelemetry-javaagent.jar" -OutFile "$otelDir\opentelemetry-javaagent.jar" -UseBasicParsing -Quiet
}

if (-not (Test-Path "$otelDir\digma-otel-agent-extension.jar")) {
    Invoke-WebRequest -Uri "https://github.com/digma-ai/otel-java-instrumentation/releases/latest/download/digma-otel-agent-extension.jar" -OutFile "$otelDir\digma-otel-agent-extension.jar" -UseBasicParsing -Quiet
}

if (-not (Test-Path "$otelDir\digma-agent.jar")) {
    Invoke-WebRequest -Uri "https://github.com/digma-ai/digma-agent/releases/latest/download/digma-agent.jar" -OutFile "$otelDir\digma-agent.jar" -UseBasicParsing -Quiet
}

# Set environment variables
Write-Host "Setting observability environment variables..."
$env:JAVA_TOOL_OPTIONS="-javaagent:$otelDir\digma-agent.jar `
-javaagent:$otelDir\opentelemetry-javaagent.jar `
-Dotel.javaagent.extensions=$otelDir\digma-otel-agent-extension.jar `
-Dotel.exporter.otlp.traces.endpoint=$DIGMA_URL `
-Dotel.traces.exporter=otlp -Dotel.exporter.otlp.protocol=grpc `
-Dotel.metrics.exporter=none -Dotel.logs.exporter=none `
-Dotel.instrumentation.common.experimental.controller.telemetry.enabled=true `
-Dotel.instrumentation.common.experimental.view.telemetry.enabled=true `
-Dotel.instrumentation.experimental.span-suppression-strategy=none `
-Dotel.instrumentation.jdbc-datasource.enabled=true"

$env:OTEL_SERVICE_NAME=$ServiceName
$env:OTEL_RESOURCE_ATTRIBUTES="digma.environment=$ENV_NAME,digma.environment.type=$ENV_TYPE"

Write-Host "Successfully configured this environment for observability"
Write-Host "Traces will be sent to a $DIGMA_DEPLOYMENT Digma deployment at $DIGMA_URL"
# Final message
Write-Host "You can run your Java app normally and observability data will be analyzed by Digma."