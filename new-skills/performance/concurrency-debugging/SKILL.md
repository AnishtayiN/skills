---
name: concurrency-debugging
description: >-
  Debug concurrency issues: race conditions, deadlocks, async bugs, thread safety.
  TRIGGERS: race condition, deadlock, thread, async, concurrent, parallel, synchronization,
  mutex, lock, atomics, data race, thread safe, async bug, await issue,
  lock-free, actor model, CSP, thread safety, concurrent programming,
  شرط مسابقه, بن‌بست, همزمانی, آسنکرون, قفل, ایمنی رشته,
  竞态条件, 死锁, 并发, 异步, 线程安全
priority: P0
dependencies: [debugging]
conflicts: []
---

# Concurrency Debugging Skill

## Purpose

Find and fix concurrency issues including race conditions, deadlocks, livelocks, and async/await pitfalls. Understand concurrency models and apply appropriate synchronization patterns.

## When to Activate

- Non-deterministic failures (works sometimes, fails sometimes)
- Deadlock detected (program hangs)
- Async code behaving unexpectedly
- Thread safety issues
- High CPU usage with low throughput
- Race conditions in shared state
- "Cannot access already disposed object" errors

## Workflow

### Step 1: Identify Concurrency Model

```
1. What concurrency model is used?
   - Threads (pthreads, Java threads, C# Task)
   - Async/Await (JavaScript, Python asyncio, C# async)
   - Goroutines (Go)
   - Processes (multiprocessing)
   - Actors (Erlang, Akka)
   - CSP (Go channels)
2. What shared state exists?
3. What synchronization is used?
4. What is the expected execution order?
```

### Step 2: Classify the Issue

```
Common concurrency issues:
- Race condition: Two operations on shared state without sync
- Deadlock: Two locks acquired in different order
- Livelock: Threads continuously changing state without progress
- Starvation: One thread blocks others from proceeding
- Async bug: Missing await, wrong async flow
- Thread safety: Shared mutable state without synchronization
```

### Step 3: Detect & Analyze

```
1. Add logging to understand execution order
2. Use thread/async debuggers
3. Run stress tests to reproduce
4. Analyze thread dumps if available
5. Check for race conditions in critical sections
```

### Step 4: Fix & Verify

```
1. Add proper synchronization
2. Use atomic operations
3. Fix lock ordering
4. Add proper async/await
5. Minimize shared state
6. Verify fix with stress tests
```

## Advanced Techniques

### 1. Race Condition Detection & Prevention
```python
import threading
import time

# UNSAFE: Race condition
counter = 0

def unsafe_increment():
    global counter
    for _ in range(100000):
        counter += 1  # Not atomic! Read-modify-write

# SAFE: Using Lock
counter = 0
lock = threading.Lock()

def safe_increment():
    global counter
    for _ in range(100000):
        with lock:
            counter += 1

# SAFE: Using atomic operations (Python doesn't have true atomics)
# Use queue for thread-safe communication
from queue import Queue
import threading

def producer(queue):
    for i in range(10):
        time.sleep(0.1)
        queue.put(i)
    queue.put(None)  # Sentinel

def consumer(queue):
    while True:
        item = queue.get()
        if item is None:
            break
        print(f"Processing {item}")

# Usage
q = threading.Thread(target=producer, args=(q,))
c = threading.Thread(target=consumer, args=(q,))
```

