---
name: graphql
description: >-
  Design, implement, and optimize production GraphQL APIs with schema design, DataLoader/N+1
  prevention, federation, subscriptions, and security depth-limiting.
  TRIGGERS: graphql, graphql api, schema design, resolver, mutation, query, subscription,
  dataloader, apollo server, graphql federation, type definitions, graphql optimization,
  n+1 problem graphql, graphql caching, graphql schema,
  طراحی GraphQL, API گراف‌کیوال, اسکیمای GraphQL, ری‌الور GraphQL, جستجوی GraphQL, اشتراک GraphQL,
  GraphQL设计, GraphQL API, GraphQL模式, DataLoader, GraphQL分页, GraphQL订阅, GraphQL安全
priority: P2
dependencies: [api-design, system-design]
conflicts: []
---

# GraphQL API Design Skill — Schema, Resolvers, Federation & Security

## Overview

This skill provides comprehensive guidance for designing, implementing, and optimizing production-grade GraphQL APIs. GraphQL offers a flexible, strongly-typed query language that lets clients request exactly the data they need — but this flexibility introduces unique challenges: schema design discipline, N+1 resolver problems, query complexity attacks, caching invalidation, and federation across microservices. This skill covers schema-first design, DataLoader batching, subscriptions for real-time data, Apollo Federation for distributed graphs, security depth/complexity limiting, and production hardening.

## When to Use This Skill

- Designing a new GraphQL API schema from scratch or migrating from REST
- Implementing resolvers with DataLoader to prevent N+1 query problems
- Setting up GraphQL subscriptions for real-time features (chat, notifications, live dashboards)
- Configuring Apollo Server, GraphQL Yoga, or Mercurius in production
- Building a federated graph across multiple microservices (Apollo Federation v2)
- Adding query depth limiting, complexity analysis, or rate limiting to prevent abuse
- Optimizing GraphQL response caching (CDN, response-level, per-field `@cacheControl`)
- Converting a REST API to GraphQL or designing a hybrid architecture
- ت?
- طراحی GraphQL (GraphQL design), اسکیمای GraphQL (GraphQL schema)
- API گراف‌کیوال (GraphQL API), ری‌الور GraphQL (GraphQL resolver)
- جستجوی GraphQL (GraphQL query), اشتراک GraphQL (GraphQL subscription)
- ت?
- GraphQL设计 (GraphQL design), DataLoader分批加载 (DataLoader batching)
- GraphQL模式 (GraphQL schema), GraphQL分页 (GraphQL pagination)
- GraphQL订阅 (GraphQL subscription), GraphQL安全 (GraphQL security)

## When NOT to Use This Skill

- Building a simple CRUD API with fixed data shapes → use **api-design** (REST) instead
- Only designing database schemas with no API layer → use **database-design** instead
- Implementing pure backend business logic with no client-facing API → use **code-generation** or domain logic skills
- Building a file upload/download service with streaming → REST is more natural
- Working on message queues or event streaming → use **queue** skill instead
- Need real-time only (no query flexibility) → consider WebSockets via **websockets** or **real-time** skills
- Performance optimization unrelated to GraphQL → use **performance-optimization** skill

---

## Workflow

### Step 1: Define Schema Design Principles

```
Schema Design Checklist:
├── 1. Use noun-based types (User, Order, Product) — never verb-based
├── 2. Use Input types for all mutation arguments
├── 3. Use Relay-style connections for pagination (edges/nodes/pageInfo)
├── 4. Add descriptions to every type, field, and argument
├── 5. Use enums for fixed-value fields (status, role, type)
├── 6. Use scalar types for dates (DateTime), URLs (URL), emails (Email)
├── 7. Make nullable fields explicit — null means "may be absent"
├── 8. Use union types for polymorphic responses (SearchResult = User | Product | Order)
├── 9. Design mutation payloads with errors array, not throwing exceptions
└── 10. Version with additive changes — never remove fields, deprecate instead
```

**Naming Conventions**:
```
Types:        PascalCase    → User, OrderItem, PaymentStatus
Fields:       camelCase     → firstName, orderCount, createdAt
Enums:        SCREAMING     → PENDING, CONFIRMED, SHIPPED
Mutations:    verb + noun   → createUser, cancelOrder, updateProfile
Queries:      noun-based    → user, orders, me
Arguments:    camelCase     → userId, first, after
```

### Step 2: Design the Complete Schema

