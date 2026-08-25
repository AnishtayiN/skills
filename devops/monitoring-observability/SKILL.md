---
name: monitoring-observability
description: >-
  Implement production observability with metrics, logs, and traces using OpenTelemetry,
  Prometheus, Grafana, and alerting systems. TRIGGERS: monitoring, observability, logging,
  metrics, tracing, alerting, Prometheus, Grafana, Jaeger, OpenTelemetry, distributed tracing,
  structured logging, log aggregation, APM, SLO, error budget, health check, ELK,
  نظارت بر سیستم, مانیتورینگ, لاگینگ, ردیابی, هشدار, متریک, داشبورد,
  可观测性, 监控, 日志, 追踪, 告警, Prometheus, Grafana, 指标
priority: P1
dependencies: [ci-cd]
conflicts: []
---

# Monitoring & Observability Skill — Metrics, Logs, Traces & Alerting

## Overview

Observability is the ability to understand the internal state of a system by examining its external outputs. This skill covers the three pillars of observability — metrics, logs, and traces — and how to implement them for production systems. Metrics tell you *what* is happening, logs tell you *why*, and traces tell you *where* in a distributed system the problem originates. This skill provides production-grade implementations for OpenTelemetry instrumentation, Prometheus metrics collection, structured logging, distributed tracing, Grafana dashboards, alerting design, and health check endpoints. A system without observability is flying blind — you will not know it is broken until users complain.

## When to Use This Skill

- Setting up structured logging for applications or microservices
- Implementing Prometheus metrics (counters, histograms, gauges) with proper labeling
- Building distributed tracing with OpenTelemetry across service boundaries
- Designing Grafana dashboards that tell a coherent operational story
- Creating alerting rules that avoid alert fatigue and cover real failure modes
- Implementing health check endpoints for Kubernetes liveness/readiness probes
- Migrating from ad-hoc logging to a centralized log aggregation system (ELK, Loki)
- Setting up SLO/error budget monitoring for reliability engineering
- Debugging latency issues in distributed systems using trace analysis

## When NOT to Use This Skill

- Writing application business logic (→ application code)
- Setting up CI/CD pipelines (→ ci-cd)
- Managing feature flags for gradual rollouts (→ feature-flag)
- Incident response and postmortem writing (→ incident-response)
- Designing database schemas (→ database-design)
- Writing unit or integration tests (→ testing)
- Configuring cloud infrastructure (→ infrastructure)
- Implementing security scanning or auditing (→ security)

## Workflow

### Step 1: Instrument the Application

```
1. Add OpenTelemetry SDK to the application
2. Configure auto-instrumentation for HTTP, database, and cache libraries
3. Add manual spans for critical business operations
4. Configure structured logging with trace correlation
5. Expose Prometheus metrics endpoint
```

### Step 2: Set Up Collection Pipeline

```
1. Deploy OpenTelemetry Collector as sidecar or daemonset
2. Configure Prometheus scraping for metrics
3. Configure Loki or Elasticsearch for log aggregation
4. Configure Jaeger or Tempo for trace storage
5. Set up retention policies for each signal
```

### Step 3: Build Dashboards

```
1. Create RED metrics dashboard (Rate, Errors, Duration)
2. Create USE metrics dashboard (Utilization, Saturation, Errors)
3. Create service-specific dashboards
4. Add SLO/error budget panels
5. Link traces to logs for debugging
```

### Step 4: Configure Alerting

```
1. Define alert rules based on SLO burn rates
2. Set up multi-window, multi-burn-rate alerts
3. Configure routing to PagerDuty/Slack
4. Test alert firing and resolution
5. Review and tune alerts monthly
```

## Advanced Techniques

### 1. OpenTelemetry Full-Stack Instrumentation

