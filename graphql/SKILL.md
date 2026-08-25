---
name: graphql
description: >-
  Design, implement, and optimize GraphQL APIs including schema design, resolvers, subscriptions,
  federation, caching, and security. Use this skill when the user mentions GraphQL, GraphQL API,
  schema design, resolver, mutation, query, subscription, DataLoader, GraphQL federation,
  Apollo Server, type definitions, GraphQL optimization, N+1 problem GraphQL,
  or says طراحی GraphQL، API گراف‌کیوال، اسکیمای GraphQL، ری‌الور GraphQL.
---

# GraphQL Skill — Schema Design, Resolvers, Caching & Federation

## Overview

This skill covers GraphQL API design, implementation, and optimization. GraphQL provides a flexible query language for APIs with strong typing, but requires careful schema design, resolver optimization, and caching strategies. This skill covers schema-first design, resolver patterns, DataLoader for N+1 prevention, subscriptions for real-time data, federation for microservices, and security best practices.

## When to Use This Skill

- User wants to design a GraphQL schema
- User needs to implement GraphQL resolvers
- User asks about GraphQL performance optimization
- User mentions N+1 problem, DataLoader, or GraphQL caching
- User wants to set up GraphQL subscriptions
- User asks about Apollo Server, GraphQL Yoga, or other servers
- User mentions طراحی GraphQL or API گراف‌کیوال

---

## Part 1: Schema Design

### Schema-First Design

```graphql
# Schema definition
scalar DateTime

enum UserStatus {
  ACTIVE
  INACTIVE
  SUSPENDED
}

type User {
  id: ID!
  email: String!
  name: String!
  status: UserStatus!
  posts: [Post!]!
  createdAt: DateTime!
  updatedAt: DateTime!
}

type Post {
  id: ID!
  title: String!
  content: String!
  author: User!
  comments: [Comment!]!
  likeCount: Int!
  published: Boolean!
  createdAt: DateTime!
}

type Comment {
  id: ID!
  text: String!
  author: User!
  post: Post!
  createdAt: DateTime!
}

type Query {
  user(id: ID!): User
  users(status: UserStatus, limit: Int, offset: Int): [User!]!
  post(id: ID!): Post
  posts(authorId: ID, published: Boolean): [Post!]!
  me: User!
}

type Mutation {
  createUser(input: CreateUserInput!): User!
  updateUser(id: ID!, input: UpdateUserInput!): User!
  deleteUser(id: ID!): Boolean!
  
  createPost(input: CreatePostInput!): Post!
  updatePost(id: ID!, input: UpdatePostInput!): Post!
  deletePost(id: ID!): Boolean!
  
  addComment(postId: ID!, text: String!): Comment!
  likePost(postId: ID!): Post!
}

type Subscription {
  postCreated: Post!
  commentAdded(postId: ID!): Comment!
}

input CreateUserInput {
  email: String!
  name: String!
  password: String!
}

input UpdateUserInput {
  name: String
  email: String
  status: UserStatus
}

input CreatePostInput {
  title: String!
  content: String!
  published: Boolean = false
}
```

### Schema Design Principles

| Principle | Description | Example |
|-----------|-------------|---------|
| **Use strong types** | ID, Int, Float, String, Boolean, enums | `status: UserStatus!` |
| **Nullability** | `!` for required, nullable for optional | `name: String!` vs `bio: String` |
| **Nested objects** | Use relationships, not flat data | `author: User!` not `authorId: ID!` |
| **Input types** | Separate input from output types | `CreateUserInput` |
| **Relay-style connections** | Cursor-based pagination | `edges`, `nodes`, `pageInfo` |
| **Consistent naming** | camelCase for fields, PascalCase for types | `firstName`, `User` |

### Pagination (Relay Connection)

```graphql
type PostConnection {
  edges: [PostEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type PostEdge {
  cursor: String!
  node: Post!
}

type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}

type Query {
  posts(first: Int, after: String, last: Int, before: String): PostConnection!
}
```

---

## Part 2: Resolvers

### Resolver Structure

