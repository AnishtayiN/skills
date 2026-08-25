---
name: monitoring-observability
description: >-
  Set up logging, metrics, tracing, and alerting for production systems.
  Use this skill when the user mentions monitoring, observability, logging, metrics, tracing,
  alerting, ELK stack, Prometheus, Grafana, Jaeger, OpenTelemetry, distributed tracing,
  structured logging, log aggregation, APM, uptime monitoring, health checks,
  or says نظارت بر سیستم, مانیتورینگ, لاگینگ, ردیابی, هشدار.
---

# Monitoring & Observability Skill — Logging, Metrics, Tracing & Alerting

## Overview

This skill covers the three pillars of observability (logs, metrics, traces) and how to set them up for production systems. A system without monitoring is flying blind — you won't know it's broken until users complain. This skill provides practical setup guides for ELK, Prometheus, Grafana, Jaeger, and OpenTelemetry, plus alerting strategies and health check patterns.

## When to Use This Skill

- User wants to set up logging for their application
- User needs metrics collection and dashboards
- User asks about distributed tracing
- User wants to configure alerts for system failures
- User mentions ELK, Prometheus, Grafana, Jaeger, OpenTelemetry
- User says "how do I know when something breaks?"
- User mentions نظارت, مانیتورینگ, or لاگینگ

---

## Part 1: Structured Logging

### Why Structured Logging

```python
# ❌ BAD: Unstructured log (hard to search/parse)
print(f"User {user_id} placed order {order_id} for ${total}")

# ✅ GOOD: Structured log (JSON, searchable, parseable)
import structlog
logger = structlog.get_logger()
logger.info("order_placed", user_id=user_id, order_id=order_id, total=total, currency="USD")
```

### Structured Log Format

```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "INFO",
  "service": "order-service",
  "message": "Order placed successfully",
  "user_id": "usr_123",
  "order_id": "ord_456",
  "total": 99.99,
  "currency": "USD",
  "trace_id": "abc123",
  "span_id": "def456"
}
```

### Log Levels

| Level | When to Use | Example |
|-------|------------|---------|
| **DEBUG** | Detailed diagnostic info | "Query returned 42 rows in 15ms" |
| **INFO** | Normal operations | "Order ord_456 placed by user usr_123" |
| **WARN** | Something unexpected but handled | "Rate limit 80% consumed for user usr_123" |
| **ERROR** | Operation failed | "Failed to charge payment: card declined" |
| **FATAL** | System cannot continue | "Database connection pool exhausted" |

### Python Structured Logging Setup

```python
import structlog
import logging

# Configure structlog
structlog.configure(
    processors=[
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.add_log_level,
        structlog.processors.JSONRenderer()
    ],
    wrapper_class=structlog.BoundLogger,
    context_class=dict,
    logger_factory=structlog.PrintLoggerFactory(),
)

# Usage
log = structlog.get_logger()
log.info("user_login", user_id="usr_123", method="oauth", ip="1.2.3.4")
log.error("payment_failed", user_id="usr_123", amount=99.99, reason="card_declined")
```

### Node.js Structured Logging

```javascript
const pino = require('pino');
const logger = pino({ level: 'info' });

// Structured logging
logger.info({ userId: 'usr_123', orderId: 'ord_456' }, 'Order placed');
logger.error({ err: error, userId: 'usr_123' }, 'Payment failed');
```

---

## Part 2: Metrics (Prometheus)

### Four Golden Signals

| Signal | What It Measures | How to Measure |
|--------|-----------------|----------------|
| **Latency** | Time to serve a request | Request duration histogram |
| **Traffic** | Demand on the system | Request rate (RPS) |
| **Errors** | Rate of failed requests | Error rate counter |
| **Saturation** | How "full" is the system | CPU, memory, disk, connections |

### Prometheus Setup

