#!/bin/bash

# Generate realistic Digma test trace with observability operations
# Digma test runner and analysis operations

# Configuration (endpoint is required)
COLLECTOR_ENDPOINT="$1"

if [ -z "$COLLECTOR_ENDPOINT" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: $0 <COLLECTOR_ENDPOINT>"
    echo "  COLLECTOR_ENDPOINT: Collector intake URL (e.g. https://your-host/v0.4/traces)"
    echo "Example: $0 https://collector.example.com/v0.4/traces"
    exit 1
fi

# Generate random hex values (Windows compatible)
TRACE_ID=$(printf "%032x" $((RANDOM * RANDOM * RANDOM * RANDOM)))
PARENT_SPAN_ID=$(printf "%016x" $((RANDOM * RANDOM * RANDOM + 1)))
HANDLER_SPAN_ID=$(printf "%016x" $((RANDOM * RANDOM * RANDOM + 2)))
RENDER_SPAN_ID=$(printf "%016x" $((RANDOM * RANDOM * RANDOM + 3)))
REPO_SPAN_ID=$(printf "%016x" $((RANDOM * RANDOM * RANDOM + 4)))
SQL_SPAN_ID=$(printf "%016x" $((RANDOM * RANDOM * RANDOM + 5)))

# Convert to decimal for Datadog format
TRACE_ID_DECIMAL=$((0x${TRACE_ID: -14}))
PARENT_SPAN_ID_DECIMAL=$((0x$PARENT_SPAN_ID))
HANDLER_SPAN_ID_DECIMAL=$((0x$HANDLER_SPAN_ID))
RENDER_SPAN_ID_DECIMAL=$((0x$RENDER_SPAN_ID))
REPO_SPAN_ID_DECIMAL=$((0x$REPO_SPAN_ID))
SQL_SPAN_ID_DECIMAL=$((0x$SQL_SPAN_ID))

# Realistic timing for web service with SQL
START_TIME=$(date +%s)000000000
PARENT_END_TIME=$((START_TIME + 245000000)) # ~245ms total
HANDLER_START_TIME=$((START_TIME + 800000)) # Start 0.8ms after parent
HANDLER_END_TIME=$((HANDLER_START_TIME + 240000000)) # ~240ms duration
REPO_START_TIME=$((HANDLER_START_TIME + 5000000)) # Start 5ms into handler
REPO_END_TIME=$((REPO_START_TIME + 230000000)) # ~230ms duration
SQL_START_TIME=$((REPO_START_TIME + 2000000)) # Start 2ms into repo
SQL_END_TIME=$((SQL_START_TIME + 225000000)) # ~225ms duration (most of the time)
RENDER_START_TIME=$((REPO_END_TIME + 500000)) # Start just after repo
RENDER_END_TIME=$((RENDER_START_TIME + 3500000)) # ~3.5ms duration

echo "Generating realistic Digma test trace..."
echo "Trace ID: $TRACE_ID"
echo "Simulating: POST /api/digma/test/analyze-datadog request"

# Create the JSON payload for Datadog v0.4 intake
DATADOG_JSON=$(cat <<EOF
[
  [
    {
      "trace_id": $TRACE_ID_DECIMAL,
      "span_id": $PARENT_SPAN_ID_DECIMAL,
      "name": "servlet.request",
      "service": "digma-test-service",
      "resource": "POST /api/digma/test/analyze-datadog",
      "type": "web",
      "start": $START_TIME,
      "duration": $((PARENT_END_TIME - START_TIME)),
      "error": 0,
      "meta": {
        "dd.span.Resource": "POST /api/digma/test/analyze-datadog",
        "datadog.span.id": "$PARENT_SPAN_ID_DECIMAL",
        "datadog.trace.id": "$TRACE_ID_DECIMAL",
        "http.status_code": "200",
        "_dd.p.tid": "689a50f300000000",
        "servlet.context": "/api",
        "http.url": "http://localhost:8080/api/digma/test/analyze-datadog",
        "http.route": "/api/digma/test/analyze-datadog",
        "thread.name": "http-nio-8080-exec-3",
        "http.method": "POST",
        "deployment.environment": "agentic-dev",
        "servlet.path": "/api/digma/test/analyze-datadog",
        "span.kind": "server",
        "_dd.p.dm": "-1",
        "digma.environment.type": "Public",
        "http.useragent": "Digma-Test-Runner/1.0",
        "peer.ipv4": "127.0.0.1",
        "http.hostname": "localhost",
        "language": "jvm",
        "component": "tomcat-server",
        "digma.environment": "AGENTIC-DEV",
        "runtime-id": "66225a4d-6890-4329-8c86-02baebfe779c",
        "_dd.base_service": "digma-test-service",
        "_dd.tags.container": "service:digma-test-service,kube_service:digma-test-service,kube_deployment:digma-test-service,image_name:openjdk,image_tag:17-jre-slim"
      }
    },
    {
      "trace_id": $TRACE_ID_DECIMAL,
      "span_id": $HANDLER_SPAN_ID_DECIMAL,
      "parent_id": $PARENT_SPAN_ID_DECIMAL,
      "name": "spring.handler",
      "service": "digma-test-service",
      "resource": "TestController.analyzeTest",
      "type": "web",
      "start": $HANDLER_START_TIME,
      "duration": $((HANDLER_END_TIME - HANDLER_START_TIME)),
      "error": 0,
      "meta": {
        "dd.span.Resource": "TestController.analyzeTest",
        "datadog.span.id": "$HANDLER_SPAN_ID_DECIMAL",
        "datadog.trace.id": "$TRACE_ID_DECIMAL",
        "digma.environment.type": "Public",
        "thread.name": "http-nio-8080-exec-3",
        "_dd.p.tid": "689a50f300000000",
        "span.kind": "server",
        "digma.environment": "AGENTIC-DEV",
        "deployment.environment": "agentic-dev",
        "component": "spring-web-controller",
        "language": "jvm",
        "_dd.base_service": "digma-test-service"
      }
    },
    {
      "trace_id": $TRACE_ID_DECIMAL,
      "span_id": $REPO_SPAN_ID_DECIMAL,
      "parent_id": $HANDLER_SPAN_ID_DECIMAL,
      "name": "repository.operation",
      "service": "digma-test-service",
      "resource": "TestResultRepository.saveTestData",
      "type": "custom",
      "start": $REPO_START_TIME,
      "duration": $((REPO_END_TIME - REPO_START_TIME)),
      "error": 0,
      "meta": {
        "dd.span.Resource": "TestResultRepository.saveTestData",
        "datadog.span.id": "$REPO_SPAN_ID_DECIMAL",
        "datadog.trace.id": "$TRACE_ID_DECIMAL",
        "digma.environment": "AGENTIC-DEV",
        "deployment.environment": "agentic-dev",
        "component": "spring-data",
        "digma.environment.type": "Public",
        "thread.name": "http-nio-8080-exec-3",
        "_dd.p.tid": "689a50f300000000",
        "span.kind": "client",
        "_dd.base_service": "digma-test-service"
      }
    },
    {
      "trace_id": $TRACE_ID_DECIMAL,
      "span_id": $SQL_SPAN_ID_DECIMAL,
      "parent_id": $REPO_SPAN_ID_DECIMAL,
      "name": "postgresql.query",
      "service": "digma-test-service",
      "resource": "INSERT INTO test_results (test_id, status, metrics) VALUES (?, ?, ?)",
      "type": "sql",
      "start": $SQL_START_TIME,
      "duration": $((SQL_END_TIME - SQL_START_TIME)),
      "error": 0,
      "meta": {
        "dd.span.Resource": "INSERT INTO test_results (test_id, status, metrics) VALUES (?, ?, ?)",
        "datadog.span.id": "$SQL_SPAN_ID_DECIMAL",
        "datadog.trace.id": "$TRACE_ID_DECIMAL",
        "db.statement": "INSERT INTO test_results (test_id, status, metrics, execution_time, created_at) VALUES ($1, $2, $3, $4, NOW())",
        "db.system": "postgresql",
        "db.name": "digma_test_db",
        "db.user": "digma_test_user",
        "thread.name": "http-nio-8080-exec-3",
        "_dd.p.tid": "689a50f300000000",
        "span.kind": "client",
        "digma.environment": "AGENTIC-DEV",
        "deployment.environment": "agentic-dev",
        "component": "postgresql",
        "_dd.base_service": "digma-test-service"
      }
    },
    {
      "trace_id": $TRACE_ID_DECIMAL,
      "span_id": $RENDER_SPAN_ID_DECIMAL,
      "parent_id": $PARENT_SPAN_ID_DECIMAL,
      "name": "response.serialize",
      "service": "digma-test-service",
      "resource": "test-result.serialize",
      "type": "serialization",
      "start": $RENDER_START_TIME,
      "duration": $((RENDER_END_TIME - RENDER_START_TIME)),
      "error": 0,
      "meta": {
        "dd.span.Resource": "test-result.serialize",
        "datadog.span.id": "$RENDER_SPAN_ID_DECIMAL",
        "datadog.trace.id": "$TRACE_ID_DECIMAL",
        "deployment.environment": "agentic-dev",
        "digma.environment.type": "Public",
        "component": "jackson",
        "serialization.format": "json",
        "span.kind": "internal",
        "thread.name": "http-nio-8080-exec-3",
        "_dd.p.tid": "689a50f300000000",
        "digma.environment": "AGENTIC-DEV",
        "language": "jvm",
        "_dd.base_service": "digma-test-service"
      }
    }
  ]
]
EOF
)

echo "Sending realistic Digma test trace to collector..."
echo "Endpoint: $COLLECTOR_ENDPOINT"

# Send the trace as JSON using Datadog intake headers to convey SDK metadata
RESPONSE=$(echo "$DATADOG_JSON" | curl -s -w "%{http_code}" -X POST \
  --data-binary @- \
  -H "Content-Type: application/json" \
  -H "User-Agent: Datadog Agent/7.0" \
  -H "X-Datadog-Trace-Count: 1" \
  -H "Datadog-Meta-Lang: java" \
  -H "Datadog-Meta-Lang-Version: 21.0.7" \
  -H "Datadog-Meta-Tracer-Version: 1.38.0~60ddc9e0d7" \
  "$COLLECTOR_ENDPOINT")

HTTP_CODE="${RESPONSE: -3}"
if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "202" ]; then
    echo "✓ Trace sent successfully (HTTP $HTTP_CODE)"
    echo ""
    echo "Trace details:"
    echo "- Service: digma-test-service"
    echo "- Endpoint: POST /api/digma/test/analyze-datadog"
    echo "- Total duration: ~245ms"
    echo "- Spans: servlet.request → spring.handler → repository.operation → postgresql.query + response.serialize"
else
    echo "✗ Failed to send trace (HTTP $HTTP_CODE)"
    echo "Response: ${RESPONSE%???}"
fi
