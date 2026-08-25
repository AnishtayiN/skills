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
  domain and DNS on cloud, cloud hosting, Route 53, CloudFront, API Gateway, ALB, NLB,
  IAM role, IAM policy, S3 bucket policy, Lambda function URL, Lambda@Edge,
  DynamoDB, RDS, Aurora, ElastiCache, SQS, SNS, EventBridge, Secrets Manager, KMS,
  CloudWatch, CloudTrail, GuardDuty, WAF,
  GCP Cloud Run, Cloud Functions, Cloud Storage, Cloud SQL, Firestore,
  Pub/Sub, Secret Manager, Cloud Armor, Cloud CDN, GKE Autopilot, Cloud Build,
  Azure App Service, Azure Functions, Azure Container Apps, Azure SQL, Cosmos DB,
  Azure Key Vault, Azure Front Door, Azure Monitor, Bicep,
  استقرار در AWS, استقرار در GCP, استقرار در آژور, زیرساخت ابری,
  سرور ابری, دیتابیس ابری, ذخیره‌سازی ابری, CDN ابری,
  Terraform module, Terraform state, state locking, Pulumi, CDK,
  blue-green deployment, canary deployment, rolling update, zero-downtime deploy,
  cloud cost optimization, reserved instances, spot instances, cloud budget,
  multi-region deployment, disaster recovery, RTO, RPO, active-active, active-passive,
  زیرساخت به عنوان کد, ترافورم, استقرار بدون توقف,
  سرورلس, فانکشن ابری, لامبدا, اپ سرویس,
  سرور ابری AWS, محیط استیجینگ, محیط تولید,
  AWS SAM, Serverless Framework, Pulumi TypeScript, CDK Python,
  Terraform workspace, Terraform import, Terraform drift,
  AWS Organizations, AWS Control Tower, AWS Landing Zone,
  GCP Organization Policy, GCP Firewall Rules, GCP VPC Service Controls,
  Azure Subscription, Azure Management Group, Azure Policy,
  Infrastructure as Code, GitOps, progressive delivery,
  cloud-native deployment, container orchestration, managed Kubernetes,
  serverless container, FaaS, BaaS, PaaS, IaaS,
  cloud networking, private subnet, public subnet, NAT gateway,
  transit gateway, VPC peering, private link, service mesh,
  cloud monitoring, distributed tracing, structured logging.
---

# Cloud Deployment Skill — AWS, GCP & Azure

## Overview

This skill deploys applications to major cloud providers with production-ready configurations. It covers IaaS (VMs), PaaS (managed services), serverless (functions), and container orchestration. The goal is secure, scalable, cost-effective deployments — not just "get it running somewhere."

## When to Use This Skill

- User wants to deploy an application to AWS, GCP, or Azure
- User asks about cloud infrastructure setup or configuration
- User needs databases, storage, or other cloud services
- User wants infrastructure as code (Terraform, CloudFormation, ARM templates)
- User needs CDN, load balancer, SSL, or DNS configuration
- User wants staging/production environment separation
- User needs multi-region or disaster recovery setup
- User wants cost optimization for existing cloud infrastructure
- User wants cloud-native CI/CD (CodePipeline, Cloud Build, Azure DevOps)
- User wants to migrate from one cloud provider to another
- User needs VPC/VNet, security groups, or networking setup
- User asks about serverless vs. container trade-offs

## Workflow

### Step 1: Analyze the Application

1. **Read the project** — App type (web server, API, static site, cron job, WebSocket) and tech stack.
2. **Determine requirements:**
   - Persistent storage needed?
   - Database type?
   - Expected traffic?
   - Budget constraints?
   - Compliance (data residency, GDPR)?
3. **Check for existing infrastructure** — Terraform, CloudFormation, `serverless.yml`, cloud config.

### Step 2: Choose the Right Service

| App Type | AWS | GCP | Azure |
|----------|-----|-----|-------|
| Static site / SPA | S3 + CloudFront | Cloud Storage + CDN | Blob + Front Door |
| API / Web server | ECS Fargate / EC2 | Cloud Run / GKE | App Service / AKS |
| Serverless functions | Lambda | Cloud Functions | Azure Functions |
| Containerized app | ECS / EKS | Cloud Run / GKE | AKS / Container Apps |
| Database (SQL) | RDS | Cloud SQL | Azure SQL |
| Database (NoSQL) | DynamoDB | Firestore | Cosmos DB |
| Cache | ElastiCache | Memorystore | Azure Cache for Redis |
| Message queue | SQS / EventBridge | Pub/Sub | Service Bus |

