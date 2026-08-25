---
name: queue
description: >-
  Design and implement message queues, event streams, and asynchronous processing systems
  using RabbitMQ, Kafka, Redis, SQS, or similar. Use this skill when the user mentions
  message queue, message broker, event queue, async processing, RabbitMQ, Kafka, Redis queue,
  SQS, pub/sub, event streaming, task queue, job queue, background jobs,
  or says صف پیام، رویدادها، پردازش ناهمگام، کانال پیام، کار پس‌زمینه.
---

# Queue Skill — Message Queues, Event Streaming & Async Processing

## Overview

This skill covers message queue design, implementation, and management. Queues decouple producers from consumers, enable async processing, handle traffic spikes, and provide reliable message delivery. This skill covers RabbitMQ, Kafka, Redis queues, AWS SQS, and common patterns like pub/sub, dead letter queues, and exactly-once delivery.

## When to Use This Skill

- User needs to process tasks asynchronously
- User wants to decouple services via messaging
- User asks about RabbitMQ, Kafka, Redis queues, or SQS
- User needs event streaming or pub/sub patterns
- User mentions background jobs, task queues, or message brokers
- User mentions صف پیام or پردازش ناهمگام

---

## Part 1: Queue Selection

### Comparison Matrix

| Feature | RabbitMQ | Kafka | Redis | SQS |
|---------|----------|-------|-------|-----|
| **Model** | Message broker | Event streaming | In-memory + persistence | Managed service |
| **Throughput** | High | Very High | Very High | High |
| **Latency** | Low | Low | Very Low | Medium |
| **Ordering** | Per-queue | Per-partition | Per-stream | Per-message-group |
| **Persistence** | Yes | Yes | Optional | Yes |
| **Consumer Groups** | Yes | Yes | Yes | Yes |
| **Dead Letter** | Yes | Manual | Manual | Yes |
| **Best For** | Task queues, RPC | Event sourcing, analytics | Caching + queues | AWS-native |

### Decision Guide

```
Need task queue (background jobs)?
├── YES → RabbitMQ or SQS
└── NO → Need event streaming (audit, replay)?
    ├── YES → Kafka
    └── NO → Need simple pub/sub with caching?
        ├── YES → Redis
        └── NO → Need managed service on AWS?
            └── YES → SQS/SNS
```

---

## Part 2: RabbitMQ

### Connection Setup

```typescript
import amqplib from 'amqplib';

class RabbitMQ {
  private connection: amqplib.Connection;
  private channel: amqplib.Channel;
  
  async connect() {
    this.connection = await amqplib.connect(process.env.RABBITMQ_URL);
    this.channel = await this.connection.createChannel();
    
    // Handle connection errors
    this.connection.on('error', (err) => {
      console.error('RabbitMQ connection error:', err);
    });
    
    this.channel.on('error', (err) => {
      console.error('RabbitMQ channel error:', err);
    });
  }
  
  async assertQueue(queue: string, options = {}) {
    await this.channel.assertQueue(queue, {
      durable: true, // Persist queue across restarts
      ...options,
    });
  }
  
  async publish(queue: string, message: any) {
    const buffer = Buffer.from(JSON.stringify(message));
    this.channel.sendToQueue(queue, buffer, {
      persistent: true, // Persist message to disk
      timestamp: Date.now(),
    });
  }
  
  async consume(queue: string, handler: (msg: any) => Promise<void>) {
    await this.channel.consume(queue, async (msg) => {
      if (msg) {
        try {
          await handler(JSON.parse(msg.content.toString()));
          this.channel.ack(msg);
        } catch (error) {
          console.error('Processing failed:', error);
          this.channel.nack(msg, false, true); // Requeue
        }
      }
    });
  }
}
```

### Exchange Types

```typescript
// Direct Exchange (routing key)
await channel.assertExchange('orders', 'direct', { durable: true });
await channel.bindQueue('order-created', 'orders', 'created');
await channel.bindQueue('order-completed', 'orders', 'completed');

channel.publish('orders', 'created', Buffer.from(JSON.stringify(order)));

// Fanout Exchange (broadcast)
await channel.assertExchange('notifications', 'fanout', { durable: true });
await channel.bindQueue('email-notifications', 'notifications', '');
await channel.bindQueue('sms-notifications', 'notifications', '');

// Topic Exchange (pattern matching)
await channel.assertExchange('logs', 'topic', { durable: true });
await channel.bindQueue('error-logs', 'logs', '*.error');
await channel.bindQueue('all-logs', 'logs', '#');

channel.publish('logs', 'order.error', Buffer.from('Payment failed'));
```

---

## Part 3: Kafka

### Producer

```typescript
import { Kafka, Producer, ProducerRecord } from 'kafkajs';

const kafka = new Kafka({
  clientId: 'order-service',
  brokers: ['localhost:9092'],
});

const producer = kafka.producer();

async function sendOrderEvent(order: Order) {
  await producer.send({
    topic: 'orders',
    messages: [
      {
        key: order.id, // Ensures ordering per order
        value: JSON.stringify({
          type: 'ORDER_CREATED',
          payload: order,
          timestamp: new Date().toISOString(),
        }),
        headers: {
          'content-type': 'application/json',
          'correlation-id': generateId(),
        },
      },
    ],
  });
}
```

### Consumer

