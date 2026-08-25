---
name: algorithm-design
description: >-
  Expert guidance on algorithms, data structures, and complexity analysis for
  production systems. TRIGGERS: algorithm, data structures, big-O, sorting,
  graph, dynamic programming, greedy, complexity analysis, time complexity,
  space complexity, optimize algorithm, binary search, BFS, DFS, hash table,
  tree traversal, backtracking, الگوریتم, ساختمان داده, پیچیدگی, مرتب‌سازی,
  گراف, بهینه‌سازی, برنامه‌نویسی پویا, الگوریتم حریصانه, جستجو, بازگشتی,
  算法, 数据结构, 复杂度, 排序, 图论, 动态规划, 贪心, 优化, 二分查找, 树
priority: P0
dependencies: [code-migration, regex]
conflicts: []
---

# Algorithm Design Skill

## Overview

This skill provides expert-level guidance on designing, analyzing, and implementing algorithms and data structures for real-world software engineering. It covers formal complexity analysis (asymptotic notation, amortized analysis), classical algorithm families (sorting, searching, graph traversal, dynamic programming, greedy methods, divide-and-conquer), and practical techniques for selecting the right approach under production constraints. All recommendations prioritize correctness, clarity, and measurable performance — not academic novelty.

## When to Use This Skill

- Choosing or comparing algorithms for a specific problem (e.g., sort, search, path-finding, scheduling).
- Analyzing time/space complexity of existing or proposed code paths.
- Selecting the optimal data structure for a workload (hash map vs. tree, array vs. linked list, heap vs. balanced BST).
- Implementing graph algorithms (BFS, DFS, shortest path, MST, topological sort, network flow).
- Designing dynamic programming solutions for optimization, counting, or sequence problems.
- Applying greedy strategies when optimal substructure and greedy-choice property hold.
- Interview preparation or technical assessment requiring algorithmic reasoning.
- Refactoring slow hot-path code where algorithmic improvements outperform micro-optimization.
- Evaluating trade-offs between correctness, performance, and implementation complexity.

## When NOT to Use This Skill

- Pure UI/front-end work with no algorithmic component (CSS layout, component composition).
- Routine CRUD operations where framework abstractions are sufficient.
- DevOps infrastructure tasks (CI/CD pipelines, container orchestration) unless scheduling is involved.
- Database query optimization (use the database-design or query-optimization skill instead).
- Machine learning model selection (use the ml-engineering skill).
- Simple string processing that can be handled by the regex skill alone.
- Network protocol design (use the networking skill).

## Workflow

### Step 1 — Problem Analysis

Before writing any code, decompose the problem formally:

```
Input:       What data do we receive? Size, type, constraints?
Output:      What must we produce? Exact or approximate?
Constraints: Time budget? Memory limit? Real-time?
Special:     Online (streaming) vs offline? Adversarial input?
```

**Example — Problem Statement:**

> Given N points in a 2D plane, find the pair with the smallest Euclidean distance.

Analysis:
- Input: N points, each with (x, y) coordinates. N can be up to 200,000.
- Output: Minimum distance value (or the pair itself).
- Constraint: O(N²) brute-force is too slow for N = 200,000.
- Special: Points may share coordinates.

### Step 2 — Complexity Baseline

Establish the naive solution's complexity to set a target:

```
Brute-force:  Check all C(N,2) = N*(N-1)/2 pairs → O(N²) time, O(1) space.
Target:       O(N log N) time is achievable with a sweep-line + divide-and-conquer approach.
```

### Step 3 — Algorithm Selection

Match problem properties to algorithm families:

| Property | Candidate Algorithms |
|---|---|
| Optimal substructure + overlapping subproblems | Dynamic Programming |
| Greedy-choice property | Greedy algorithms |
| Decomposable into independent subproblems | Divide and Conquer |
| Search space with ordering | Binary Search variants |
| Connectivity / paths | Graph algorithms (BFS, DFS, Union-Find) |
| Partial ordering | Topological sort |
| Optimization over subsets | Branch and Bound, DP over subsets |

### Step 4 — Data Structure Selection