### Step 3: Create Infrastructure Configuration

#### Option A: Terraform (Recommended)

```
infra/
  main.tf          # Provider config, resources
  variables.tf     # Input variables
  outputs.tf       # Output values
  terraform.tfvars # Variable values
```

#### Option B: Cloud-Native IaC

- **AWS**: CloudFormation / SAM templates
- **GCP**: Deployment Manager / `gcloud` commands
- **Azure**: ARM templates / Bicep

#### Option C: CLI Commands (simple deploys)

For quick single-service deploys.

### Step 4: Configure the Deployment

1. **Networking** — VPC/VNet with public/private subnets. Least-privilege security groups.
2. **Identity & Access** — IAM roles with minimum permissions. Service accounts, not user creds.
3. **Secrets** — Secrets Manager, Secret Manager, Key Vault. Never hardcode.
4. **Environment variables** — Separate configs per environment.
5. **SSL/TLS** — ACM, Managed Certs, App Service certs.
6. **Logging & Monitoring** — CloudWatch / Cloud Logging / Azure Monitor + alerts.
7. **Health checks & auto-scaling** — Target groups, health endpoints, scaling policies.

### Step 5: Provide Deployment Commands

Clear, copy-pasteable commands.

## Platform-Specific Notes

### AWS
- ECS Fargate for containers (no server management). EKS only for advanced K8s features.
- S3 + CloudFront for static sites — cheapest and fastest.
- Lambda for event-driven. Watch cold starts; keep warm if latency matters.
- RDS Multi-AZ for production databases.

### GCP
- Cloud Run is easiest and most cost-effective for containerized APIs.
- Cloud SQL with private IP (no public exposure for databases).
- IAM Workload Identity for GKE pods (no service account keys).

### Azure
- App Service simplest for web apps. Container Apps for microservices.
- Azure Front Door for global CDN + WAF.
- Managed Identities (no credentials in code).

## Advanced Techniques

### 1. Terraform Module Composition

```hcl
# modules/web-app/main.tf
variable "app_name" { type = string }
variable "environment" { type = string }
variable "container_image" { type = string }
variable "port" { default = 3000 }

resource "aws_ecs_task_definition" "app" {
  family                   = var.app_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([{
    name      = var.app_name
    image     = var.container_image
    essential = true
    portMappings = [{ containerPort = var.port }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.app_name}"
        "awslogs-region"        = "us-east-1"
        "awslogs-stream-prefix" = var.app_name
      }
    }
  }])
}
```

```hcl
# environments/production/main.tf
module "api" {
  source           = "../../modules/web-app"
  app_name         = "api"
  environment      = "production"
  container_image  = "123456789.dkr.ecr.us-east-1.amazonaws.com/api:v1.2.0"
  port             = 8000
}
```

### 2. Zero-Downtime Blue-Green on ECS

```hcl
resource "aws_ecs_service" "app" {
  name            = "my-app"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  deployment_controller { type = "CODE_DEPLOY" }
  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "app"
    container_port   = 3000
  }
  deployment_circuit_breaker { enable = true; rollback = true }
}
```

### 3. Serverless API Gateway + Lambda + DynamoDB

```hcl
resource "aws_lambda_function" "api" {
  function_name = "my-api"
  filename      = "function.zip"
  runtime       = "nodejs20.x"
  handler       = "index.handler"
  role          = aws_iam_role.lambda.arn
  environment { variables = { TABLE_NAME = aws_dynamodb_table.data.name } }
}
resource "aws_apigatewayv2_api" "http" {
  name          = "my-api"
  protocol_type = "HTTP"
  target        = aws_lambda_function.api.arn
}
```

### 4. GCP Cloud Run with Private Cloud SQL

```hcl
resource "google_cloud_run_service" "api" {
  name     = "my-api"
  location = "us-central1"
  template {
    spec {
      container_concurrency = 80
      timeout_seconds       = 300
      containers {
        image = "us-docker.pkg.dev/my-project/api:v1.0.0"
        env { name = "DATABASE_URL"; value = "/cloudsql/my-project:us-central1:my-db" }
        resources { limits = { cpu = "2"; memory = "1Gi" } }
      }
    }
    metadata {
      annotations = {
        "run.googleapis.com/cloudsql-instances"  = "my-project:us-central1:my-db"
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.connector.id
      }
    }
  }
  traffic { percent = 100; latest_revision = true }
}
```