```typescript
// tracing.ts — OpenTelemetry setup for Node.js
import { NodeSDK } from '@opentelemetry/sdk-node';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-grpc';
import { OTLPMetricExporter } from '@opentelemetry/exporter-metrics-otlp-grpc';
import { PeriodicExportingMetricReader } from '@opentelemetry/sdk-metrics';
import { Resource } from '@opentelemetry/resources';
import { ATTR_SERVICE_NAME, ATTR_SERVICE_VERSION } from '@opentelemetry/semantic-conventions';
import { trace, context, SpanKind, SpanStatusCode } from '@opentelemetry/api';

// Configure resource (identifies this service)
const resource = new Resource({
  [ATTR_SERVICE_NAME]: 'order-service',
  [ATTR_SERVICE_VERSION]: process.env.APP_VERSION || '1.0.0',
  'deployment.environment': process.env.NODE_ENV || 'development',
});

// Configure trace exporter (sends to OTel Collector)
const traceExporter = new OTLPTraceExporter({
  url: process.env.OTEL_EXPORTER_OTLP_ENDPOINT || 'http://localhost:4317',
});

// Configure metric exporter
const metricExporter = new OTLPMetricExporter({
  url: process.env.OTEL_EXPORTER_OTLP_ENDPOINT || 'http://localhost:4317',
});

// Metric reader with 15-second export interval
const metricReader = new PeriodicExportingMetricReader({
  exporter: metricExporter,
  exportIntervalMillis: 15_000,
});

// Initialize SDK
const sdk = new NodeSDK({
  resource,
  traceExporter,
  metricReader,
  instrumentations: [
    getNodeAutoInstrumentations({
      // Fine-tune auto-instrumentation
      '@opentelemetry/instrumentation-http': {
        enabled: true,
      },
      '@opentelemetry/instrumentation-express': {
        enabled: true,
      },
      '@opentelemetry/instrumentation-pg': {
        enabled: true,
      },
      '@opentelemetry/instrumentation-redis': {
        enabled: true,
      },
    }),
  ],
});

sdk.start();
process.on('SIGTERM', () => sdk.shutdown());

// ── Manual tracing for business operations ──

const tracer = trace.getTracer('order-service', process.env.APP_VERSION);

/**
 * Process an order with full distributed tracing.
 */
async function processOrder(orderId: string, userId: string): Promise<OrderResult> {
  return tracer.startActiveSpan(
    'processOrder',
    {
      kind: SpanKind.INTERNAL,
      attributes: {
        'order.id': orderId,
        'user.id': userId,
      },
    },
    async (span) => {
      try {
        // Child span: validate order
        const validation = await tracer.startActiveSpan('validateOrder', async (childSpan) => {
          try {
            const result = await validateOrder(orderId);
            childSpan.setAttribute('order.valid', result.isValid);
            childSpan.setAttribute('order.item_count', result.itemCount);
            return result;
          } catch (err) {
            childSpan.setStatus({ code: SpanStatusCode.ERROR, message: String(err) });
            throw err;
          } finally {
            childSpan.end();
          }
        });

        if (!validation.isValid) {
          span.setAttribute('order.result', 'invalid');
          return { success: false, reason: 'validation_failed' };
        }

        // Child span: charge payment
        await tracer.startActiveSpan('chargePayment', async (childSpan) => {
          try {
            await chargePayment(userId, validation.totalAmount);
            childSpan.setAttribute('payment.amount', validation.totalAmount);
            childSpan.setAttribute('payment.currency', 'USD');
          } catch (err) {
            childSpan.setStatus({ code: SpanStatusCode.ERROR, message: String(err) });
            throw err;
          } finally {
            childSpan.end();
          }
        });

        // Child span: send confirmation
        await tracer.startActiveSpan('sendConfirmation', async (childSpan) => {
          try {
            await sendOrderConfirmation(orderId, userId);
            childSpan.setAttribute('notification.type', 'email');
          } catch (err) {
            // Non-critical: log but don't fail the order
            childSpan.setStatus({ code: SpanStatusCode.ERROR, message: String(err) });
            console.warn('Failed to send confirmation', { orderId, error: err });
          } finally {
            childSpan.end();
          }
        });

        span.setAttribute('order.result', 'success');
        return { success: true, orderId };
      } catch (err) {
        span.setStatus({ code: SpanStatusCode.ERROR, message: String(err) });
        span.setAttribute('order.result', 'error');
        throw err;
      } finally {
        span.end();
      }
    }
  );
}
```

### 2. Prometheus Metrics with RED Method

