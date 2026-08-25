---
name: queue
description: >-
  Design and implement message queues, event streams, and async processing with RabbitMQ,
  Kafka, SQS, and Redis. Covers idempotency, DLQ, backpressure, and delivery guarantees.
  TRIGGERS: message queue, message broker, event queue, async processing, rabbitmq, kafka,
  redis queue, sqs, pub/sub, event streaming, task queue, job queue, background jobs,
  dead letter queue, backpressure, idempotent consumer,
  صف پیام، رویدادها، پردازش ناهمگام، کانال پیام، کار پس‌زمینه، صف وظیفه، انتشار پیام، ابر رویداد,
  消息队列, 事件流, 异步处理, RabbitMQ, Kafka, 死信队列, 消息代理, 后台任务, 消息幂等, 背压
priority: P2
dependencies: [system-design]
conflicts: []
---

# Message Queues & Async Processing Skill — RabbitMQ, Kafka, SQS & Patterns

## Overview

Message queues decouple producers from consumers, enabling asynchronous processing, traffic spike absorption, reliable delivery, and event-driven architectures. This skill covers queue technology selection (RabbitMQ, Kafka, Redis/BullMQ, AWS SQS), message design, delivery guarantees (at-most-once, at-least-once, exactly-once), idempotent consumer patterns, dead letter queues (DLQ), backpressure management, dead message handling, and production monitoring. Every pattern includes production-ready code with error handling.

## When to Use This Skill

- Choosing between RabbitMQ, Kafka, SQS, or Redis for a messaging use case
- Designing async task queues for background jobs (email, image processing, reports)
- Implementing event-driven architectures with pub/sub or event streaming
- Building dead letter queues (DLQ) for failed message handling
- Implementing idempotent consumers to handle duplicate message delivery
- Managing backpressure when producers outpace consumers
- Setting up exactly-once vs. at-least-once delivery guarantees
- Designing event schemas for cross-service communication
- Configuring consumer groups, partitioning, and message ordering
- صف پیام (message queue), صف وظیفه (task queue), انتشار پیام (pub/sub)
- پردازش ناهمگام (async processing), ابر رویداد (event streaming)
- 消息队列 (message queue), 异步处理 (async processing), 死信队图 (dead letter queue)
- 消息代理 (message broker), 背压 (backpressure), 消息幂等 (idempotent message)

## When NOT to Use This Skill

- Synchronous API call patterns with no async needs → use **api-design** skill
- Microservice boundary design without messaging focus → use **microservices** skill
- Caching strategies (not queue-related) → use **caching** skill
- Real-time WebSocket streaming without queuing → use **websockets** or **real-time** skill
- Database job scheduling (cron-like) → use **database-design** or infrastructure skills
- Simple background tasks in a single-process app → use language-specific job libraries
- No message passing or async processing involved → use general coding skills

---

## Workflow

### Step 1: Select the Right Queue Technology

```
Queue Technology Decision Tree:
├── Need task queue (background jobs)?
│   ├── Simple tasks, few consumers → Redis + BullMQ
│   ├── Complex routing, priority queues → RabbitMQ
│   └── AWS-native, fully managed → SQS
│
├── Need event streaming (audit, replay, analytics)?
│   ├── High throughput, ordered events → Kafka
│   ├── Simple pub/sub, low volume → Redis Streams
│   └── AWS-native streaming → Kinesis
│
├── Need pub/sub (broadcast to many consumers)?
│   ├── Fan-out to multiple services → RabbitMQ (fanout exchange)
│   ├── Durable, replayable subscriptions → Kafka
│   └── Simple notifications → Redis Pub/Sub
│
└── Need exactly-once delivery?
    ├── Financial transactions → Kafka (with transactions)
    ├── Idempotent processing with DLQ → RabbitMQ + idempotency keys
    └── SQS FIFO queues (ordered, exactly-once per message group)
```

**Comparison Matrix**:

| Feature | RabbitMQ | Kafka | Redis (BullMQ) | SQS |
|---|---|---|---|---|
| **Model** | Message broker | Event log | In-memory + AOF | Managed service |
| **Throughput** | 50K msgs/sec | 1M+ msgs/sec | 100K+ msgs/sec | 3K msgs/sec (standard) |
| **Latency** | < 1ms | < 10ms | < 1ms | 10-50ms |
| **Ordering** | Per-queue | Per-partition | Per-stream | Per-message-group (FIFO) |
| **Persistence** | Disk (durable) | Disk (replicated) | Optional (AOF) | Disk |
| **Dead Letter** | Built-in | Manual | Manual | Built-in |
| **Replay** | No (unless quorum queues) | Yes (offset-based) | Yes (stream) | No |
| **Best For** | Task routing, RPC | Event sourcing, analytics | Background jobs, caching | AWS-native, simple queues |

### Step 2: Design Message Schema