### 5. Azure Bicep with Key Vault Integration

```bicep
resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'kv-myapp-${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: { name: 'standard' family: 'A' }
    enableSoftDelete: true
    enablePurgeProtection: true
  }
}
resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: 'my-app-${environment}'
  location: location
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [{name: 'DATABASE_URL', value: '@Microsoft.KeyVault(VaultName=${kv.name};SecretName=DatabaseUrl)'}]
      minTlsVersion: '1.2'
    }
  }
}
```

### 6. Multi-Region Failover with Route 53

```hcl
resource "aws_route53_health_check" "us_east" {
  fqdn              = "api.us-east.example.com"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  request_interval  = 30
  failure_threshold = 3
}
resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.example.com"
  type    = "CNAME"
  set {
    health_check_id = aws_route53_health_check.us_east.id
    records         = [aws_lb.us_east.dns_name]
  }
  failover_routing_policy { type = "SECONDARY" }
}
```

### 7. Cost Optimization with Spot/Preemptible Instances

```hcl
resource "aws_ecs_capacity_provider" "spot" {
  name = "spot"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.spot.arn
    managed_scaling {
      maximum_scaling_step_size = 5
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 80
    }
  }
}
```

## Common Patterns

### Pattern 1: Static Site on S3 + CloudFront

```hcl
resource "aws_s3_bucket" "site" { bucket = "my-static-site" }
resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id
  index_document { suffix = "index.html" }
  error_document { key = "404.html" }
}
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id   = "s3-origin"
  }
  enabled         = true
  is_ipv6_enabled = true
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "s3-origin"
    forwarded_values { query_string = false cookies { forward = "none" } }
    viewer_protocol_policy = "redirect-to-https"
  }
  restrictions { geo_restriction { restriction_type = "none" } }
  viewer_certificate { cloudfront_default_certificate = true }
}
```

### Pattern 2: Container API on ECS Fargate

```hcl
resource "aws_ecs_cluster" "main" {
  name = "my-cluster"
  setting { name = "containerInsights"; value = "enabled" }
}
resource "aws_ecs_service" "api" {
  name            = "api"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = aws_subnet.private[*].id
    security_groups = [aws_security_group.api.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = "api"
    container_port   = 8000
  }
}
```

### Pattern 3: GCP Cloud Run Direct Deploy

```bash
gcloud run deploy my-api \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --cpu 2 --memory 1Gi \
  --min-instances 1 --max-instances 100 \
  --set-env-vars DATABASE_URL=cloudsql://... \
  --vpc-connector my-connector
```

### Pattern 4: Terraform Remote State with S3 + DynamoDB

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute { name = "LockID"; type = "S" }
}
```

### Pattern 5: AWS CDK for Programmatic Infrastructure

```python
# Python CDK example
from aws_cdk import (
    Stack, CfnOutput, Duration,
    aws_ec2 as ec2, aws_ecs as ecs, aws_ecs_patterns as ecs_patterns
)
from constructs import Construct

class ApiStack(Stack):
    def __init__(self, scope: Construct, id: str, **kwargs):
        super().__init__(scope, id, **kwargs)
        cluster = ecs.Cluster(self, "Cluster", vpc=ec2.Vpc(self, "Vpc", max_azs=2))
        service = ecs_patterns.ApplicationLoadBalancedFargateService(
            self, "Service",
            cluster=cluster, desired_count=2,
            task_image_options=ecs_patterns.ApplicationLoadBalancedTaskImageOptions(
                image=ecs.ContainerImage.from_registry("myapp:latest"),
                container_port=8000,
            ),
            public_load_balancer=True,
        )
        service.target_group.configure_health_check(path="/health")
        CfnOutput(self, "Url", value=service.load_balancer.load_balancer_dns_name)