```python
from prometheus_client import Counter, Histogram, Gauge, Summary, generate_latest, CONTENT_TYPE_LATEST
from functools import wraps
import time
import flask

# ── RED Metrics: Rate, Errors, Duration ──

# Request counter (Rate)
REQUEST_COUNT = Counter(
    'http_requests_total',
    'Total HTTP requests',
    ['method', 'endpoint', 'status', 'service']
)

# Error counter (Errors)
ERROR_COUNT = Counter(
    'http_errors_total',
    'Total HTTP errors (4xx, 5xx)',
    ['method', 'endpoint', 'status', 'error_type', 'service']
)

# Request duration histogram (Duration)
REQUEST_DURATION = Histogram(
    'http_request_duration_seconds',
    'HTTP request duration in seconds',
    ['method', 'endpoint', 'service'],
    buckets=[0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0]
)

# In-flight requests (Saturation)
INFLIGHT_REQUESTS = Gauge(
    'http_requests_in_flight',
    'Number of HTTP requests currently being processed',
    ['service']
)

# ── Business Metrics ──

ORDER_COUNT = Counter(
    'orders_total',
    'Total orders processed',
    ['status', 'payment_method']
)

ORDER_VALUE = Histogram(
    'order_value_usd',
    'Order value in USD',
    buckets=[10, 25, 50, 100, 250, 500, 1000, 2500, 5000]
)

ACTIVE_USERS = Gauge(
    'active_users',
    'Number of currently active users',
    ['tier']
)

# ── Infrastructure Metrics ──

DB_CONNECTION_POOL = Gauge(
    'db_connection_pool_size',
    'Database connection pool size',
    ['state']  # active, idle, waiting
)

CACHE_HIT_RATE = Counter(
    'cache_operations_total',
    'Cache operations',
    ['operation', 'result']  # get/set, hit/miss/error
)


def monitor_endpoint(service_name: str):
    """Decorator to instrument Flask endpoints with RED metrics."""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            start_time = time.time()
            INFLIGHT_REQUESTS.inc()

            try:
                result = func(*args, **kwargs)
                duration = time.time() - start_time

                # Determine status code
                if hasattr(result, 'status_code'):
                    status = str(result.status_code)
                else:
                    status = '200'

                # Record metrics
                REQUEST_COUNT.labels(
                    method=flask.request.method,
                    endpoint=func.__name__,
                    status=status,
                    service=service_name
                ).inc()

                REQUEST_DURATION.labels(
                    method=flask.request.method,
                    endpoint=func.__name__,
                    service=service_name
                ).observe(duration)

                if status.startswith('4') or status.startswith('5'):
                    ERROR_COUNT.labels(
                        method=flask.request.method,
                        endpoint=func.__name__,
                        status=status,
                        error_type='client' if status.startswith('4') else 'server',
                        service=service_name
                    ).inc()

                return result

            except Exception as e:
                duration = time.time() - start_time
                ERROR_COUNT.labels(
                    method=flask.request.method,
                    endpoint=func.__name__,
                    status='500',
                    error_type='exception',
                    service=service_name
                ).inc()
                REQUEST_DURATION.labels(
                    method=flask.request.method,
                    endpoint=func.__name__,
                    service=service_name
                ).observe(duration)
                raise
            finally:
                INFLIGHT_REQUESTS.dec()

        return wrapper
    return decorator


# Flask app with metrics
app = flask.Flask(__name__)

@app.route('/metrics')
def metrics():
    """Prometheus metrics endpoint."""
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

@app.route('/items/<item_id>')
@monitor_endpoint('item-service')
def get_item(item_id):
    item = db.get_item(item_id)
    if not item:
        flask.abort(404)
    return flask.jsonify(item)
```

### 3. Structured Logging with Trace Correlation

```python
import structlog
import logging
import json
from opentelemetry import trace

# ── Structured Logger Configuration ──

def add_trace_context(logger, method_name, event_dict):
    """Inject OpenTelemetry trace context into every log entry."""
    span = trace.get_current_span()
    if span and span.is_recording():
        ctx = span.get_span_context()
        event_dict['trace_id'] = format(ctx.trace_id, '032x')
        event_dict['span_id'] = format(ctx.span_id, '016x')
    return event_dict

def add_service_context(logger, method_name, event_dict):
    """Add service metadata to every log entry."""
    event_dict['service'] = 'order-service'
    event_dict['version'] = '1.2.3'
    event_dict['environment'] = 'production'
    return event_dict

structlog.configure(
    processors=[
        structlog.contextvars.merge_contextvars,
        structlog.processors.add_log_level,
        structlog.processors.TimeStamper(fmt='iso'),
        add_trace_context,
        add_service_context,
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.JSONRenderer(),
    ],
    wrapper_class=structlog.make_filtering_bound_logger(logging.INFO),
    context_class=dict,
    logger_factory=structlog.PrintLoggerFactory(),
)

log = structlog.get_logger()

# ── Usage ──

def process_payment(order_id: str, amount: float, user_id: str):
    log.info('payment_started', order_id=order_id, amount=amount, user_id=user_id)

    try:
        result = charge_card(order_id, amount)

        log.info('payment_completed',
            order_id=order_id,
            amount=amount,
            payment_method=result.method,
            processor_response=result.response_code,
            duration_ms=result.duration_ms,
        )

        return result

    except CardDeclinedError as e:
        log.warning('payment_declined',
            order_id=order_id,
            amount=amount,
            decline_code=e.decline_code,
            decline_reason=e.reason,
        )
        raise

    except PaymentTimeoutError as e:
        log.error('payment_timeout',
            order_id=order_id,
            amount=amount,
            timeout_ms=e.timeout_ms,
            exc_info=True,
        )
        raise
```

