---
name: serverless
description: >-
  Design, build, and deploy serverless applications using AWS Lambda, Azure Functions, Google Cloud Functions,
  or similar platforms. Use this skill when the user mentions serverless, Lambda, cloud functions,
  function-as-a-service, FaaS, cold start, serverless framework, AWS SAM, serverless deployment,
  API Gateway Lambda, event-driven serverless, or says سرورلس، توابع ابری، Lambda، بدون سرور.
---

# Serverless Skill — Lambda, Cloud Functions & Event-Driven Architecture

## Overview

This skill covers serverless application development: AWS Lambda, Azure Functions, Google Cloud Functions, and serverless frameworks. Serverless eliminates server management but introduces unique patterns: cold starts, stateless execution, event-driven design, and cost optimization. This skill provides practical patterns for building production-ready serverless applications.

## When to Use This Skill

- User wants to build a serverless API
- User needs to optimize Lambda cold starts
- User asks about serverless deployment strategies
- User mentions Lambda, Azure Functions, or Cloud Functions
- User wants event-driven architecture patterns
- User mentions سرورلس or توابع ابری

---

## Part 1: Serverless Patterns

### API with Lambda + API Gateway

```typescript
// AWS Lambda handler
import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, GetCommand, PutCommand } from '@aws-sdk/lib-dynamodb';

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

export const handler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  const { httpMethod, pathParameters, body } = event;
  
  try {
    switch (httpMethod) {
      case 'GET':
        return await getItem(pathParameters?.id);
      case 'POST':
        return await createItem(JSON.parse(body!));
      case 'PUT':
        return await updateItem(pathParameters?.id, JSON.parse(body!));
      case 'DELETE':
        return await deleteItem(pathParameters?.id);
      default:
        return { statusCode: 405, body: JSON.stringify({ error: 'Method not allowed' }) };
    }
  } catch (error) {
    console.error('Error:', error);
    return { statusCode: 500, body: JSON.stringify({ error: 'Internal server error' }) };
  }
};

async function getItem(id: string): Promise<APIGatewayProxyResult> {
  const result = await docClient.send(new GetCommand({
    TableName: process.env.TABLE_NAME,
    Key: { id },
  }));
  
  if (!result.Item) {
    return { statusCode: 404, body: JSON.stringify({ error: 'Not found' }) };
  }
  
  return { statusCode: 200, body: JSON.stringify(result.Item) };
}
```

### Event Processing

```typescript
// S3 Event Processing
export const processUpload = async (event: S3Event) => {
  for (const record of event.Records) {
    const bucket = record.s3.bucket.name;
    const key = record.s3.object.key;
    
    // Process the uploaded file
    const content = await s3.getObject({ Bucket: bucket, Key: key }).promise();
    const data = JSON.parse(content.Body!.toString());
    
    // Transform and store
    const processed = transformData(data);
    await saveToDatabase(processed);
    
    // Send notification
    await sns.publish({
      TopicArn: process.env.NOTIFICATION_TOPIC,
      Message: JSON.stringify({ type: 'FILE_PROCESSED', fileKey: key }),
    }).promise();
  }
};
```

---

## Part 2: Cold Start Optimization

### Cold Start Causes

| Factor | Impact | Solution |
|--------|--------|----------|
| **Runtime** | Node.js/Python fast, Java/.NET slow | Use lightweight runtimes |
| **Package size** | Large = slow | Tree-shake, minimize dependencies |
| **VPC configuration** | VPC adds 1-2s | Use Lambda@Edge or avoid VPC |
| **Initialization** | DB connections at init | Move outside handler |
| **Memory** | More memory = more CPU | Right-size memory allocation |

### Optimization Techniques

```typescript
// ❌ BAD: Initialize inside handler (cold start every time)
export const handler = async (event) => {
  const db = new DatabaseConnection(); // New connection every invocation!
  await db.connect();
  // ...
};

// ✅ GOOD: Initialize outside handler (reused across invocations)
const db = new DatabaseConnection();

export const handler = async (event) => {
  // db is reused on warm invocations
  await db.query('SELECT ...');
};

// ✅ GOOD: Use connection pooling
let pool: Pool;

function getPool() {
  if (!pool) {
    pool = new Pool({
      host: process.env.DB_HOST,
      max: 1, // Lambda concurrency = connections
    });
  }
  return pool;
}
```

### Provisioned Concurrency

```yaml
# serverless.yml
functions:
  api:
    handler: src/handler.handler
    events:
      - httpApi: 'GET /items'
    provisionedConcurrency: 5  # Keep 5 instances warm
```

---

## Part 3: State Management

### DynamoDB Single-Table Design

