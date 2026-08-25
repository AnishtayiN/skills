---
name: serverless
description: >-
  Design, build, and optimize serverless architectures on AWS Lambda, Azure Functions,
  and Google Cloud Functions with event-driven patterns and cost control. TRIGGERS:
  serverless, Lambda, cloud functions, function-as-a-service, FaaS, cold start,
  serverless framework, AWS SAM, API Gateway, event-driven, DynamoDB, SQS, SNS,
  سرورلس, توابع ابری, Lambda, بدون سرور, عملکرد ابری,
  无服务器, Lambda函数, 云函数, 事件驱动, DynamoDB, 冷启动, 成本优化
priority: P2
dependencies: [monitoring-observability, ci-cd]
conflicts: []
---

# Serverless Skill — Lambda, Cloud Functions, Event-Driven Architecture & Cost Control

## Overview

Serverless computing eliminates server management by running functions in response to events, but introduces unique architectural patterns: cold starts, stateless execution, event-driven design, and non-obvious cost models. This skill covers the full serverless lifecycle: designing Lambda/Cloud Function handlers, optimizing cold starts, implementing event-driven architectures with SQS/SNS/EventBridge, DynamoDB single-table design, Step Functions for orchestration, cost analysis and optimization, and deployment with AWS SAM or Serverless Framework. Production-grade patterns for building reliable, scalable, and cost-effective serverless applications.

## When to Use This Skill

- Building a serverless API with Lambda and API Gateway
- Optimizing Lambda cold starts for latency-sensitive applications
- Designing event-driven architectures with SQS, SNS, EventBridge, or Kafka
- Implementing DynamoDB single-table design for serverless data access
- Building Step Functions workflows for multi-step orchestration
- Analyzing and optimizing serverless costs (Lambda, API Gateway, DynamoDB)
- Deploying serverless applications with AWS SAM, Serverless Framework, or CDK
- Implementing dead letter queues, retries, and error handling for async processing
- Migrating from server-based to serverless architecture

## When NOT to Use This Skill

- Setting up traditional server infrastructure (→ infrastructure)
- Designing microservice communication patterns (→ system-design)
- Configuring CI/CD pipelines (→ ci-cd)
- Setting up monitoring and alerting (→ monitoring-observability)
- Writing application logic unrelated to serverless (→ application code)
- Database schema design (→ database-design)
- Debugging application errors (→ debugging)
- Designing API contracts (→ api-design)

## Workflow

### Step 1: Design the Architecture

```
1. Identify event sources (HTTP, queue, schedule, storage, stream)
2. Choose function granularity (single-purpose functions)
3. Design data layer (DynamoDB tables, S3 buckets)
4. Map event flows (sync vs async, error handling)
5. Estimate cost at projected scale
```

### Step 2: Implement the Functions

```
1. Write handler functions with minimal dependencies
2. Initialize clients and connections outside the handler
3. Add structured logging with correlation IDs
4. Implement error handling and DLQ routing
5. Add input validation and output formatting
```

### Step 3: Deploy and Test

```
1. Define infrastructure as code (SAM/CDK/Serverless)
2. Configure IAM permissions (least privilege)
3. Set up API Gateway routes and authorizers
4. Deploy to staging and run integration tests
5. Deploy to production with canary or linear rollout
```

### Step 4: Optimize and Monitor

```
1. Right-size memory allocation (memory = CPU)
2. Enable provisioned concurrency for latency-critical paths
3. Monitor cold start rates and duration metrics
4. Review costs monthly and adjust configuration
5. Set up alerts for throttling, errors, and duration anomalies
```

## Advanced Techniques

### 1. Lambda Handler with DynamoDB Single-Table Design

```typescript
import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, GetCommand, PutCommand, QueryCommand, UpdateCommand, DeleteCommand } from '@aws-sdk/lib-dynamodb';

// ── Initialize OUTSIDE the handler (reused across invocations) ──
const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client, {
  marshallOptions: { removeUndefinedValues: true },
});

const TABLE_NAME = process.env.TABLE_NAME!;

// ── DynamoDB Access Patterns ──
interface AccessPatterns {
  getUser: (userId: string) => Promise<User | null>;
  getUserOrders: (userId: string, limit?: number) => Promise<Order[]>;
  getOrder: (orderId: string) => Promise<Order | null>;
  createOrder: (order: Order) => Promise<void>;
  updateUserProfile: (userId: string, updates: Partial<UserProfile>) => Promise<void>;
  getOrdersByStatus: (status: string, limit?: number) => Promise<Order[]>;
}

interface User {
  PK: string;  // USER#<userId>
  SK: string;  // PROFILE
  GSI1PK: string;  // EMAIL#<email>
  GSI1SK: string;  // USER
  userId: string;
  email: string;
  name: string;
  createdAt: string;
}

interface Order {
  PK: string;  // USER#<userId>
  SK: string;  // ORDER#<orderId>
  GSI1PK: string;  // STATUS#<status>
  GSI1SK: string;  // ORDER#<createdAt>
  orderId: string;
  userId: string;
  status: 'pending' | 'processing' | 'shipped' | 'delivered';
  totalAmount: number;
  items: Array<{ productId: string; quantity: number; price: number }>;
  createdAt: string;
}

// ── Access Pattern Implementations ──

async function getUser(userId: string): Promise<User | null> {
  const result = await docClient.send(new GetCommand({
    TableName: TABLE_NAME,
    Key: { PK: `USER#${userId}`, SK: 'PROFILE' },
  }));
  return (result.Item as User) || null;
}