### 4. Prometheus Alert Rules (Multi-Window, Multi-Burn-Rate)

```yaml
# prometheus-rules.yml
groups:
  - name: slo-alerts
    rules:
      # ── Fast burn: 14.4x burn rate for 1 hour = 2% budget in 1 hour ──
      - alert: HighErrorRate_FastBurn
        expr: |
          (
            rate(http_requests_total{status=~"5.."}[1h])
            /
            rate(http_requests_total[1h])
          )
          > 14.4 * (1 - 0.999)
        for: 2m
        labels:
          severity: critical
          slo: availability
        annotations:
          summary: "High error rate — fast burn (>14.4x for 1h)"
          description: "Error rate is {{ $value | humanizePercentage }}, consuming 2% of error budget per hour"
          runbook_url: "https://wiki/runbooks/high-error-rate"

      # ── Slow burn: 3x burn rate for 6 hours = 1% budget in 6 hours ──
      - alert: HighErrorRate_SlowBurn
        expr: |
          (
            rate(http_requests_total{status=~"5.."}[6h])
            /
            rate(http_requests_total[6h])
          )
          > 3 * (1 - 0.999)
        for: 15m
        labels:
          severity: warning
          slo: availability
        annotations:
          summary: "Elevated error rate — slow burn (>3x for 6h)"
          description: "Error rate is {{ $value | humanizePercentage }}"

      # ── Latency SLO: P99 > 1s for 5 minutes ──
      - alert: HighLatency_P99
        expr: |
          histogram_quantile(0.99,
            rate(http_request_duration_seconds_bucket[5m])
          ) > 1.0
        for: 5m
        labels:
          severity: warning
          slo: latency
        annotations:
          summary: "P99 latency > 1s"
          description: "P99 latency is {{ $value }}s"

      # ── Saturation: CPU > 80% for 10 minutes ──
      - alert: HighCPU
        expr: |
          100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
          > 80
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "CPU usage > 80%"
          description: "CPU on {{ $labels.instance }} is {{ $value }}%"

      # ── Service health ──
      - alert: ServiceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Service {{ $labels.instance }} is down"
          description: "Service has been unreachable for more than 1 minute"

      # ── Error budget exhaustion ──
      - alert: ErrorBudgetLow
        expr: |
          (
            1 - (
              sum_over_time(http_requests_total{status!~"5.."}[30d])
              /
              sum_over_time(http_requests_total[30d])
            )
          )
          > 0.001 * 0.8
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Error budget > 80% consumed"
          description: "Consider feature freeze and reliability improvements"
```

### 5. Grafana Dashboard Configuration