```
Frequent lookup by key        → Hash Map (O(1) average)
Ordered traversal             → Balanced BST / Red-Black Tree (O(log N))
Priority extraction           → Binary Heap (O(log N) insert, O(1) find-min)
Frequent prefix/suffix ops    → Trie / Suffix Array
Disjoint set merging          → Union-Find with path compression + union by rank
2D range queries              → Segment Tree / Fenwick Tree
Sliding window / deque ops    → Doubly-ended queue
```

### Step 5 — Implementation

Write the implementation with clear variable naming, proper error handling, and inline complexity comments.

```python
import math
from typing import List, Tuple

def closest_pair(points: List[Tuple[float, float]]) -> float:
    """
    Find the minimum Euclidean distance between any two points.
    Uses divide-and-conquer with a sweep-line optimization.
    
    Time:  O(N log^2 N) — O(N log N) merge with bounded strip scan.
    Space: O(N) for the sorted auxiliary array.
    """
    def dist(a, b):
        return math.hypot(a[0] - b[0], a[1] - b[1])

    pts = sorted(points, key=lambda p: p[0])
    
    def _solve(sorted_x):
        n = len(sorted_x)
        if n <= 3:
            return min(dist(sorted_x[i], sorted_x[j])
                       for i in range(n) for j in range(i + 1, n))
        
        mid = n // 2
        mid_x = sorted_x[mid][0]
        
        left = sorted_x[:mid]
        right = sorted_x[mid:]
        
        dl = _solve(left)
        dr = _solve(right)
        d = min(dl, dr)
        
        # Build strip: points within distance d of the dividing line
        strip = [p for p in sorted_x if abs(p[0] - mid_x) < d]
        strip.sort(key=lambda p: p[1])  # Sort by y-coordinate
        
        # Scan strip — at most 7 comparisons per point
        min_d = d
        for i in range(len(strip)):
            j = i + 1
            while j < len(strip) and (strip[j][1] - strip[i][1]) < min_d:
                min_d = min(min_d, dist(strip[i], strip[j]))
                j += 1
        
        return min_d
    
    return _solve(pts)


# --- Example usage ---
if __name__ == "__main__":
    pts = [(2, 3), (12, 30), (40, 50), (5, 1), (12, 10), (3, 4)]
    print(f"Minimum distance: {closest_pair(pts):.4f}")
```

### Step 6 — Verification

1. **Correctness**: Test with known inputs, edge cases (empty, single element, all identical).
2. **Complexity**: Confirm with profiling (e.g., `timeit`, `cProfile`, benchmark harness).
3. **Stress testing**: Generate random inputs and compare against brute-force for small N.
4. **Invariant checking**: Assert loop invariants and recursion invariants in debug mode.

```python
def test_closest_pair():
    """Verify correctness against brute-force on random small inputs."""
    import random
    for _ in range(100):
        pts = [(random.uniform(-1000, 1000), random.uniform(-1000, 1000))
               for _ in range(50)]
        algo = closest_pair(pts)
        brute = min(dist(pts[i], pts[j])
                    for i in range(len(pts)) for j in range(i+1, len(pts)))
        assert abs(algo - brute) < 1e-6
    print("All tests passed.")

def dist(a, b):
    return math.hypot(a[0]-b[0], a[1]-b[1])

test_closest_pair()
```

## Advanced Techniques (7 Techniques)

### 1. Amortized Analysis and Potential Methods

Amortized analysis provides tight bounds on sequences of operations rather than individual ones. The potential method assigns a "potential" to the data structure state, converting expensive operations into cheap amortized ones.

```python
class DynamicArray:
    """
    Dynamic array (like Python list) with amortized O(1) append.
    
    When the array is full, we double its capacity. Each copy costs O(n),
    but each element is copied at most log2(n) times over n appends.
    
    Amortized cost per append: O(1).
    Total cost for n appends: O(n) actual work, O(n) amortized.
    """
    def __init__(self, capacity=4):
        self._data = [None] * capacity
        self._size = 0
        self._capacity = capacity

    def append(self, value):
        if self._size == self._capacity:
            self._resize(2 * self._capacity)
        self._data[self._size] = value
        self._size += 1

    def _resize(self, new_capacity):
        new_data = [None] * new_capacity
        for i in range(self._size):
            new_data[i] = self._data[i]
        self._data = new_data
        self._capacity = new_capacity
```