### 2. Deadlock Analysis & Prevention
```python
import threading
import time
from contextlib import contextmanager

# DEADLOCK PRONE: Lock ordering violation
lock_a = threading.Lock()
lock_b = threading.Lock()

# Thread 1: acquires lock_a then lock_b
# Thread 2: acquires lock_b then lock_a
# → Deadlock!

# SAFE: Always acquire locks in same order
def safe_operation_1():
    with lock_a:
        with lock_b:
            # Work
            pass

def safe_operation_2():
    with lock_a:  # Same order as operation_1
        with lock_b:
            # Work
            pass

# SAFE: Using timeout to detect deadlock
def operation_with_timeout():
    if lock_a.acquire(timeout=1):
        try:
            if lock_b.acquire(timeout=1):
                try:
                    # Work
                    pass
                finally:
                    lock_b.release()
        finally:
            lock_a.release()
    else:
        print("Could not acquire lock_a - possible deadlock")

# DEADLOCK DETECTION: Using dependency graph
class DeadlockDetector:
    def __init__(self):
        self.lock_graph = {}  # lock -> set of locks it's waiting for
    
    def acquire(self, thread_id, lock_id, timeout=1):
        # Check for cycle in dependency graph
        if self._has_cycle(lock_id):
            raise RuntimeError(f"Potential deadlock detected for {lock_id}")
        
        # Record this thread is waiting for this lock
        if thread_id not in self.lock_graph:
            self.lock_graph[thread_id] = set()
        
        acquired = lock_id.acquire(timeout=timeout)
        if acquired:
            # Thread acquired the lock
            self.lock_graph[thread_id].add(lock_id)
        return acquired
    
    def _has_cycle(self, start_lock):
        visited = set()
        stack = [start_lock]
        while stack:
            lock = stack.pop()
            if lock in visited:
                return True
            visited.add(lock)
            # Find what this lock is waiting for
            for thread_locks in self.lock_graph.values():
                if lock in thread_locks:
                    stack.extend(thread_locks - visited)
        return False
```

### 3. Async/Await Pitfalls & Solutions
```python
import asyncio
from typing import List

# WRONG: Blocking the event loop
async def wrong_fetch():
    import requests
    return requests.get('https://api.example.com')  # Blocks!

# RIGHT: Use async HTTP client
import aiohttp

async def correct_fetch():
    async with aiohttp.ClientSession() as session:
        async with session.get('https://api.example.com') as response:
            return await response.text()

# WRONG: Missing await
async def wrong_parallel():
    # Creates tasks but doesn't await them
    [fetch_data(i) for i in range(10)]  # Tasks created but not awaited!

# RIGHT: Proper parallel execution
async def correct_parallel():
    tasks = [fetch_data(i) for i in range(10)]
    return await asyncio.gather(*tasks)

# WRONG: Sequential await in loop
async def wrong_sequential():
    results = []
    for i in range(10):
        results.append(await fetch_data(i))  # Sequential!
    return results

# RIGHT: Parallel execution
async def correct_parallel_v2():
    return await asyncio.gather(*[fetch_data(i) for i in range(10)])

# WRONG: Not handling exceptions in tasks
async def wrong_exception_handling():
    tasks = [fetch_data(i) for i in range(10)]
    await asyncio.gather(*tasks)  # If one fails, all fail!

# RIGHT: Proper exception handling
async def correct_exception_handling():
    tasks = [fetch_data(i) for i in range(10)]
    results = await asyncio.gather(*tasks, return_exceptions=True)
    errors = [r for r in results if isinstance(r, Exception)]
    if errors:
        print(f"Got {len(errors)} errors")
    return [r for r in results if not isinstance(r, Exception)]

# DEADLOCK in asyncio: Waiting on yourself
async def deadlock_example():
    await asyncio.sleep(0)  # Yield to event loop
    # But if you're in a coroutine that's waiting for you...
    # This can cause issues

# SOLUTION: Use proper synchronization
async def correct_synchronization():
    lock = asyncio.Lock()
    async with lock:
        # Critical section
        pass
```

### 4. Thread Safety Patterns
```python
import threading
from dataclasses import dataclass, field
from typing import Dict, Any
import queue

# Thread-safe singleton
class ThreadSafeSingleton:
    _instance = None
    _lock = threading.Lock()
    
    def __new__(cls):
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = super().__new__(cls)
        return cls._instance

# Thread-safe data structure
class ThreadSafeDict:
    def __init__(self):
        self._dict = {}
        self._lock = threading.RLock()  # Reentrant lock
    
    def get(self, key):
        with self._lock:
            return self._dict.get(key)
    
    def set(self, key, value):
        with self._lock:
            self._dict[key] = value
    
    def update(self, d):
        with self._lock:
            self._dict.update(d)

# Producer-Consumer pattern
class ProducerConsumer:
    def __init__(self, max_size=100):
        self.queue = queue.Queue(maxsize=max_size)
        self.running = True
    
    def producer(self, items):
        for item in items:
            self.queue.put(item)
        self.queue.put(None)  # Sentinel
    
    def consumer(self):
        while self.running:
            try:
                item = self.queue.get(timeout=1)
                if item is None:
                    break
                self.process(item)
            except queue.Empty:
                continue
    
    def process(self, item):
        print(f"Processing {item}")

# Reader-Writer lock
class ReadWriteLock:
    def __init__(self):
        self.readers = 0
        self.readers_lock = threading.Lock()
        self.writers_lock = threading.Lock()
    
    def acquire_read(self):
        with self.readers_lock:
            self.readers += 1
            if self.readers == 1:
                self.writers_lock.acquire()
    
    def release_read(self):
        with self.readers_lock:
            self.readers -= 1
            if self.readers == 0:
                self.writers_lock.release()
    
    def acquire_write(self):
        self.writers_lock.acquire()
    
    def release_write(self):
        self.writers_lock.release()
```