```json
{
  "dashboard": {
    "title": "Service RED Dashboard",
    "tags": ["sre", "red", "golden-signals"],
    "panels": [
      {
        "title": "Request Rate (RPS)",
        "type": "timeseries",
        "gridPos": { "h": 8, "w": 8, "x": 0, "y": 0 },
        "targets": [
          {
            "expr": "sum(rate(http_requests_total{service=\"$service\"}[5m]))",
            "legendFormat": "Total RPS"
          },
          {
            "expr": "sum(rate(http_requests_total{service=\"$service\", status=~\"5..\"}[5m]))",
            "legendFormat": "Error RPS"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "reqps",
            "custom": {
              "drawStyle": "line",
              "lineInterpolation": "smooth",
              "fillOpacity": 10
            }
          }
        }
      },
      {
        "title": "Error Rate",
        "type": "timeseries",
        "gridPos": { "h": 8, "w": 8, "x": 8, "y": 0 },
        "targets": [
          {
            "expr": "sum(rate(http_requests_total{service=\"$service\", status=~\"5..\"}[5m])) / sum(rate(http_requests_total{service=\"$service\"}[5m])) * 100",
            "legendFormat": "Error Rate %"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "percent",
            "thresholds": {
              "steps": [
                { "value": 0, "color": "green" },
                { "value": 1, "color": "yellow" },
                { "value": 5, "color": "red" }
              ]
            }
          }
        }
      },
      {
        "title": "Latency Percentiles",
        "type": "timeseries",
        "gridPos": { "h": 8, "w": 8, "x": 16, "y": 0 },
        "targets": [
          {
            "expr": "histogram_quantile(0.50, rate(http_request_duration_seconds_bucket{service=\"$service\"}[5m]))",
            "legendFormat": "P50"
          },
          {
            "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket{service=\"$service\"}[5m]))",
            "legendFormat": "P95"
          },
          {
            "expr": "histogram_quantile(0.99, rate(http_request_duration_seconds_bucket{service=\"$service\"}[5m]))",
            "legendFormat": "P99"
          }
        ],
        "fieldConfig": {
          "defaults": { "unit": "s" }
        }
      },
      {
        "title": "Error Budget Remaining",
        "type": "gauge",
        "gridPos": { "h": 8, "w": 8, "x": 0, "y": 8 },
        "targets": [
          {
            "expr": "(1 - (sum_over_time(http_requests_total{service=\"$service\", status!~\"5..\"}[30d]) / sum_over_time(http_requests_total{service=\"$service\"}[30d]))) * 100",
            "legendFormat": "Budget Remaining %"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "percent",
            "min": 0,
            "max": 100,
            "thresholds": {
              "steps": [
                { "value": 0, "color": "red" },
                { "value": 20, "color": "yellow" },
                { "value": 50, "color": "green" }
              ]
            }
          }
        }
      },
      {
        "title": "In-Flight Requests",
        "type": "stat",
        "gridPos": { "h": 8, "w": 8, "x": 8, "y": 8 },
        "targets": [
          {
            "expr": "sum(http_requests_in_flight{service=\"$service\"})",
            "legendFormat": "In-Flight"
          }
        ]
      },
      {
        "title": "Apdex Score",
        "type": "stat",
        "gridPos": { "h": 8, "w": 8, "x": 16, "y": 8 },
        "targets": [
          {
            "expr": "sum(rate(http_request_duration_seconds_bucket{service=\"$service\", le=\"0.5\"}[5m])) / sum(rate(http_request_duration_seconds_bucket{service=\"$service\", le=\"+Inf\"}[5m]))",
            "legendFormat": "Apdex"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "min": 0,
            "max": 1,
            "thresholds": {
              "steps": [
                { "value": 0, "color": "red" },
                { "value": 0.7, "color": "yellow" },
                { "value": 0.9, "color": "green" }
              ]
            }
          }
        }
      }
    ]
  }
}
```

### 6. Health Check Endpoints

```python
from fastapi import FastAPI, Response
from fastapi.responses import JSONResponse
import asyncio
import time

app = FastAPI()

# ── Liveness Probe: Is the process alive? ──
@app.get("/health/live")
async def liveness():
    """Kubernetes liveness probe — restarts pod if this fails."""
    return {"status": "alive"}

# ── Readiness Probe: Is the service ready for traffic? ──
@app.get("/health/ready")
async def readiness():
    """Kubernetes readiness probe — removes from load balancer if this fails."""
    checks = {}
    healthy = True

    # Database check
    try:
        start = time.time()
        await db.execute("SELECT 1")
        checks["database"] = {
            "status": "ok",
            "latency_ms": round((time.time() - start) * 1000, 2),
        }
    except Exception as e:
        checks["database"] = {"status": "error", "message": str(e)}
        healthy = False

    # Redis check
    try:
        start = time.time()
        await redis.ping()
        checks["redis"] = {
            "status": "ok",
            "latency_ms": round((time.time() - start) * 1000, 2),
        }
    except Exception as e:
        checks["redis"] = {"status": "error", "message": str(e)}
        healthy = False

    # External API check
    try:
        start = time.time()
        async with httpx.AsyncClient(timeout=5.0) as client:
            resp = await client.get("https://payment-api.example.com/health")
            checks["payment_api"] = {
                "status": "ok" if resp.status_code == 200 else "degraded",
                "latency_ms": round((time.time() - start) * 1000, 2),
            }
    except Exception as e:
        checks["payment_api"] = {"status": "error", "message": str(e)}
        # External dependency failures degrade but don't kill readiness
        checks["payment_api"]["degraded"] = True

    return JSONResponse(
        status_code=200 if healthy else 503,
        content={
            "status": "ready" if healthy else "not_ready",
            "checks": checks,
            "version": "1.2.3",
            "uptime_seconds": int(time.time() - START_TIME),
        },
    )

# ── Startup Probe: Has initialization completed? ──
@app.get("/health/startup")
async def startup():
    """Kubernetes startup probe — waits for initialization to complete."""
    if not initialization_complete:
        return JSONResponse(status_code=503, content={"status": "initializing"})
    return {"status": "started"}
```

### 7. Log Aggregation Pipeline

```yaml
# docker-compose.yml — Loki + Promtail + Grafana stack
version: '3.8'
services:
  loki:
    image: grafana/loki:2.9.0
    ports:
      - "3100:3100"
    volumes:
      - ./loki-config.yml:/etc/loki/local-config.yaml
    command: -config.file=/etc/loki/local-config.yaml

  promtail:
    image: grafana/promtail:2.9.0
    volumes:
      - /var/log:/var/log:ro
      - ./promtail-config.yml:/etc/promtail/config.yml
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
    command: -config.file=/etc/promtail/config.yml

  grafana:
    image: grafana/grafana:10.2.0
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana-data:/var/lib/grafana

volumes:
  grafana-data:
```