```typescript
const consumer = kafka.consumer({ groupId: 'order-processor' });

async function startConsumer() {
  await consumer.connect();
  await consumer.subscribe({ topic: 'orders', fromBeginning: false });
  
  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      const event = JSON.parse(message.value!.toString());
      
      switch (event.type) {
        case 'ORDER_CREATED':
          await processOrder(event.payload);
          break;
        case 'ORDER_COMPLETED':
          await completeOrder(event.payload);
          break;
      }
    },
  });
}
```

### Partitioning Strategy

```typescript
// Custom partitioner (e.g., by user ID for ordering per user)
const producer = kafka.producer({
  createPartitioner: () => ({
    partitioner: (message) => {
      const key = message.key?.toString();
      if (key) {
        return murmur2(key) % NUM_PARTITIONS;
      }
      return Math.floor(Math.random() * NUM_PARTITIONS);
    },
  }),
});
```

---

## Part 4: Redis Queue (BullMQ)

```typescript
import { Queue, Worker } from 'bullmq';

const emailQueue = new Queue('emails', {
  connection: { host: 'localhost', port: 6379 },
});

// Add job
await emailQueue.add('send-welcome', {
  userId: user.id,
  email: user.email,
}, {
  attempts: 3,  // Retry 3 times
  backoff: { type: 'exponential', delay: 1000 },
  removeOnComplete: true,
  removeOnFail: false,
});

// Process jobs
const worker = new Worker('emails', async (job) => {
  switch (job.name) {
    case 'send-welcome':
      await sendWelcomeEmail(job.data.userId, job.data.email);
      break;
  }
}, {
  connection: { host: 'localhost', port: 6379 },
  concurrency: 5, // Process 5 jobs concurrently
});

worker.on('completed', (job) => {
  console.log(`Job ${job.id} completed`);
});

worker.on('failed', (job, err) => {
  console.error(`Job ${job?.id} failed:`, err);
});
```

---

## Part 5: Dead Letter Queue (DLQ)

### Pattern

```typescript
// Messages that fail processing go to DLQ
async function consumeWithDLQ(queue: string, handler: (msg: any) => Promise<void>) {
  const dlq = `${queue}.dlq`;
  
  await channel.assertQueue(queue, { durable: true });
  await channel.assertQueue(dlq, { durable: true });
  
  await channel.consume(queue, async (msg) => {
    if (!msg) return;
    
    const retryCount = msg.properties.headers['x-retry-count'] || 0;
    
    try {
      await handler(JSON.parse(msg.content.toString()));
      channel.ack(msg);
    } catch (error) {
      if (retryCount < 3) {
        // Retry with delay
        const delay = Math.pow(2, retryCount) * 1000;
        setTimeout(() => {
          channel.sendToQueue(queue, msg.content, {
            persistent: true,
            headers: { 'x-retry-count': retryCount + 1 },
          });
        }, delay);
        channel.ack(msg);
      } else {
        // Send to DLQ
        channel.sendToQueue(dlq, msg.content, {
          persistent: true,
          headers: { 'x-death-reason': error.message },
        });
        channel.ack(msg);
      }
    }
  });
}
```

---

## Part 6: Patterns

### Saga Pattern with Queues

```typescript
// Order Saga using message queue
class OrderSaga {
  async createOrder(order: Order) {
    // Step 1: Reserve inventory
    await this.queue.publish('inventory.reserve', { orderId: order.id, items: order.items });
  }
  
  async onInventoryReserved(event: { orderId: string }) {
    // Step 2: Process payment
    await this.queue.publish('payment.process', { orderId: event.orderId });
  }
  
  async onPaymentCompleted(event: { orderId: string }) {
    // Step 3: Confirm order
    await this.queue.publish('order.confirm', { orderId: event.orderId });
  }
  
  async onPaymentFailed(event: { orderId: string, reason: string }) {
    // Compensate: Release inventory
    await this.queue.publish('inventory.release', { orderId: event.orderId });
  }
}
```

### Event Sourcing

```typescript
// Store events, not state
class EventStore {
  async append(event: DomainEvent) {
    await this.db.events.insert({
      aggregateId: event.aggregateId,
      type: event.type,
      payload: event.payload,
      timestamp: new Date(),
      version: await this.getVersion(event.aggregateId) + 1,
    });
  }
  
  async getEvents(aggregateId: string): Promise<DomainEvent[]> {
    return this.db.events.find({ aggregateId }).sort({ version: 1 });
  }
  
  // Rebuild state from events
  async getState(aggregateId: string) {
    const events = await this.getEvents(aggregateId);
    return events.reduce((state, event) => applyEvent(state, event), null);
  }
}
```

---

## Output Format

```
## Queue Architecture

### Components
| Queue | Producer | Consumer | DLQ |
|-------|----------|----------|-----|
| [name] | [service] | [service] | [yes/no] |

### Message Schema
[Event/message format]

### Processing Guarantees
- At-least-once / At-most-once / Exactly-once
- Ordering requirements
- Retry strategy

### Monitoring
[Queue depth, consumer lag, error rates]
```

## Rules

- **Use DLQ** — Always have a dead letter queue for failed messages
- **Idempotent consumers** — Handle duplicate messages gracefully
- **Monitor queue depth** — Growing queue = problem
- **Set message TTL** — Don't let messages live forever
- **Use consumer groups** — Scale consumers horizontally
- **Serialize properly** — JSON or Avro, schema registry for Kafka
- **Handle poison messages** — Messages that always fail should go to DLQ