```typescript
// ─── Standard Event Envelope ─────────────────────────────────────
interface DomainEvent {
  // Unique event ID (for idempotency)
  id: string;
  // Event type (e.g., "order.created")
  type: string;
  // Aggregate this event belongs to
  aggregateType: string;
  aggregateId: string;
  // Monotonic version (for optimistic concurrency)
  version: number;
  // ISO 8601 timestamp
  timestamp: string;
  // Correlation ID (links events across services)
  correlationId: string;
  // Causation ID (the event that caused this one)
  causationId?: string;
  // Who caused this event (user ID or system)
  causedBy: string;
  // Event-specific data
  payload: Record<string, unknown>;
  // Metadata (trace ID, source service, etc.)
  metadata: {
    source: string;
    traceId?: string;
    [key: string]: unknown;
  };
}

// ─── Example: Order Events ───────────────────────────────────────
const orderCreatedEvent: DomainEvent = {
  id: 'evt_abc123',
  type: 'order.created',
  aggregateType: 'Order',
  aggregateId: 'ord_xyz789',
  version: 1,
  timestamp: '2024-01-15T10:30:00.000Z',
  correlationId: 'corr_def456',
  causedBy: 'user_123',
  payload: {
    orderId: 'ord_xyz789',
    userId: 'user_123',
    items: [
      { productId: 'prod_1', quantity: 2, unitPriceCents: 2500 },
      { productId: 'prod_2', quantity: 1, unitPriceCents: 4999 },
    ],
    totalAmountCents: 9999,
    currency: 'USD',
  },
  metadata: {
    source: 'order-service',
    traceId: 'trace_abc123',
    requestId: 'req_xyz789',
  },
};
```

### Step 3: Implement Producers

### Step 4: Implement Idempotent Consumers

### Step 5: Configure DLQ and Retry

### Step 6: Implement Backpressure

### Step 7: Monitor and Alert

---

## Advanced Techniques

### 1. Idempotent Consumer Pattern

```typescript
import { Redis } from 'ioredis';

// ═══════════════════════════════════════════════════════════════════
// Idempotency Store: Tracks processed message IDs
// to prevent duplicate processing
// ═══════════════════════════════════════════════════════════════════

class IdempotencyStore {
  private redis: Redis;

  constructor(redis: Redis, private ttlSeconds: number = 86400) {
    this.redis = redis;
  }

  async isProcessed(messageId: string): Promise<boolean> {
    const key = `idempotency:${messageId}`;
    const result = await this.redis.get(key);
    return result !== null;
  }

  async markProcessed(messageId: string, result?: any): Promise<void> {
    const key = `idempotency:${messageId}`;
    const value = JSON.stringify({
      processedAt: new Date().toISOString(),
      result,
    });
    await this.redis.setex(key, this.ttlSeconds, value);
  }

  async getProcessedResult(messageId: string): Promise<any | null> {
    const key = `idempotency:${messageId}`;
    const raw = await this.redis.get(key);
    return raw ? JSON.parse(raw) : null;
  }
}

// ─── Idempotent Consumer Wrapper ─────────────────────────────────
class IdempotentConsumer<T> {
  constructor(
    private idempotencyStore: IdempotencyStore,
    private handler: (message: T) => Promise<any>
  ) {}

  async process(message: T & { id: string }): Promise<any> {
    // 1. Check if already processed
    const existing = await this.idempotencyStore.getProcessedResult(message.id);
    if (existing !== null) {
      console.log(`Message ${message.id} already processed, returning cached result`);
      return existing.result;
    }

    // 2. Process the message
    try {
      const result = await this.handler(message);

      // 3. Mark as processed (with result for future checks)
      await this.idempotencyStore.markProcessed(message.id, result);
      return result;
    } catch (error) {
      // Don't mark as processed on failure — allow retry
      throw error;
    }
  }
}

// ─── Usage ───────────────────────────────────────────────────────
const redis = new Redis();
const idempotencyStore = new IdempotencyStore(redis, 86400); // 24h TTL

const paymentConsumer = new IdempotentConsumer(
  idempotencyStore,
  async (event: PaymentEvent) => {
    // This will only execute once per unique event.id
    const payment = await paymentService.processPayment(event);
    return { paymentId: payment.id, status: payment.status };
  }
);

// In your message handler:
async function handleMessage(msg: amqplib.Message) {
  const event = JSON.parse(msg.content.toString());
  try {
    await paymentConsumer.process(event);
    channel.ack(msg);
  } catch (error) {
    channel.nack(msg, false, true); // Requeue for retry
  }
}
```

### 2. Dead Letter Queue (DLQ) with Retry and Poison Message Handling