### 5. Actor Model Pattern
```python
import asyncio
from typing import Any, Callable, Dict
from dataclasses import dataclass
from enum import Enum

class MessageType(Enum):
    PING = "ping"
    PONG = "pong"
    WORK = "work"
    RESULT = "result"

@dataclass
class Message:
    type: MessageType
    sender: str
    data: Any = None

class Actor:
    def __init__(self, name: str):
        self.name = name
        self.mailbox = asyncio.Queue()
        self.running = True
    
    async def receive(self, message: Message):
        """Override this to handle messages"""
        raise NotImplementedError
    
    async def send(self, actor: 'Actor', message: Message):
        """Send a message to another actor"""
        await actor.mailbox.put(message)
    
    async def run(self):
        """Main actor loop"""
        while self.running:
            try:
                message = await asyncio.wait_for(
                    self.mailbox.get(), timeout=1.0
                )
                await self.receive(message)
            except asyncio.TimeoutError:
                continue
        print(f"Actor {self.name} stopped")

class PingActor(Actor):
    async def receive(self, message: Message):
        if message.type == MessageType.PING:
            print(f"{self.name}: Received PING from {message.sender}")
            await self.send(
                message.sender_actor,
                Message(MessageType.PONG, self.name)
            )

class PongActor(Actor):
    async def receive(self, message: Message):
        if message.type == MessageType.PONG:
            print(f"{self.name}: Received PONG from {message.sender}")

# Actor system
class ActorSystem:
    def __init__(self):
        self.actors: Dict[str, Actor] = {}
    
    def create_actor(self, actor_class, name: str, **kwargs) -> Actor:
        actor = actor_class(name, **kwargs)
        self.actors[name] = actor
        return actor
    
    async def start_all(self):
        tasks = [actor.run() for actor in self.actors.values()]
        await asyncio.gather(*tasks)
    
    def stop_all(self):
        for actor in self.actors.values():
            actor.running = False
```

### 6. CSP (Communicating Sequential Processes) Pattern
```python
import asyncio
from typing import TypeVar, Generic, Optional
from dataclasses import dataclass

T = TypeVar('T')

class Channel(Generic[T]):
    """Go-like channel implementation"""
    def __init__(self, buffer_size: int = 0):
        self.buffer_size = buffer_size
        self.items = asyncio.Queue(maxsize=buffer_size)
        self.closed = False
    
    async def send(self, item: T):
        if self.closed:
            raise RuntimeError("Channel is closed")
        await self.items.put(item)
    
    async def receive(self) -> Optional[T]:
        if self.closed and self.items.empty():
            return None
        return await self.items.get()
    
    def close(self):
        self.closed = True

# Producer using channels
async def producer(channel: Channel[int]):
    for i in range(10):
        await channel.send(i)
        print(f"Sent {i}")
    channel.close()

# Consumer using channels
async def consumer(channel: Channel[int]):
    while True:
        item = await channel.receive()
        if item is None:
            break
        print(f"Received {item}")

# Fan-out pattern
async def fan_out(input_channel: Channel, workers: list):
    async def worker(channel: Channel):
        while True:
            item = await channel.receive()
            if item is None:
                break
            await process(item)
    
    channels = [Channel() for _ in workers]
    # Distribute work to workers
    async def distributor():
        while True:
            item = await input_channel.receive()
            if item is None:
                for ch in channels:
                    ch.close()
                break
            # Round-robin distribution
            for ch in channels:
                await ch.send(item)
    
    await asyncio.gather(distributor(), *[worker(ch) for ch in channels])

# Fan-in pattern
async def fan_in(*channels: Channel) -> Channel:
    output = Channel()
    
    async def merge(channel: Channel):
        while True:
            item = await channel.receive()
            if item is None:
                break
            await output.send(item)
    
    async def check_done():
        for ch in channels:
            await ch.receive()  # Wait for close
        output.close()
    
    await asyncio.gather(*[merge(ch) for ch in channels], check_done())
    return output
```