### 2. Bit Manipulation for Algorithmic Optimization

Bit tricks can reduce constant factors dramatically for set operations, parity checks, and numeric puzzles.

```python
def find_two_non_repeating(nums):
    """
    Find two elements that appear exactly once in an array where
    all other elements appear exactly twice.
    
    Time: O(N), Space: O(1)
    
    Key insight: XOR of two non-repeating numbers gives a number
    where each set bit distinguishes one from the other.
    """
    xor_all = 0
    for num in nums:
        xor_all ^= num
    
    # Find any set bit (rightmost)
    diff_bit = xor_all & (-xor_all)
    
    # Partition into two groups based on that bit
    a, b = 0, 0
    for num in nums:
        if num & diff_bit:
            a ^= num
        else:
            b ^= num
    
    return a, b

result = find_two_non_repeating([1, 2, 3, 2, 1, 4])
print(f"Non-repeating: {sorted(result)}")  # [3, 4]
```

### 3. Union-Find with Path Compression and Union by Rank

Union-Find (Disjoint Set Union) supports near-O(1) merge and find operations using two classic optimizations.

```python
class UnionFind:
    """
    Disjoint Set Union with path compression and union by rank.
    
    Amortized time per operation: O(alpha(N)) — inverse Ackermann, effectively constant.
    """
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n
        self.components = n

    def find(self, x):
        """Find representative with path compression."""
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        """Union by rank. Returns True if a merge occurred."""
        rx, ry = self.find(x), self.find(y)
        if rx == ry:
            return False
        if self.rank[rx] < self.rank[ry]:
            rx, ry = ry, rx
        self.parent[ry] = rx
        if self.rank[rx] == self.rank[ry]:
            self.rank[rx] += 1
        self.components -= 1
        return True


# Example: Detect cycle in undirected graph
def has_cycle(n, edges):
    uf = UnionFind(n)
    for u, v in edges:
        if not uf.union(u, v):
            return True  # u and v already connected — cycle
    return False

print(has_cycle(4, [(0,1),(1,2),(2,3),(3,0)]))  # True
print(has_cycle(4, [(0,1),(1,2),(2,3)]))          # False
```

### 4. Segment Tree for Range Queries

Segment trees answer range queries (sum, min, max, GCD) and range updates in O(log N) time.

```python
class SegmentTree:
    """
    Segment tree for range sum queries with point updates.
    
    Build: O(N), Query: O(log N), Update: O(log N)
    Space: O(4N)
    """
    def __init__(self, data):
        self.n = len(data)
        self.tree = [0] * (4 * self.n)
        self._build(data, 1, 0, self.n - 1)

    def _build(self, data, node, start, end):
        if start == end:
            self.tree[node] = data[start]
            return
        mid = (start + end) // 2
        self._build(data, 2 * node, start, mid)
        self._build(data, 2 * node + 1, mid + 1, end)
        self.tree[node] = self.tree[2 * node] + self.tree[2 * node + 1]

    def update(self, idx, val, node=1, start=0, end=None):
        if end is None:
            end = self.n - 1
        if start == end:
            self.tree[node] = val
            return
        mid = (start + end) // 2
        if idx <= mid:
            self.update(idx, val, 2 * node, start, mid)
        else:
            self.update(idx, val, 2 * node + 1, mid + 1, end)
        self.tree[node] = self.tree[2 * node] + self.tree[2 * node + 1]

    def query(self, l, r, node=1, start=0, end=None):
        """Range sum query on [l, r]."""
        if end is None:
            end = self.n - 1
        if r < start or l > end:
            return 0
        if l <= start and end <= r:
            return self.tree[node]
        mid = (start + end) // 2
        return self.query(l, r, 2 * node, start, mid) + \
               self.query(l, r, 2 * node + 1, mid + 1, end)


data = [1, 3, 5, 7, 9, 11]
st = SegmentTree(data)
print(st.query(1, 3))  # 3+5+7 = 15
st.update(2, 10)       # data[2] = 10
print(st.query(1, 3))  # 3+10+7 = 20
```

