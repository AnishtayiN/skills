---
name: cloud-deployment
description: >-
  Deploy applications to cloud providers (AWS, GCP, Azure) including infrastructure configuration,
  serverless functions, container orchestration, and managed services.
  Trigger this skill when the user wants to deploy an app to the cloud, set up cloud infrastructure,
  configure cloud services, or migrate to a cloud provider.
  Also activate for: deploy to cloud, استقرار ابری, AWS deployment, GCP deploy, Azure setup,
  cloud infrastructure, deploy to AWS, deploy to GCP, deploy to Azure, EC2, Lambda, S3, Cloud Run,
  App Service, Terraform, CloudFormation, serverless deploy, Fargate, ECS, EKS, GKE, AKS,
  cloud setup, infrastructure as code, deploy app, production deployment, staging environment,
  cloud migration, VPC setup, CDN configuration, SSL/TLS on cloud, load balancer setup,
  domain and DNS on cloud, cloud hosting.
---

# Cloud Deployment Skill — Complete AWS, GCP & Azure Mastery

## Overview

This skill deploys applications to major cloud providers with production-ready configurations. It covers IaaS (VMs), PaaS (managed services), serverless (functions), container orchestration, Terraform infrastructure as code, cost optimization, disaster recovery, multi-region deployment, and serverless architecture patterns. The goal is secure, scalable, cost-effective deployments — not just "get it running somewhere."

## When to Use This Skill

- User wants to deploy an application to AWS, GCP, or Azure
- User asks about cloud infrastructure setup or configuration
- User needs to set up databases, storage, or other cloud services
- User wants infrastructure as code (Terraform, CloudFormation, ARM templates)
- User needs CDN, load balancer, SSL, or DNS configuration
- User wants to set up staging/production environments
- User asks about ECS vs EKS, Cloud Run vs GKE, Container Apps
- User needs cost optimization or disaster recovery patterns
- User asks about multi-region deployment or serverless architecture

---

## Part 1: Application Analysis

### Step 1: Analyze the Application

1. **Read the project** — Identify app type (web server, API, static site, cron job, WebSocket service) and technology stack.
2. **Determine deployment requirements:**
   - Persistent storage needed?
   - Database? Which type?
   - Expected traffic level?
   - Budget constraints?
   - Compliance requirements (data residency, GDPR, etc.)?
3. **Check for existing infrastructure** — Terraform files, CloudFormation templates, `serverless.yml`, etc.

### Step 2: Choose the Right Service

| App Type | AWS | GCP | Azure |
|----------|-----|-----|-------|
| Static site / SPA | S3 + CloudFront | Cloud Storage + Cloud CDN | Blob Storage + Front Door |
| API / Web server | ECS Fargate / EC2 | Cloud Run / GKE | App Service / Container Apps |
| Serverless functions | Lambda | Cloud Functions (2nd gen) | Azure Functions |
| Containerized app | ECS / EKS | Cloud Run / GKE | AKS / Container Apps |
| Database (SQL) | RDS / Aurora | Cloud SQL / AlloyDB | Azure SQL |
| Database (NoSQL) | DynamoDB | Firestore / Bigtable | Cosmos DB |
| Cache | ElastiCache | Memorystore | Azure Cache for Redis |
| Message queue | SQS / EventBridge | Pub/Sub | Service Bus |
| Object storage | S3 | Cloud Storage | Blob Storage |
| Search | OpenSearch | Cloud Search | Azure Cognitive Search |

---

## Part 2: AWS — Deep Dive

### ECS vs EKS Decision Matrix

| Factor | ECS Fargate | EKS |
|--------|------------|-----|
| Complexity | Low | High |
| Cost | Lower (no cluster mgmt) | Higher (control plane cost) |
| Kubernetes skills | Not needed | Required |
| Auto-scaling | Service-level | HPA, VPA, Cluster Autoscaler |
| Networking | AWS VPC integration | CNI plugins, service mesh |
| Best for | Simple to moderate workloads | Complex microservices, K8s ecosystem |

### ECS Fargate Pattern

```yaml
# task-definition.json
{
  "family": "myapp",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "512",
  "memory": "1024",
  "executionRoleArn": "arn:aws:iam::role/ecsTaskExecutionRole",
  "containerDefinitions": [
    {
      "name": "app",
      "image": "123456789.dkr.ecr.us-east-1.amazonaws.com/myapp:latest",
      "portMappings": [
        { "containerPort": 3000, "protocol": "tcp" }
      ],
      "environment": [
        { "name": "NODE_ENV", "value": "production" }
      ],
      "secrets": [
        {
          "name": "DATABASE_URL",
          "valueFrom": "arn:aws:secretsmanager:us-east-1:123456789:secret:db-url"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/myapp",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "healthCheck": {
        "command": ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3
      }
    }
  ]
}
```