```typescript
import amqplib from 'amqplib';

// ═══════════════════════════════════════════════════════════════════
// DLQ Pattern: Messages that fail N times go to DLQ
// for manual inspection and potential reprocessing
// ═══════════════════════════════════════════════════════════════════

class DLQConsumer {
  private channel: amqplib.Channel;
  private maxRetries: number;
  private retryDelayMs: number;

  constructor(
    channel: amqplib.Channel,
    options: { maxRetries?: number; retryDelayMs?: number } = {}
  ) {
    this.channel = channel;
    this.maxRetries = options.maxRetries ?? 3;
    this.retryDelayMs = options.retryDelayMs ?? 1000;
  }

  async consume(
    queue: string,
    handler: (msg: any) => Promise<void>
  ): Promise<void> {
    const dlq = `${queue}.dlq`;
    const retryQueue = `${queue}.retry`;

    // Assert queues exist
    await this.channel.assertQueue(queue, { durable: true });
    await this.channel.assertQueue(dlq, { durable: true });
    await this.channel.assertQueue(retryQueue, {
      durable: true,
      arguments: {
        'x-message-ttl': this.retryDelayMs,
        'x-dead-letter-exchange': '',
        'x-dead-letter-routing-key': queue,
      },
    });

    await this.channel.consume(queue, async (msg) => {
      if (!msg) return;

      const retryCount = msg.properties.headers?.['x-retry-count'] || 0;

      try {
        await handler(JSON.parse(msg.content.toString()));
        this.channel.ack(msg);
      } catch (error) {
        console.error(`Processing failed (attempt ${retryCount + 1}/${this.maxRetries}):`, error.message);

        if (retryCount < this.maxRetries) {
          // Requeue with incremented retry count
          this.channel.sendToQueue(retryQueue, msg.content, {
            persistent: true,
            headers: {
              'x-retry-count': retryCount + 1,
              'x-death-reason': error.message,
              'x-original-queue': queue,
              'x-first-failure-at': new Date().toISOString(),
            },
          });
          this.channel.ack(msg); // Ack original, DLQ version is the retry
        } else {
          // Max retries exceeded → send to DLQ
          console.error(`Message sent to DLQ after ${this.maxRetries} attempts`);
          this.channel.sendToQueue(dlq, msg.content, {
            persistent: true,
            headers: {
              'x-retry-count': retryCount,
              'x-death-reason': error.message,
              'x-failed-at': new Date().toISOString(),
              'x-original-queue': queue,
            },
          });
          this.channel.ack(msg);
        }
      }
    });
  }
}

// ─── DLQ Replay Tool ────────────────────────────────────────────
class DLQManager {
  constructor(private channel: amqplib.Channel) {}

  // Replay a single message from DLQ back to original queue
  async replayMessage(dlqName: string, messageId: string): Promise<void> {
    const msg = await this.getFromDLQ(dlqName, messageId);
    if (!msg) throw new Error(`Message ${messageId} not found in ${dlqName}`);

    const originalQueue = msg.headers?.['x-original-queue'] || dlqName.replace('.dlq', '');
    this.channel.sendToQueue(originalQueue, msg.content, {
      persistent: true,
      headers: {
        'x-retry-count': 0, // Reset retry count
        'x-replayed': true,
        'x-replayed-at': new Date().toISOString(),
      },
    });
  }

  // Replay all messages from DLQ
  async replayAll(dlqName: string): Promise<number> {
    const originalQueue = dlqName.replace('.dlq', '');
    let count = 0;

    const consumer = async (msg: amqplib.ConsumeMessage | null) => {
      if (!msg) return;
      this.channel.sendToQueue(originalQueue, msg.content, {
        persistent: true,
        headers: { 'x-retry-count': 0, 'x-replayed': true },
      });
      this.channel.ack(msg);
      count++;
    };

    await this.channel.consume(dlqName, consumer);
    return count;
  }

  // Get DLQ statistics
  async getStats(dlqName: string): Promise<DLQStats> {
    const queueInfo = await this.channel.checkQueue(dlqName);
    return {
      queueName: dlqName,
      messageCount: queueInfo.messageCount,
      consumerCount: queueInfo.consumerCount,
    };
  }
}

interface DLQStats {
  queueName: string;
  messageCount: number;
  consumerCount: number;
}
```

### 3. Backpressure Management

```typescript
// ═══════════════════════════════════════════════════════════════════
// Backpressure: When producers outpace consumers,
// implement flow control to prevent system overload
// ═══════════════════════════════════════════════════════════════════

// ─── Strategy 1: Consumer Prefetch (RabbitMQ) ───────────────────
// Limit how many unacknowledged messages a consumer holds
await channel prefetch(10); // Only fetch 10 messages at a time

// ─── Strategy 2: Rate-Limited Producer ───────────────────────────
class RateLimitedProducer {
  private tokens: number;
  private lastRefill: number;

  constructor(
    private maxTokens: number,
    private refillRate: number, // tokens per second
    private channel: amqplib.Channel,
  ) {
    this.tokens = maxTokens;
    this.lastRefill = Date.now();
  }

  async publish(queue: string, message: any): Promise<boolean> {
    this.refill();

    if (this.tokens <= 0) {
      console.warn('Backpressure: producer rate limited, waiting...');
      await new Promise((resolve) => setTimeout(resolve, 100));
      return this.publish(queue, message); // Retry
    }

    this.tokens--;
    const buffer = Buffer.from(JSON.stringify(message));
    this.channel.sendToQueue(queue, buffer, { persistent: true });
    return true;
  }

  private refill() {
    const now = Date.now();
    const elapsed = (now - this.lastRefill) / 1000;
    this.tokens = Math.min(this.maxTokens, this.tokens + elapsed * this.refillRate);
    this.lastRefill = now;
  }
}

// ─── Strategy 3: Queue Depth Monitor ────────────────────────────
class QueueDepthMonitor {
  private channel: amqplib.Channel;
  private alertThreshold: number;
  private checkIntervalMs: number;

  constructor(
    channel: amqplib.Channel,
    options: { alertThreshold?: number; checkIntervalMs?: number } = {}
  ) {
    this.channel = channel;
    this.alertThreshold = options.alertThreshold ?? 10000;
    this.checkIntervalMs = options.checkIntervalMs ?? 5000;
  }

  async monitor(queueName: string): Promise<void> {
    setInterval(async () => {
      const info = await this.channel.checkQueue(queueName);
      const depth = info.messageCount;

      if (depth > this.alertThreshold) {
        console.error(`[ALERT] Queue ${queueName} depth: ${depth} (threshold: ${this.alertThreshold})`);
        // Send alert to monitoring system
        await this.sendAlert({
          queue: queueName,
          depth,
          threshold: this.alertThreshold,
          timestamp: new Date().toISOString(),
        });
      }
    }, this.checkIntervalMs);
  }

  private async sendAlert(alert: any) {
    // Integrate with PagerDuty, Slack, etc.
    console.error('Queue depth alert:', alert);
  }
}

// ─── Strategy 4: Kubernetes HPA on Queue Depth ───────────────────
const horizontalPodAutoscaler = `
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: order-consumer-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: order-consumer
  minReplicas: 2
  maxReplicas: 20
  metrics:
    - type: External
      external:
        metric:
          name: rabbitmq_queue_depth
          selector:
            matchLabels:
              queue: orders
        target:
          type: AverageValue
          averageValue: "100"
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
        - type: Pods
          value: 4
          periodSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
        - type: Percent
          value: 25
          periodSeconds: 120