async function getUserOrders(userId: string, limit: number = 20): Promise<Order[]> {
  const result = await docClient.send(new QueryCommand({
    TableName: TABLE_NAME,
    KeyConditionExpression: 'PK = :pk AND begins_with(SK, :sk)',
    ExpressionAttributeValues: {
      ':pk': `USER#${userId}`,
      ':sk': 'ORDER#',
    },
    ScanIndexForward: false, // Newest first
    Limit: limit,
  }));
  return (result.Items as Order[]) || [];
}

async function getOrdersByStatus(status: string, limit: number = 20): Promise<Order[]> {
  const result = await docClient.send(new QueryCommand({
    TableName: TABLE_NAME,
    IndexName: 'GSI1',
    KeyConditionExpression: 'GSI1PK = :pk AND begins_with(GSI1SK, :sk)',
    ExpressionAttributeValues: {
      ':pk': `STATUS#${status}`,
      ':sk': 'ORDER#',
    },
    Limit: limit,
  }));
  return (result.Items as Order[]) || [];
}

async function createOrder(order: Order): Promise<void> {
  await docClient.send(new PutCommand({
    TableName: TABLE_NAME,
    Item: {
      PK: `USER#${order.userId}`,
      SK: `ORDER#${order.orderId}`,
      GSI1PK: `STATUS#${order.status}`,
      GSI1SK: `ORDER#${order.createdAt}`,
      ...order,
    },
    ConditionExpression: 'attribute_not_exists(PK)', // Prevent overwrites
  }));
}

// ── Lambda Handler ──

export const handler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  const { httpMethod, path, pathParameters, body, queryStringParameters } = event;

  try {
    // Route requests
    if (path === '/users/{userId}' && httpMethod === 'GET') {
      const userId = pathParameters?.userId!;
      const user = await getUser(userId);
      if (!user) {
        return response(404, { error: 'User not found' });
      }
      return response(200, user);
    }

    if (path === '/users/{userId}/orders' && httpMethod === 'GET') {
      const userId = pathParameters?.userId!;
      const limit = parseInt(queryStringParameters?.limit || '20');
      const orders = await getUserOrders(userId, limit);
      return response(200, { orders, count: orders.length });
    }

    if (path === '/orders' && httpMethod === 'POST') {
      const orderData = JSON.parse(body!);
      const order: Order = {
        PK: `USER#${orderData.userId}`,
        SK: `ORDER#${orderData.orderId}`,
        GSI1PK: `STATUS#pending`,
        GSI1SK: `ORDER#${new Date().toISOString()}`,
        ...orderData,
        status: 'pending',
        createdAt: new Date().toISOString(),
      };
      await createOrder(order);
      return response(201, order);
    }

    if (path === '/orders' && httpMethod === 'GET') {
      const status = queryStringParameters?.status || 'pending';
      const orders = await getOrdersByStatus(status);
      return response(200, { orders, count: orders.length });
    }

    return response(404, { error: 'Route not found' });

  } catch (err) {
    console.error('Handler error:', JSON.stringify({
      error: String(err),
      path,
      method: httpMethod,
      requestId: event.requestContext?.requestId,
    }));

    if (err instanceof Error && err.name === 'ConditionalCheckFailedException') {
      return response(409, { error: 'Resource already exists' });
    }

    return response(500, { error: 'Internal server error' });
  }
};

function response(statusCode: number, body: unknown): APIGatewayProxyResult {
  return {
    statusCode,
    headers: {
      'Content-Type': 'application/json',
      'X-Request-Id': crypto.randomUUID(),
    },
    body: JSON.stringify(body),
  };
}
```

### 2. Event-Driven Processing with SQS and DLQ

```typescript
import { SQSEvent, SQSBatchResponse, SQSRecord } from 'aws-lambda';
import { SQSClient, SendMessageCommand } from '@aws-sdk/client-sqs';

const sqsClient = new SQSClient({});
const DLQ_URL = process.env.DLQ_URL!;
const MAX_RETRIES = 3;

interface OrderEvent {
  orderId: string;
  userId: string;
  action: 'create' | 'update' | 'cancel';
  retryCount?: number;
}

/**
 * Process SQS messages with partial batch failure reporting.
 * Failed messages are retried up to MAX_RETRIES times, then sent to DLQ.
 */