```graphql
scalar DateTime
scalar URL
scalar EmailAddress

# ─── Enums ───────────────────────────────────────────────────────
enum OrderStatus {
  PENDING
  CONFIRMED
  PROCESSING
  SHIPPED
  DELIVERED
  CANCELLED
}

enum UserRole {
  CUSTOMER
  ADMIN
  SUPPORT
}

# ─── Core Types ──────────────────────────────────────────────────
type User {
  "Unique user identifier"
  id: ID!
  "User's full name"
  name: String!
  "User's email address (private field)"
  email: String! @deprecated(reason: "Use profileEmail on UserPreferences")
  "User account role"
  role: UserRole!
  "User's profile information"
  profile: UserProfile
  "All orders placed by this user"
  orders(
    first: Int
    after: String
    status: OrderStatus
  ): OrderConnection!
  "User's account preferences"
  preferences: UserPreferences
  createdAt: DateTime!
  updatedAt: DateTime!
}

type UserProfile {
  displayName: String!
  avatarUrl: URL
  bio: String
  timezone: String!
}

type UserPreferences {
  userId: ID!
  emailNotifications: Boolean!
  smsNotifications: Boolean!
  theme: String!
}

type Order {
  id: ID!
  "Human-readable order number"
  orderNumber: String!
  "Customer who placed this order"
  customer: User!
  "Line items in this order"
  items: [OrderItem!]!
  "Total order amount in cents"
  totalAmountCents: Int!
  "Order status"
  status: OrderStatus!
  "Shipping address"
  shippingAddress: Address
  createdAt: DateTime!
  updatedAt: DateTime!
}

type OrderItem {
  id: ID!
  product: Product!
  quantity: Int!
  "Price per unit in cents at time of purchase"
  unitPriceCents: Int!
}

type Product {
  id: ID!
  name: String!
  description: String!
  priceCents: Int!
  inStock: Boolean!
  "Average rating across all reviews"
  averageRating: Float
  "Total number of reviews"
  reviewCount: Int!
  reviews(first: Int, after: String): ReviewConnection!
  category: Category!
  createdAt: DateTime!
}

type Address {
  street1: String!
  street2: String
  city: String!
  state: String!
  postalCode: String!
  country: String!
}

type Review {
  id: ID!
  author: User!
  product: Product!
  rating: Int!
  comment: String
  createdAt: DateTime!
}

# ─── Pagination Types ────────────────────────────────────────────
type OrderConnection {
  edges: [OrderEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type OrderEdge {
  cursor: String!
  node: Order!
}

type ReviewConnection {
  edges: [ReviewEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type ReviewEdge {
  cursor: String!
  node: Review!
}

type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}

# ─── Input Types ─────────────────────────────────────────────────
input CreateUserInput {
  name: String!
  email: EmailAddress!
  password: String!
  role: UserRole = CUSTOMER
}

input UpdateUserProfileInput {
  displayName: String
  bio: String
  avatarUrl: URL
  timezone: String
}

input CreateOrderInput {
  items: [OrderItemInput!]!
  shippingAddress: AddressInput!
}

input OrderItemInput {
  productId: ID!
  quantity: Int!
}

input AddressInput {
  street1: String!
  street2: String
  city: String!
  state: String!
  postalCode: String!
  country: String!
}

input UserFilter {
  role: UserRole
  search: String
  createdAfter: DateTime
}

# ─── Mutation Payloads (Result Types) ────────────────────────────
type CreateUserPayload {
  user: User
  errors: [UserError!]!
}

type UpdateUserPayload {
  user: User
  errors: [UserError!]!
}

type CreateOrderPayload {
  order: Order
  errors: [OrderError!]!
}

type CancelOrderPayload {
  order: Order
  errors: [OrderError!]!
}

type UserError {
  field: String
  message: String!
  code: ErrorCode!
}

type OrderError {
  field: String
  message: String!
  code: ErrorCode!
}

enum ErrorCode {
  VALIDATION_ERROR
  NOT_FOUND
  UNAUTHENTICATED
  FORBIDDEN
  ALREADY_EXISTS
  RATE_LIMITED
  INTERNAL_ERROR
}

# ─── Union Types ─────────────────────────────────────────────────
union SearchResult = User | Product | Order

# ─── Query / Mutation / Subscription ─────────────────────────────
type Query {
  "Fetch the currently authenticated user"
  me: User
  "Fetch a user by ID"
  user(id: ID!): User
  "List users with filtering and pagination"
  users(
    first: Int
    after: String
    filter: UserFilter
  ): UserConnection!
  "Fetch an order by ID"
  order(id: ID!): Order
  "Fetch orders for the current user"
  myOrders(
    first: Int
    after: String
    status: OrderStatus
  ): OrderConnection!
  "Fetch a product by ID"
  product(id: ID!): Product
  "List products with pagination"
  products(
    first: Int
    after: String
    categoryId: ID
    minPrice: Int
    maxPrice: Int
    inStock: Boolean
  ): ProductConnection!
  "Search across all entity types"
  search(query: String!, first: Int, after: String): SearchResultConnection!
}

type Mutation {
  "Register a new user account"
  createUser(input: CreateUserInput!): CreateUserPayload!
  "Update the current user's profile"
  updateMyProfile(input: UpdateUserProfileInput!): UpdateUserPayload!
  "Place a new order"
  createOrder(input: CreateOrderInput!): CreateOrderPayload!
  "Cancel a pending order"
  cancelOrder(orderId: ID!): CancelOrderPayload!
}

type Subscription {
  "Fires when a new order is created (admin only)"
  orderCreated: Order!
  "Fires when an order status changes for a specific user"
  orderStatusChanged(userId: ID!): Order!
}

# Connection wrapper for search
type SearchResultConnection {
  edges: [SearchResultEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type SearchResultEdge {
  cursor: String!
  node: SearchResult!
}

# Pagination types for products
type ProductConnection {
  edges: [ProductEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type ProductEdge {
  cursor: String!
  node: Product!
}

type UserConnection {
  edges: [UserEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type UserEdge {
  cursor: String!
  node: User!
}
```

### Step 3: Implement DataLoader for N+1 Prevention

```typescript
import DataLoader from 'dataloader';
import { DB } from './database';

// ─── DataLoader Factory ──────────────────────────────────────────
export function createLoaders(db: DB) {
  return {
    // Single-entity loader
    user: new DataLoader<string, User | null>(async (ids) => {
      const users = await db.users.findByIds([...ids]);
      const userMap = new Map(users.map((u) => [u.id, u]));
      return ids.map((id) => userMap.get(id) || null);
    }),

    // One-to-many loader (user → orders)
    ordersByUser: new DataLoader<string, Order[]>(async (userIds) => {
      const orders = await db.orders.find({
        where: { userId: { in: [...userIds] } },
      });
      const grouped = userIds.map((uid) =>
        orders.filter((o) => o.userId === uid)
      );
      return grouped;
    }),

    // One-to-many loader (product → reviews)
    reviewsByProduct: new DataLoader<string, Review[]>(async (productIds) => {
      const reviews = await db.reviews.find({
        where: { productId: { in: [...productIds] } },
      });
      return productIds.map((pid) =>
        reviews.filter((r) => r.productId === pid)
      );
    }),

    // Many-to-one loader (order → customer)
    customerByOrder: new DataLoader<string, User | null>(async (orderIds) => {
      const orders = await db.orders.findByIds([...orderIds]);
      const userIds = [...new Set(orders.map((o) => o.userId))];
      const users = await db.users.findByIds(userIds);
      const userMap = new Map(users.map((u) => [u.id, u]));
      return orders.map((o) => userMap.get(o.userId) || null);
    }),

    // Product loader (order item → product)
    product: new DataLoader<string, Product | null>(async (ids) => {
      const products = await db.products.findByIds([...ids]);
      const productMap = new Map(products.map((p) => [p.id, p]));
      return ids.map((id) => productMap.get(id) || null);
    }),

    // Aggregate loader (product → average rating)
    productRating: new DataLoader<string, { avg: number; count: number }>(
      async (productIds) => {
        const stats = await db.reviews.aggregate({
          where: { productId: { in: [...productIds] } },
          groupBy: 'productId',
          select: {
            productId: true,
            avgRating: 'AVG(rating)',
            reviewCount: 'COUNT(*)',
          },
        });
        const statMap = new Map(
          stats.map((s) => [
            s.productId,
            { avg: s.avgRating, count: s.reviewCount },
          ])
        );
        return productIds.map(
          (id) => statMap.get(id) || { avg: 0, count: 0 }
        );
      }
    ),
  };
}

// ─── Context Factory ─────────────────────────────────────────────
import { verifyToken } from './auth';

export function createContext({ req, db }: { req: Request; db: DB }) {
  const token = req.headers.authorization?.replace('Bearer ', '');
  const user = token ? verifyToken(token) : null;

  return {
    user,
    db,
    loaders: createLoaders(db),
  };
}
```