`;
```

### 4. Exactly-Once vs. At-Least-Once Delivery

```typescript
// ═══════════════════════════════════════════════════════════════════
// Delivery Guarantees:
// - At-most-once: Fire and forget. Message may be lost.
// - At-least-once: Message delivered at least once. Consumer must be idempotent.
// - Exactly-once: Message processed exactly once. Hard to achieve.
// ═══════════════════════════════════════════════════════════════════

// ─── At-Least-Once with Idempotency (Recommended) ───────────────
// This is the pragmatic choice for most systems
class AtLeastOnceConsumer {
  private idempotencyStore: IdempotencyStore;

  constructor(private handler: (msg: any) => Promise<any>) {
    this.idempotencyStore = new IdempotencyStore(new Redis());
  }

  async process(message: { id: string; payload: any }): Promise<void> {
    // Check if already processed
    if (await this.idempotencyStore.isProcessed(message.id)) {
      console.log(`Duplicate message ${message.id}, skipping`);
      return;
    }

    // Process
    const result = await this.handler(message.payload);

    // Mark as processed (atomic: process + mark in same transaction when possible)
    await this.idempotencyStore.markProcessed(message.id, result);
  }
}

// ─── Exactly-Once with Kafka Transactions ───────────────────────
import { Kafka, EachMessagePayload } from 'kafkajs';

class ExactlyOnceKafkaConsumer {
  private kafka: Kafka;
  private consumer: any;
  private producer: any;

  constructor(config: KafkaConfig) {
    this.kafka = new Kafka(config);
  }

  async start(groupId: string, inputTopic: string, outputTopic: string) {
    this.consumer = this.kafka.consumer({ groupId });
    this.producer = this.kafka.producer({ idempotent: true });

    await this.consumer.connect();
    await this.producer.connect();

    await this.consumer.subscribe({ topic: inputTopic, fromBeginning: false });

    await this.consumer.run({
      eachMessage: async (payload: EachMessagePayload) => {
        // Kafka transaction: read + process + write atomically
        const transaction = await this.producer.transaction();

        try {
          const event = JSON.parse(payload.message.value!.toString());

          // Process the event
          const result = await this.processEvent(event);

          // Write output in the same transaction
          await transaction.send({
            topic: outputTopic,
            messages: [{
              key: payload.message.key,
              value: JSON.stringify(result),
            }],
          });

          // Commit consumer offset + produce in one transaction
          await transaction.sendOffsets({
            offsets: [{
              topic: payload.topic,
              partition: payload.partition,
              offset: String(Number(payload.message.offset) + 1),
            }],
            groupId,
          });

          await transaction.commit();
        } catch (error) {
          await transaction.abort();
          throw error;
        }
      },
    });
  }

  private async processEvent(event: any): Promise<any> {
    // Your processing logic here
    return { ...event, processed: true };
  }
}

// ─── Exactly-Once with SQS FIFO + DynamoDB ──────────────────────
// SQS FIFO provides exactly-once delivery within a message group
// Combine with DynamoDB conditional writes for exactly-once processing
class SQSExactlyOnceConsumer {
  async processMessage(message: SQS.Message): Promise<void> {
    const messageDeduplicationId = message.MessageDeduplicationId;
    const messageGroupId = message.MessageGroupId;

    // Use DynamoDB conditional write for deduplication
    try {
      await dynamodb.put({
        TableName: 'ProcessedMessages',
        Item: {
          messageId: messageDeduplicationId,
          processedAt: Date.now(),
          data: message.Body,
        },
        ConditionExpression: 'attribute_not_exists(messageId)', // Only insert if not exists
      }).promise();

      // Process the message (only runs once per unique messageId)
      await this.handler(JSON.parse(message.Body));
    } catch (error) {
      if (error.code === 'ConditionalCheckFailedException') {
        console.log(`Message ${messageDeduplicationId} already processed, skipping`);
        return;
      }
      throw error;
    }
  }
}
```

### 5. Kafka Partitioning Strategy