export const handler = async (event: SQSEvent): Promise<SQSBatchResponse> => {
  const batchItemFailures: { itemIdentifier: string }[] = [];

  for (const record of event.Records) {
    try {
      const orderEvent: OrderEvent = JSON.parse(record.body);
      await processOrderEvent(orderEvent, record);
    } catch (err) {
      console.error('Message processing failed', {
        messageId: record.messageId,
        error: String(err),
        retryCount: getRetryCount(record),
      });

      const retryCount = getRetryCount(record);
      if (retryCount >= MAX_RETRIES) {
        // Send to DLQ after max retries
        await sendToDLQ(record, String(err));
      } else {
        // Mark for retry
        batchItemFailures.push({ itemIdentifier: record.messageId });
      }
    }
  }

  return { batchItemFailures };
};

async function processOrderEvent(event: OrderEvent, record: SQSRecord): Promise<void> {
  const retryCount = getRetryCount(record);

  switch (event.action) {
    case 'create':
      await createOrder(event);
      break;
    case 'update':
      await updateOrder(event);
      break;
    case 'cancel':
      await cancelOrder(event);
      break;
    default:
      throw new Error(`Unknown action: ${event.action}`);
  }

  console.log('Order event processed', {
    orderId: event.orderId,
    action: event.action,
    retryCount,
  });
}

async function sendToDLQ(record: SQSRecord, error: string): Promise<void> {
  await sqsClient.send(new SendMessageCommand({
    QueueUrl: DLQ_URL,
    MessageBody: JSON.stringify({
      originalMessage: record.body,
      error,
      failedAt: new Date().toISOString(),
      messageId: record.messageId,
    }),
    MessageAttributes: {
      'source': { DataType: 'String', StringValue: 'order-processor' },
      'error': { DataType: 'String', StringValue: error.substring(0, 256) },
    },
  }));
}

function getRetryCount(record: SQSRecord): number {
  return parseInt(record.messageAttributes?.['ApproximateReceiveCount']?.stringValue || '1');
}
```

### 3. Step Functions Workflow Orchestration

```typescript
// Step Functions state machine definition (ASL)
const orderWorkflow = {
  Comment: 'Order processing workflow',
  StartAt: 'ValidateOrder',
  States: {
    ValidateOrder: {
      Type: 'Task',
      Resource: 'arn:aws:lambda:us-east-1:123456789:function:validate-order',
      Retry: [
        {
          ErrorEquals: ['States.TaskFailed'],
          IntervalSeconds: 2,
          MaxAttempts: 2,
          BackoffRate: 2,
        },
      ],
      Catch: [
        {
          ErrorEquals: ['States.ALL'],
          Next: 'OrderFailed',
          ResultPath: '$.error',
        },
      ],
      Next: 'ProcessPayment',
    },

    ProcessPayment: {
      Type: 'Task',
      Resource: 'arn:aws:lambda:us-east-1:123456789:function:process-payment',
      TimeoutSeconds: 30,
      Retry: [
        {
          ErrorEquals: ['PaymentTimeoutError'],
          IntervalSeconds: 5,
          MaxAttempts: 3,
          BackoffRate: 2,
        },
        {
          ErrorEquals: ['PaymentDeclinedError'],
          MaxAttempts: 0, // No retry for declined cards
        },
      ],
      Catch: [
        {
          ErrorEquals: ['States.ALL'],
          Next: 'PaymentFailed',
          ResultPath: '$.error',
        },
      ],
      Next: 'FulfillOrder',
    },

    FulfillOrder: {
      Type: 'Task',
      Resource: 'arn:aws:lambda:us-east-1:123456789:function:fulfill-order',
      Retry: [
        {
          ErrorEquals: ['States.TaskFailed'],
          IntervalSeconds: 10,
          MaxAttempts: 3,
          BackoffRate: 2,
        },
      ],
      Next: 'SendConfirmation',
    },

    SendConfirmation: {
      Type: 'Task',
      Resource: 'arn:aws:lambda:us-east-1:123456789:function:send-confirmation',
      Retry: [
        {
          ErrorEquals: ['States.ALL'],
          IntervalSeconds: 5,
          MaxAttempts: 2,
          BackoffRate: 2,
        },
      ],
      Next: 'OrderComplete',
    },

    OrderComplete: {
      Type: 'Succeed',
    },

    OrderFailed: {
      Type: 'Task',
      Resource: 'arn:aws:lambda:us-east-1:123456789:function:handle-order-failure',
      Next: 'OrderFailedState',
    },

    PaymentFailed: {
      Type: 'Task',
      Resource: 'arn:aws:lambda:us-east-1:123456789:function:refund-payment',
      Next: 'OrderFailedState',
    },

    OrderFailedState: {
      Type: 'Fail',
      Error: 'OrderProcessingFailed',
      Cause: 'Order could not be processed',
    },
  },
};
```

### 4. Cold Start Optimization

```typescript
// ── CRITICAL: Initialize outside the handler ──

// ❌ BAD: New connection on every invocation
export const badHandler = async (event: APIGatewayProxyEvent) => {
  const db = new DatabaseConnection(); // Cold start penalty on every invocation!
  await db.connect();
  const result = await db.query('SELECT * FROM users');
  return { statusCode: 200, body: JSON.stringify(result) };
};