### Step 4: Implement Resolvers

```typescript
import { GraphQLError } from 'graphql';
import { IResolvers } from '@graphql-tools/schema';
import { Context } from './context';

export const resolvers: IResolvers<{}, Context> = {
  Query: {
    me: (_, __, ctx) => {
      if (!ctx.user) {
        throw new GraphQLError('Not authenticated', {
          extensions: { code: 'UNAUTHENTICATED' },
        });
      }
      return ctx.loaders.user.load(ctx.user.id);
    },

    user: (_, { id }, ctx) => ctx.loaders.user.load(id),

    users: async (_, { first = 20, after, filter }, ctx) => {
      const cursor = after ? decodeCursor(after) : null;
      const users = await ctx.db.users.find({
        where: {
          ...(filter?.role && { role: filter.role }),
          ...(filter?.search && {
            name: { contains: filter.search, mode: 'insensitive' },
          }),
          ...(cursor && { createdAt: { lt: cursor } }),
        },
        orderBy: { createdAt: 'desc' },
        take: first + 1,
      });

      const hasNextPage = users.length > first;
      const nodes = hasNextPage ? users.slice(0, first) : users;

      return {
        edges: nodes.map((u) => ({
          cursor: encodeCursor(u.createdAt),
          node: u,
        })),
        pageInfo: {
          hasNextPage,
          hasPreviousPage: !!after,
          endCursor: nodes.length > 0 ? encodeCursor(nodes[nodes.length - 1].createdAt) : null,
          startCursor: nodes.length > 0 ? encodeCursor(nodes[0].createdAt) : null,
        },
        totalCount: await ctx.db.users.count({
          where: filter?.role ? { role: filter.role } : {},
        }),
      };
    },

    order: (_, { id }, ctx) => ctx.db.orders.findById(id),

    myOrders: async (_, { first = 20, after, status }, ctx) => {
      if (!ctx.user) {
        throw new GraphQLError('Not authenticated', {
          extensions: { code: 'UNAUTHENTICATED' },
        });
      }
      // Implementation similar to users query with status filter
      return ctx.loaders.ordersByUser.load(ctx.user.id);
    },

    product: (_, { id }, ctx) => ctx.loaders.product.load(id),

    products: async (_, { first = 20, after, categoryId, minPrice, maxPrice, inStock }, ctx) => {
      const products = await ctx.db.products.find({
        where: {
          ...(categoryId && { categoryId }),
          ...(minPrice != null && { priceCents: { gte: minPrice } }),
          ...(maxPrice != null && { priceCents: { lte: maxPrice } }),
          ...(inStock != null && { inStock }),
        },
        orderBy: { createdAt: 'desc' },
        take: first + 1,
      });
      const hasNextPage = products.length > first;
      const nodes = hasNextPage ? products.slice(0, first) : products;
      return {
        edges: nodes.map((p) => ({ cursor: encodeCursor(p.createdAt), node: p })),
        pageInfo: { hasNextPage, hasPreviousPage: !!after, endCursor: null, startCursor: null },
        totalCount: await ctx.db.products.count(),
      };
    },

    search: async (_, { query, first = 20 }, ctx) => {
      // Delegate to each type's search method, merge results
      const [users, products, orders] = await Promise.all([
        ctx.db.users.find({ where: { name: { contains: query } }, take: first }),
        ctx.db.products.find({ where: { name: { contains: query } }, take: first }),
        ctx.db.orders.find({ where: { orderNumber: { contains: query } }, take: first }),
      ]);
      const nodes = [...users, ...products, ...orders];
      return {
        edges: nodes.map((n, i) => ({ cursor: String(i), node: n })),
        pageInfo: { hasNextPage: false, hasPreviousPage: false, startCursor: null, endCursor: null },
        totalCount: nodes.length,
      };
    },
  },

  Mutation: {
    createUser: async (_, { input }, ctx) => {
      const errors: any[] = [];

      if (!input.email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
        errors.push({ field: 'email', message: 'Invalid email format', code: 'VALIDATION_ERROR' });
      }
      if (input.password.length < 8) {
        errors.push({ field: 'password', message: 'Password must be at least 8 characters', code: 'VALIDATION_ERROR' });
      }
      if (errors.length > 0) return { user: null, errors };

      const existing = await ctx.db.users.findOne({ where: { email: input.email } });
      if (existing) {
        return {
          user: null,
          errors: [{ field: 'email', message: 'Email already registered', code: 'ALREADY_EXISTS' }],
        };
      }

      const hashedPassword = await bcrypt.hash(input.password, 12);
      const user = await ctx.db.users.create({
        ...input,
        password: hashedPassword,
      });

      return { user, errors: [] };
    },

    updateMyProfile: async (_, { input }, ctx) => {
      if (!ctx.user) {
        throw new GraphQLError('Not authenticated', {
          extensions: { code: 'UNAUTHENTICATED' },
        });
      }

      const user = await ctx.db.users.update(ctx.user.id, input);
      // Invalidate cache
      ctx.loaders.user.clear(ctx.user.id);
      return { user, errors: [] };
    },

    createOrder: async (_, { input }, ctx) => {
      if (!ctx.user) {
        throw new GraphQLError('Not authenticated', {
          extensions: { code: 'UNAUTHENTICATED' },
        });
      }

      const errors: any[] = [];
      for (const item of input.items) {
        const product = await ctx.loaders.product.load(item.productId);
        if (!product) {
          errors.push({ field: 'items', message: `Product ${item.productId} not found`, code: 'NOT_FOUND' });
        } else if (!product.inStock) {
          errors.push({ field: 'items', message: `Product ${product.name} is out of stock`, code: 'VALIDATION_ERROR' });
        }
      }
      if (errors.length > 0) return { order: null, errors };

      const totalAmountCents = await calculateTotal(input.items);
      const order = await ctx.db.orders.create({
        userId: ctx.user.id,
        items: input.items,
        totalAmountCents,
        shippingAddress: input.shippingAddress,
        status: 'PENDING',
      });

      return { order, errors: [] };
    },

    cancelOrder: async (_, { orderId }, ctx) => {
      if (!ctx.user) {
        throw new GraphQLError('Not authenticated', {
          extensions: { code: 'UNAUTHENTICATED' },
        });
      }

      const order = await ctx.db.orders.findById(orderId);
      if (!order) {
        return { order: null, errors: [{ field: 'orderId', message: 'Order not found', code: 'NOT_FOUND' }] };
      }
      if (order.userId !== ctx.user.id) {
        return { order: null, errors: [{ field: 'orderId', message: 'Not authorized', code: 'FORBIDDEN' }] };
      }
      if (order.status !== 'PENDING') {
        return { order: null, errors: [{ field: 'status', message: 'Only pending orders can be cancelled', code: 'VALIDATION_ERROR' }] };
      }

      const updated = await ctx.db.orders.update(orderId, { status: 'CANCELLED' });
      return { order: updated, errors: [] };
    },
  },

  // ─── Field Resolvers (DataLoader-powered) ──────────────────────
  User: {
    profile: (user, _, ctx) => ctx.db.profiles.findByUserId(user.id),
    orders: (user, { first, after }, ctx) => ctx.loaders.ordersByUser.load(user.id),
    preferences: (user, _, ctx) => ctx.db.preferences.findByUserId(user.id),
  },

  Order: {
    customer: (order, _, ctx) => ctx.loaders.user.load(order.userId),
    items: (order, _, ctx) => ctx.db.orderItems.findByOrderId(order.id),
    shippingAddress: (order) => order.shippingAddress,
  },

  OrderItem: {
    product: (item, _, ctx) => ctx.loaders.product.load(item.productId),
  },

  Product: {
    reviews: (product, { first, after }, ctx) =>
      ctx.loaders.reviewsByProduct.load(product.id),
    averageRating: (product, _, ctx) =>
      ctx.loaders.productRating.load(product.id).then((r) => r.avg),
    reviewCount: (product, _, ctx) =>
      ctx.loaders.productRating.load(product.id).then((r) => r.count),
    category: (product, _, ctx) => ctx.loaders.category.load(product.categoryId),
  },

  Review: {
    author: (review, _, ctx) => ctx.loaders.user.load(review.authorId),
    product: (review, _, ctx) => ctx.loaders.product.load(review.productId),
  },

  SearchResult: {
    __resolveType(obj) {
      if (obj.email) return 'User';
      if (obj.priceCents !== undefined) return 'Product';
      if (obj.orderNumber) return 'Order';
      return null;
    },
  },
};

// ─── Helpers ─────────────────────────────────────────────────────
function encodeCursor(date: Date): string {
  return Buffer.from(date.toISOString()).toString('base64url');
}

function decodeCursor(cursor: string): Date {
  return new Date(Buffer.from(cursor, 'base64url').toString());
}

async function calculateTotal(items: { productId: string; quantity: number }[]): Promise<number> {
  // Implementation: sum of (product.priceCents * quantity) for each item
  return 0; // placeholder
}
```