```typescript
import { IResolvers } from '@graphql-tools/schema';

const resolvers: IResolvers = {
  Query: {
    user: (_, { id }, context) => context.loaders.user.load(id),
    users: (_, { status, limit, offset }, context) => 
      context.db.users.find({ where: { status }, take: limit, skip: offset }),
    me: (_, __, context) => {
      if (!context.user) throw new AuthenticationError('Not authenticated');
      return context.user;
    },
  },
  
  Mutation: {
    createUser: async (_, { input }, context) => {
      const existing = await context.db.users.findOne({ where: { email: input.email } });
      if (existing) throw new UserInputError('Email already exists');
      
      const hashedPassword = await bcrypt.hash(input.password, 10);
      return context.db.users.create({ ...input, password: hashedPassword });
    },
    
    createPost: async (_, { input }, context) => {
      if (!context.user) throw new AuthenticationError('Not authenticated');
      return context.db.posts.create({ ...input, authorId: context.user.id });
    },
  },
  
  User: {
    posts: (user, _, context) => context.loaders.postsByUser.load(user.id),
  },
  
  Post: {
    author: (post, _, context) => context.loaders.user.load(post.authorId),
    comments: (post, _, context) => context.loaders.commentsByPost.load(post.id),
    likeCount: (post) => context.db.likes.count({ where: { postId: post.id } }),
  },
};
```

### DataLoader (N+1 Prevention)

```typescript
import DataLoader from 'dataloader';

// Create loaders
function createLoaders(db) {
  return {
    user: new DataLoader(async (ids: string[]) => {
      const users = await db.users.findByIds(ids);
      const userMap = new Map(users.map(u => [u.id, u]));
      return ids.map(id => userMap.get(id) || null);
    }),
    
    postsByUser: new DataLoader(async (userIds: string[]) => {
      const posts = await db.posts.find({ where: { authorId: { in: userIds } } });
      const postsByUser = userIds.map(id => posts.filter(p => p.authorId === id));
      return postsByUser;
    }),
    
    commentsByPost: new DataLoader(async (postIds: string[]) => {
      const comments = await db.comments.find({ where: { postId: { in: postIds } } });
      return postIds.map(id => comments.filter(c => c.postId === id));
    }),
  };
}

// Context factory
function createContext({ req, db }) {
  return {
    user: getUserFromToken(req.headers.authorization),
    db,
    loaders: createLoaders(db),
  };
}
```

---

## Part 3: Subscriptions

### WebSocket Subscriptions

```typescript
import { PubSub } from 'graphql-subscriptions';

const pubsub = new PubSub();
const POST_CREATED = 'POST_CREATED';
const COMMENT_ADDED = 'COMMENT_ADDED';

// Resolver
const resolvers = {
  Subscription: {
    postCreated: {
      subscribe: () => pubsub.asyncIterator([POST_CREATED]),
    },
    commentAdded: {
      subscribe: (_, { postId }) => pubsub.asyncIterator([`${COMMENT_ADDED}:${postId}`]),
    },
  },
  
  Mutation: {
    createPost: async (_, { input }, context) => {
      const post = await context.db.posts.create(input);
      pubsub.publish(POST_CREATED, { postCreated: post });
      return post;
    },
    
    addComment: async (_, { postId, text }, context) => {
      const comment = await context.db.comments.create({
        postId, text, authorId: context.user.id
      });
      pubsub.publish(`${COMMENT_ADDED}:${postId}`, { commentAdded: comment });
      return comment;
    },
  },
};
```

---

## Part 4: Caching

### Response Caching

```typescript
import { responseCachePlugin } from '@apollo/server-plugin-response-cache';

const server = new ApolloServer({
  typeDefs,
  resolvers,
  plugins: [
    responseCachePlugin({
      sessionId: (requestContext) => requestContext.request.http?.headers.get('session-id') || null,
    }),
  ],
});

// Cache hints in schema
type User @cacheControl(maxAge: 300) {
  id: ID!
  name: String!
  email: String! @cacheControl(maxAge: 0)  # Never cache email
}
```

### DataLoader Caching

```typescript
// DataLoader caches within a single request
const userLoader = new DataLoader(async (ids) => {
  const users = await db.users.findByIds(ids);
  return ids.map(id => users.find(u => u.id === id));
}, {
  maxBatchSize: 100,  // Max items per batch
  cache: true,        # Enable caching (default)
});
```