### Lambda Best Practices

```javascript
// Lambda function with proper patterns
exports.handler = async (event) => {
  // 1. Initialize outside handler (reused across invocations)
  const db = await getDatabaseConnection();

  try {
    // 2. Parse and validate input
    const { id } = JSON.parse(event.body);

    // 3. Business logic
    const result = await db.query('SELECT * FROM items WHERE id = ?', [id]);

    // 4. Return proper response
    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify(result)
    };
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'Internal server error' })
    };
  }
};
```

```yaml
# SAM template for Lambda
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31

Globals:
  Function:
    Runtime: nodejs20.x
    MemorySize: 256
    Timeout: 30
    Tracing: Active
    Environment:
      Variables:
        NODE_ENV: production
        POWERTOOLS_SERVICE_NAME: my-service

Resources:
  MyFunction:
    Type: AWS::Serverless::Function
    Properties:
      Handler: src/handler.handler
      Events:
        ApiEvent:
          Type: Api
          Properties:
            Path: /{proxy+}
            Method: ANY
            RestApiId: !Ref MyApi
      Policies:
        - DynamoDBCrudPolicy:
            TableName: !Ref MyTable
        - SecretsManagerGetSecretPolicy:
            SecretId: !Ref MySecret

  MyTable:
    Type: AWS::DynamoDB::Table
    Properties:
      TableName: my-table
      BillingMode: PAY_PER_REQUEST
      AttributeDefinitions:
        - AttributeName: id
          AttributeType: S
      KeySchema:
        - AttributeName: id
          KeyType: HASH
```

### RDS Patterns

```yaml
# Production RDS with Multi-AZ
Resources:
  MyDatabase:
    Type: AWS::RDS::DBInstance
    Properties:
      DBInstanceIdentifier: mydb
      DBInstanceClass: db.t3.medium
      Engine: postgres
      EngineVersion: '16.1'
      MasterUsername: admin
      MasterUserPassword: !Ref DBPassword
      AllocatedStorage: 100
      StorageType: gp3
      StorageEncrypted: true
      MultiAZ: true
      PubliclyAccessible: false
      VPCSecurityGroups:
        - !Ref DBSecurityGroup
      DBSubnetGroupName: !Ref DBSubnetGroup
      BackupRetentionPeriod: 7
      DeletionProtection: true
      EnablePerformanceInsights: true
      MonitoringInterval: 60
```

---

## Part 3: GCP — Deep Dive

### Cloud Run vs GKE Decision

| Factor | Cloud Run | GKE |
|--------|-----------|-----|
| Complexity | Very low | High |
| Cost | Pay per request (can scale to 0) | Always-on cluster |
| Concurrency | Single container per instance | Multiple containers per pod |
| Networking | Managed | Full VPC control |
| Customization | Limited | Full Kubernetes |
| Best for | APIs, simple services | Complex microservices, ML workloads |

### Cloud Run Pattern

```yaml
# cloud-run-service.yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: myapp
  annotations:
    run.googleapis.com/ingress: all
spec:
  template:
    metadata:
      annotations:
        run.googleapis.com/cpu-throttling: "false"
        run.googleapis.com/memory-limit: "1Gi"
        run.googleapis.com/cpu: "2"
    spec:
      containerConcurrency: 80
      containers:
        - image: gcr.io/my-project/myapp:latest
          ports:
            - containerPort: 3000
          env:
            - name: NODE_ENV
              value: production
          resources:
            limits:
              memory: 1Gi
              cpu: "2"
          startupProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 10
            periodSeconds: 3
      serviceAccountName: myapp@my-project.iam.gserviceaccount.com
  traffic:
    - latestRevision: true
      percent: 100
```

```bash
# Deploy to Cloud Run
gcloud run deploy myapp \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 1Gi \
  --cpu 2 \
  --min-instances 1 \
  --max-instances 100
```

### Cloud Functions (2nd Gen)

```javascript
// index.js - Cloud Function
const functions = require('@google-cloud/functions-framework');

functions.http('myFunction', (req, res) => {
  res.json({ message: 'Hello from Cloud Functions!' });
});
```

```yaml
# deployment.yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: my-function
spec:
  template:
    spec:
      containers:
        - image: gcr.io/my-project/my-function:latest
          ports:
            - containerPort: 8080
```

### Cloud SQL Pattern