```typescript
// Single table for multiple entity types
interface DynamoItem {
  PK: string;  // Partition key
  SK: string;  // Sort key
  GSI1PK: string; // GSI partition key
  GSI1SK: string; // GSI sort key
  type: string;
  [key: string]: any;
}

// Access patterns
const accessPatterns = {
  // Get user by ID
  getUser: { PK: `USER#${userId}`, SK: `PROFILE` },
  
  // Get all orders for a user
  getUserOrders: { PK: `USER#${userId}`, SK: `ORDER#` },
  
  // Get order by ID
  getOrder: { PK: `ORDER#${orderId}`, SK: `DETAILS` },
  
  // Query by GSI: Get all orders by status
  getOrdersByStatus: { GSI1PK: `STATUS#${status}`, GSI1SK: `ORDER#` },
};
```

### External State Stores

```typescript
// Use ElastiCache/Redis for state
import Redis from 'ioredis';

const redis = new Redis(process.env.REDIS_URL);

export const handler = async (event) => {
  const sessionId = event.headers['x-session-id'];
  
  // Check cache first
  let session = await redis.get(`session:${sessionId}`);
  if (session) {
    return JSON.parse(session);
  }
  
  // Load from database
  session = await loadSessionFromDb(sessionId);
  await redis.setex(`session:${sessionId}`, 3600, JSON.stringify(session));
  
  return session;
};
```

---

## Part 4: Cost Optimization

### Cost Analysis

```typescript
// Lambda pricing (us-east-1)
const pricing = {
  requests: 0.0000002, // $0.20 per 1M requests
  duration: 0.0000166667, // $16.67 per 1M GB-seconds
};

function estimateMonthlyCost(invocations: number, avgDurationMs: number, memoryMB: number) {
  const gbSeconds = (invocations * avgDurationMs / 1000) * (memoryMB / 1024);
  const requestCost = invocations * pricing.requests;
  const durationCost = gbSeconds * pricing.duration;
  
  return {
    requests: requestCost,
    duration: durationCost,
    total: requestCost + durationCost,
  };
}
```

### Optimization Strategies

| Strategy | Savings | Implementation |
|----------|---------|----------------|
| **Right-size memory** | 30-50% | Test with different memory sizes |
| **Use Graviton2** | 20% | ARM64 architecture |
| **Minimize cold starts** | User experience | Provisioned concurrency |
| **Batch processing** | Cost | Process multiple items per invocation |
| **Use Spot** | 70% | For non-critical workloads |

---

## Part 5: Deployment

### Serverless Framework

```yaml
# serverless.yml
service: my-api

provider:
  name: aws
  runtime: nodejs20.x
  region: us-east-1
  stage: ${opt:stage, 'dev'}
  
  environment:
    TABLE_NAME: ${self:service}-${self:provider.stage}
    
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
          Resource: !GetAtt Table.Arn

functions:
  api:
    handler: src/handler.handler
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

resources:
  Resources:
    Table:
      Type: AWS::DynamoDB::Table
      Properties:
        TableName: ${self:provider.environment.TABLE_NAME}
        BillingMode: PAY_PER_REQUEST
        AttributeDefinitions:
          - AttributeName: id
            AttributeType: S
        KeySchema:
          - AttributeName: id
            KeyType: HASH
```

### AWS SAM

```yaml
# template.yaml
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31

Resources:
  GetItemsFunction:
    Type: AWS::Serverless::Function
    Properties:
      Handler: src/handlers/getItems.handler
      Runtime: nodejs20.x
      MemorySize: 256
      Timeout: 30
      Events:
        GetItems:
          Type: Api
          Properties:
            Path: /items
            Method: get
      Policies:
        - DynamoDBReadPolicy:
            TableName: !Ref ItemsTable
```

---

## Part 6: Local Development

### LocalStack / SAM Local

```bash
# Start local DynamoDB
docker run -p 8000:8000 amazon/dynamodb-local

# Test Lambda locally
sam local invoke GetItemsFunction --event events/get-items.json

# Start local API
sam local start-api --port 3000
```

### Testing

```typescript
// Unit test Lambda handler
import { handler } from '../src/handler';
import { mockClient } from 'aws-sdk-client-mock';
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';

const dynamoMock = mockClient(DynamoDBClient);

describe('Lambda Handler', () => {
  it('returns items', async () => {
    dynamoMock.on(GetCommand).resolves({ Item: { id: '1', name: 'Test' } });
    
    const result = await handler({
      httpMethod: 'GET',
      pathParameters: { id: '1' },
    } as any);
    
    expect(result.statusCode).toBe(200);
    expect(JSON.parse(result.body).name).toBe('Test');
  });
});
```

---

## Output Format

```
## Serverless Architecture

### Functions
| Function | Trigger | Memory | Timeout |
|----------|---------|--------|---------|
| [name] | [trigger] | [MB] | [s] |

### Data Layer
[Database/storage choices]

### Cost Estimate
[Monthly cost projection]

### Deployment
[Deployment strategy]
```

## Rules

- **Keep functions small** — One function, one responsibility
- **Optimize cold starts** — Initialize outside handler
- **Use provisioned concurrency** — For latency-sensitive APIs
- **Monitor costs** — Serverless can be expensive at scale
- **Handle failures gracefully** — Retries, dead letter queues
- **Use layers for shared code** — Don't duplicate dependencies
- **Test locally first** — SAM Local or LocalStack