### 5. Sliding Window with Monotonic Deque

Monotonic deques solve the "sliding window maximum/minimum" problem in O(N) time — something a heap-based approach can only achieve in O(N log K).

```python
from collections import deque

def sliding_window_max(nums, k):
    """
    Find the maximum in every contiguous window of size k.
    
    Time: O(N), Space: O(K)
    
    Maintains a deque of indices in decreasing order of values.
    The front always holds the current window's maximum index.
    """
    result = []
    dq = deque()

    for i, val in enumerate(nums):
        while dq and dq[0] < i - k + 1:
            dq.popleft()
        while dq and nums[dq[-1]] < val:
            dq.pop()
        dq.append(i)
        if i >= k - 1:
            result.append(nums[dq[0]])
    
    return result


print(sliding_window_max([1, 3, -1, -3, 5, 3, 6, 7], 3))
# Output: [3, 3, 5, 5, 6, 7]
```

### 6. Topological Sort with Cycle Detection

Topological sort orders nodes in a DAG such that all edges point forward. It detects cycles (impossible in a DAG) and is essential for dependency resolution, task scheduling, and build systems.

```python
from collections import defaultdict, deque

def topological_sort(n, edges):
    """
    Kahn's algorithm for topological sorting.
    
    Returns the topological order, or None if a cycle exists.
    Time: O(V + E), Space: O(V + E)
    """
    graph = defaultdict(list)
    in_degree = [0] * n

    for u, v in edges:
        graph[u].append(v)
        in_degree[v] += 1

    queue = deque([i for i in range(n) if in_degree[i] == 0])
    order = []

    while queue:
        node = queue.popleft()
        order.append(node)
        for neighbor in graph[node]:
            in_degree[neighbor] -= 1
            if in_degree[neighbor] == 0:
                queue.append(neighbor)

    if len(order) != n:
        return None  # Cycle detected

    return order


# Example: Course schedule
prerequisites = [(1, 0), (2, 0), (3, 1), (3, 2)]
order = topological_sort(4, prerequisites)
print(f"Course order: {order}")  # e.g., [0, 1, 2, 3]
```

### 7. Trie for Prefix-Based Operations

Tries provide O(M) lookup for strings of length M, independent of dataset size. They're essential for autocomplete, spell-check, IP routing, and word games.

```python
class TrieNode:
    __slots__ = ('children', 'is_end', 'count')

    def __init__(self):
        self.children = {}
        self.is_end = False
        self.count = 0


class Trie:
    """
    Prefix tree with insert, search, starts_with, and count operations.
    Time per operation: O(M) where M is the string length.
    """
    def __init__(self):
        self.root = TrieNode()

    def insert(self, word):
        node = self.root
        for char in word:
            if char not in node.children:
                node.children[char] = TrieNode()
            node = node.children[char]
            node.count += 1
        node.is_end = True

    def search(self, word):
        node = self._find_prefix(word)
        return node is not None and node.is_end

    def starts_with(self, prefix):
        return self._find_prefix(prefix) is not None

    def word_count_with_prefix(self, prefix):
        node = self._find_prefix(prefix)
        return node.count if node else 0

    def _find_prefix(self, prefix):
        node = self.root
        for char in prefix:
            if char not in node.children:
                return None
            node = node.children[char]
        return node


trie = Trie()
for word in ["apple", "app", "application", "bat", "ball", "batch"]:
    trie.insert(word)

print(f"'apple' exists: {trie.search('apple')}")              # True
print(f"'app' exists: {trie.search('app')}")                    # True
print(f"'ap' exists: {trie.search('ap')}")                      # False
print(f"Words starting with 'app': {trie.word_count_with_prefix('app')}")  # 3
```

## Common Patterns

### Pattern 1 — Two-Pointer Technique

Two pointers scan from both ends or at different speeds, reducing quadratic searches to linear.