// ✅ GOOD: Reuse across invocations
let cachedPool: Pool | null = null;

function getPool(): Pool {
  if (!cachedPool) {
    cachedPool = new Pool({
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT || '5432'),
      database: process.env.DB_NAME,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      max: 1, // Lambda concurrency = connections
      idleTimeoutMillis: 600_000,
      connectionTimeoutMillis: 5_000,
    });
  }
  return cachedPool;
}

export const handler = async (event: APIGatewayProxyEvent) => {
  const pool = getPool(); // Reused on warm invocations
  const result = await pool.query('SELECT * FROM users');
  return { statusCode: 200, body: JSON.stringify(result.rows) };
};

// ── Lazy initialization with timeout ──

let initialized = false;
let initError: Error | null = null;

async function ensureInitialized(): Promise<void> {
  if (initialized) return;
  if (initError) throw initError;

  try {
    // One-time setup
    await configureServices();
    initialized = true;
  } catch (err) {
    initError = err as Error;
    throw err;
  }
}

// ── AWS Lambda Power Tuning ──

// Memory configuration directly affects CPU and network bandwidth.
// Use Lambda Power Tuning tool to find the optimal memory setting.
// https://github.com/alexcasalboni/aws-lambda-power-tuning

// Example results for a Node.js function:
// | Memory (MB) | Duration (ms) | Cost per 1M invocations |
// |-------------|---------------|-------------------------|
// | 128         | 3200          | $6.67                   |
// | 256         | 1600          | $6.67                   |
// | 512         | 800           | $6.67                   |
// | 1024        | 400           | $6.67                   |
// | 2048        | 200           | $6.67                   |
// | 3008        | 150           | $7.50                   |
//
// Sweet spot is often 512MB-1024MB: same cost, much faster.
```

### 5. EventBridge Rule-Based Routing

```typescript
import { EventBridgeClient, PutEventsCommand } from '@aws-sdk/client-eventbridge';

const eventBridge = new EventBridgeClient({});

// ── Emit domain events ──

async function emitOrderEvent(order: Order, action: string): Promise<void> {
  await eventBridge.send(new PutEventsCommand({
    Entries: [{
      Source: 'com.myapp.orders',
      DetailType: `Order${action.charAt(0).toUpperCase() + action.slice(1)}`,
      Detail: JSON.stringify({
        orderId: order.orderId,
        userId: order.userId,
        totalAmount: order.totalAmount,
        items: order.items,
        timestamp: new Date().toISOString(),
      }),
      EventBusName: 'default',
    }],
  }));
}

// ── EventBridge rules (CDK/CloudFormation) ──
const eventRules = {
  // Route order events to specific handlers
  orderCreated: {
    EventPattern: {
      source: ['com.myapp.orders'],
      detailType: ['OrderCreated'],
    },
    Targets: [
      { Arn: 'arn:aws:lambda:us-east-1:123456789:function:send-confirmation-email' },
      { Arn: 'arn:aws:lambda:us-east-1:123456789:function:update-inventory' },
      { Arn: 'arn:aws:lambda:us-east-1:123456789:function:notify-warehouse' },
    ],
  },

  // High-value orders get additional processing
  highValueOrder: {
    EventPattern: {
      source: ['com.myapp.orders'],
      detailType: ['OrderCreated'],
      detail: {
        totalAmount: [{ numeric: ['>=', 500] }],
      },
    },
    Targets: [
      { Arn: 'arn:aws:lambda:us-east-1:123456789:function:fraud-detection' },
      { Arn: 'arn:aws:sqs:us-east-1:123456789:high-value-orders' },
    ],
  },

  // Cancel events trigger refund processing
  orderCancelled: {
    EventPattern: {
      source: ['com.myapp.orders'],
      detailType: ['OrderCancelled'],
    },
    Targets: [
      { Arn: 'arn:aws:lambda:us-east-1:123456789:function:process-refund' },
      { Arn: 'arn:aws:lambda:us-east-1:123456789:function:restore-inventory' },
    ],
  },
};
```

### 6. Cost Analysis and Optimization

```typescript
// ── Lambda Pricing Calculator (us-east-1) ──

const LAMBDA_PRICING = {
  requests: 0.0000002,       // $0.20 per 1M requests
  durationGBSeconds: 0.0000166667, // $16.67 per 1M GB-seconds
  freeRequests: 1_000_000,   // Monthly free tier
  freeGBSeconds: 400_000,    // Monthly free tier
};

interface CostEstimate {
  requests: number;
  avgDurationMs: number;
  memoryMB: number;
  monthlyInvocations: number;
}

function estimateLambdaCost(params: CostEstimate): {
  requestCost: number;
  computeCost: number;
  totalCost: number;
  costPerInvocation: number;
} {
  const { requests, avgDurationMs, memoryMB, monthlyInvocations } = params;

  const billableRequests = Math.max(0, monthlyInvocations - LAMBDA_PRICING.freeRequests);
  const gbSeconds = (monthlyInvocations * avgDurationMs / 1000) * (memoryMB / 1024);
  const billableGBSeconds = Math.max(0, gbSeconds - LAMBDA_PRICING.freeGBSeconds);

  const requestCost = billableRequests * LAMBDA_PRICING.requests;
  const computeCost = billableGBSeconds * LAMBDA_PRICING.durationGBSeconds;

  return {
    requestCost,
    computeCost,
    totalCost: requestCost + computeCost,
    costPerInvocation: monthlyInvocations > 0 ? (requestCost + computeCost) / monthlyInvocations : 0,
  };
}