```yaml
# Cloud SQL with Cloud Run
apiVersion: v1
kind: Service
metadata:
  name: myapp
  annotations:
    run.googleapis.com/cloudsql-instances: "my-project:us-central1:mydb"
spec:
  template:
    spec:
      containers:
        - image: gcr.io/my-project/myapp:latest
          env:
            - name: DATABASE_URL
              value: "postgresql://user:pass@/mydb?host=/cloudsql/my-project:us-central1:mydb"
```

---

## Part 4: Azure — Deep Dive

### Container Apps Pattern

```yaml
# containerapp.yaml
apiVersion: containerapp.azure.com/v1
kind: ContainerApp
metadata:
  name: myapp
  resourceGroup: my-rg
location: eastus
properties:
  configuration:
    ingress:
      external: true
      targetPort: 3000
    registries:
      - server: myregistry.azurecr.io
        identity: managed
  template:
    containers:
      - name: myapp
        image: myregistry.azurecr.io/myapp:latest
        resources:
          cpu: 0.5
          memory: 1Gi
        probes:
          - type: liveness
            httpGet:
              path: /health
              port: 3000
            periodSeconds: 30
          - type: readiness
            httpGet:
              path: /ready
              port: 3000
            periodSeconds: 10
    scale:
      minReplicas: 1
      maxReplicas: 10
      rules:
        - name: http-rule
          http:
            metadata:
              concurrentRequests: 100
  environment:
    - name: NODE_ENV
      value: production
    - name: DATABASE_URL
      secretRef: database-url
  secrets:
    - name: database-url
      value: "Server=mydb.database.windows.net;Database=myapp;..."
```

### Azure Functions

```javascript
// src/functions/httpTrigger.js
const { app } = require('@azure/functions');

app.http('httpTrigger', {
  methods: ['GET', 'POST'],
  authLevel: 'anonymous',
  handler: async (request, context) => {
    const body = await request.json();
    return { jsonBody: { message: 'Hello from Azure Functions!' } };
  }
});
```

---

## Part 5: Terraform Patterns

### Project Structure

```
infra/
  main.tf              # Provider config, data sources
  variables.tf         # Input variables
  outputs.tf           # Output values
  providers.tf         # Provider versions
  terraform.tfvars     # Variable values (gitignored)
  
  modules/
    networking/        # VPC, subnets, security groups
    compute/           # ECS, Lambda, Cloud Run
    database/          # RDS, Cloud SQL, Cosmos DB
    monitoring/        # CloudWatch, alerts, dashboards
    
  environments/
    dev/               # Dev-specific values
    staging/           # Staging-specific values
    production/        # Production-specific values
```

### Terraform Modules

```hcl
# modules/ecs-service/main.tf
variable "service_name" {
  type = string
}

variable "image" {
  type = string
}

variable "port" {
  type    = number
  default = 3000
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.service.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = var.service_name
    container_port   = var.port
  }
}

output "service_name" {
  value = aws_ecs_service.service.name
}
```

### State Management

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

### Workspaces

```bash
# Create workspaces for different environments
terraform workspace new dev
terraform workspace new staging
terraform workspace new production

# Select workspace
terraform workspace select dev

# Current workspace
terraform workspace show

# Use workspace in configuration
resource "aws_instance" "web" {
  instance_type = terraform.workspace == "production" ? "t3.large" : "t3.micro"
}
```

### Remote State Data Sources

```hcl
# Read state from another workspace
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state"
    key    = "networking/terraform.tfstate"
    region = "us-east-1"
  }
}

# Use outputs from remote state
resource "aws_instance" "web" {
  subnet_id = data.terraform_remote_state.networking.outputs.public_subnet_id
}
```

---

## Part 6: Cost Optimization Strategies

### Right-Sizing

```bash
# AWS - Find idle resources
aws ce get-cost-and-usage \
  --time-period Start=2024-01-01,End=2024-01-31 \
  --granularity MONTHLY \
  --metrics "UnblendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE

# GCP - Cost analysis
gcloud billing budgets list
gcloud compute instances list --format="table(name,zone,machineType,status)"
```

### Spot/Preemptible Instances

```yaml
# ECS with Spot instances
resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.example.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 2
  }

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}
```

### Auto-Scaling

```hcl
# AWS Auto Scaling
resource "aws_appautoscaling_target" "ecs" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 70.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
```

### Reserved Instances and Savings Plans

```bash
# AWS Savings Plans
aws savingsplans describe-savings-plans \
  --output table \
  --filters Name=state,Values=active

# Reserved Instances for RDS
aws rds describe-reserved-db-instances-offerings \
  --db-instance-class db.t3.medium \
  --engine postgres
```

---

## Part 7: Disaster Recovery Patterns

### Backup Strategy