```typescript
// ═══════════════════════════════════════════════════════════════════
// Kafka Partitioning: Controls message ordering and parallelism
// Messages with the same key go to the same partition (ordered)
// ═══════════════════════════════════════════════════════════════════

import { Kafka, Partitioners } from 'kafkajs';

const kafka = new Kafka({
  clientId: 'order-service',
  brokers: ['kafka-1:9092', 'kafka-2:9092', 'kafka-3:9092'],
});

// ─── Custom Partitioner ──────────────────────────────────────────
const producer = kafka.producer({
  createPartitioner: Partitioners.DefaultPartitioner,
});

async function publishOrderEvent(order: Order) {
  await producer.send({
    topic: 'orders',
    messages: [
      {
        // Key determines partition assignment
        // All events for the same user go to the same partition
        // This ensures per-user ordering
        key: order.userId,
        value: JSON.stringify({
          type: 'ORDER_CREATED',
          orderId: order.id,
          userId: order.userId,
          total: order.totalAmountCents,
        }),
        headers: {
          'correlation-id': generateCorrelationId(),
          'event-type': 'ORDER_CREATED',
          'source': 'order-service',
        },
      },
    ],
  });
}

// ─── Consumer Group with Partition Assignment ────────────────────
const consumer = kafka.consumer({
  groupId: 'payment-processor',
  // Each partition is assigned to exactly one consumer in the group
  // Adding more consumers (up to partition count) increases parallelism
});

await consumer.connect();
await consumer.subscribe({ topic: 'orders', fromBeginning: false });

await consumer.run({
  eachMessage: async ({ topic, partition, message }) => {
    const event = JSON.parse(message.value!.toString());
    console.log(`Processing event from partition ${partition}:`, event.type);

    await processPayment(event);
  },
});
```

### 6. Event Sourcing with Kafka

```typescript
// ═══════════════════════════════════════════════════════════════════
// Event Sourcing: Store events, not state
// Rebuild state by replaying events from the beginning
// ═══════════════════════════════════════════════════════════════════

class EventStore {
  private producer: any;

  constructor(private kafka: Kafka) {
    this.producer = kafka.producer();
  }

  async append(event: DomainEvent): Promise<void> {
    await this.producer.send({
      topic: `events.${event.aggregateType.toLowerCase()}`,
      messages: [
        {
          key: event.aggregateId,
          value: JSON.stringify(event),
          headers: {
            'event-type': event.type,
            'aggregate-type': event.aggregateType,
            'aggregate-id': event.aggregateId,
            'version': String(event.version),
          },
        },
      ],
    });
  }

  // Replay events for an aggregate to rebuild state
  async getEvents(aggregateType: string, aggregateId: string): Promise<DomainEvent[]> {
    const consumer = this.kafka.consumer({ groupId: `replay-${aggregateId}` });
    await consumer.connect();
    await consumer.subscribe({
      topic: `events.${aggregateType.toLowerCase()}`,
      fromBeginning: true,
    });

    const events: DomainEvent[] = [];

    await consumer.run({
      eachMessage: async ({ message }) => {
        const event = JSON.parse(message.value!.toString());
        if (event.aggregateId === aggregateId) {
          events.push(event);
        }
      },
    });

    // Sort by version
    events.sort((a, b) => a.version - b.version);
    return events;
  }
}

// ─── Aggregate Rebuild ──────────────────────────────────────────
class OrderAggregate {
  id: string;
  status: string;
  items: any[];
  totalAmountCents: number;

  // Rebuild from events
  static fromEvents(events: DomainEvent[]): OrderAggregate {
    const order = new OrderAggregate();
    for (const event of events) {
      order.apply(event);
    }
    return order;
  }

  private apply(event: DomainEvent) {
    switch (event.type) {
      case 'OrderCreated':
        this.id = event.payload.orderId;
        this.status = 'PENDING';
        this.items = event.payload.items;
        this.totalAmountCents = event.payload.totalAmountCents;
        break;
      case 'OrderConfirmed':
        this.status = 'CONFIRMED';
        break;
      case 'OrderCancelled':
        this.status = 'CANCELLED';
        break;
    }
  }
}
```

### 7. RabbitMQ Exchange Types

```typescript
// ═══════════════════════════════════════════════════════════════════
// RabbitMQ Exchange Types: Control how messages are routed
// ═══════════════════════════════════════════════════════════════════

// ─── Direct Exchange (Routing Key Match) ─────────────────────────
// Messages routed by exact routing key match
await channel.assertExchange('orders', 'direct', { durable: true });
await channel.bindQueue('order-created', 'orders', 'created');
await channel.bindQueue('order-cancelled', 'orders', 'cancelled');

// Publish
channel.publish('orders', 'created', Buffer.from(JSON.stringify(order)));
channel.publish('orders', 'cancelled', Buffer.from(JSON.stringify({ orderId })));

// ─── Topic Exchange (Pattern Matching) ───────────────────────────
// Messages routed by routing key patterns
// * matches one word, # matches zero or more words
await channel.assertExchange('logs', 'topic', { durable: true });
await channel.bindQueue('error-logs', 'logs', '*.error');
await channel.bindQueue('order-logs', 'logs', 'order.*');
await channel.bindQueue('all-logs', 'logs', '#');

channel.publish('logs', 'order.error', Buffer.from('Payment failed'));
channel.publish('logs', 'user.created', Buffer.from('New user registered'));

// ─── Fanout Exchange (Broadcast) ────────────────────────────────
// Messages sent to ALL bound queues (ignores routing key)
await channel.assertExchange('notifications', 'fanout', { durable: true });
await channel.bindQueue('email-notifications', 'notifications', '');
await channel.bindQueue('sms-notifications', 'notifications', '');
await channel.bindQueue('push-notifications', 'notifications', '');

channel.publish('notifications', '', Buffer.from(JSON.stringify({
  type: 'ORDER_SHIPPED',
  userId: 'user_123',
  orderId: 'order_456',
})));

// ─── Headers Exchange (Header Matching) ──────────────────────────
// Messages routed by header attributes (not routing key)
await channel.assertExchange('priority-tasks', 'headers', { durable: true });
await channel.bindQueue('high-priority', 'priority-tasks', '', {
  'x-match': 'all',
  'priority': 'high',
  'type': 'payment',
});
await channel.bindQueue('all-tasks', 'priority-tasks', '', {
  'x-match': 'all', // or 'any'
});

channel.publish('priority-tasks', '', Buffer.from(JSON.stringify(task)), {
  headers: { priority: 'high', type: 'payment' },
});
```