// ── Cost Optimization Strategies ──

const OPTIMIZATION_STRATEGIES = {
  rightSizeMemory: {
    description: 'Test with different memory sizes to find the cost-performance sweet spot',
    savings: '30-50%',
    tool: 'Lambda Power Tuning',
  },
  useGraviton2: {
    description: 'ARM64 architecture offers 20% better price-performance',
    savings: '20%',
    config: { Architectures: ['arm64'] },
  },
  provisionedConcurrency: {
    description: 'Pre-warm instances for latency-critical paths',
    tradeoff: 'Higher cost for lower latency',
    config: { ProvisionedConcurrencyConfig: { ProvisionedConcurrentExecutions: 5 } },
  },
  batchProcessing: {
    description: 'Process multiple items per invocation to amortize cold start cost',
    savings: '40-60%',
  },
  useSnapStart: {
    description: 'Java-only: snapshots initialized JVM state for faster cold starts',
    savings: 'Cold start from ~5s to ~200ms',
  },
  edgeOptimization: {
    description: 'Use Lambda@Edge or CloudFront Functions for simple logic',
    savings: 'Reduce Lambda invocations by processing at CDN edge',
  },
};
```

### 7. Serverless Framework Configuration

```yaml
# serverless.yml — Production-grade configuration
service: order-api

frameworkVersion: '3'

provider:
  name: aws
  runtime: nodejs20.x
  architecture: arm64
  region: us-east-1
  stage: ${opt:stage, 'dev'}

  environment:
    TABLE_NAME: ${self:service}-${self:provider.stage}
    NODE_OPTIONS: '--enable-source-maps'

  memorySize: 512
  timeout: 30

  # Least-privilege IAM
  iam:
    role:
      statements:
        - Effect: Allow
          Action:
            - dynamodb:GetItem
            - dynamodb:PutItem
            - dynamodb:UpdateItem
            - dynamodb:DeleteItem
            - dynamodb:Query
          Resource:
            - !GetAtt Table.Arn
            - !Join ['/', [!GetAtt Table.Arn, 'index', '*']]
        - Effect: Allow
          Action:
            - sqs:SendMessage
            - sqs:ReceiveMessage
            - sqs:DeleteMessage
          Resource:
            - !GetAtt OrderQueue.Arn

  # API Gateway settings
  apiGateway:
    minimumCompressionSize: 1024
    shouldStartNameWithService: true

  # CloudWatch logging
  logs:
    httpApi:
      format: '{"requestId":"$context.requestId","ip":"$context.identity.sourceIp","requestTime":"$context.requestTime","httpMethod":"$context.httpMethod","routeKey":"$context.routeKey","status":"$context.status","protocol":"$context.protocol","responseLength":"$context.responseLength","duration":"$context.responseLatency"}'

functions:
  api:
    handler: src/handlers/api.handler
    events:
      - httpApi:
          path: /items
          method: GET
      - httpApi:
          path: /items
          method: POST
      - httpApi:
          path: /items/{id}
          method: GET
      - httpApi:
          path: /items/{id}
          method: PUT
      - httpApi:
          path: /items/{id}
          method: DELETE
    memorySize: 512
    provisionedConcurrency: 5

  processOrder:
    handler: src/handlers/process-order.handler
    events:
      - sqs:
          arn: !GetAtt OrderQueue.Arn
          batchSize: 10
          maximumBatchingWindow: 30
          functionResponseType: ReportBatchItemFailures
    reservedConcurrency: 50

  scheduledCleanup:
    handler: src/handlers/cleanup.handler
    events:
      - schedule:
          rate: rate(24 hours)
          enabled: true

resources:
  Resources:
    Table:
      Type: AWS::DynamoDB::Table
      Properties:
        TableName: ${self:provider.environment.TABLE_NAME}
        BillingMode: PAY_PER_REQUEST
        PointInTimeRecoverySpecification:
          PointInTimeRecoveryEnabled: true
        AttributeDefinitions:
          - AttributeName: PK
            AttributeType: S
          - AttributeName: SK
            AttributeType: S
          - AttributeName: GSI1PK
            AttributeType: S
          - AttributeName: GSI1SK
            AttributeType: S
        KeySchema:
          - AttributeName: PK
            KeyType: HASH
          - AttributeName: SK
            KeyType: RANGE
        GlobalSecondaryIndexes:
          - IndexName: GSI1
            KeySchema:
              - AttributeName: GSI1PK
                KeyType: HASH
              - AttributeName: GSI1SK
                KeyType: RANGE
            Projection:
              ProjectionType: ALL
        Tags:
          - Key: Environment
            Value: ${self:provider.stage}

    OrderQueue:
      Type: AWS::SQS::Queue
      Properties:
        QueueName: ${self:service}-${self:provider.stage}-orders
        VisibilityTimeout: 360
        RedrivePolicy:
          deadLetterTargetArn: !GetAtt DLQ.Arn
          maxReceiveCount: 3
        MessageRetentionPeriod: 1209600  # 14 days

    DLQ:
      Type: AWS::SQS::Queue
      Properties:
        QueueName: ${self:service}-${self:provider.stage}-dlq
        MessageRetentionPeriod: 1209600

  Outputs:
    ApiUrl:
      Value: !Sub 'https://${Api}.execute-api.${AWS::Region}.amazonaws.com/${self:provider.stage}'
    TableName:
      Value: !Ref Table