```yaml
# AWS Backup Plan
resource "aws_backup_plan" "main" {
  name = "main-backup-plan"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.main.name
    schedule          = "cron(0 2 * * ? *)"
    lifecycle {
      delete_after = 30
    }
  }

  rule {
    rule_name         = "monthly-backup"
    target_vault_name = aws_backup_vault.main.name
    schedule          = "cron(0 2 1 * ? *)"
    lifecycle {
      delete_after = 365
    }
  }
}
```

### RTO/RPO Targets

| Tier | RTO | RPO | Pattern |
|------|-----|-----|---------|
| Critical | < 1 hour | < 5 minutes | Multi-region active-active |
| High | < 4 hours | < 1 hour | Multi-AZ with automated failover |
| Medium | < 24 hours | < 4 hours | Cross-region backup + restore |
| Low | < 72 hours | < 24 hours | Daily backups |

### Multi-Region Deployment

```hcl
# Primary region
provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

# Secondary region
provider "aws" {
  alias  = "secondary"
  region = "eu-west-1"
}

# Primary RDS
module "primary_db" {
  source    = "./modules/rds"
  providers = { aws = aws.primary }
  # ...
}

# Read replica in secondary region
module "secondary_db" {
  source    = "./modules/rds"
  providers = { aws = aws.secondary }
  # ...
}

# Route 53 failover
resource "aws_route53_health_check" "primary" {
  ip_address        = var.primary_ip
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 10
}

resource "aws_route53_record" "failover" {
  zone_id = var.zone_id
  name    = "api.example.com"
  type    = "A"

  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = var.primary_alb_dns
    zone_id                = var.primary_alb_zone
    evaluate_target_health = true
  }

  set_identifier  = "primary"
  health_check_id = aws_route53_health_check.primary.id
}
```

---

## Part 8: Serverless Architecture Patterns

### Event-Driven Architecture

```yaml
# AWS Event-Driven Pattern
Resources:
  # API Gateway -> Lambda -> DynamoDB
  ApiFunction:
    Type: AWS::Serverless::Function
    Properties:
      Handler: api.handler
      Events:
        Api:
          Type: Api
          Properties:
            Path: /api/{proxy+}
            Method: ANY

  # S3 Event -> Lambda -> SQS
  ProcessUpload:
    Type: AWS::Serverless::Function
    Properties:
      Handler: process.handler
      Events:
        S3Event:
          Type: S3
          Properties:
            Bucket: !Ref UploadBucket
            Events: s3:ObjectCreated:*

  # SQS -> Lambda -> Database
  QueueProcessor:
    Type: AWS::Serverless::Function
    Properties:
      Handler: queue.handler
      Events:
        QueueEvent:
          Type: SQS
          Properties:
            Queue: !GetAtt ProcessQueue.Arn
            BatchSize: 10
```

### Step Functions (Workflow Orchestration)

```json
{
  "Comment": "Order Processing Workflow",
  "StartAt": "ValidateOrder",
  "States": {
    "ValidateOrder": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:function:validate-order",
      "Next": "ProcessPayment"
    },
    "ProcessPayment": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:function:process-payment",
      "Catch": [
        {
          "ErrorEquals": ["PaymentFailed"],
          "Next": "PaymentFailed"
        }
      ],
      "Next": "FulfillOrder"
    },
    "FulfillOrder": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:function:fulfill-order",
      "End": true
    },
    "PaymentFailed": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:function:handle-payment-failure",
      "End": true
    }
  }
}
```

---

## Part 9: Output Format

1. **Infrastructure files** — Terraform, CloudFormation, or CLI commands in code blocks with filenames.
2. **Deployment steps** — Numbered list of commands to deploy, in order.
3. **Cost estimate** — Rough monthly cost estimate for the proposed setup.
4. **Post-deployment checklist** — DNS, SSL, monitoring, secrets verification.
5. **Explanation** — Why specific services were chosen and any tradeoffs.

## Common Pitfalls to Avoid

- **Don't put databases in public subnets.** They should only be accessible from the application tier.
- **Don't use default security groups.** Restrict ingress to only needed ports and sources.
- **Don't store secrets in environment variables in plain text.** Use a secrets manager.
- **Don't skip TLS.** Even for internal services.
- **Don't use the most expensive option by default.** Start with the minimum that meets requirements and scale up.
- **Don't deploy to a single Availability Zone in production.** Use multiple AZs for high availability.
- **Don't skip monitoring and alerting.** You need to know when things break.
- **Don't forget to set up backups.** Automated backups with tested restore procedures.
- **Don't ignore cost anomalies.** Set up billing alerts to catch unexpected cost increases.
- **Don't hardcode infrastructure values.** Use outputs, remote state, or parameter stores.