### 7. Lock-Free Data Structures
```python
import threading
from typing import Any, Optional

class LockFreeStack:
    """Lock-free stack using compare-and-swap"""
    def __init__(self):
        self.head = None
    
    class Node:
        def __init__(self, value: Any, next_node=None):
            self.value = value
            self.next = next_node
    
    def push(self, value: Any):
        while True:
            old_head = self.head
            new_node = self.Node(value, old_head)
            # Simulated CAS (actual implementation would use ctypes or similar)
            if self.head == old_head:
                self.head = new_node
                break
    
    def pop(self) -> Optional[Any]:
        while True:
            old_head = self.head
            if old_head is None:
                return None
            # Simulated CAS
            if self.head == old_head:
                self.head = old_head.next
                return old_head.value

class LockFreeQueue:
    """Lock-free queue using two stacks"""
    def __init__(self):
        self.in_stack = []
        self.out_stack = []
        self._lock = threading.Lock()  # For transition only
    
    def push(self, item):
        self.in_stack.append(item)
    
    def pop(self):
        if not self.out_stack:
            if not self.in_stack:
                return None
            # Move all items from in_stack to out_stack
            with self._lock:
                if not self.out_stack:
                    self.out_stack = self.in_stack[::-1]
                    self.in_stack = []
        return self.out_stack.pop() if self.out_stack else None

# Compare-and-swap simulation (for illustration)
def compare_and_swap(obj, expected, new_value):
    """Simulated CAS operation"""
    if obj.value == expected:
        obj.value = new_value
        return True
    return False
```

## Common Patterns

### Pattern 1: Proper Lock Ordering
```python
import threading

# Global lock ordering to prevent deadlocks
lock_order = {
    'database': 0,
    'cache': 1,
    'file_system': 2
}

locks = {name: threading.Lock() for name in lock_order}

def get_locks(*names):
    """Get locks in consistent order"""
    sorted_names = sorted(names, key=lambda n: lock_order[n])
    return [locks[name] for name in sorted_names]

def safe_operation():
    with get_locks('cache', 'database')[0]:  # Always same order
        with get_locks('cache', 'database')[1]:
            # Safe to use both resources
            pass
```

### Pattern 2: Async Context Manager for Locks
```python
import asyncio
from contextlib import asynccontextmanager

class AsyncLock:
    def __init__(self):
        self._lock = asyncio.Lock()
    
    @asynccontextmanager
    async def acquire(self):
        async with self._lock:
            yield self

# Usage
async_lock = AsyncLock()

async def safe_async_operation():
    async with async_lock.acquire():
        # Critical section
        pass
```

### Pattern 3: Thread Pool for CPU-bound Work
```python
import concurrent.futures
from typing import List

def process_item(item):
    # CPU-intensive work
    return item * 2

def parallel_process(items: List) -> List:
    with concurrent.futures.ThreadPoolExecutor(max_workers=8) as executor:
        results = list(executor.map(process_item, items))
    return results

# For IO-bound work
async def parallel_io(items):
    with concurrent.futures.ThreadPoolExecutor(max_workers=32) as executor:
        loop = asyncio.get_event_loop()
        tasks = [
            loop.run_in_executor(executor, process_item, item)
            for item in items
        ]
        return await asyncio.gather(*tasks)
```