```

## Common Patterns

### Pattern 1: API Gateway + Lambda CRUD

```typescript
// Generic CRUD handler factory
function createCrudHandler<T extends { id: string }>(
  tableName: string,
  validate: (body: unknown) => T
) {
  return async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
    const { httpMethod, pathParameters, body } = event;

    switch (httpMethod) {
      case 'GET':
        if (pathParameters?.id) {
          const item = await getItem(tableName, pathParameters.id);
          return item ? ok(item) : notFound();
        }
        return ok(await listItems(tableName));

      case 'POST':
        const validated = validate(JSON.parse(body!));
        await putItem(tableName, validated);
        return created(validated);

      case 'PUT':
        const updated = validate({ ...JSON.parse(body!), id: pathParameters?.id });
        await putItem(tableName, updated);
        return ok(updated);

      case 'DELETE':
        await deleteItem(tableName, pathParameters!.id!);
        return noContent();

      default:
        return methodNotAllowed();
    }
  };
}
```

### Pattern 2: Async Event Processing Pipeline

```typescript
// Producer: API receives request, enqueues for async processing
export const createOrder = async (event: APIGatewayProxyEvent) => {
  const order = JSON.parse(event.body!);

  // Validate synchronously
  validateOrder(order);

  // Enqueue for async processing
  await sqsClient.send(new SendMessageCommand({
    QueueUrl: ORDER_QUEUE_URL,
    MessageBody: JSON.stringify(order),
    MessageGroupId: order.userId, // FIFO ordering per user
    MessageDeduplicationId: order.orderId,
  }));

  return {
    statusCode: 202,
    body: JSON.stringify({
      orderId: order.orderId,
      status: 'accepted',
      message: 'Order is being processed',
    }),
  };
};

// Consumer: Process order asynchronously
export const processOrder = async (event: SQSEvent) => {
  for (const record of event.Records) {
    const order = JSON.parse(record.body);
    await fulfillOrder(order);
  }
};
```

### Pattern 3: DynamoDB Streams to Lambda

```typescript
import { DynamoDBStreamEvent } from 'aws-lambda';

export const streamHandler = async (event: DynamoDBStreamEvent) => {
  for (const record of event.Records) {
    if (record.eventName === 'INSERT') {
      const newImage = record.dynamodb?.NewImage;
      if (newImage) {
        // Index new item in Elasticsearch/OpenSearch
        await indexDocument({
          id: newImage.PK.S!,
          body: unmarshall(newImage),
        });
      }
    }

    if (record.eventName === 'MODIFY') {
      const newImage = record.dynamodb?.NewImage;
      const oldImage = record.dynamodb?.OldImage;
      // Detect specific field changes
      if (newImage?.status?.S !== oldImage?.status?.S) {
        await notifyStatusChange(newImage!);
      }
    }

    if (record.eventName === 'REMOVE') {
      const oldImage = record.dynamodb?.OldImage;
      if (oldImage) {
        await removeDocument(oldImage.PK.S!);
      }
    }
  }
};
```

### Pattern 4: Scheduled Jobs (Cron + Rate)

```typescript
// Serverless cron: no servers to patch, scales to zero between runs
export const nightlyRollup = async (event: { detailType: string }) => {
  // Idempotency guard: scheduled events CAN fire twice
  const lockKey = `rollup:${new Date().toISOString().slice(0, 10)}`;
  const acquired = await dynamo.putIfNotExists(lockKey, { ttl: 86400 });
  if (!acquired) return { skipped: 'already ran' };

  await aggregateYesterdayMetrics();
  await pruneExpiredSessions();
};