```yaml
# promtail-config.yml
server:
  http_listen_port: 9080

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: container-logs
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
        refresh_interval: 5s
    relabel_configs:
      - source_labels: ['__meta_docker_container_name']
        regex: '/(.*)'
        target_label: 'container'
      - source_labels: ['__meta_docker_container_log_stream']
        target_label: 'logstream'
    pipeline_stages:
      - docker: {}
      - json:
          expressions:
            level: level
            message: message
            trace_id: trace_id
      - labels:
          level:
          trace_id:
```

```promql
# Useful LogQL queries in Grafana

# Error rate from logs
sum(rate({container="order-service"} | logfmt | level="error" [5m]))

# Search for specific error
{container="order-service"} | logfmt | message=~".*timeout.*"

# Logs correlated with a trace
{container="order-service"} | logfmt | trace_id="abc123def456"
```

## Common Patterns

### Pattern 1: SLI Definition and Measurement

```python
# SLI definitions for an HTTP service
SLIS = {
    'availability': {
        'description': 'Proportion of successful requests',
        'good': 'http_requests_total{status!~"5.."}',
        'total': 'http_requests_total',
        'target': 99.9,  # percent
    },
    'latency': {
        'description': 'Proportion of requests under 500ms',
        'good': 'http_request_duration_seconds_bucket{le="0.5"}',
        'total': 'http_request_duration_seconds_bucket{le="+Inf"}',
        'target': 99.0,
    },
    'correctness': {
        'description': 'Proportion of responses with correct data',
        'good': 'http_responses_correct_total',
        'total': 'http_responses_total',
        'target': 99.99,
    },
}
```

### Pattern 2: Alert Routing Configuration

```yaml
# alertmanager-config.yml
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname', 'severity']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  receiver: 'default'
  routes:
    - match:
        severity: critical
      receiver: 'pagerduty-critical'
      group_wait: 10s
      repeat_interval: 1h
    - match:
        severity: warning
      receiver: 'slack-warnings'
      repeat_interval: 4h

receivers:
  - name: 'default'
    slack_configs:
      - api_url: '${SLACK_WEBHOOK}'
        channel: '#alerts'
        title: '{{ .GroupLabels.alertname }}'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'

  - name: 'pagerduty-critical'
    pagerduty_configs:
      - service_key: '${PAGERDUTY_KEY}'
        description: '{{ .GroupLabels.alertname }}'
        severity: '{{ if eq .GroupLabels.severity "critical" }}critical{{ else }}warning{{ end }}'

  - name: 'slack-warnings'
    slack_configs:
      - api_url: '${SLACK_WEBHOOK}'
        channel: '#alerts-warning'
```

### Pattern 3: Trace-to-Log Correlation

```python
# In your application — inject trace context into logs
from opentelemetry import trace

def get_trace_context():
    span = trace.get_current_span()
    if span and span.is_recording():
        ctx = span.get_span_context()
        return {
            'trace_id': format(ctx.trace_id, '032x'),
            'span_id': format(ctx.span_id, '016x'),
        }
    return {}

# In your logging middleware
@app.middleware("http")
async def logging_middleware(request: Request, call_next):
    trace_ctx = get_trace_context()
    log.info("request_started",
        method=request.method,
        path=request.url.path,
        **trace_ctx,
    )

    response = await call_next(request)

    log.info("request_completed",
        method=request.method,
        path=request.url.path,
        status_code=response.status_code,
        **trace_ctx,
    )
    return response
```

### Pattern 4: Custom Dashboard Variables

```json
{
  "templating": {
    "list": [
      {
        "name": "service",
        "type": "query",
        "query": "label_values(http_requests_total, service)",
        "refresh": 2,
        "multi": false,
        "includeAll": true
      },
      {
        "name": "environment",
        "type": "custom",
        "query": "production,staging,development",
        "current": { "text": "production", "value": "production" }
      }
    ]
  }
}
```

### Pattern 5: Error Budget Burn Rate Alerting

```yaml
# Multi-window burn rate alerting for 99.9% SLO (30-day window)
# Fast burn: 14.4x rate = 2% budget in 1 hour → pages immediately
# Slow burn: 3x rate = 1% budget in 3 days → ticket created

# Alert rules in PromQL:
# Fast burn (1h window, 14.4x rate):
#   rate(http_5xx_total[1h]) / rate(http_requests_total[1h]) > 14.4 * 0.001
#
# Slow burn (3d window, 3x rate):
#   rate(http_5xx_total[72h]) / rate(http_requests_total[72h]) > 3 * 0.001
```