### 8. SQS Configuration

```typescript
import { SQS } from '@aws-sdk/client-sqs';

const sqs = new SQS({ region: 'us-east-1' });

// ─── Standard Queue ──────────────────────────────────────────────
const standardQueueUrl = 'https://sqs.us-east-1.amazonaws.com/123456789/tasks';

// ─── FIFO Queue (Ordered, Exactly-Once per Message Group) ───────
const fifoQueueUrl = 'https://sqs.us-east-1.amazonaws.com/123456789/tasks.fifo';

// Send message to FIFO queue
await sqs.sendMessage({
  QueueUrl: fifoQueueUrl,
  MessageBody: JSON.stringify({
    type: 'ORDER_CREATED',
    orderId: 'order_123',
  }),
  MessageGroupId: 'order-service', // Messages in same group are ordered
  MessageDeduplicationId: `order_123_${Date.now()}`, // Dedup within 5min window
});

// ─── Receive with Long Polling ───────────────────────────────────
const response = await sqs.receiveMessage({
  QueueUrl: standardQueueUrl,
  MaxNumberOfMessages: 10,
  WaitTimeSeconds: 20, // Long polling (reduces empty responses)
  VisibilityTimeout: 30, // Seconds before message becomes visible again
  AttributeNames: ['All'],
});

for (const message of response.Messages || []) {
  try {
    const event = JSON.parse(message.Body!);
    await processEvent(event);

    // Delete message on success
    await sqs.deleteMessage({
      QueueUrl: standardQueueUrl,
      ReceiptHandle: message.ReceiptHandle!,
    });
  } catch (error) {
    console.error('Processing failed:', error);
    // Message will become visible again after VisibilityTimeout
    // Configure redrive policy (DLQ) in SQS console
  }
}

// ─── Dead Letter Queue Configuration ─────────────────────────────
const dlqConfig = {
  redrivePolicy: {
    deadLetterTargetArn: 'arn:aws:sqs:us-east-1:123456789:tasks-dlq',
    maxReceiveCount: 3, // After 3 failures → DLQ
  },
};
```

---

## Common Patterns

### Pattern 1: Event-Driven Side Effects

```typescript
// ═══════════════════════════════════════════════════════════════════
// After a state change, publish events for downstream services
// ═══════════════════════════════════════════════════════════════════

class OrderService {
  constructor(
    private db: Database,
    private outbox: OutboxStore,
  ) {}

  async createOrder(command: CreateOrderCommand): Promise<Order> {
    const order = await this.db.transaction(async (tx) => {
      const order = await tx.orders.create({
        userId: command.userId,
        items: command.items,
        status: 'PENDING',
        totalAmountCents: command.totalAmountCents,
      });

      // Write event to outbox (same transaction)
      await this.outbox.write(tx, {
        aggregateType: 'Order',
        aggregateId: order.id,
        eventType: 'OrderCreated',
        payload: {
          orderId: order.id,
          userId: command.userId,
          items: command.items,
          totalAmountCents: command.totalAmountCents,
        },
      });

      return order;
    });

    return order;
  }
}
```

### Pattern 2: Priority Queue (RabbitMQ)

```typescript
// Define priority queues with different routing
async function setupPriorityQueues(channel: amqplib.Channel) {
  // High priority queue
  await channel.assertQueue('tasks.high', {
    durable: true,
    arguments: { 'x-max-priority': 10 },
  });

  // Normal priority queue
  await channel.assertQueue('tasks.normal', {
    durable: true,
    arguments: { 'x-max-priority': 5 },
  });

  // Low priority queue
  await channel.assertQueue('tasks.low', {
    durable: true,
  });

  // Exchange to route based on priority
  await channel.assertExchange('task-router', 'direct', { durable: true });
  await channel.bindQueue('tasks.high', 'task-router', 'high');
  await channel.bindQueue('tasks.normal', 'task-router', 'normal');
  await channel.bindQueue('tasks.low', 'task-router', 'low');
}

// Publish with priority
function publishTask(channel: amqplib.Channel, task: any, priority: string) {
  channel.publish('task-router', priority, Buffer.from(JSON.stringify(task)), {
    persistent: true,
    priority: priority === 'high' ? 10 : priority === 'normal' ? 5 : 1,
  });
}
```

### Pattern 3: Saga with Message Queue