```python
def two_sum_sorted(nums, target):
    """
    Find two numbers in a sorted array that sum to target.
    Time: O(N), Space: O(1)
    """
    left, right = 0, len(nums) - 1
    while left < right:
        current = nums[left] + nums[right]
        if current == target:
            return left, right
        elif current < target:
            left += 1
        else:
            right -= 1
    return -1, -1


def max_area(height):
    """
    Find two lines that together with the x-axis form a container
    holding the most water.
    Time: O(N), Space: O(1)
    """
    left, right = 0, len(height) - 1
    max_water = 0
    while left < right:
        water = min(height[left], height[right]) * (right - left)
        max_water = max(max_water, water)
        if height[left] < height[right]:
            left += 1
        else:
            right -= 1
    return max_water

print(max_area([1, 8, 6, 2, 5, 4, 8, 3, 7]))  # 49
```

### Pattern 2 — Binary Search Variants

Binary search goes far beyond simple lookup — it finds boundaries, answers monotonic predicates, and solves optimization problems.

```python
def binary_search_boundary(arr, target):
    """Find the leftmost index of target (or insertion point)."""
    lo, hi = 0, len(arr)
    while lo < hi:
        mid = (lo + hi) // 2
        if arr[mid] < target:
            lo = mid + 1
        else:
            hi = mid
    return lo


def binary_search_on_answer(low, high, is_valid):
    """
    Binary search on a monotonic predicate to find the optimal value.
    Useful for: minimum feasible value, maximum feasible value, etc.
    """
    while low < high:
        mid = (low + high) // 2
        if is_valid(mid):
            high = mid
        else:
            low = mid + 1
    return low


# Example: Find minimum capacity to ship packages within D days
def min_ship_capacity(weights, days):
    def can_ship(capacity):
        current_load, day_count = 0, 1
        for w in weights:
            if current_load + w > capacity:
                day_count += 1
                current_load = w
            else:
                current_load += w
        return day_count <= days
    
    lo = max(weights)
    hi = sum(weights)
    return binary_search_on_answer(lo, hi, can_ship)

print(min_ship_capacity([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 5))  # 15
```

### Pattern 3 — Dynamic Programming on Arrays

Standard DP patterns: knapsack, LIS, LCS, and house robber.

```python
def knapsack_01(weights, values, capacity):
    """
    0/1 Knapsack: maximize total value within weight capacity.
    Time: O(N * W), Space: O(W) with rolling array.
    """
    dp = [0] * (capacity + 1)
    for i in range(len(weights)):
        for w in range(capacity, weights[i] - 1, -1):
            dp[w] = max(dp[w], dp[w - weights[i]] + values[i])
    return dp[capacity]


def longest_increasing_subsequence(nums):
    """
    Length of longest strictly increasing subsequence.
    Time: O(N log N) using patience sorting with binary search.
    """
    import bisect
    tails = []
    for num in nums:
        pos = bisect.bisect_left(tails, num)
        if pos == len(tails):
            tails.append(num)
        else:
            tails[pos] = num
    return len(tails)

print(knapsack_01([2, 3, 4, 5], [3, 4, 5, 6], 8))  # 10
print(longest_increasing_subsequence([10, 9, 2, 5, 3, 7, 101, 18]))  # 4
```

### Pattern 4 — Graph BFS/DFS Templates

Standard graph traversal patterns for connected components, shortest paths (unweighted), and cycle detection.