### Step 5: Configure Security (Depth Limiting & Complexity)

```typescript
import depthLimit from 'graphql-depth-limit';
import { createComplexityRule, simpleEstimator, fieldExtensionsEstimator } from 'graphql-query-complexity';
import { ApolloServer } from '@apollo/server';
import { ApolloServerPluginDrainHttpServer } from '@apollo/server/plugin/drainHttpServer';

// ─── Schema-level complexity extensions ──────────────────────────
const typeDefs = `
  extend type Query {
    "Heavy query: complexity 10"
    products(first: Int): [Product!]! @complexity(value: 10)
  }
  extend type User {
    "Nested relation: complexity 5"
    orders(first: Int): [Order!]! @complexity(value: 5)
  }
`;

// ─── Server with security plugins ────────────────────────────────
const server = new ApolloServer({
  typeDefs,
  resolvers,
  introspection: process.env.NODE_ENV !== 'production',
  plugins: [
    ApolloServerPluginDrainHttpServer({ httpServer }),

    // Request-level logging
    {
      async requestDidStart() {
        return {
          async didResolveOperation(requestContext) {
            const { request, document } = requestContext;
            const operationName = request.operationName || 'anonymous';
            console.log(`GraphQL Operation: ${operationName}`);
          },
          async didEncounterErrors(requestContext) {
            for (const error of requestContext.errors) {
              console.error('GraphQL Error:', {
                message: error.message,
                path: error.path,
                extensions: error.extensions,
              });
            }
          },
        };
      },
    },
  ],
  validationRules: [
    // Prevent deeply nested queries (max depth: 7)
    depthLimit(7),

    // Prevent expensive queries (max complexity: 1000)
    createComplexityRule({
      maximumComplexity: 1000,
      estimators: [
        fieldExtensionsEstimator(),
        simpleEstimator({ defaultComplexity: 1 }),
      ],
      onComplete: (complexity) => {
        if (complexity > 500) {
          console.warn(`High complexity query: ${complexity}`);
        }
      },
    }),
  ],
});
```

### Step 6: Configure Subscriptions (WebSocket)