```

## Edge Cases & Pitfalls

1. **Database in public subnet** — Never put RDS/Cloud SQL in public. Always private subnets with NAT gateway.

2. **Security group too permissive** — `0.0.0.0/0` on port 3306/5432 is an open door. Restrict to specific CIDRs.

3. **IAM role with AdministratorAccess** — Violates least privilege. Scope to specific services and actions.

4. **S3 bucket without encryption** — Explicitly enable SSE and block public access.

5. **Missing CloudWatch log retention** — Default is "never expire". Set 30 or 90 day retention.

6. **RDS without Multi-AZ in production** — No failover. Enable Multi-AZ or use Aurora.

7. **Lambda cold start timeout** — Set `reserved_concurrency` or Provisioned Concurrency for latency-sensitive apps.

8. **CloudFront without OAC** — S3 origins should use Origin Access Control (not deprecated OAI).

9. **Terraform state drift** — Manual console changes cause drift. Always use Terraform. Run `terraform plan` to detect.

10. **Hardcoded region in provider** — Use variables so same code works across environments.

11. **Missing DNS validation for SSL** — ACM DNS validation needs Route 53 records or manual CNAME for other providers.

12. **ECS Fargate pulling from ECR in private subnet** — Needs VPC endpoint for ECR.

13. **Azure App Service always-on disabled** — Without `alwaysOn: true`, app unloads during idle, causing cold starts.

14. **GCP Cloud SQL without HA** — Default has no HA. Enable regional HA for production.

15. **Untagged resources** — Can't track costs. Enforce tagging policies and budget alerts.

16. **API Gateway without throttling** — Set rate limits and usage plans to prevent abuse.

17. **Cross-account IAM role trust policy too broad** — Restrict `Principal` to specific account ARNs, not `*`.

18. **S3 lifecycle rules deleting too aggressively** — Ensure versioning + lifecycle rules match compliance requirements.

## Integration

### Related Skills

- **Dockerization** (`dockerization`) — Cloud deployment deploys Docker images. Container deployments (ECS, Cloud Run, AKS) need properly built images.
- **CI/CD Pipeline** (`ci-cd-pipeline`) — CI/CD triggers cloud deployments. OIDC federation, environments, and approval flows connect CI to cloud.
- **Security Audit** (`security-audit`) — Audit cloud for misconfigurations: IAM policies, security groups, encryption, public exposure.

### Common Integration Points

1. **Dockerization → CI/CD → Cloud** — Dockerfile → CI builds/pushes to ECR/GCR/ACR → CI/CD triggers Terraform or Cloud Run deploy.
2. **Security Audit → Cloud** — Posture audit: open security groups, public S3, missing encryption, overly permissive IAM.
3. **CI/CD → Cloud** — Pipeline handles `terraform apply`, `gcloud run deploy`, or `az webapp deploy`.

## Output Format Templates

### Template A: Full Infrastructure as Code

```markdown
## Cloud Deployment — [Project Name]

**Provider:** AWS / GCP / Azure
**Architecture:** [Brief description]
**Estimated Monthly Cost:** $XX-YY

### Infrastructure Files
```
infra/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
└── modules/
    ├── vpc/
    ├── ecs/
    └── rds/
```

### [File: infra/main.tf]
[complete Terraform/Bicep/CloudFormation]

### Deployment Steps
1. `terraform init`
2. `terraform plan`
3. `terraform apply`

### Architecture Diagram (text)
[ASCII or text diagram]
```

### Template B: Quick CLI Deploy

```markdown
## Quick Deploy — [App Name] to [Service]

**Platform:** [GCP Cloud Run / AWS Lambda / Azure App Service]

### Prerequisites
- [CLI installed]
- [Authenticated]

### Deploy Commands
```bash
[step-by-step commands]
```

### Verify
```bash
[verification commands]
```

### Clean Up
```bash
[teardown commands]
```
```

### Template C: Cloud Migration Plan

```markdown
## Cloud Migration Plan — [Project Name]

### Current State
- **Hosting:** [On-prem / VPS / Other cloud]
- **Stack:** [Technology details]
- **Monthly Cost:** $XX

### Target State
- **Provider:** [AWS / GCP / Azure]
- **Services:** [List services]
- **Estimated Cost:** $YY/month

### Migration Steps
1. [Step with details]
2. [Step with details]

### Risk Assessment
| Risk | Mitigation |
|------|------------|
| [Risk] | [Mitigation] |

### Rollback Plan
[Steps to rollback if migration fails]
```

### Template D: Cost Optimization Report

```markdown
## Cloud Cost Optimization Report

### Current Monthly Spend: $XXX

### Top Cost Drivers
| Service | Monthly Cost | Optimization |
|---------|-------------|-------------|
| [Service] | $XX | [Action] |

### Recommended Changes
1. [Change]: Save ~$XX/month
2. [Change]: Save ~$XX/month

### Estimated Savings: $XX/month (XX% reduction)

### Implementation
[Terraform or CLI changes to apply]
```