```python
from collections import defaultdict, deque

class Graph:
    def __init__(self, n, directed=False):
        self.n = n
        self.adj = defaultdict(list)
        self.directed = directed

    def add_edge(self, u, v):
        self.adj[u].append(v)
        if not self.directed:
            self.adj[v].append(u)

    def bfs(self, start):
        """BFS traversal returning distances from start."""
        dist = [-1] * self.n
        dist[start] = 0
        queue = deque([start])
        while queue:
            node = queue.popleft()
            for neighbor in self.adj[node]:
                if dist[neighbor] == -1:
                    dist[neighbor] = dist[node] + 1
                    queue.append(neighbor)
        return dist

    def dfs_iterative(self, start):
        """Iterative DFS using an explicit stack."""
        visited = [False] * self.n
        stack = [start]
        order = []
        while stack:
            node = stack.pop()
            if visited[node]:
                continue
            visited[node] = True
            order.append(node)
            for neighbor in reversed(self.adj[node]):
                if not visited[neighbor]:
                    stack.append(neighbor)
        return order

    def has_cycle_undirected(self):
        """Detect cycle in an undirected graph using BFS coloring."""
        color = [0] * self.n
        for start in range(self.n):
            if color[start] != 0:
                continue
            color[start] = 1
            queue = deque([start])
            while queue:
                node = queue.popleft()
                for neighbor in self.adj[node]:
                    if color[neighbor] == 0:
                        color[neighbor] = 3 - color[node]
                        queue.append(neighbor)
                    elif color[neighbor] == color[node]:
                        return True
        return False


g = Graph(6)
for u, v in [(0,1),(0,2),(1,3),(2,3),(2,4),(4,5)]:
    g.add_edge(u, v)

print(f"Distances from 0: {g.bfs(0)}")  # [0, 1, 1, 2, 2, 3]
print(f"DFS from 0: {g.dfs_iterative(0)}")
```

### Pattern 5 — Greedy Algorithm with Exchange Argument Proof

Greedy algorithms make locally optimal choices at each step. The key is proving correctness via the exchange argument.

```python
def activity_selection(activities):
    """
    Activity Selection Problem: select maximum non-overlapping activities.
    
    Greedy choice: pick activity with earliest finish time that doesn't conflict.
    
    Proof sketch (exchange argument): If an optimal solution doesn't include
    the earliest-finishing activity, we can swap it in without reducing
    the total count.
    
    Time: O(N log N) for sorting, O(N) for selection.
    """
    sorted_acts = sorted(activities, key=lambda x: x[1])
    selected = [sorted_acts[0]]
    last_finish = sorted_acts[0][1]

    for act in sorted_acts[1:]:
        if act[0] >= last_finish:
            selected.append(act)
            last_finish = act[1]

    return selected


activities = [(1,4), (3,5), (0,6), (5,7), (3,8), (5,9), (6,10), (8,11)]
selected = activity_selection(activities)
print(f"Selected activities: {selected}")
# Output: [(1,4), (5,7), (8,11)]
```

### Pattern 6 — Sparse Table for Static Range Queries

Sparse tables answer idempotent range queries (min, max, GCD) in O(1) after O(N log N) preprocessing. Ideal for read-heavy workloads.

```python
import math

class SparseTable:
    """
    Sparse Table for range minimum queries (RMQ).
    
    Preprocessing: O(N log N), Query: O(1) using idempotent property.
    Only works for idempotent operations (min, max, gcd).
    """
    def __init__(self, data):
        n = len(data)
        k = math.floor(math.log2(n)) + 1
        
        self.st = [[0] * n for _ in range(k)]
        self.st[0] = data[:]
        self.log = [0] * (n + 1)
        
        for i in range(2, n + 1):
            self.log[i] = self.log[i // 2] + 1
        
        for j in range(1, k):
            for i in range(n - (1 << j) + 1):
                self.st[j][i] = min(self.st[j-1][i],
                                     self.st[j-1][i + (1 << (j-1))])

    def query(self, l, r):
        """Range minimum query on [l, r] in O(1)."""
        j = self.log[r - l + 1]
        return min(self.st[j][l], self.st[j][r - (1 << j) + 1])


data = [2, 1, 5, 3, 4, 6, 8, 7]
st = SparseTable(data)
print(st.query(1, 5))  # min(1,5,3,4,6) = 1
print(st.query(4, 7))  # min(4,6,8,7) = 4
```

### Pattern 7 — Memoized Recursion vs Tabulation

Two approaches to DP: top-down (memoization) and bottom-up (tabulation). Each has trade-offs.

```python
from functools import lru_cache

def fibonacci_memo(n):
    """Top-down DP with memoization. Easy to write, natural recursion."""
    @lru_cache(maxsize=None)
    def fib(k):
        if k <= 1:
            return k
        return fib(k - 1) + fib(k - 2)
    return fib(n)


def fibonacci_tab(n):
    """Bottom-up DP with tabulation. Better cache behavior, no stack overhead."""
    if n <= 1:
        return n
    dp = [0] * (n + 1)
    dp[1] = 1
    for i in range(2, n + 1):
        dp[i] = dp[i - 1] + dp[i - 2]
    return dp[n]


def fibonacci_optimized(n):
    """Space-optimized tabulation. O(1) space."""
    if n <= 1:
        return n
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b

for fib_func in [fibonacci_memo, fibonacci_tab, fibonacci_optimized]:
    print(f"{fib_func.__name__}(50) = {fib_func(50)}")
# 12586269025
```