### CDN Caching

```graphql
# Cache-Control headers for CDN
# Set in server configuration
{
  "cacheControl": {
    "defaultMaxAge": 60,
    "stripFormattedExtensions": false
  }
}
```

---

## Part 5: Security

### Auth Middleware

```typescript
import { GraphQLError } from 'graphql';

// Authentication
function authDirective(def) {
  const originalResolve = def.resolve;
  def.resolve = async (parent, args, context, info) => {
    if (!context.user) {
      throw new GraphQLError('Not authenticated', {
        extensions: { code: 'UNAUTHENTICATED' },
      });
    }
    return originalResolve(parent, args, context, info);
  };
}

// Rate limiting
const rateLimitMap = new Map();

function rateLimit(key, limit, windowMs) {
  const now = Date.now();
  const record = rateLimitMap.get(key) || { count: 0, resetAt: now + windowMs };
  
  if (now > record.resetAt) {
    record.count = 0;
    record.resetAt = now + windowMs;
  }
  
  record.count++;
  rateLimitMap.set(key, record);
  
  if (record.count > limit) {
    throw new GraphQLError('Rate limit exceeded', {
      extensions: { code: 'RATE_LIMITED' },
    });
  }
}
```

### Query Complexity

```typescript
import depthLimit from 'graphql-depth-limit';
import { createComplexityRule } from 'graphql-query-complexity';

const server = new ApolloServer({
  validationRules: [
    depthLimit(7),  # Max query depth
    createComplexityRule({
      maximumComplexity: 1000,
      estimators: [
        fieldExtensionsEstimator(),
        simpleEstimator({ defaultComplexity: 1 }),
      ],
      onComplete: (complexity) => {
        console.log('Query complexity:', complexity);
      },
    }),
  ],
});
```

### Input Validation

```typescript
const resolvers = {
  Mutation: {
    createUser: (_, { input }) => {
      // Validate email
      if (!input.email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
        throw new UserInputError('Invalid email format');
      }
      
      // Validate password strength
      if (input.password.length < 8) {
        throw new UserInputError('Password must be at least 8 characters');
      }
      
      // Validate name
      if (input.name.length < 2 || input.name.length > 100) {
        throw new UserInputError('Name must be 2-100 characters');
      }
      
      return createUser(input);
    },
  },
};
```

---

## Part 6: Testing

### Resolver Tests

```typescript
import { ApolloServer } from '@apollo/server';
import { createTestClient } from 'apollo-server-testing';

describe('User resolvers', () => {
  let server;
  
  beforeEach(() => {
    server = new ApolloServer({
      typeDefs,
      resolvers,
      context: () => ({
        user: mockUser,
        db: mockDb,
        loaders: createMockLoaders(),
      }),
    });
  });
  
  it('returns current user', async () => {
    const { query } = createTestClient(server);
    const res = await query({
      query: `query { me { id name email } }`,
    });
    
    expect(res.errors).toBeUndefined();
    expect(res.data.me.name).toBe('Test User');
  });
  
  it('requires authentication', async () => {
    const { query } = createTestClient(server);
    const res = await query({
      query: `query { me { id name email } }`,
    });
    
    expect(res.errors[0].extensions.code).toBe('UNAUTHENTICATED');
  });
});
```

---

## Output Format

```
## GraphQL API Design

### Schema Overview
- Types: [count]
- Queries: [list]
- Mutations: [list]
- Subscriptions: [list]

### Key Types
[Schema for main types]

### Resolver Strategy
[How resolvers are organized]

### Performance
- DataLoader: [what entities]
- Caching: [strategy]
- Complexity limit: [number]
```

## Rules

- **Design schema first** — Schema is the contract
- **Use strong types** — Avoid `String` where a specific type works
- **Prevent N+1** — Use DataLoader for all nested queries
- **Validate inputs** — Don't trust client input
- **Rate limit** — Prevent abuse
- **Set depth limits** — Prevent deeply nested queries
- **Cache aggressively** — Use response caching and DataLoader
- **Document everything** — Use descriptions in schema