### Pattern 4: Producer-Consumer with Bounded Buffer
```python
import queue
import threading
from typing import Any

class BoundedBuffer:
    def __init__(self, max_size: int):
        self.queue = queue.Queue(maxsize=max_size)
        self.items_count = 0
        self.lock = threading.Lock()
    
    def put(self, item: Any):
        self.queue.put(item)
        with self.lock:
            self.items_count += 1
    
    def get(self) -> Any:
        item = self.queue.get()
        with self.lock:
            self.items_count -= 1
        return item
    
    @property
    def size(self) -> int:
        with self.lock:
            return self.items_count

# Usage
buffer = BoundedBuffer(max_size=100)

def producer():
    for i in range(1000):
        buffer.put(i)

def consumer():
    for _ in range(1000):
        item = buffer.get()
        process(item)

threads = [
    threading.Thread(target=producer),
    threading.Thread(target=consumer)
]
```

### Pattern 5: Async Generator for Streaming
```python
import asyncio
from typing import AsyncGenerator

async def async_range(start: int, stop: int) -> AsyncGenerator[int, None]:
    """Async generator for streaming data"""
    for i in range(start, stop):
        yield i
        await asyncio.sleep(0)  # Yield control

async def process_stream():
    async for item in async_range(0, 100):
        print(f"Processing {item}")
        await asyncio.sleep(0.1)  # Simulate async work

# Usage
asyncio.run(process_stream())
```

## Edge Cases & Pitfalls

1. **Non-deterministic test failures**: Tests that pass sometimes and fail other times
2. **ABA problem**: Value changes from A to B and back to A, CAS doesn't detect it
3. **False sharing**: CPU cache line conflicts between threads
4. **Memory barriers**: Missing memory barriers causing visibility issues
5. **Signal handling in async**: Async code not handling signals properly
6. **Thread-local storage**: Using thread-local storage incorrectly
7. **Fork safety**: fork() in multithreaded programs causing deadlocks
8. **GIL limitations**: Python's GIL limiting true parallelism
9. **Async context switching**: Incorrect assumptions about execution order
10. **Future/Task cancellation**: Not handling task cancellation properly
11. **Event loop blocking**: Running blocking code in async event loop
12. **Race condition in lazy initialization**: Double-checked locking issues
13. **Callback hell**: Nested callbacks making code unreadable
14. **Resource leaks**: Not properly cleaning up threads/connections
15. **Priority inversion**: Low-priority thread holding lock needed by high-priority thread

## Integration with Other Skills

| Skill | Integration Type | Description |
|-------|-----------------|-------------|
| debugging | Input | General debugging principles apply |
| performance-analysis | Collaboration | Concurrency affects performance |
| testing | Output | Test concurrent code thoroughly |
| code-review | Collaboration | Review for concurrency issues |
| deployment | Input | Deploy with proper configuration |
| security | Collaboration | Concurrency can introduce security issues |
| ai-agent-orchestration | Input | Multi-agent coordination patterns |
| documentation | Output | Document concurrency patterns |

## Output Format Templates

### Template 1: Concurrency Issue Report
```markdown
# Concurrency Issue Report

## Issue Summary
- **Type**: [Race Condition/Deadlock/Livelock/Starvation]
- **Severity**: [Critical/High/Medium/Low]
- **Reproducibility**: [Always/Sometimes/Rare]
- **Affected Component**: [Service/Module/Function]

## Symptoms
- [ ] Non-deterministic failures
- [ ] Program hangs
- [ ] High CPU usage
- [ ] Incorrect results
- [ ] Exception: [Specific error message]

## Reproduction Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Root Cause Analysis
- **Shared State**: [What shared state is involved]
- **Synchronization**: [What synchronization is missing/incorrect]
- **Execution Order**: [What execution order causes the issue]

## Thread/Task Dump
```
Thread 1: [state]
Thread 2: [state]
Thread 3: [state]
```

## Fix
- **Solution**: [Description of fix]
- **Code Changes**: [Files/functions modified]
- **Testing**: [How to verify the fix]

## Prevention
- [ ] Add proper synchronization
- [ ] Document concurrency assumptions
- [ ] Add stress tests
```

