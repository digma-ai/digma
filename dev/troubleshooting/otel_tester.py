#python3 -m venv otel-env
#source otel-env/bin/activate  # On Windows, use otel-env\Scripts\activate
#pip3 install opentelemetry-api opentelemetry-sdk opentelemetry-exporter-otlp-proto-grpc
#python3 otel_tester.py
#
#
#
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)

exporter = OTLPSpanExporter(endpoint="http://localhost:4317");
span_processor = BatchSpanProcessor(exporter)
trace.get_tracer_provider().add_span_processor(span_processor)

with tracer.start_as_current_span("test-span"):
    print("Trace sent!")