```typescript
import { makeExecutableSchema } from '@graphql-tools/schema';
import { WebSocketServer } from 'ws';
import { useServer } from 'graphql-ws/lib/use/ws';
import { PubSub } from 'graphql-subscriptions';

const pubsub = new PubSub();
const ORDER_CREATED = 'ORDER_CREATED';
const ORDER_STATUS_CHANGED = 'ORDER_STATUS_CHANGED';

// ─── Subscription Resolvers ──────────────────────────────────────
const subscriptionResolvers = {
  Subscription: {
    orderCreated: {
      subscribe: (_, __, ctx) => {
        if (!ctx.user || ctx.user.role !== 'ADMIN') {
          throw new GraphQLError('Not authorized', {
            extensions: { code: 'FORBIDDEN' },
          });
        }
        return pubsub.asyncIterableIterator([ORDER_CREATED]);
      },
    },

    orderStatusChanged: {
      subscribe: (_, { userId }, ctx) => {
        if (!ctx.user) {
          throw new GraphQLError('Not authenticated', {
            extensions: { code: 'UNAUTHENTICATED' },
          });
        }
        // Users can only subscribe to their own order changes
        if (ctx.user.id !== userId && ctx.user.role !== 'ADMIN') {
          throw new GraphQLError('Not authorized', {
            extensions: { code: 'FORBIDDEN' },
          });
        }
        return pubsub.asyncIterableIterator([`${ORDER_STATUS_CHANGED}:${userId}`]);
      },
    },
  },
};

// ─── Publish from mutations ──────────────────────────────────────
// In createOrder mutation, after successful creation:
pubsub.publish(ORDER_CREATED, { orderCreated: order });

// In updateOrderStatus mutation:
pubsub.publish(`${ORDER_STATUS_CHANGED}:${order.userId}`, {
  orderStatusChanged: order,
});

// ─── WebSocket Server Setup ──────────────────────────────────────
const schema = makeExecutableSchema({ typeDefs, resolvers: { ...resolvers, ...subscriptionResolvers } });

const wsServer = new WebSocketServer({
  server: httpServer,
  path: '/graphql',
});

const serverCleanup = useServer(
  {
    schema,
    context: async (ctx) => {
      const token = ctx.connectionParams?.authorization;
      const user = token ? verifyToken(token) : null;
      return { user, db, loaders: createLoaders(db) };
    },
  },
  wsServer
);

// Graceful shutdown
process.on('SIGTERM', () => {
  serverCleanup.dispose();
  wsServer.close();
});
```

### Step 7: Implement Response Caching

```typescript
import { responseCachePlugin } from '@apollo/server-plugin-response-cache';
import Redis from 'ioredis';

const redis = new Redis(process.env.REDIS_URL);

const server = new ApolloServer({
  typeDefs,
  resolvers,
  plugins: [
    responseCachePlugin({
      // Cache per-session (private) or globally (public)
      sessionId: (requestContext) => {
        return requestContext.request.http?.headers.get('authorization') || null;
      },
      // Cache key generation
      cacheKeyFn: (requestContext) => {
        const body = requestContext.request.body;
        return `${body.operationName}:${JSON.stringify(body.variables)}`;
      },
    }),
  ],
});

// Schema-level cache control directives
// type Product @cacheControl(maxAge: 300, scope: PUBLIC) { ... }
// type User @cacheControl(maxAge: 0, scope: PRIVATE) { ... }
```

---

## Advanced Techniques

### 1. Persisted Queries (APQ - Automatic Persisted Queries)

Reduce network payload by sending query hashes instead of full query strings.

```typescript
import { ApolloServerPluginCacheControl } from '@apollo/server/plugin/cacheControl';

// Client sends: { extensions: { persistedQuery: { sha256Hash: "abc..." } } }
// Server looks up the query from Redis/DB by hash
// Reduces request size from KB to bytes for repeated queries

// Configuration
const server = new ApolloServer({
  plugins: [
    ApolloServerPluginCacheControl({ defaultMaxAge: 5 }),
  ],
  allowBatchedHttpRequests: true,
});
```

### 2. Query Batching

Combine multiple GraphQL operations into a single HTTP request.

```typescript
// Client sends array of operations:
// [
//   { query: "query { user(id: 1) { name } }", variables: {} },
//   { query: "query { products(first: 5) { name } }", variables: {} }
// ]

// Server processes all in one request, returns array of results
const server = new ApolloServer({
  allowBatchedHttpRequests: true,
});
```

### 3. Directive-Based Authorization

```graphql
# Schema directives
directive @auth(requires: Role = CUSTOMER) on FIELD_DEFINITION

enum Role {
  CUSTOMER
  ADMIN
  SUPPORT
}

type Query {
  me: User! @auth(requires: CUSTOMER)
  users: [User!]! @auth(requires: ADMIN)
}
```

```typescript
import { mapSchema, getDirective, MapperKind } from '@graphql-tools/utils';

function authDirectiveTransformer(schema) {
  return mapSchema(schema, {
    [MapperKind.OBJECT_FIELD]: (fieldConfig) => {
      const authDirective = getDirective(schema, fieldConfig, 'auth')?.[0];
      if (authDirective) {
        const requires = authDirective.requires || 'CUSTOMER';
        const originalResolve = fieldConfig.resolve;
        fieldConfig.resolve = async (parent, args, context, info) => {
          if (!context.user) {
            throw new GraphQLError('Not authenticated', {
              extensions: { code: 'UNAUTHENTICATED' },
            });
          }
          if (roleHierarchy.indexOf(context.user.role) < roleHierarchy.indexOf(requires)) {
            throw new GraphQLError('Not authorized', {
              extensions: { code: 'FORBIDDEN' },
            });
          }
          return originalResolve(parent, args, context, info);
        };
      }
      return fieldConfig;
    },
  });
}
```

### 4. Federation (Apollo Federation v2)

```typescript
// ─── Users Subgraph ──────────────────────────────────────────────
// users-subgraph/schema.graphql
const usersTypeDefs = `
  type User @key(fields: "id") {
    id: ID!
    name: String!
    email: String!
    role: UserRole!
  }

  enum UserRole {
    CUSTOMER
    ADMIN
  }

  extend type Query {
    user(id: ID!): User
    me: User
  }