// serverless.yml / SAM:
//   Schedule1: rate(1 day)            # every day
//   Schedule2: cron(0 3 * * ? *)      # 03:00 UTC daily
```

**When:** report generation, cleanup jobs, data rollups. **Watch:** timezone drift (always schedule in UTC), overlapping runs (idempotency lock above), and max 15-min runtime.

### Pattern 5: Webhook Receiver with Fan-Out

```typescript
// Ingest third-party webhooks fast, process async — never do work inline
export const webhookReceiver = async (event: APIGatewayEvent) => {
  const signature = event.headers['X-Signature'];
  if (!verifyHmac(event.body!, signature)) {
    return { statusCode: 401 };           // reject forgeries immediately
  }

  // Respond 200 FAST; providers retry aggressively on timeout
  await queue.send({
    body: event.body,
    source: event.headers['X-Github-Event'] ?? 'generic',
    receivedAt: Date.now(),
  });
  return { statusCode: 202 };             // accepted, not yet processed
};
```

**Why:** webhook senders (Stripe/GitHub) time out after ~10s and disable endpoints that fail repeatedly. Verify signature → enqueue → 202 is the only safe shape.

## Edge Cases & Pitfalls

1. **Cold start latency for latency-sensitive APIs** — Provisioned concurrency eliminates cold starts but costs money even when idle. Use it only for critical user-facing endpoints; let background processing tolerate cold starts.

2. **Lambda timeout limits** — Default 3-second timeout; maximum 15 minutes. For long-running processes, use Step Functions or break work into smaller chunks with SQS chaining.

3. **Connection pooling in Lambda** — Each Lambda invocation may run on a different container. Database connection pools inside Lambda cause connection exhaustion at scale; use RDS Proxy or limit pool size to 1.

4. **SQS visibility timeout misconfiguration** — If processing takes longer than the visibility timeout, the message becomes visible again and gets processed twice. Set visibility timeout to 6x the max processing time.

5. **DynamoDB throttling at scale** — PAY_PER_REQUEST avoids throttling but can be expensive at high throughput. Provisioned capacity with auto-scaling is cheaper for predictable workloads.

6. **API Gateway request/response payload limits** — 10MB for REST API, 10MB for HTTP API. Large payloads should be stored in S3 and referenced by URL.

7. **Lambda layer storage limits** — Layers count toward the 250MB unzipped deployment package limit. For large dependencies, use container images (up to 10GB).

8. **Concurrency limits and account-level throttling** — Default account-level concurrency is 1,000 across all functions. Request increases proactively; use reserved concurrency for critical functions.

9. **Step Functions cost at scale** — Standard workflows cost $25 per 1,000 transitions. Complex workflows with many states can become expensive; use Express workflows for high-volume, short-duration tasks.

10. **IAM permission granularity** — Overly broad IAM roles (e.g., `dynamodb:*`) violate least privilege. Use resource-level permissions and condition keys.

11. **Missing dead letter queues** — Async invocations without DLQs silently drop failed events. Always configure DLQs for async processing; review and reprocess DLQ messages regularly.

12. **CloudWatch Logs retention** — Default log retention is indefinite (expensive). Set retention to 30-90 days for non-audit logs; use Log Groups for cost control.

13. **API Gateway caching bypass** — API Gateway cache ignores `Authorization` headers by default. If you cache responses per-user, include the `Authorization` header in the cache key.

14. **Lambda@Edge and CloudFront Functions limitations** — Lambda@Edge has a 5-second timeout for viewer triggers and 30 seconds for origin triggers. CloudFront Functions can only use JavaScript, no async/await.

15. **Vendor lock-in with proprietary event sources** — Deep integration with AWS-specific services (SQS, DynamoDB, EventBridge) makes migration difficult. Use portability layers (e.g., Knative, Terraform) where multi-cloud is a requirement.

## Integration with Other Skills

| Skill | Integration Point | Direction | Notes |
|-------|-------------------|-----------|-------|
| monitoring-observability | Lambda metrics, X-Ray tracing, CloudWatch logs | ← | Serverless monitoring uses cloud-native tools; traces map cold starts and downstream calls |
| ci-cd | SAM/CDK deployment, Lambda layer publishing | → | CI/CD pipelines deploy serverless infrastructure; Lambda layers are CI artifacts |
| feature-flag | Lambda feature routing, A/B test variants | ← | Flags control which Lambda handler processes a request |
| incident-response | Lambda error handling, DLQ reprocessing | ← | DLQ failures require incident investigation; Lambda throttles trigger alerts |
| api-design | API Gateway schema validation, OpenAPI specs | ← | API Gateway can validate requests against OpenAPI schemas |
| database-design | DynamoDB single-table design, access patterns | ← | Serverless data layer uses different patterns than traditional databases |
| security | IAM least privilege, WAF, API key management | ↔ | Serverless security is primarily IAM and API Gateway configuration |

## Output Format Templates

### Template 1: Serverless Architecture Design

```markdown
## Serverless Architecture: {Service Name}

### Functions
| Function | Trigger | Memory | Timeout | Concurrency | Provisioned |
|----------|---------|--------|---------|-------------|-------------|
| api-handler | API Gateway | 512MB | 30s | 100 | 5 |
| order-processor | SQS | 256MB | 60s | 50 | 0 |
| scheduled-cleanup | CloudWatch Schedule | 128MB | 300s | 5 | 0 |

### Data Layer
| Resource | Type | Purpose | Billing |
|----------|------|---------|---------|
| main-table | DynamoDB | Application data | PAY_PER_REQUEST |
| order-queue | SQS | Async processing | Per-message |
| dlq | SQS | Failed messages | Per-message |