## Edge Cases & Pitfalls

1. **Cardinality explosion from high-cardinality labels** — Labels like `user_id`, `request_id`, or `ip_address` create millions of time series. Use bounded label values or move high-cardinality data to traces.

2. **Alert fatigue from too many alerts** — If every alert is "critical", none are. Implement severity levels and require runbooks for every alert. Review and prune monthly.

3. **Missing trace context propagation** — If your HTTP client library does not inject `traceparent` headers, traces break at service boundaries. Verify propagation with `curl -v` and check headers.

4. **Histogram bucket configuration** — Default histogram buckets may not match your latency profile. Customize buckets to capture your actual latency distribution (e.g., `[0.01, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10]`).

5. **Health checks that are too expensive** — Health checks that query every dependency on every request add load. Use lazy checks or cache results briefly (10-30 seconds).

6. **Liveness probe restart loops** — If the liveness probe fails because the service is under load (not actually dead), Kubernetes will restart it repeatedly, making things worse. Keep liveness checks lightweight.

7. **Log aggregation storage costs** — Storing all logs forever is expensive. Define retention policies by log level (keep errors for 90 days, debug logs for 7 days).

8. **Missing correlation IDs** — Without a shared `trace_id` across logs, metrics, and traces, debugging distributed issues requires manual log searching. Always propagate correlation context.

9. **Over-reliance on percentiles** — P99 latency masks the experience of the worst 1%. Combine with Apdex score, SLOs, and absolute thresholds for a complete picture.

10. **Alert rules that fire on transient spikes** — A 1-second spike in error rate should not page someone. Use `for` clauses (e.g., `for: 5m`) to require sustained deviation.

11. **Metrics without context** — A counter showing 500 errors is useless without knowing which endpoint, which user tier, and which deployment version. Always include contextual labels.

12. **Dashboards that nobody uses** — A dashboard is only valuable if it answers a question. Design dashboards around operational questions, not arbitrary metrics.

13. **Prometheus scrape interval too short** — Scraping every 5 seconds generates enormous data volume with minimal benefit. 15-second intervals are sufficient for most use cases.

14. **Log levels set incorrectly in production** — DEBUG in production generates terabytes of noise; WARNING as default loses critical errors. Set INFO as default, DEBUG on-demand per service.

15. **Missing SLI for async operations** — Queue-based processing (SQS, Kafka) needs separate SLIs for enqueue success, processing success, and end-to-end latency.

## Integration with Other Skills

| Skill | Integration Point | Direction | Notes |
|-------|-------------------|-----------|-------|
| ci-cd | Pipeline health metrics, deployment verification | → | CI/CD reports pipeline metrics; monitoring verifies deployments |
| incident-response | Alert detection, RCA evidence, timeline reconstruction | ↔ | Monitoring detects incidents; incidents improve monitoring |
| feature-flag | Experiment metrics, rollout monitoring | ← | Flag changes generate metrics; metrics guide rollout decisions |
| serverless | Lambda metrics, cold start tracking | ← | Serverless platforms expose different metrics than traditional |
| deployment | Canary verification, rollback triggers | ← | Monitoring validates canary deployments; triggers automatic rollback |
| api-design | API latency SLIs, error rate tracking | ← | API contracts define expected latency; monitoring verifies compliance |
| database-design | Query performance metrics, connection pool monitoring | ← | Database metrics inform indexing and connection pool tuning |

## Output Format Templates

### Template 1: Monitoring Setup Checklist

```markdown
## Monitoring Setup: {Service Name}

### Instrumentation
- [ ] OpenTelemetry SDK configured
- [ ] Auto-instrumentation for HTTP, database, cache
- [ ] Manual spans for business operations
- [ ] Structured logging with trace correlation
- [ ] Prometheus metrics endpoint exposed

### Collection
- [ ] OTel Collector deployed
- [ ] Prometheus scraping configured (15s interval)
- [ ] Loki/Promtail for log aggregation
- [ ] Jaeger/Tempo for trace storage
- [ ] Retention policies defined

### Dashboards
- [ ] RED dashboard (Rate, Errors, Duration)
- [ ] USE dashboard (Utilization, Saturation, Errors)
- [ ] Service-specific dashboard
- [ ] SLO/error budget panel
- [ ] Infrastructure dashboard

### Alerting
- [ ] Availability SLO burn rate alerts
- [ ] Latency SLO burn rate alerts
- [ ] Saturation alerts (CPU, memory, disk)
- [ ] Service health alerts
- [ ] Runbooks linked to every alert

### Health Checks
- [ ] Liveness probe (/health/live)
- [ ] Readiness probe (/health/ready)
- [ ] Startup probe (/health/startup)
```

