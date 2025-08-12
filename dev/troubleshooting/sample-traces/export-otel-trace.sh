#!/bin/bash

# Configuration (endpoint is required)
COLLECTOR_ENDPOINT="$1"

if [ -z "$COLLECTOR_ENDPOINT" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: $0 <COLLECTOR_ENDPOINT>"
    echo "  COLLECTOR_ENDPOINT: OTLP HTTP traces endpoint (e.g. https://your-host/v1/traces)"
    echo "Example: $0 https://collector.example.com/v1/traces"
    exit 1
fi

# Generate random hex values (Windows compatible) - same as Datadog script
TRACE_ID=$(printf "%032x" $((RANDOM * RANDOM * RANDOM * RANDOM)))
PARENT_SPAN_ID=$(printf "%016x" $((RANDOM * RANDOM * RANDOM + 1)))
HANDLER_SPAN_ID=$(printf "%016x" $((RANDOM * RANDOM * RANDOM + 2)))
RENDER_SPAN_ID=$(printf "%016x" $((RANDOM * RANDOM * RANDOM + 3)))
REPO_SPAN_ID=$(printf "%016x" $((RANDOM * RANDOM * RANDOM + 4)))
SQL_SPAN_ID=$(printf "%016x" $((RANDOM * RANDOM * RANDOM + 5)))

# Realistic timing for web service with SQL - same as Datadog script
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

echo "Generating OpenTelemetry Digma test trace..."
echo "Trace ID: $TRACE_ID"
echo "Simulating: POST /api/digma/test/analyze-otel request"

# Create the JSON payload in OpenTelemetry format
OTEL_JSON=$(cat <<EOF
{
  "resourceSpans": [
    {
      "resource": {
        "attributes": [
          {
            "key": "service.name",
            "value": {
              "stringValue": "digma-test-service"
            }
          },
          {
            "key": "service.version",
            "value": {
              "stringValue": "1.2.3"
            }
          },
          {
            "key": "deployment.environment",
            "value": {
              "stringValue": "agentic-dev"
            }
          },
          {
            "key": "digma.environment",
            "value": {
              "stringValue": "AGENTIC-DEV"
            }
          },
          {
            "key": "digma.environment.type",
            "value": {
              "stringValue": "Public"
            }
          },
          {
            "key": "telemetry.sdk.language",
            "value": {
              "stringValue": "java"
            }
          },
          {
            "key": "telemetry.sdk.name",
            "value": {
              "stringValue": "opentelemetry"
            }
          },
          {
            "key": "telemetry.sdk.version",
            "value": {
              "stringValue": "1.0.0"
            }
          }
        ]
      },
      "scopeSpans": [
        {
          "scope": {
            "name": "digma-test-instrumentation",
            "version": "1.0.0"
          },
          "spans": [
            {
              "traceId": "$TRACE_ID",
              "spanId": "$PARENT_SPAN_ID",
              "name": "servlet.request",
              "kind": 2,
              "startTimeUnixNano": "$START_TIME",
              "endTimeUnixNano": "$PARENT_END_TIME",
              "attributes": [
                {
                  "key": "http.method",
                  "value": {
                    "stringValue": "POST"
                  }
                },
                {
                  "key": "http.url",
                  "value": {
                    "stringValue": "http://localhost:8080/api/digma/test/analyze-otel"
                  }
                },
                {
                  "key": "http.route",
                  "value": {
                    "stringValue": "/api/digma/test/analyze-otel"
                  }
                },
                {
                  "key": "http.status_code",
                  "value": {
                    "intValue": "200"
                  }
                },
                {
                  "key": "http.user_agent",
                  "value": {
                    "stringValue": "Digma-Test-Runner/1.0"
                  }
                },
                {
                  "key": "servlet.context",
                  "value": {
                    "stringValue": "/api"
                  }
                },
                {
                  "key": "servlet.path",
                  "value": {
                    "stringValue": "/api/digma/test/analyze-otel"
                  }
                },
                {
                  "key": "thread.name",
                  "value": {
                    "stringValue": "http-nio-8080-exec-3"
                  }
                },
                {
                  "key": "deployment.environment",
                  "value": {
                    "stringValue": "agentic-dev"
                  }
                },
                {
                  "key": "digma.environment",
                  "value": {
                    "stringValue": "AGENTIC-DEV"
                  }
                },
                {
                  "key": "digma.environment.type",
                  "value": {
                    "stringValue": "Public"
                  }
                },
                {
                  "key": "peer.ipv4",
                  "value": {
                    "stringValue": "127.0.0.1"
                  }
                },
                {
                  "key": "http.hostname",
                  "value": {
                    "stringValue": "localhost"
                  }
                },
                {
                  "key": "language",
                  "value": {
                    "stringValue": "jvm"
                  }
                },
                {
                  "key": "component",
                  "value": {
                    "stringValue": "tomcat-server"
                  }
                },
                {
                  "key": "runtime-id",
                  "value": {
                    "stringValue": "66225a4d-6890-4329-8c86-02baebfe779c"
                  }
                }
              ],
              "status": {
                "code": 1
              }
            },
            {
              "traceId": "$TRACE_ID",
              "spanId": "$HANDLER_SPAN_ID",
              "parentSpanId": "$PARENT_SPAN_ID",
              "name": "spring.handler",
              "kind": 2,
              "startTimeUnixNano": "$HANDLER_START_TIME",
              "endTimeUnixNano": "$HANDLER_END_TIME",
              "attributes": [
                {
                  "key": "thread.name",
                  "value": {
                    "stringValue": "http-nio-8080-exec-3"
                  }
                },
                {
                  "key": "deployment.environment",
                  "value": {
                    "stringValue": "agentic-dev"
                  }
                },
                {
                  "key": "digma.environment",
                  "value": {
                    "stringValue": "AGENTIC-DEV"
                  }
                },
                {
                  "key": "digma.environment.type",
                  "value": {
                    "stringValue": "Public"
                  }
                },
                {
                  "key": "component",
                  "value": {
                    "stringValue": "spring-web-controller"
                  }
                },
                {
                  "key": "language",
                  "value": {
                    "stringValue": "jvm"
                  }
                }
              ],
              "status": {
                "code": 1
              }
            },
            {
              "traceId": "$TRACE_ID",
              "spanId": "$REPO_SPAN_ID",
              "parentSpanId": "$HANDLER_SPAN_ID",
              "name": "repository.operation",
              "kind": 3,
              "startTimeUnixNano": "$REPO_START_TIME",
              "endTimeUnixNano": "$REPO_END_TIME",
              "attributes": [
                {
                  "key": "thread.name",
                  "value": {
                    "stringValue": "http-nio-8080-exec-3"
                  }
                },
                {
                  "key": "deployment.environment",
                  "value": {
                    "stringValue": "agentic-dev"
                  }
                },
                {
                  "key": "digma.environment",
                  "value": {
                    "stringValue": "AGENTIC-DEV"
                  }
                },
                {
                  "key": "digma.environment.type",
                  "value": {
                    "stringValue": "Public"
                  }
                },
                {
                  "key": "component",
                  "value": {
                    "stringValue": "spring-data"
                  }
                }
              ],
              "status": {
                "code": 1
              }
            },
            {
              "traceId": "$TRACE_ID",
              "spanId": "$SQL_SPAN_ID",
              "parentSpanId": "$REPO_SPAN_ID",
              "name": "postgresql.query",
              "kind": 3,
              "startTimeUnixNano": "$SQL_START_TIME",
              "endTimeUnixNano": "$SQL_END_TIME",
              "attributes": [
                {
                  "key": "db.statement",
                  "value": {
                    "stringValue": "INSERT INTO test_results (test_id, status, metrics, execution_time, created_at) VALUES ($1, $2, $3, $4, NOW())"
                  }
                },
                {
                  "key": "db.system",
                  "value": {
                    "stringValue": "postgresql"
                  }
                },
                {
                  "key": "db.name",
                  "value": {
                    "stringValue": "digma_test_db"
                  }
                },
                {
                  "key": "db.user",
                  "value": {
                    "stringValue": "digma_test_user"
                  }
                },
                {
                  "key": "thread.name",
                  "value": {
                    "stringValue": "http-nio-8080-exec-3"
                  }
                },
                {
                  "key": "deployment.environment",
                  "value": {
                    "stringValue": "agentic-dev"
                  }
                },
                {
                  "key": "digma.environment",
                  "value": {
                    "stringValue": "AGENTIC-DEV"
                  }
                },
                {
                  "key": "component",
                  "value": {
                    "stringValue": "postgresql"
                  }
                }
              ],
              "status": {
                "code": 1
              }
            },
            {
              "traceId": "$TRACE_ID",
              "spanId": "$RENDER_SPAN_ID",
              "parentSpanId": "$PARENT_SPAN_ID",
              "name": "response.serialize",
              "kind": 1,
              "startTimeUnixNano": "$RENDER_START_TIME",
              "endTimeUnixNano": "$RENDER_END_TIME",
              "attributes": [
                {
                  "key": "serialization.format",
                  "value": {
                    "stringValue": "json"
                  }
                },
                {
                  "key": "thread.name",
                  "value": {
                    "stringValue": "http-nio-8080-exec-3"
                  }
                },
                {
                  "key": "deployment.environment",
                  "value": {
                    "stringValue": "agentic-dev"
                  }
                },
                {
                  "key": "digma.environment",
                  "value": {
                    "stringValue": "AGENTIC-DEV"
                  }
                },
                {
                  "key": "digma.environment.type",
                  "value": {
                    "stringValue": "Public"
                  }
                },
                {
                  "key": "component",
                  "value": {
                    "stringValue": "jackson"
                  }
                },
                {
                  "key": "language",
                  "value": {
                    "stringValue": "jvm"
                  }
                }
              ],
              "status": {
                "code": 1
              }
            }
          ]
        }
      ]
    }
  ]
}
EOF
)

echo "Sending Digma test trace to OpenTelemetry collector..."
echo "Endpoint: $COLLECTOR_ENDPOINT"

# Send the trace as JSON to OTLP endpoint
# Try different Content-Type for better compatibility
RESPONSE=$(echo "$OTEL_JSON" | curl -s -w "%{http_code}" -X POST \
  --data-binary @- \
  -H "Content-Type: application/json" \
  -H "User-Agent: OpenTelemetry-Collector/1.0" \
  "$COLLECTOR_ENDPOINT")

# If that doesn't work, let's also try with debugging
echo "Response body (without status code): ${RESPONSE%???}"

HTTP_CODE="${RESPONSE: -3}"
if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "202" ]; then
    echo "✓ Trace sent successfully (HTTP $HTTP_CODE)"
else
    echo "✗ Failed to send trace (HTTP $HTTP_CODE)"
    echo "Response: ${RESPONSE%???}"

fi