`;

// Users Subgraph resolver
const usersResolvers = {
  User: {
    __resolveReference(ref, { loaders }) {
      return loaders.user.load(ref.id);
    },
  },
};

// ─── Orders Subgraph ─────────────────────────────────────────────
// orders-subgraph/schema.graphql
const ordersTypeDefs = `
  type Order @key(fields: "id") {
    id: ID!
    customer: User!
    items: [OrderItem!]!
    totalAmountCents: Int!
    status: OrderStatus!
    createdAt: DateTime!
  }

  type OrderItem {
    product: Product!
    quantity: Int!
    unitPriceCents: Int!
  }

  enum OrderStatus {
    PENDING
    CONFIRMED
    SHIPPED
    DELIVERED
    CANCELLED
  }

  # Reference to external type
  type User @key(fields: "id") {
    id: ID!
  }

  type Product @key(fields: "id") {
    id: ID!
  }

  extend type Query {
    order(id: ID!): Order
    myOrders(first: Int, after: String): OrderConnection!
  }

  extend type User {
    orders(first: Int, after: String): OrderConnection!
  }
`;

// Orders Subgraph resolver
const ordersResolvers = {
  Order: {
    __resolveReference(ref, { loaders }) {
      return loaders.order.load(ref.id);
    },
    customer: (order, _, ctx) => ctx.loaders.user.load(order.userId),
    items: (order, _, ctx) => ctx.loaders.orderItems.load(order.id),
  },

  User: {
    orders: (user, args, ctx) => ctx.loaders.ordersByUser.load(user.id),
  },
};

// ─── Gateway Configuration ───────────────────────────────────────
import { ApolloGateway, IntrospectAndCompose } from '@apollo/gateway';

const gateway = new ApolloGateway({
  supergraphSdl: new IntrospectAndCompose({
    subgraphs: [
      { name: 'users', url: 'http://localhost:4001/graphql' },
      { name: 'orders', url: 'http://localhost:4002/graphql' },
      { name: 'products', url: 'http://localhost:4003/graphql' },
    ],
  }),
  buildService({ url }) {
    return new RemoteGraphQLDataSource({
      url,
      willSendRequest({ request, context }) {
        request.http.headers.set('authorization', context.authToken || '');
      },
    });
  },
});
```

### 5. Custom Scalars with Validation

```typescript
import { GraphQLScalarType, Kind } from 'graphql';

const DateTimeScalar = new GraphQLScalarType({
  name: 'DateTime',
  description: 'ISO 8601 date-time string',
  serialize(value) {
    if (value instanceof Date) return value.toISOString();
    throw new Error('DateTime serializer: expected Date object');
  },
  parseValue(value) {
    const date = new Date(value);
    if (isNaN(date.getTime())) throw new Error('Invalid DateTime');
    return date;
  },
  parseLiteral(ast) {
    if (ast.kind === Kind.STRING) {
      const date = new Date(ast.value);
      if (isNaN(date.getTime())) throw new Error('Invalid DateTime');
      return date;
    }
    throw new Error('DateTime must be a string');
  },
});

const EmailAddressScalar = new GraphQLScalarType({
  name: 'EmailAddress',
  description: 'RFC 5322 email address',
  serialize: (value) => value,
  parseValue: (value) => {
    if (typeof value !== 'string' || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
      throw new Error('Invalid email address');
    }
    return value.toLowerCase();
  },
});
```

### 6. Tracing and Observability

```typescript
import { ApolloServerPluginUsageReporting } from '@apollo/server/plugin/usageReporting';

const server = new ApolloServer({
  plugins: [
    ApolloServerPluginUsageReporting({
      sendVariableValues: { none: true }, // Don't send PII
      sendReportsImmediately: true,
      generateClientInfo: ({ request }) => ({
        clientName: request.http?.headers.get('x-client-name') || 'unknown',
        clientVersion: request.http?.headers.get('x-client-version') || '0.0.0',
      }),
    }),
  ],
});
```

### 7. File Uploads with GraphQL

```typescript
import { GraphQLUpload, graphqlUploadKoa } from 'graphql-upload';

const typeDefs = `
  scalar Upload

  type Mutation {
    uploadAvatar(file: Upload!): AvatarPayload!
  }
`;

const resolvers = {
  Upload: GraphQLUpload,

  Mutation: {
    uploadAvatar: async (_, { file }, ctx) => {
      const { createReadStream, filename, mimetype } = await file;
      const stream = createReadStream();

      // Upload to S3 or filesystem
      const key = `avatars/${ctx.user.id}/${filename}`;
      await s3Upload(key, stream, mimetype);

      // Update user profile
      await ctx.db.users.update(ctx.user.id, { avatarUrl: key });

      return { url: `https://cdn.example.com/${key}` };
    },
  },
};
```

### 8. Rate Limiting Per-User and Per-Query

```typescript
import { RateLimiterRedis } from 'rate-limiter-flexible';
import Redis from 'ioredis';

const redis = new Redis();
const limiter = new RateLimiterRedis({
  storeClient: redis,
  keyPrefix: 'graphql_rl',
  points: 100,        // 100 requests
  duration: 60,       // per 60 seconds
  blockDuration: 0,
});

const queryComplexityLimiter = new RateLimiterRedis({
  storeClient: redis,
  keyPrefix: 'graphql_complexity_rl',
  points: 5000,       // 5000 complexity points
  duration: 60,
});

// In context factory:
async function createContext({ req, db }) {
  const userId = req.headers.authorization
    ? verifyToken(req.headers.authorization)?.id
    : req.ip;

  try {
    await limiter.consume(userId);
  } catch {
    throw new GraphQLError('Rate limit exceeded', {
      extensions: { code: 'RATE_LIMITED', retryAfter: 60 },
    });
  }

  return { user: /* ... */, db, loaders: createLoaders(db) };
}
```

---

## Common Patterns

### Pattern 1: Mutation Error Handling (Result Type Pattern)

```typescript
// Instead of throwing exceptions, return structured error payloads
type CreateUserPayload {
  user: User
  errors: [UserError!]!
}

type UserError {
  field: String
  message: String!
  code: ErrorCode!
}

// Resolver implementation
async createUser(_, { input }, ctx) {
  const errors = validateCreateUser(input);
  if (errors.length > 0) return { user: null, errors };

  const existing = await ctx.db.users.findOne({ email: input.email });
  if (existing) {
    return { user: null, errors: [
      { field: 'email', message: 'Already registered', code: 'ALREADY_EXISTS' }
    ]};
  }

  const user = await ctx.db.users.create(input);
  return { user, errors: [] };
}
```

### Pattern 2: Cursor-Based Pagination Helper

```typescript
function encodeCursor(value: string | number): string {
  return Buffer.from(String(value)).toString('base64url');
}