```typescript
// ═══════════════════════════════════════════════════════════════════
// Saga Pattern using message queues for cross-service coordination
// ═══════════════════════════════════════════════════════════════════

class OrderSaga {
  constructor(private mq: MessageQueue) {}

  // Step 1: Start the saga
  async start(order: Order): Promise<void> {
    await this.mq.publish('saga.order.created', {
      sagaId: `saga-${order.id}`,
      orderId: order.id,
      userId: order.userId,
      items: order.items,
      totalAmountCents: order.totalAmountCents,
    });
  }

  // Step 2: Inventory service listens for order.created
  async onOrderCreated(event: any): Promise<void> {
    try {
      await this.reserveInventory(event.items);
      await this.mq.publish('saga.inventory.reserved', {
        sagaId: event.sagaId,
        orderId: event.orderId,
      });
    } catch (error) {
      await this.mq.publish('saga.inventory.failed', {
        sagaId: event.sagaId,
        orderId: event.orderId,
        reason: error.message,
      });
    }
  }

  // Step 3: Payment service listens for inventory.reserved
  async onInventoryReserved(event: any): Promise<void> {
    try {
      await this.processPayment(event.userId, event.totalAmountCents);
      await this.mq.publish('saga.payment.completed', {
        sagaId: event.sagaId,
        orderId: event.orderId,
      });
    } catch (error) {
      // Compensate: release inventory
      await this.mq.publish('saga.payment.failed', {
        sagaId: event.sagaId,
        orderId: event.orderId,
        reason: error.message,
      });
    }
  }

  // Step 4: Compensation handlers
  async onInventoryFailed(event: any): Promise<void> {
    await this.cancelOrder(event.orderId);
  }

  async onPaymentFailed(event: any): Promise<void> {
    await this.releaseInventory(event.orderId);
    await this.cancelOrder(event.orderId);
  }
}
```

### Pattern 4: Batch Processing Consumer

```typescript
class BatchConsumer {
  private buffer: any[] = [];
  private flushInterval: NodeJS.Timeout;

  constructor(
    private batchSize: number = 100,
    private flushIntervalMs: number = 5000,
    private processor: (batch: any[]) => Promise<void>,
  ) {
    this.flushInterval = setInterval(() => this.flush(), flushIntervalMs);
  }

  async addMessage(message: any): Promise<void> {
    this.buffer.push(message);

    if (this.buffer.length >= this.batchSize) {
      await this.flush();
    }
  }

  private async flush(): Promise<void> {
    if (this.buffer.length === 0) return;

    const batch = [...this.buffer];
    this.buffer = [];

    try {
      await this.processor(batch);
    } catch (error) {
      console.error(`Batch processing failed for ${batch.length} messages:`, error);
      // Re-add failed messages to buffer for retry
      this.buffer.unshift(...batch);
    }
  }

  shutdown(): void {
    clearInterval(this.flushInterval);
    this.flush(); // Process remaining messages
  }
}

// Usage: Batch insert to database
const batchConsumer = new BatchConsumer(
  100,  // batch size
  5000, // flush every 5 seconds
  async (batch) => {
    await db.users.bulkCreate(batch);
    console.log(`Inserted ${batch.length} users`);
  }
);
```

### Pattern 5: Message Queue Health Check

```typescript
class QueueHealthChecker {
  private channel: amqplib.Channel;
  private checks: HealthCheck[];

  constructor(channel: amqplib.Channel) {
    this.channel = channel;
    this.checks = [];
  }

  addCheck(queueName: string, options: { maxDepth?: number; maxAge?: number }) {
    this.checks.push({ queueName, ...options });
  }

  async checkAll(): Promise<HealthReport> {
    const results: QueueHealth[] = [];

    for (const check of this.checks) {
      const info = await this.channel.checkQueue(check.queueName);
      const isHealthy =
        info.messageCount <= (check.maxDepth ?? Infinity);

      results.push({
        queue: check.queueName,
        messageCount: info.messageCount,
        consumerCount: info.consumerCount,
        healthy: isHealthy,
      });
    }

    return {
      timestamp: new Date().toISOString(),
      overall: results.every((r) => r.healthy) ? 'healthy' : 'degraded',
      queues: results,
    };
  }
}

interface QueueHealth {
  queue: string;
  messageCount: number;
  consumerCount: number;
  healthy: boolean;
}

interface HealthReport {
  timestamp: string;
  overall: 'healthy' | 'degraded' | 'unhealthy';
  queues: QueueHealth[];
}
```

---

## Edge Cases & Pitfalls

### 1. Message Ordering Guarantees
RabbitMQ: Per-queue ordering only. Kafka: Per-partition ordering. Don't assume global ordering unless using a single partition.

### 2. Duplicate Message Delivery
Every network can retry. Every queue can redeliver. Consumers MUST be idempotent — use message IDs and deduplication stores.

### 3. Poison Messages (Infinite Retry Loop)
A message that always fails will block the queue. Implement max retry count → DLQ with alerting.

### 4. Unbounded Queue Growth
If consumers are slow or crashed, queue depth grows forever. Monitor queue depth and set alerts.

### 5. Consumer Group Rebalancing (Kafka)
When consumers join/leave, partitions are reassigned. During rebalancing, messages may be processed out of order. Use static group membership to reduce rebalancing.

### 6. Message Size Limits
RabbitMQ: Default 128MB. SQS: 256KB. Kafka: Configurable (default 1MB). Large messages should reference external storage.

### 7. Dead Letter Queue Explosion
DLQs accumulate failed messages. Without monitoring and cleanup, they consume disk space and operators forget about them.

### 8. Backpressure Ignored
If you don't implement backpressure, producers will overwhelm consumers. Use prefetch, rate limiting, or queue depth monitoring.

### 9. Schema Evolution Without Versioning
Changing event schemas breaks consumers. Always version events and use additive-only changes.

### 10. Transactional Outbox Not Used
Publishing events directly from business logic risks inconsistency (DB committed but event not published, or vice versa). Use the Outbox pattern.

