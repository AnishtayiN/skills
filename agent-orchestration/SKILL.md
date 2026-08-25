---
name: agent-orchestration
description: >-
  Design, implement, and debug multi-agent systems and agent orchestration patterns.
  Use this skill when the user mentions agent orchestration, multi-agent systems, agent coordination,
  agent communication, agent delegation, task distribution, agent swarm, hierarchical agents,
  agent memory, agent state management, agent debugging, or wants to build systems where multiple
  AI agents collaborate to solve complex problems. Also trigger for: هماهنگی اجنت‌ها, سیستم چنداجنتی,
  توزیع کار بین اجنت‌ها, مدیریت حالت اجنت, اتوماسیون چندمرحله‌ای, orchestration pattern,
  agent graph, agent workflow, agent pipeline, agentic system.
---

# Agent Orchestration Skill — Multi-Agent System Design & Implementation

## Overview

This skill guides the design, implementation, and debugging of multi-agent systems where multiple AI agents collaborate to solve complex problems. Modern AI applications increasingly rely on multiple specialized agents working together — a coding agent paired with a testing agent, a research agent feeding into a writing agent, or a swarm of agents tackling parallel tasks. This skill covers the full lifecycle: architecture design, communication patterns, task delegation, state management, error handling, and debugging.

## When to Use This Skill

- User wants to build a system with multiple collaborating agents
- User needs to decompose a complex task across multiple agents
- User asks about agent communication patterns (hierarchical, peer-to-peer, blackboard)
- User needs to manage agent state and memory across turns
- User is debugging a multi-agent system (deadlocks, infinite loops, lost context)
- User wants to implement agent delegation and task routing
- User asks about agent frameworks (LangGraph, CrewAI, AutoGen, custom)
- User says "how should I split this across multiple agents?"

## When NOT to Use This Skill

- Simple single-agent tasks that don't need coordination
- Tasks where a single agent with tools is sufficient
- User just wants to use one agent with different prompts

---

## Core Concepts

### What Makes Multi-Agent Different

Single-agent systems have one decision loop. Multi-agent systems have:
- **Multiple decision loops** running concurrently or sequentially
- **Communication overhead** between agents
- **Shared state** that agents must coordinate on
- **Failure modes** unique to distributed systems (deadlocks, race conditions, context loss)

### Agent Taxonomy

| Agent Type | Role | Example |
|-----------|------|---------|
| **Orchestrator** | Routes tasks, manages flow | Main agent that decides which specialist to call |
| **Specialist** | Deep expertise in one area | Debug agent, review agent, test agent |
| **Researcher** | Gathers information | Web search agent, code reading agent |
| **Writer** | Produces output | Documentation agent, code generation agent |
| **Critic** | Reviews and validates | Code review agent, fact-check agent |
| **Executor** | Performs actions | File writer, terminal runner, API caller |
| **Monitor** | Watches for issues | Quality gate, error detector, performance monitor |

---

## Architecture Patterns

### Pattern 1: Sequential Pipeline

Agents execute one after another, each processing the output of the previous.

```
Input → Agent A → Agent B → Agent C → Output
         (Research)  (Write)   (Review)
```

**When to use:** Tasks with clear stages where each stage depends on the previous.
**Example:** Research → Draft → Review → Publish

```
# Implementation pattern
class Pipeline:
    def __init__(self, agents: list[Agent]):
        self.agents = agents
    
    async def run(self, input_data):
        current = input_data
        for agent in self.agents:
            current = await agent.process(current)
        return current
```

**Pros:** Simple to implement, easy to debug, clear data flow.
**Cons:** Slow (sequential), single point of failure at each stage, no parallelism.

### Pattern 2: Parallel Fan-Out

Multiple agents process the same or different inputs simultaneously.

```
         ┌→ Agent A (Frontend)  ─┐
Input →  ├→ Agent B (Backend)   ─├→ Merge → Output
         └→ Agent C (Database) ─┘
```

**When to use:** Independent subtasks that can run simultaneously.
**Example:** Review different parts of a codebase in parallel.

```python
# Implementation pattern
class FanOut:
    def __init__(self, agents: list[Agent], merger):
        self.agents = agents
        self.merger = merger
    
    async def run(self, input_data):
        results = await asyncio.gather(
            *[agent.process(input_data) for agent in self.agents]
        )
        return self.merger(results)
```