### Event Flow
```
HTTP Request → API Gateway → Lambda (api-handler) → DynamoDB
                                     ↓
                              SQS (order-queue) → Lambda (order-processor) → DynamoDB
                                     ↓
                              EventBridge → Lambda (send-email)
```

### Cost Estimate (monthly)
| Service | Invocations | Cost |
|---------|-------------|------|
| Lambda | 10M | $2.00 |
| API Gateway | 10M | $35.00 |
| DynamoDB | 10M reads + 5M writes | $12.50 |
| SQS | 10M messages | $4.00 |
| CloudWatch Logs | 50GB | $2.50 |
| **Total** | | **$56.00** |
```

### Template 2: Cold Start Analysis

```markdown
## Cold Start Analysis: {Function Name}

### Current Performance
| Metric | Cold Start | Warm Start |
|--------|------------|------------|
| Duration | 2500ms | 45ms |
| Memory Used | 128MB | 95MB |
| Init Time | 1800ms | 0ms |

### Optimization Results
| Technique | Cold Start | Improvement |
|-----------|------------|-------------|
| Baseline | 2500ms | - |
| Move DB init outside handler | 1200ms | 52% |
| Reduce package size | 800ms | 33% |
| Upgrade to Node 20 | 650ms | 19% |
| Provisioned Concurrency | 45ms (always warm) | 98% |

### Recommendation
[Use provisioned concurrency for /checkout endpoint; optimize others]
```

### Template 3: Cost Optimization Report

```markdown
## Serverless Cost Report: {Service Name}

### Current Monthly Spend
| Service | Usage | Cost | % of Total |
|---------|-------|------|-----------|
| Lambda | 50M invocations | $10.00 | 15% |
| API Gateway | 50M requests | $175.00 | 55% |
| DynamoDB | 100M RCU + 50M WCU | $62.50 | 20% |
| S3 | 100GB stored, 10M requests | $7.50 | 3% |
| CloudWatch | 200GB logs | $10.00 | 3% |
| **Total** | | **$265.00** | |

### Optimization Opportunities
| Opportunity | Implementation | Savings |
|-------------|----------------|---------|
| Enable API caching | Cache GET responses for 5min | $50/mo |
| Use HTTP API instead of REST | Migrate to HTTP API | $87/mo |
| Right-size Lambda memory | Power tuning analysis | $2/mo |
| DynamoDB on-demand → provisioned | For predictable workloads | $15/mo |

### Total Potential Savings: $154/mo (58%)
```

### Template 4: Deployment Checklist

```markdown
## Serverless Deployment: {Service Name}

### Pre-Deploy
- [ ] Infrastructure as code reviewed
- [ ] IAM permissions follow least privilege
- [ ] DLQ configured for async functions
- [ ] Environment variables encrypted (KMS)
- [ ] Lambda layers tested

### Deploy
- [ ] Deploy to staging first
- [ ] Run integration tests
- [ ] Verify CloudWatch logs
- [ ] Check Lambda cold start metrics
- [ ] Deploy to production (canary 10% → 50% → 100%)

### Post-Deploy
- [ ] Health checks passing
- [ ] Error rate within baseline
- [ ] Latency within SLO
- [ ] No increase in cold starts
- [ ] Cost tracking updated
```

## Rules

1. **Initialize connections and clients outside the handler** — Every Lambda invocation reuses the same execution environment; moving initialization outside the handler eliminates cold start overhead on warm invocations.

2. **Set appropriate timeouts** — Default 3-second timeout kills most real work. Set timeouts based on actual expected duration plus a safety margin; never use the maximum 15-minute timeout for request-response patterns.

3. **Use dead letter queues for all async processing** — Failed async events are silently dropped without DLQs. Always configure DLQs and monitor them with alerts.

4. **Right-size memory allocation** — Lambda memory directly controls CPU and network bandwidth. Use Lambda Power Tuning to find the optimal setting; 512MB-1024MB is often the sweet spot.

5. **Implement idempotency** — Lambda may invoke your function more than once for the same event. Use DynamoDB conditional writes or idempotency keys to prevent duplicate processing.

6. **Keep functions small and single-purpose** — One function, one responsibility. Large functions have larger deployment packages, slower cold starts, and harder-to-debug behavior.

7. **Monitor costs monthly** — Serverless can be expensive at scale. Track Lambda invocations, API Gateway requests, and DynamoDB operations; set billing alarms.

8. **Use provisioned concurrency strategically** — Only for user-facing, latency-critical endpoints. Background processing should tolerate cold starts.

9. **Secure with least privilege IAM** — Every Lambda function gets only the permissions it needs. Use resource-level policies and condition keys.

10. **Test locally before deploying** — Use SAM Local, LocalStack, or Lambda Runtime Emulator to test handlers without cloud deployment.

11. **Use Step Functions for multi-step workflows** — Don't chain Lambda invocations with SQS when Step Functions provides visibility, error handling, and retry logic natively.

12. **Set CloudWatch log retention** — Default indefinite retention is expensive. Set 30-90 days for application logs; 1 year for audit logs.