### 11. Consumer Not Handling SIGTERM
When deploying, consumers should finish processing current messages before shutting down. Implement graceful shutdown.

### 12. FIFO Queue Throughput Limits
SQS FIFO queues have lower throughput (300 msgs/sec with batching). For high-throughput ordered processing, use Kafka.

### 13. Replaying DLQ Messages Without Idempotency
Replaying messages from DLQ can cause double-processing. Ensure consumers are idempotent before replaying.

### 14. Race Conditions in Concurrent Consumers
Multiple consumers processing the same queue may race on shared resources. Use distributed locks or optimistic concurrency.

### 15. Forgetting to Monitor Consumer Lag
Consumer lag (messages waiting to be processed) is a critical metric. High lag means consumers can't keep up.

---

## Integration with Other Skills

| Related Skill | Relationship | When to Integrate |
|---|---|---|
| **microservices** | ← Depends on | Queues are the backbone of async inter-service communication |
| **api-design** | → Feeds into | Event schemas are API contracts between services |
| **caching** | → Feeds into | Queue depth monitoring, Redis as message broker |
| **performance-optimization** | → Feeds into | Queue throughput tuning, backpressure optimization |
| **database-design** | → Feeds into | Outbox table design, event store schema |
| **monitoring** | → Feeds into | Queue depth, consumer lag, DLQ alerts |
| **security** | → Feeds into | Message encryption, ACLs on queues |

---

## Output Format Templates

### Template 1: Queue Architecture Document

```
## Queue Architecture — [System Name]

### Queue Inventory
| Queue | Technology | Producer | Consumer | DLQ | Purpose |
|-------|-----------|----------|----------|-----|---------|
| [name] | [tech] | [service] | [service] | [yes/no] | [purpose] |

### Message Schema
[Event envelope definition with examples]

### Delivery Guarantees
| Queue | Guarantee | Idempotent? | Ordering |
|-------|-----------|-------------|----------|
| [name] | [at-least-once/exactly-once] | [yes/no] | [per-queue/per-partition] |

### Retry Policy
| Queue | Max Retries | Delay | DLQ |
|-------|------------|-------|-----|
| [name] | [N] | [exponential/fixed] | [queue name] |

### Monitoring
| Metric | Threshold | Alert |
|--------|-----------|-------|
| Queue depth | > 10,000 | PagerDuty |
| Consumer lag | > 5,000 | Slack |
| DLQ depth | > 0 | Email |
```

### Template 2: Event Schema Documentation

```
## Event Schema — [event.type]

### Envelope
{
  "id": "uuid",
  "type": "order.created",
  "aggregateType": "Order",
  "aggregateId": "uuid",
  "version": 1,
  "timestamp": "ISO 8601",
  "correlationId": "uuid",
  "payload": { ... }
}

### Payload Fields
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| orderId | string | yes | Unique order ID |
| userId | string | yes | Customer ID |

### Producers
- [service-name]

### Consumers
- [service-name] — handles [action]

### Schema Version
- v1: Initial schema (2024-01-01)
```

### Template 3: DLQ Runbook

```
## DLQ Runbook — [Queue Name]

### Alert Triggered: DLQ depth > 0

### Steps
1. Check DLQ depth: `rabbitmqctl list_queues name messages`
2. Inspect a sample message: [command]
3. Identify failure reason from message headers
4. Fix the root cause
5. Replay messages: [command or code]
6. Verify queue is draining
7. Close the alert

### Common Causes
- Invalid message format → Fix producer
- Downstream service unavailable → Wait for recovery
- Data validation error → Fix data or consumer logic
- Schema mismatch → Update consumer for new schema
```

### Template 4: Consumer Implementation Checklist

```
## Consumer Implementation Checklist

- [ ] Idempotent processing (dedup store or DB constraint)
- [ ] Message validation (schema check before processing)
- [ ] Error handling with DLQ routing
- [ ] Retry logic with exponential backoff
- [ ] Graceful shutdown (finish current message on SIGTERM)
- [ ] Consumer lag monitoring
- [ ] Dead letter queue configured and monitored
- [ ] Rate limiting / backpressure handling
- [ ] Distributed tracing (correlation ID propagation)
- [ ] Health check endpoint
```

---

## Rules

1. **Every consumer must be idempotent** — Messages can be delivered more than once. Design for duplicates.
2. **Always use the Outbox pattern** — Don't publish events directly from business logic. Use transactional outbox for atomicity.
3. **Set max retry count → DLQ** — Poison messages must not block the queue. Route to DLQ after N failures.
4. **Monitor queue depth and consumer lag** — A growing queue means consumers can't keep up. Alert on thresholds.
5. **Version your event schemas** — Use additive-only changes. Never remove required fields without deprecation.
6. **Use dead letter queues everywhere** — Every queue should have a DLQ. Failed messages need inspection and replay.
7. **Implement graceful shutdown** — Finish processing the current message before shutting down consumers.
8. **Set message TTL** — Don't let messages live forever. Expire stale messages automatically.
9. **Use consumer groups for scaling** — Add more consumers to increase throughput (up to partition count in Kafka).
10. **Serialize with schema registry** — Use Avro, Protobuf, or JSON Schema with a registry for type safety.
11. **Handle poison messages proactively** — Messages that always fail should be moved to DLQ immediately.
12. **Backpressure is not optional** — If producers outpace consumers, implement flow control or scale consumers.