function decodeCursor(cursor: string): string {
  return Buffer.from(cursor, 'base64url').toString();
}

async function paginateQuery(db, table, { first = 20, after, where = {} }) {
  const cursorField = 'createdAt';
  const cursor = after ? decodeCursor(after) : null;

  const query = {
    where: {
      ...where,
      ...(cursor && { [cursorField]: { lt: cursor } }),
    },
    orderBy: { [cursorField]: 'desc' },
    take: first + 1,
  };

  const rows = await db[table].find(query);
  const hasNextPage = rows.length > first;
  const nodes = hasNextPage ? rows.slice(0, first) : rows;
  const lastNode = nodes[nodes.length - 1];

  return {
    edges: nodes.map((node) => ({
      cursor: encodeCursor(node[cursorField]),
      node,
    })),
    pageInfo: {
      hasNextPage,
      hasPreviousPage: !!after,
      endCursor: lastNode ? encodeCursor(lastNode[cursorField]) : null,
      startCursor: nodes[0] ? encodeCursor(nodes[0][cursorField]) : null,
    },
    totalCount: await db[table].count({ where }),
  };
}
```

### Pattern 3: DataLoader Cache Invalidation on Mutation

```typescript
// After a mutation, clear relevant DataLoader caches
async updateOrderStatus(_, { orderId, status }, ctx) {
  const order = await ctx.db.orders.update(orderId, { status });

  // Clear all loaders that might have cached this order
  ctx.loaders.order.clear(orderId);
  ctx.loaders.ordersByUser.clear(order.userId);

  // Publish subscription event
  pubsub.publish(`ORDER_STATUS_CHANGED:${order.userId}`, {
    orderStatusChanged: order,
  });

  return order;
}
```

### Pattern 4: Schema Stitching for Gradual Migration

```typescript
import { stitchSchemas } from '@graphql-tools/stitch';

// Merge REST-derived schema with existing GraphQL
const gatewaySchema = stitchSchemas({
  subschemas: [
    {
      schema: existingGraphQLSchema,
      executor: graphQLExecutor,
    },
    {
      schema: restSchema,
      executor: restExecutor,
      merge: {
        User: {
          fieldName: 'user',
          selectionSet: '{ id }',
          args: (originalObject) => ({ id: originalObject.id }),
        },
      },
    },
  ],
});
```

### Pattern 5: Testing GraphQL Resolvers

```typescript
import { createTestClient } from 'apollo-server-testing';
import { ApolloServer } from '@apollo/server';

describe('User Resolvers', () => {
  let server;
  let mockDb;
  let mockLoaders;

  beforeEach(() => {
    mockDb = createMockDb();
    mockLoaders = createMockLoaders();

    server = new ApolloServer({
      typeDefs,
      resolvers,
      context: () => ({
        user: { id: '1', role: 'ADMIN' },
        db: mockDb,
        loaders: mockLoaders,
      }),
    });
  });

  it('returns current user with profile', async () => {
    const { query } = createTestClient(server);
    const res = await query({
      query: `
        query GetMe {
          me {
            id
            name
            email
            profile {
              displayName
              avatarUrl
            }
          }
        }
      `,
    });

    expect(res.errors).toBeUndefined();
    expect(res.data.me).toBeDefined();
    expect(res.data.me.profile).toBeDefined();
  });

  it('rejects unauthenticated requests', async () => {
    const unauthServer = new ApolloServer({
      typeDefs,
      resolvers,
      context: () => ({ user: null, db: mockDb, loaders: mockLoaders }),
    });

    const { query } = createTestClient(unauthServer);
    const res = await query({
      query: `query { me { id name } }`,
    });

    expect(res.errors[0].extensions.code).toBe('UNAUTHENTICATED');
  });

  it('returns validation errors for invalid input', async () => {
    const { mutate } = createTestClient(server);
    const res = await mutate({
      mutation: `
        mutation CreateUser($input: CreateUserInput!) {
          createUser(input: $input) {
            user { id }
            errors { field message code }
          }
        }
      `,
      variables: {
        input: { name: '', email: 'invalid', password: '123' },
      },
    });

    expect(res.data.createUser.errors.length).toBeGreaterThan(0);
    expect(res.data.createUser.user).toBeNull();
  });

  it('batch-loads related entities (N+1 prevention)', async () => {
    const { query } = createTestClient(server);
    const res = await query({
      query: `
        query {
          products(first: 10) {
            edges {
              node {
                id
                name
                category { id name }
                reviews(first: 3) {
                  edges { node { author { id name } rating } }
                }
              }
            }
          }
        }
      `,
    });

    // DataLoader should batch: 1 query for products, 1 for categories, 1 for reviews, 1 for authors
    expect(mockDb.queryCount).toBeLessThanOrEqual(4);
    expect(res.errors).toBeUndefined();
  });
});
```

---

## Edge Cases & Pitfalls

### 1. N+1 Query Problem (Most Common GraphQL Bug)
Nested resolvers execute one query per parent. Without DataLoader, fetching 100 users with their orders triggers 101 database queries. Always use DataLoader for entity resolution.

### 2. Circular Fragment Spreads
```graphql
# ❌ BAD: Infinite loop
fragment UserFields on User {
  posts { author { ...UserFields } }
}