### Template 2: SLI/SLO Definition Document

```markdown
## SLI/SLO Definition: {Service Name}

### SLI Definitions
| SLI | What We Measure | Good Events | Total Events | Window |
|-----|----------------|-------------|--------------|--------|
| Availability | Request success rate | 5xx-free requests | All requests | 30 days |
| Latency | Request duration | Requests < 500ms | All requests | 30 days |
| Correctness | Response accuracy | Correct responses | All responses | 30 days |

### SLO Targets
| SLO | Target | Error Budget (30d) | Alert Threshold |
|-----|--------|---------------------|-----------------|
| Availability | 99.9% | 43.2 min | 14.4x (fast), 3x (slow) |
| Latency | 99% < 500ms | 7.2 hours | 10x (fast), 3x (slow) |

### Error Budget Policy
- > 50% remaining: Normal deployment velocity
- 20-50% remaining: Deploy with caution
- < 20% remaining: Feature freeze
- Exhausted: No deployments, reliability focus
```

### Template 3: Alert Rule Documentation

```markdown
## Alert: {Alert Name}

**Severity:** Critical/Warning
**SLO:** {Which SLO this protects}
**Runbook:** {Link to runbook}

### Description
[What this alert means]

### PromQL Expression
```promql
{expression}
```

### Thresholds
| Window | Burn Rate | Budget Consumed | Action |
|--------|-----------|-----------------|--------|
| 1 hour | 14.4x | 2% | Page on-call |
| 6 hours | 6x | 1% | Create ticket |
| 3 days | 3x | 1% | Create ticket |

### Response Steps
1. Check dashboard: {link}
2. Review recent deployments: {command}
3. Check logs: {query}
4. Mitigate: {runbook link}
```

### Template 4: Dashboard Design Spec

```markdown
## Dashboard: {Name}

**Audience:** SRE team
**Refresh:** 15s
**Time Range:** Last 6 hours (default)

### Layout
| Row | Panel | Type | Query |
|-----|-------|------|-------|
| 1 | Request Rate | Time series | `sum(rate(http_requests_total[5m]))` |
| 1 | Error Rate | Time series | `rate(http_errors_total[5m]) / rate(http_requests_total[5m])` |
| 1 | P95 Latency | Time series | `histogram_quantile(0.95, ...)` |
| 2 | Error Budget | Gauge | Budget remaining % |
| 2 | In-Flight | Stat | Active requests |
| 2 | Apdex | Stat | Satisfaction score |

### Variables
| Variable | Type | Query |
|----------|------|-------|
| service | Query | `label_values(http_requests_total, service)` |
| environment | Custom | `production,staging` |
```

## Rules

1. **Always use structured logging** — JSON logs are searchable, parseable, and machine-readable. Plain text logs are a debugging dead end at scale.

2. **Correlate logs, metrics, and traces** — Every log entry should include `trace_id` and `span_id`. Without correlation, debugging distributed systems requires manual log grepping.

3. **Alert on symptoms, not causes** — Alert on "error rate > 5%" not "disk 90% full". Symptoms affect users; causes are internal details that may or may not matter.

4. **Every alert must have a runbook** — An alert without a runbook is noise. If you cannot write a response procedure, the alert should not exist.

5. **Use multi-window burn rate alerts** — Single-window alerts either miss slow degradation or fire on transient spikes. Multi-window, multi-burn-rate catches both.

6. **Health checks must be fast** — Liveness and readiness probes should respond in < 100ms. Expensive dependency checks belong in readiness, not liveness.

7. **Dashboard design follows the RED/USE method** — RED (Rate, Errors, Duration) for user-facing services; USE (Utilization, Saturation, Errors) for infrastructure.

8. **Set explicit histogram buckets** — Default buckets rarely match your latency distribution. Configure buckets based on your SLO thresholds and expected latencies.

9. **Define SLOs before writing alerts** — SLOs tell you what matters; alerts tell you when it breaks. Without SLOs, alerts are arbitrary thresholds.

10. **Review alerting rules monthly** — Prune false positives, adjust thresholds based on learned baselines, and add alerts for newly identified failure modes.

11. **Use labels judiciously** — Labels enable dimensional queries but cause cardinality explosions. Never use user IDs, request IDs, or IP addresses as labels.

12. **Test your monitoring in staging** — Deploy dashboards and alerts to staging first. An untested alert will fail when you need it most.