## Edge Cases & Pitfalls

### 1. Off-by-One Errors in Binary Search
Binary search's most common bug is the loop condition and mid calculation. Using `lo < hi` with `lo = mid + 1` and `hi = mid` is the safest convention. Never mix half-open and closed interval conventions within the same function.

### 2. Integer Overflow in Mid Calculation
In languages like C/C++/Java, `(lo + hi) / 2` can overflow when both values are large. Always use `lo + (hi - lo) / 2`. In Python this is not an issue due to arbitrary-precision integers.

### 3. Negative Modulo in Hash Functions
Python's `%` operator always returns non-negative results for positive divisors, but C++/Java's `%` can return negative values. When building hash tables or circular buffers, ensure the index is `(x % N + N) % N`.

### 4. Floating Point Comparisons
Never use `==` to compare floating point numbers. Use `abs(a - b) < epsilon` with an appropriate epsilon value (typically 1e-9 for competitive programming, or relative epsilon for scientific computing).

### 5. Stack Overflow from Deep Recursion
Recursive solutions with depth > 10,000 will cause stack overflow in most environments. Convert to iterative with an explicit stack, or use tail-call optimization where the language supports it.

### 6. Uninitialized Variables in Graph Algorithms
When implementing BFS/DFS, always mark nodes as visited when they're pushed to the queue/stack, not when they're popped. Otherwise, the same node can be added multiple times, causing exponential blowup.

### 7. Modifying an Array While Iterating
Iterating over a list and removing elements causes index shifting, skipping elements. Use list comprehensions to create filtered copies, or iterate in reverse when removing.

### 8. Confusing Assignment and Equality in Conditions
A classic bug in C-family languages: `if (x = 5)` instead of `if (x == 5)`. Use Yoda conditions (`if (5 == x)`) or better languages (Python) to avoid this class entirely.

### 9. Using Hash Maps When Order Matters
Hash maps (dicts) do not guarantee insertion order in all languages. In Python 3.7+ they do, but in C++ `std::unordered_map` and Java `HashMap` don't. Use ordered maps when iteration order matters.

### 10. Not Handling Empty Input
Algorithms that assume non-empty input crash on edge cases. Always handle: empty arrays, single-element arrays, all-identical elements, already-sorted/reverse-sorted input.

### 11. DP State Space Explosion
Defining DP states too broadly (e.g., tracking all possible subsets) leads to exponential time/space. Always minimize state dimensions by finding invariants or using bitmask compression.

### 12. Greedy Without Proof
Applying greedy heuristics without verifying the greedy-choice property and optimal substructure leads to wrong answers. Classic counterexample: coin change with arbitrary denominations is NOT solvable by greedy.

### 13. Mutable Default Arguments in Python
Using `def f(arr=[])` causes the list to be shared across all calls. Always use `def f(arr=None)` and initialize inside the function.

### 14. Incorrect Union-Find Rank Update
When merging two trees, only increment the rank of the root whose rank didn't change. Incorrect: always increment. This breaks the amortized complexity guarantee.

### 15. TLE from O(N^2) on Large Inputs
N = 200,000 with O(N^2) is 40 billion operations — far beyond any time limit. Always compute the complexity first. If the input is 10^5, aim for O(N log N) or better.

### 16. Not Considering Cache Locality
Array-based data structures have excellent cache locality; pointer-based structures (linked lists, trees with scattered nodes) cause cache misses. For performance-critical code, prefer arrays even if asymptotic complexity is the same.

## Integration with Other Skills