### Template 2: Deadlock Analysis
```markdown
# Deadlock Analysis Report

## Deadlock Detected
- **Time**: [When deadlock occurred]
- **Threads Involved**: [Thread IDs]
- **Locks Involved**: [Lock identifiers]

## Lock Dependency Graph
```
Thread 1: Lock A → Lock B
Thread 2: Lock B → Lock A
Cycle detected: A → B → A
```

## Thread Stack Traces
### Thread 1
```
at com.example.Class.method1(Class.java:42)
- waiting to lock <0x000000076ab12340> (a java.lang.Object)
- locked <0x000000076ab12348> (a java.lang.Object)
```

### Thread 2
```
at com.example.Class.method2(Class.java:56)
- waiting to lock <0x000000076ab12348> (a java.lang.Object)
- locked <0x000000076ab12340> (a java.lang.Object)
```

## Resolution
- **Immediate Fix**: [How to break the deadlock]
- **Long-term Fix**: [Prevent recurrence]
- **Lock Ordering**: [Define consistent lock ordering]
```

### Template 3: Async Code Review Checklist
```markdown
# Async Code Review Checklist

## Correctness
- [ ] All async functions are properly awaited
- [ ] No blocking calls in async context
- [ ] Proper exception handling in async tasks
- [ ] Tasks are properly cancelled when needed
- [ ] No race conditions in async code

## Performance
- [ ] Parallel execution where possible
- [ ] No unnecessary sequential awaits
- [ ] Proper use of asyncio.gather vs sequential
- [ ] Timeout handling for I/O operations

## Error Handling
- [ ] Exceptions are caught and handled
- [ ] Error propagation is correct
- [ ] Partial failure handling in gather
- [ ] Resource cleanup on error

## Testing
- [ ] Tests for async code exist
- [ ] Tests cover edge cases
- [ ] Stress tests for concurrency
- [ ] Tests are not flaky
```

### Template 4: Thread Safety Review
```markdown
# Thread Safety Review

## Shared State Inventory
| Resource | Type | Access Pattern | Synchronization |
|----------|------|----------------|-----------------|
| cache | dict | R/W | Lock |
| counter | int | R/W | Atomic |
| queue | Queue | R/W | Thread-safe |

## Synchronization Analysis
- [ ] All shared mutable state is protected
- [ ] Lock ordering is consistent
- [ ] No lock contention in hot paths
- [ ] Proper use of reentrant locks where needed
- [ ] No orphaned locks (locks never released)

## Testing
- [ ] Stress tests with multiple threads
- [ ] Race condition detection tools used
- [ ] Thread sanitizer enabled
- [ ] Load testing performed
```

## Rules

1. **ALWAYS** document concurrency assumptions and invariants
2. **ALWAYS** use consistent lock ordering to prevent deadlocks
3. **ALWAYS** minimize the scope of locks (hold locks briefly)
4. **NEVER** call unknown code while holding a lock
5. **ALWAYS** use context managers or try-finally for lock release
6. **ALWAYS** test concurrent code under load
7. **NEVER** use sleep as a synchronization mechanism
8. **ALWAYS** prefer message passing over shared state
9. **ALWAYS** handle task cancellation in async code
10. **NEVER** block the async event loop with synchronous operations
11. **ALWAYS** use atomic operations when available
12. **ALWAYS** add timeouts to lock acquisition
13. **ALWAYS** profile for lock contention
14. **NEVER** assume execution order in concurrent code
15. **ALWAYS** use thread-safe data structures

## Anti-Patterns

- ❌ Using sleep to "fix" race conditions
- ❌ Adding more locks without understanding the issue
- ❌ Ignoring non-deterministic test failures
- ❌ Holding locks while doing I/O
- ❌ Using global mutable state without synchronization
- ❌ Not handling task cancellation in async code
- ❌ Blocking the async event loop
- ❌ Using locks in async code (use asyncio.Lock instead)
- ❌ Not testing under realistic concurrency
- ❌ Assuming single-threaded execution in concurrent code
- ❌ Using reentrant locks when simple locks would work
- ❌ Not profiling for lock contention
- ❌ Ignoring thread safety in library code
- ❌ Using Thread.sleep for synchronization
- ❌ Not cleaning up resources on error

## Skill Interactions

- ← debugging: General debugging principles apply
- → performance-analysis: Concurrency affects performance
- → testing: Test concurrent code thoroughly
- → code-review: Review for concurrency issues
- → deployment: Deploy with proper configuration
- → security: Concurrency can introduce security issues
- → ai-agent-orchestration: Multi-agent coordination patterns
- → documentation: Document concurrency patterns