# ✅ GOOD: Use depth limiting + avoid circular refs
fragment UserFields on User {
  id name email
}
```

### 3. Batched Mutation Side Effects
When batching mutations, ensure each mutation's side effects don't interfere. Use idempotency keys or transaction isolation.

### 4. Subscription Memory Leaks
PubSub in-memory stores grow forever. Use Redis PubSub or a managed service for production:
```typescript
import { RedisPubSub } from 'graphql-redis-subscriptions';
const pubsub = new RedisPubSub({ connection: { host: 'redis-host' } });
```

### 5. Schema Pollution (Leaking Implementation Details)
Don't expose database IDs, internal timestamps, or service-specific fields. Use field-level `@auth` directives to restrict sensitive data.

### 6. Missing `totalCount` Performance
`totalCount` on connections requires a `COUNT(*)` query which can be slow on large tables. Consider caching or approximate counts.

### 7. Query Depth Attacks
An attacker can craft deeply nested queries to overwhelm your server. Always set `depthLimit(7-10)` and complexity limits.

### 8. Over-Fetching in GraphQL
GraphQL doesn't automatically prevent over-fetching. Clients can still request all fields. Combine with persisted queries and complexity budgets.

### 9. Stale Cache After Mutation
Cache-aside pattern requires manual invalidation after every mutation. Forgetting to invalidate leads to stale data.

### 10. Federation Entity Resolution Failures
When a subgraph is down, entity resolution across the federated graph fails. Implement circuit breakers per subgraph.

### 11. Inconsistent Null Handling
A resolver returning `null` for a required field (`!`) causes the entire parent to null out. Be intentional about nullable vs. non-nullable fields.

### 12. File Upload Limitations
GraphQL isn't designed for binary data. Use multipart uploads (graphql-upload) or presigned URLs for files.

### 13. Subscription Authorization Bypass
Always authorize subscriptions during connection setup, not just at query time. A client can subscribe once and receive events indefinitely.

### 14. Complex Input Validation
Input validation in resolvers is verbose. Use a validation library (zod, yup) and wrap validation errors in the result type pattern.

### 15. Schema-First vs. Code-First Conflicts
When using schema-first design, ensure resolvers stay in sync with the schema. Use `graphql-codegen` to generate TypeScript types from the schema.

---

## Integration with Other Skills

| Related Skill | Relationship | When to Integrate |
|---|---|---|
| **api-design** | ← Depends on | GraphQL is an API design choice; this skill extends api-design for GraphQL-specific patterns |
| **system-design** | ← Depends on | Schema design informs system boundaries in microservices |
| **database-design** | → Feeds into | GraphQL types map to database entities; N+1 prevention depends on DB schema |
| **caching** | → Feeds into | Response caching, DataLoader caching, CDN cache control |
| **microservices** | → Feeds into | Federation is the GraphQL answer to microservice API composition |
| **queue** | → Feeds into | Subscriptions can be powered by message queues for distributed PubSub |
| **performance-optimization** | → Feeds into | Query complexity analysis, DataLoader performance, connection pooling |
| **testing** | → Feeds into | Resolver testing, integration testing, contract testing |

---

## Output Format Templates

### Template 1: GraphQL API Design Document

```
## GraphQL API Design — [Service Name]

### Schema Overview
- Types: [count]
- Queries: [list with descriptions]
- Mutations: [list with descriptions]
- Subscriptions: [list with descriptions]
- Custom Scalars: [list]

### Core Types
[Schema for main types with descriptions]

### Connection Types (Pagination)
[Relay connection types]

### Mutation Payloads
[Result type pattern for each mutation]

### Resolver Strategy
- DataLoader entities: [list]
- Cache strategy: [response caching / field caching]
- Auth pattern: [directive / middleware]

### Security
- Query depth limit: [number]
- Complexity budget: [number]
- Rate limiting: [per-user / per-IP]
- Introspection: [enabled in prod?]

### Federation Plan
[Subgraph boundaries and entity resolution]
```

### Template 2: DataLoader Configuration

```
## DataLoader Setup — [Entity]

| Loader Name | Entity | Relationship | Batch Query |
|---|---|---|---|
| user | User | one-to-one | SELECT * FROM users WHERE id IN (?) |
| ordersByUser | Order | one-to-many | SELECT * FROM orders WHERE user_id IN (?) |
| product | Product | one-to-one | SELECT * FROM products WHERE id IN (?) |

Cache invalidation points: [list mutations that clear each loader]
```

### Template 3: Security Audit Checklist

```
## GraphQL Security Audit

- [ ] Query depth limited to ≤ 10
- [ ] Query complexity limited to ≤ 1000
- [ ] Introspection disabled in production
- [ ] Rate limiting per user/IP configured
- [ ] Subscription authorization enforced
- [ ] Input validation on all mutations
- [ ] Sensitive fields require @auth directive
- [ ] PII not exposed in error messages
- [ ] Persisted queries enabled (APQ)
- [ ] No batched mutation side-effect conflicts
```

### Template 4: Federation Migration Plan

```
## Federation Migration — [Phase]

### Current State
- Monolithic GraphQL schema: [types, queries, mutations]
- Database: [shared / per-service]

### Target State
- Subgraphs: [list with owners]
- Entity references: [cross-subgraph types]
- Gateway: [Apollo Gateway / Mesh]

### Migration Steps
1. [Extract subgraph] — move types and resolvers
2. [Deploy subgraph] — standalone deployment
3. [Update gateway] — add subgraph to supergraph
4. [Validate] — run integration tests
5. [Cut over] — point clients to gateway
```

---

## Rules

1. **Schema is the contract** — Design the schema first, implement resolvers second. The schema drives all client and server code.
2. **Use DataLoader for every nested resolver** — No exceptions. Every field that touches the database must go through a DataLoader.
3. **Return result types, not exceptions** — Use `{ data, errors }` pattern for mutations instead of throwing GraphQL errors for expected failures.
4. **Never expose internal IDs or database structure** — Use opaque IDs (UUIDs or hashed) and hide implementation details.
5. **Set query depth limit (≤ 10)** — Prevent depth attacks that traverse circular references.
6. **Set query complexity budget (≤ 1000)** — Prevent expensive queries from starving other users.
7. **Disable introspection in production** — Don't expose your full schema to potential attackers.
8. **Always paginate connections** — Never return unbounded lists. Use Relay-style cursor pagination.
9. **Invalidate DataLoader caches on mutations** — Call `loader.clear(id)` after every write operation.
10. **Use `@cacheControl` directives** — Let Apollo Server set proper `Cache-Control` headers for CDN caching.
11. **Authorize subscriptions during connection setup** — Don't rely on per-message authorization.
12. **Validate all inputs** — Don't trust client data. Use input types with server-side validation.
13. **Document every field** — Add descriptions to all types, fields, and arguments. The schema is documentation.
14. **Prefer additive schema changes** — Never remove fields; deprecate with `@deprecated(reason: "...")` instead.
15. **Test resolvers in isolation** — Unit test each resolver with mock DataLoaders; integration test the full query path.