```python
from prometheus_client import Counter, Histogram, Gauge, start_http_server

# Define metrics
REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP requests', ['method', 'endpoint', 'status'])
REQUEST_LATENCY = Histogram('http_request_duration_seconds', 'Request latency', ['method', 'endpoint'])
ACTIVE_CONNECTIONS = Gauge('active_connections', 'Number of active connections')
ERROR_RATE = Counter('http_errors_total', 'Total HTTP errors', ['endpoint', 'status'])

# Instrument a request
from functools import wraps

def monitor_endpoint(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        ACTIVE_CONNECTIONS.inc()
        try:
            result = func(*args, **kwargs)
            REQUEST_COUNT.labels(method='GET', endpoint=func.__name__, status='200').inc()
            return result
        except Exception as e:
            REQUEST_COUNT.labels(method='GET', endpoint=func.__name__, status='500').inc()
            ERROR_RATE.labels(endpoint=func.__name__, status='500').inc()
            raise
        finally:
            REQUEST_LATENCY.labels(method='GET', endpoint=func.__name__).observe(time.time() - start)
            ACTIVE_CONNECTIONS.dec()
    return wrapper

# Start metrics server
start_http_server(8000)
```

### Key Prometheus Queries

```promql
# Request rate (RPS)
rate(http_requests_total[5m])

# Error rate
rate(http_errors_total[5m]) / rate(http_requests_total[5m])

# P95 latency
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# P99 latency
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))

# Active connections
active_connections

# CPU usage
rate(process_cpu_seconds_total[5m]) * 100

# Memory usage
process_resident_memory_bytes / 1024 / 1024
```

---

## Part 3: Distributed Tracing (OpenTelemetry)

### OpenTelemetry Setup

```python
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanExporter
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.instrumentation.requests import RequestsInstrumentor

# Setup
provider = TracerProvider()
exporter = OTLPSpanExporter(endpoint="http://jaeger:4317")
provider.add_span_processor(BatchSpanExporter(exporter))
trace.set_tracer_provider(provider)

# Auto-instrument FastAPI
FastAPIInstrumentor.instrument_app(app)

# Auto-instrument requests library
RequestsInstrumentor().instrument()

# Manual tracing
tracer = trace.get_tracer("order-service")

def process_order(order_id):
    with tracer.start_as_current_span("process_order") as span:
        span.set_attribute("order_id", order_id)
        
        # Child span
        with tracer.start_as_current_span("validate_order"):
            validate_order(order_id)
        
        with tracer.start_as_current_span("charge_payment"):
            charge_payment(order_id)
```

### Trace Context Propagation

```python
# HTTP headers for trace propagation
# traceparent: 00-{trace-id}-{span-id}-{trace-flags}
# tracestate: vendor-specific data

# Propagate trace context across services
from opentelemetry.propagate import inject

headers = {}
inject(headers)  # Adds traceparent header
response = requests.get("http://other-service/api", headers=headers)
```

---

## Part 4: Log Aggregation (ELK Stack)

### Elasticsearch + Logstash + Kibana

```yaml
# docker-compose.yml for ELK
version: '3.8'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.11.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    ports:
      - "9200:9200"

  logstash:
    image: docker.elastic.co/logstash/logstash:8.11.0
    volumes:
      - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf

  kibana:
    image: docker.elastic.co/kibana/kibana:8.11.0
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
```

```ruby
# logstash.conf
input {
  beats { port => 5044 }
  tcp { port => 5000 codec => json }
}

filter {
  mutate {
    add_field => { "service" => "%{[fields][service]}" }
  }
  date {
    match => [ "timestamp", "ISO8601" ]
  }
}

output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    index => "logs-%{+YYYY.MM.dd}"
  }
}
```

---

## Part 5: Dashboards (Grafana)

### Grafana Dashboard JSON (Basic)

```json
{
  "dashboard": {
    "title": "Service Overview",
    "panels": [
      {
        "title": "Request Rate",
        "type": "graph",
        "targets": [{
          "expr": "rate(http_requests_total[5m])",
          "legendFormat": "{{method}} {{endpoint}}"
        }]
      },
      {
        "title": "Error Rate",
        "type": "graph",
        "targets": [{
          "expr": "rate(http_errors_total[5m]) / rate(http_requests_total[5m]) * 100",
          "legendFormat": "{{endpoint}}"
        }]
      },
      {
        "title": "P95 Latency",
        "type": "graph",
        "targets": [{
          "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))",
          "legendFormat": "{{endpoint}}"
        }]
      }
    ]
  }
}
```