**Pros:** Fast (parallel), resilient (one failure doesn't stop others).
**Cons:** More complex, needs result merging, potential resource contention.

### Pattern 3: Orchestrator-Worker

One central agent delegates tasks to specialist workers.

```
                    ┌→ Worker A (code)
Orchestrator → Task ├→ Worker B (test)
                    └→ Worker C (review)
                         ↓
                    Results back to Orchestrator
```

**When to use:** Complex tasks requiring different expertise at different stages.
**Example:** Project planning agent delegating to coding, testing, and deployment agents.

```python
# Implementation pattern
class Orchestrator:
    def __init__(self, workers: dict[str, Agent]):
        self.workers = workers
        self.task_queue = asyncio.Queue()
    
    async def run(self, goal: str):
        plan = await self.plan(goal)
        results = {}
        for task in plan:
            worker = self.workers[task.type]
            results[task.id] = await worker.process(task)
        return await self.synthesize(results)
```

**Pros:** Flexible, can adapt to different tasks, central control.
**Cons:** Orchestrator is a bottleneck and single point of failure.

### Pattern 4: Blackboard

Agents read from and write to a shared knowledge base.

```
┌─────────────────────────────────────┐
│           Blackboard                │
│  (shared state / knowledge store)   │
└──┬──────────┬──────────┬───────────┘
   │          │          │
Agent A    Agent B    Agent C
(reader)   (writer)   (reader)
```

**When to use:** Agents need to share and build on each other's findings incrementally.
**Example:** Research agents contributing findings to a shared knowledge base.

```python
# Implementation pattern
class Blackboard:
    def __init__(self):
        self.state = {}
        self.observers = []
    
    def write(self, key: str, value: any, agent_id: str):
        self.state[key] = {"value": value, "agent": agent_id, "timestamp": time.time()}
        self._notify_observers(key)
    
    def read(self, key: str) -> any:
        return self.state.get(key, {}).get("value")
    
    def query(self, pattern: str) -> dict:
        return {k: v for k, v in self.state.items() if pattern in k}
```

**Pros:** Loose coupling, agents can join/leave dynamically, shared context.
**Cons:** No clear ownership, potential conflicts, hard to debug state.

### Pattern 5: Hierarchical (Tree)

Agents form a tree where parent agents delegate to children.

```
           Root Agent
          /          \
    Team Lead A    Team Lead B
    /    \          /    \
Agent1 Agent2  Agent3 Agent4
```

**When to use:** Large-scale tasks requiring multiple levels of decomposition.
**Example:** CTO agent → Team leads → Individual contributor agents.

**Pros:** Scalable, clear authority, matches organizational structures.
**Cons:** Deep trees add latency, communication overhead increases with depth.

### Pattern 6: Map-Reduce

Map phase distributes work, reduce phase combines results.

```
Input → Map (split into chunks)
      → Chunk 1 → Agent A ─┐
      → Chunk 2 → Agent B ─├→ Reduce → Output
      → Chunk 3 → Agent C ─┘
```

**When to use:** Large tasks that can be split into independent chunks.
**Example:** Code review of 100 files (map: review each file, reduce: combine findings).

```python
# Implementation pattern
class MapReduce:
    def __init__(self, mapper: Agent, reducer: Agent, chunk_size: int):
        self.mapper = mapper
        self.reducer = reducer
        self.chunk_size = chunk_size
    
    async def run(self, items: list):
        # Map phase
        chunks = [items[i:i+self.chunk_size] for i in range(0, len(items), self.chunk_size)]
        mapped = await asyncio.gather(
            *[self.mapper.process(chunk) for chunk in chunks]
        )
        # Reduce phase
        return await self.reducer.process(mapped)
```

---

## Communication Patterns

### Direct Message

Agents send messages directly to each other.

```python
class Agent:
    def __init__(self, id: str, inbox: MessageBus):
        self.id = id
        self.inbox = inbox
    
    async def send(self, to: str, message: dict):
        await self.inbox.deliver(from_=self.id, to=to, message=message)
    
    async def receive(self) -> dict:
        return await self.inbox.get(self.id)
```

### Event-Driven

Agents publish and subscribe to events.

```python
class EventBus:
    def __init__(self):
        self.subscribers: dict[str, list[Callable]] = {}
    
    def subscribe(self, event_type: str, handler: Callable):
        self.subscribers.setdefault(event_type, []).append(handler)
    
    async def publish(self, event_type: str, data: dict):
        for handler in self.subscribers.get(event_type, []):
            await handler(data)
```

### Request-Response

Synchronous communication where one agent requests and another responds.

```python
class RequestResponse:
    async def request(self, agent_id: str, request: dict) -> dict:
        future = asyncio.Future()
        self.pending_requests[request["id"]] = future
        await self.send(agent_id, request)
        return await asyncio.wait_for(future, timeout=30.0)
```

---

## Task Delegation Strategies

### Rule-Based Routing

Route tasks based on explicit rules.

```python
def route_task(task: Task) -> str:
    if task.type == "code_review":
        return "review-agent"
    elif task.type == "debugging":
        return "debug-agent"
    elif task.type == "testing":
        return "test-agent"
    elif task.type == "documentation":
        return "doc-agent"
    else:
        return "general-agent"
```

### Capability-Based Routing

Route based on agent capabilities.

```python
def route_by_capability(task: Task, agents: list[Agent]) -> Agent:
    scored = []
    for agent in agents:
        score = match_score(task.required_capabilities, agent.capabilities)
        scored.append((agent, score))
    return max(scored, key=lambda x: x[1])[0]
```

### Load-Balanced Routing

Distribute tasks evenly across agents.

```python
class LoadBalancer:
    def __init__(self, agents: list[Agent]):
        self.agents = agents
        self.load = {agent.id: 0 for agent in agents}
    
    def next_agent(self) -> Agent:
        min_load = min(self.load.values())
        least_loaded = [a for a in self.agents if self.load[a.id] == min_load]
        return least_loaded[0]
    
    def complete(self, agent_id: str):
        self.load[agent_id] -= 1
```

### Adaptive Routing

Learn which agent is best for which task type.

```python
class AdaptiveRouter:
    def __init__(self):
        self.performance: dict[str, dict[str, float]] = {}  # agent_id -> task_type -> score
    
    def update(self, agent_id: str, task_type: str, score: float):
        self.performance.setdefault(agent_id, {}).setdefault(task_type, [])
        self.performance[agent_id][task_type].append(score)
        # Keep only last N scores
        self.performance[agent_id][task_type] = self.performance[agent_id][task_type][-10:]
    
    def route(self, task_type: str) -> str:
        best_agent = None
        best_score = -1
        for agent_id, scores in self.performance.items():
            if task_type in scores:
                avg = sum(scores[task_type]) / len(scores[task_type])
                if avg > best_score:
                    best_score = avg
                    best_agent = agent_id
        return best_agent or self.default_agent
```

---

## State Management

### Shared State Patterns

| Pattern | Use Case | Complexity |
|---------|----------|------------|
| **In-Memory Dict** | Simple, single-process | Low |
| **Redis** | Distributed, persistent | Medium |
| **Database** | Durable, queryable | Medium |
| **Message Queue** | Event-driven, decoupled | High |
| **File System** | Simple persistence | Low |

### Agent Memory

Agents need both short-term and long-term memory:

```python
class AgentMemory:
    def __init__(self):
        self.short_term: list[dict] = []  # Current conversation/task
        self.long_term: dict[str, any] = {}  # Persistent knowledge
        self.working: dict[str, any] = {}  # Current task state
    
    def add_to_short_term(self, message: dict):
        self.short_term.append(message)
        # Keep only last N messages
        if len(self.short_term) > 50:
            self.short_term = self.short_term[-50:]
    
    def save_to_long_term(self, key: str, value: any):
        self.long_term[key] = value
    
    def get_context(self) -> dict:
        return {
            "short_term": self.short_term[-10:],
            "long_term": self.long_term,
            "working": self.working
        }
```

### Context Passing

When agents pass context to each other:

```python
class Context:
    def __init__(self):
        self.data = {}
        self.history = []
        self.metadata = {}
    
    def add_result(self, agent_id: str, result: any):
        self.data[agent_id] = result
        self.history.append({"agent": agent_id, "result": result, "timestamp": time.time()})
    
    def get_agent_input(self, required_keys: list[str]) -> dict:
        return {k: self.data[k] for k in required_keys if k in self.data}
    
    def to_dict(self) -> dict:
        return {"data": self.data, "history": self.history, "metadata": self.metadata}
```

---

## Error Handling

### Common Multi-Agent Failures

| Failure Mode | Symptom | Prevention |
|-------------|---------|------------|
| **Deadlock** | Agents waiting on each other forever | Timeout on all waits, deadlock detection |
| **Infinite Loop** | Same task repeated endlessly | Max iteration count, progress tracking |
| **Context Loss** | Agent loses critical information | Persistent state, context compression |
| **Cascading Failure** | One agent failure kills the pipeline | Circuit breakers, graceful degradation |
| **Resource Exhaustion** | Too many agents consuming tokens/money | Rate limiting, cost tracking |
| **Race Condition** | Agents writing to same state concurrently | Locks, atomic operations, event sourcing |

### Error Handling Patterns

```python
class ResilientAgent:
    def __init__(self, agent: Agent, max_retries: int = 3):
        self.agent = agent
        self.max_retries = max_retries
    
    async def process(self, task: Task) -> dict:
        last_error = None
        for attempt in range(self.max_retries):
            try:
                result = await self.agent.process(task)
                return result
            except Exception as e:
                last_error = e
                logger.warning(f"Agent {self.agent.id} failed (attempt {attempt + 1}): {e}")
                await asyncio.sleep(2 ** attempt)  # Exponential backoff
        
        # All retries failed - fallback
        return await self.fallback(task, last_error)
    
    async def fallback(self, task: Task, error: Exception) -> dict:
        return {
            "status": "error",
            "error": str(error),
            "fallback": True,
            "task": task.to_dict()
        }
```

### Circuit Breaker Pattern

```python
class CircuitBreaker:
    def __init__(self, failure_threshold: int = 5, reset_timeout: float = 60.0):
        self.failure_count = 0
        self.failure_threshold = failure_threshold
        self.reset_timeout = reset_timeout
        self.state = "closed"  # closed, open, half-open
        self.last_failure_time = None
    
    async def call(self, func, *args, **kwargs):
        if self.state == "open":
            if time.time() - self.last_failure_time > self.reset_timeout:
                self.state = "half-open"
            else:
                raise CircuitBreakerOpenError("Circuit breaker is open")
        
        try:
            result = await func(*args, **kwargs)
            if self.state == "half-open":
                self.state = "closed"
                self.failure_count = 0
            return result
        except Exception as e:
            self.failure_count += 1
            self.last_failure_time = time.time()
            if self.failure_count >= self.failure_threshold:
                self.state = "open"
            raise
```

---

## Debugging Multi-Agent Systems

### Debugging Checklist

1. **Trace the flow** — Draw the sequence of agent interactions
2. **Check state at each step** — What does each agent see?
3. **Identify the failure point** — Which agent failed? What did it receive?
4. **Check communication** — Were messages delivered? In order? Complete?
5. **Check resource usage** — Token limits, API rate limits, memory
6. **Check concurrency** — Race conditions, deadlocks, resource contention

### Debugging Tools

| Tool | Purpose |
|------|---------|
| **Trace logging** | Record every agent interaction with timestamps |
| **State snapshots** | Capture state before/after each agent call |
| **Visualization** | Draw the agent graph and data flow |
| **Replay** | Re-run the exact same inputs through the system |
| **Chaos testing** | Inject failures to test resilience |

### Common Debug Patterns

```python
class TracedAgent:
    def __init__(self, agent: Agent):
        self.agent = agent
        self.trace = []
    
    async def process(self, task: Task) -> dict:
        entry = {
            "agent_id": self.agent.id,
            "task": task.to_dict(),
            "start_time": time.time(),
            "input_hash": hash(str(task.to_dict()))
        }
        
        try:
            result = await self.agent.process(task)
            entry["result"] = result
            entry["status"] = "success"
        except Exception as e:
            entry["error"] = str(e)
            entry["status"] = "error"
            raise
        finally:
            entry["end_time"] = time.time()
            entry["duration"] = entry["end_time"] - entry["start_time"]
            self.trace.append(entry)
        
        return result
```

---

## Framework Integration

### LangGraph Pattern

```python
from langgraph.graph import StateGraph, END

# Define state
class AgentState(TypedDict):
    messages: list
    next_agent: str
    results: dict

# Build graph
graph = StateGraph(AgentState)

# Add nodes
graph.add_node("orchestrator", orchestrator_agent)
graph.add_node("coder", coder_agent)
graph.add_node("reviewer", reviewer_agent)
graph.add_node("tester", tester_agent)

# Add edges
graph.add_conditional_edges("orchestrator", route_agent)
graph.add_edge("coder", "reviewer")
graph.add_edge("reviewer", "tester")
graph.add_edge("tester", END)

# Compile
app = graph.compile()
```

### CrewAI Pattern

```python
from crewai import Agent, Task, Crew

# Define agents
researcher = Agent(
    role="Researcher",
    goal="Find relevant information",
    backstory="Expert at web research and data gathering",
    tools=[search_tool, read_tool]
)

writer = Agent(
    role="Writer",
    goal="Write clear, engaging content",
    backstory="Experienced technical writer",
    tools=[write_tool]
)

# Define tasks
research_task = Task(
    description="Research the latest AI trends",
    agent=researcher,
    expected_output="Comprehensive research report"
)

writing_task = Task(
    description="Write an article based on the research",
    agent=writer,
    expected_output="1000-word article",
    context=[research_task]
)

# Create crew
crew = Crew(
    agents=[researcher, writer],
    tasks=[research_task, writing_task],
    verbose=True
)

result = crew.kickoff()
```

### AutoGen Pattern

```python
from autogen import AssistantAgent, UserProxyAgent

# Create agents
assistant = AssistantAgent(
    name="coding_assistant",
    system_message="You are an expert coder.",
    llm_config={"model": "gpt-4"}
)

user_proxy = UserProxyAgent(
    name="user_proxy",
    human_input_mode="NEVER",
    code_execution_config={"work_dir": "workspace"}
)

# Start conversation
user_proxy.initiate_chat(
    assistant,
    message="Write a Python function to sort a list of dictionaries by a key."
)
```

---

## Cost & Performance Optimization

### Token Budget Management

```python
class TokenBudget:
    def __init__(self, total_limit: int):
        self.total_limit = total_limit
        self.used = 0
        self.per_agent: dict[str, int] = {}
    
    def allocate(self, agent_id: str, tokens: int) -> bool:
        if self.used + tokens > self.total_limit:
            return False
        self.used += tokens
        self.per_agent[agent_id] = self.per_agent.get(agent_id, 0) + tokens
        return True
    
    def remaining(self) -> int:
        return self.total_limit - self.used
    
    def report(self) -> dict:
        return {
            "total_limit": self.total_limit,
            "used": self.used,
            "remaining": self.remaining(),
            "per_agent": self.per_agent
        }
```

### Caching Agent Results

```python
import hashlib

class AgentCache:
    def __init__(self):
        self.cache = {}
    
    def _key(self, agent_id: str, task: dict) -> str:
        content = f"{agent_id}:{json.dumps(task, sort_keys=True)}"
        return hashlib.sha256(content.encode()).hexdigest()
    
    async def get_or_run(self, agent: Agent, task: Task) -> dict:
        key = self._key(agent.id, task.to_dict())
        if key in self.cache:
            return self.cache[key]
        result = await agent.process(task)
        self.cache[key] = result
        return result
```

### Parallel Execution with Concurrency Limits

```python
class ParallelRunner:
    def __init__(self, max_concurrent: int = 5):
        self.semaphore = asyncio.Semaphore(max_concurrent)
    
    async def run(self, agent: Agent, tasks: list[Task]) -> list[dict]:
        async def limited_run(task):
            async with self.semaphore:
                return await agent.process(task)
        
        return await asyncio.gather(*[limited_run(t) for t in tasks])
```

---

## Output Format

When designing multi-agent systems:

```markdown
## Multi-Agent System Design

### Architecture
[Diagram of agents and their connections]

### Agent Definitions
| Agent | Role | Capabilities | Input | Output |
|-------|------|-------------|-------|--------|

### Communication Flow
[Step-by-step flow of how agents communicate]

### State Management
[How shared state is managed]

### Error Handling
[What happens when an agent fails]

### Cost Estimate
[Token/budget estimate per agent per task]
```

## Rules

- **Start simple** — Begin with 2 agents, add more only when needed
- **Define clear boundaries** — Each agent should have a single, well-defined responsibility
- **Always have error handling** — Every agent call can fail
- **Monitor costs** — Multi-agent systems can burn tokens fast
- **Log everything** — You can't debug what you can't see
- **Test incrementally** — Test each agent alone, then in pairs, then the full system
- **Design for failure** — Assume any agent can fail at any time
- **Keep context small** — Don't pass entire conversations between agents; extract key facts

## Common Pitfalls to Avoid

- **Don't use 10 agents when 2 will do.** Complexity grows exponentially with agent count
- **Don't let agents call each other in cycles.** This creates infinite loops
- **Don't share mutable state without locks.** Race conditions will corrupt your data
- **Don't skip the orchestrator.** Without centralized control, agents will conflict
- **Don't assume agents remember everything.** Pass explicit context, not implicit memory
- **Don't ignore costs.** Each agent call costs tokens. Budget accordingly