| Skill | When to Combine | How |
|---|---|---|
| code-migration | Porting algorithm implementations between languages | Preserve algorithmic correctness while adapting idioms (e.g., Java streams to Python comprehensions) |
| regex | Text processing that benefits from algorithmic insight | Use Aho-Corasick or KMP for multi-pattern matching instead of N independent regex passes |
| database-design | Optimizing query performance | Apply algorithmic thinking to index selection, join ordering, and query plan analysis |
| code-review | Reviewing algorithmic code | Verify complexity claims, check for off-by-one errors, validate edge case handling |
| performance-tuning | Profiling hot paths | Identify algorithmic bottlenecks (O(N^2) loops) before micro-optimizing |
| testing | Verifying algorithm correctness | Property-based testing, stress testing against brute-force, invariant checking |
| concurrency | Parallelizing algorithms | MapReduce patterns, parallel divide-and-conquer, lock-free data structures |
| system-design | Architecture with algorithmic components | Caching strategies (LRU), load balancing, consistent hashing, rate limiting |

## Output Format Templates

### Template 1 — Standard Algorithm Analysis

```markdown
## Problem: {Problem Name}

**Input**: {Description of input format and constraints}
**Output**: {Description of expected output}
**Time Complexity**: O(...) — {justification}
**Space Complexity**: O(...) — {justification}

### Algorithm
1. {Step 1}
2. {Step 2}
...

### Implementation
```{language}
{code}
```

### Tests
- Case 1: {input} → {expected output}
- Case 2: {edge case} → {expected output}
```

### Template 2 — Detailed Complexity Report

```markdown
## Complexity Analysis: {Function/Algorithm Name}

| Aspect | Complexity | Explanation |
|---|---|---|
| Time (Best) | O(...) | {when this occurs} |
| Time (Average) | O(...) | {justification} |
| Time (Worst) | O(...) | {justification} |
| Space | O(...) | {breakdown of memory usage} |
| Amortized | O(...) | {if applicable} |

### Bottleneck
{Identify the most expensive operation and suggest alternatives}

### Optimization Opportunities
1. {Suggestion with expected improvement}
```

### Template 3 — Quick Reference Card

```markdown
## {Algorithm Name} — Quick Reference

**Use when**: {one-line description}
**Time**: O(...) | **Space**: O(...)
**Key idea**: {one-sentence intuition}

**Implementation sketch**:
```{language}
{compact code}
```

**Watch out for**: {top 1-2 pitfalls}
```

### Template 4 — Agent-Friendly Structured Output

```json
{
  "algorithm": "{name}",
  "complexity": {
    "time": "O(...)",
    "space": "O(...)",
    "justification": "..."
  },
  "implementation": {
    "language": "{lang}",
    "code": "...",
    "dependencies": []
  },
  "edge_cases": ["...", "..."],
  "alternatives": ["..."],
  "references": ["..."]
}
```

## Rules

1. **Always state complexity** — Every algorithm recommendation must include time and space complexity with justification.
2. **Choose clarity over cleverness** — Optimize for readability first; apply advanced optimizations only when profiling confirms a bottleneck.
3. **Handle edge cases explicitly** — Empty inputs, single elements, identical elements, and already-sorted inputs must be tested.
4. **Verify correctness before optimizing** — A correct O(N^2) solution is preferable to a buggy O(N log N) one.
5. **Prefer standard library implementations** — Use `bisect`, `heapq`, `collections.deque`, `collections.Counter` before writing custom implementations.
6. **Profile before optimizing** — Use benchmarks to identify actual bottlenecks; don't guess.
7. **Consider cache performance** — Array-based structures often outperform pointer-based ones in practice due to cache locality.
8. **Document invariants** — Comment the key invariants your algorithm maintains; they're the first thing to break during refactoring.
9. **Test with random inputs** — Compare algorithmic solutions against brute-force for small inputs to catch subtle bugs.
10. **Know when to stop** — Not every problem needs the theoretically optimal algorithm; practical constraints (implementation time, maintenance cost, input size) matter.
11. **Use appropriate data structures** — The right data structure often matters more than the right algorithm; changing from a list to a heap can be the difference between O(N) and O(N log N).
12. **Prefer iterative over recursive for production** — Recursive solutions are elegant but risk stack overflow; convert to iterative for large inputs.