### Dashboard Best Practices

| Section | Panels |
|---------|--------|
| **Overview** | Request rate, error rate, P95 latency, uptime |
| **Traffic** | Requests by endpoint, status code distribution |
| **Performance** | Latency percentiles (P50, P95, P99), throughput |
| **Resources** | CPU, memory, disk, network I/O |
| **Errors** | Error rate by type, top error messages |
| **Saturation** | Connection pool usage, queue depth, worker count |

---

## Part 6: Alerting

### Alert Rules

```yaml
# prometheus-rules.yml
groups:
  - name: service-alerts
    rules:
      - alert: HighErrorRate
        expr: rate(http_errors_total[5m]) / rate(http_requests_total[5m]) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate (>5%)"
          description: "Error rate is {{ $value | humanizePercentage }}"

      - alert: HighLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 2
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "P95 latency > 2s"

      - alert: HighCPU
        expr: rate(process_cpu_seconds_total[5m]) * 100 > 80
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "CPU usage > 80%"

      - alert: ServiceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Service is down"
```

### Alert Severity Levels

| Severity | Response Time | Notification | Example |
|----------|-------------|-------------|---------|
| **Critical** | Immediate | Page + SMS | Service down, data loss |
| **High** | < 1 hour | Slack + Email | Error rate > 5%, P99 > 5s |
| **Medium** | < 4 hours | Email | CPU > 80%, disk > 85% |
| **Low** | Next business day | Slack | Deprecation warning, cert expiry |

---

## Part 7: Health Checks

### Health Check Endpoint

```python
from fastapi import FastAPI
import redis
import sqlalchemy

app = FastAPI()

@app.get("/health")
async def health_check():
    checks = {}
    healthy = True
    
    # Database check
    try:
        db.execute("SELECT 1")
        checks["database"] = "ok"
    except Exception as e:
        checks["database"] = f"error: {str(e)}"
        healthy = False
    
    # Redis check
    try:
        redis_client.ping()
        checks["redis"] = "ok"
    except Exception as e:
        checks["redis"] = f"error: {str(e)}"
        healthy = False
    
    # External API check
    try:
        resp = await httpx.get("https://api.external.com/health", timeout=5)
        checks["external_api"] = "ok" if resp.status_code == 200 else "degraded"
    except Exception as e:
        checks["external_api"] = f"error: {str(e)}"
        healthy = False
    
    return {
        "status": "healthy" if healthy else "degraded",
        "checks": checks,
        "version": "1.2.3",
        "uptime": get_uptime()
    }

@app.get("/ready")
async def readiness_check():
    """Kubernetes readiness probe - is the service ready to accept traffic?"""
    return {"ready": True}
```

---

## Output Format

```
## Monitoring Setup Report

### Components Configured
- [ ] Structured logging: [tool]
- [ ] Metrics: [Prometheus/CloudWatch/etc]
- [ ] Dashboards: [Grafana/CloudWatch/etc]
- [ ] Tracing: [Jaeger/Zipkin/etc]
- [ ] Alerting: [PagerDuty/Slack/etc]
- [ ] Health checks: [/health, /ready]

### Key Metrics
| Metric | Current Value | Alert Threshold |
|--------|--------------|-----------------|
| Request rate | X RPS | - |
| Error rate | X% | > 5% |
| P95 latency | Xms | > 2s |
| CPU usage | X% | > 80% |
| Memory usage | X% | > 85% |

### Alert Rules
[Table of alert rules with severity and thresholds]
```

## Rules

- **Always use structured logging** — JSON logs are searchable and parseable
- **Log everything, alert on what matters** — Too many alerts = alert fatigue
- **Health checks should be fast** — Don't block on slow external dependencies
- **Use distributed tracing in microservices** — You need to see the full request path
- **Dashboards should tell a story** — Overview → Traffic → Performance → Resources → Errors
- **Alert on symptoms, not causes** — Alert on "error rate > 5%" not "disk almost full"
- **Test your alerts** — An untested alert is worse than no alert
