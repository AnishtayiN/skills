---
name: algorithm-design
description: >-
  Design, analyze, and implement algorithms including sorting, searching, graph algorithms,
  dynamic programming, greedy algorithms, and complexity analysis (Big O).
  Use this skill when the user mentions algorithm, data structure, Big O, time complexity,
  space complexity, sorting, searching, graph algorithm, tree, hash table, dynamic programming,
  greedy algorithm, recursion, backtracking, binary search, BFS, DFS, linked list,
  stack, queue, heap, trie, or says الگوریتم, ساختمان داده, پیچیدگی زمانی, مرتب‌سازی,
  جستجو, برنامه‌نویسی پویا, الگوریتم حریصانه.
---

# Algorithm Design Skill — Data Structures, Complexity Analysis & Algorithm Patterns

## Overview

This skill covers algorithm design, data structure selection, complexity analysis (Big O notation), and common algorithmic patterns. It provides a systematic approach to analyzing problems, selecting the right algorithm, implementing it correctly, and optimizing for time/space. Covers sorting, searching, graph algorithms, dynamic programming, greedy algorithms, and interview-style problem solving.

## When to Use This Skill

- User needs to analyze time/space complexity of code
- User asks about the best algorithm for a problem
- User wants to implement a specific data structure
- User mentions Big O, sorting, searching, graph algorithms
- User needs to optimize a slow algorithm
- User asks about dynamic programming, greedy, or backtracking
- User mentions الگوریتم, ساختمان داده, or پیچیدگی زمانی

---

## Part 1: Complexity Analysis (Big O)

### Common Complexities

| Big O | Name | Example | Growth |
|-------|------|---------|--------|
| O(1) | Constant | Array access, hash lookup | Flat |
| O(log n) | Logarithmic | Binary search | Slow growth |
| O(n) | Linear | Array scan, single loop | Moderate |
| O(n log n) | Linearithmic | Merge sort, quicksort | Moderate-high |
| O(n²) | Quadratic | Nested loops, bubble sort | High |
| O(2ⁿ) | Exponential | Recursive Fibonacci | Explosive |
| O(n!) | Factorial | Brute force permutations | Unusable |

### Analysis Rules

```python
# O(1) — Constant
def get_first(arr):
    return arr[0]

# O(log n) — Logarithmic
def binary_search(arr, target):
    lo, hi = 0, len(arr) - 1
    while lo <= hi:
        mid = (lo + hi) // 2
        if arr[mid] == target: return mid
        elif arr[mid] < target: lo = mid + 1
        else: hi = mid - 1
    return -1

# O(n) — Linear
def find_max(arr):
    max_val = arr[0]
    for val in arr:
        if val > max_val:
            max_val = val
    return max_val

# O(n²) — Quadratic
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(0, n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]

# O(n log n) — Linearithmic
def merge_sort(arr):
    if len(arr) <= 1: return arr
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    return merge(left, right)

# O(2^n) — Exponential (BAD!)
def fibonacci(n):
    if n <= 1: return n
    return fibonacci(n-1) + fibonacci(n-2)
```

### Recurrence Relations

| Recurrence | Solution | Algorithm |
|-----------|----------|-----------|
| T(n) = T(n-1) + O(1) | O(n) | Linear scan |
| T(n) = T(n/2) + O(1) | O(log n) | Binary search |
| T(n) = 2T(n/2) + O(n) | O(n log n) | Merge sort |
| T(n) = 2T(n/2) + O(1) | O(n) | Tree traversal |
| T(n) = T(n-1) + T(n-2) + O(1) | O(2ⁿ) | Naive Fibonacci |

---

## Part 2: Data Structures

### Selection Guide

| Data Structure | Access | Search | Insert | Delete | Use Case |
|---------------|--------|--------|--------|--------|----------|
| **Array** | O(1) | O(n) | O(n) | O(n) | Static collections |
| **Linked List** | O(n) | O(n) | O(1) | O(1) | Frequent insert/delete |
| **Hash Table** | O(1) | O(1) | O(1) | O(1) | Key-value lookup |
| **BST** | O(log n) | O(log n) | O(log n) | O(log n) | Ordered data |
| **Heap** | O(1) max | O(n) | O(log n) | O(log n) | Priority queue |
| **Trie** | O(m) | O(m) | O(m) | O(m) | String prefix search |
| **Graph** | - | - | - | - | Relationships |

### Hash Table (Python dict)

```python
# O(1) average lookup
hash_map = {}
hash_map["key"] = "value"
value = hash_map["key"]  # O(1)
"key" in hash_map  # O(1)

# Collision handling: chaining or open addressing
# Python uses open addressing with probing
```

### Binary Search Tree

```python
class Node:
    def __init__(self, val):
        self.val = val
        self.left = None
        self.right = None

def insert(root, val):
    if not root:
        return Node(val)
    if val < root.val:
        root.left = insert(root.left, val)
    else:
        root.right = insert(root.right, val)
    return root

def search(root, val):
    if not root or root.val == val:
        return root
    if val < root.val:
        return search(root.left, val)
    return search(root.right, val)
```

### Trie (Prefix Tree)

```python
class TrieNode:
    def __init__(self):
        self.children = {}
        self.is_end = False

class Trie:
    def __init__(self):
        self.root = TrieNode()
    
    def insert(self, word):
        node = self.root
        for char in word:
            if char not in node.children:
                node.children[char] = TrieNode()
            node = node.children[char]
        node.is_end = True
    
    def search(self, word):
        node = self.root
        for char in word:
            if char not in node.children:
                return False
            node = node.children[char]
        return node.is_end
    
    def starts_with(self, prefix):
        node = self.root
        for char in prefix:
            if char not in node.children:
                return False
            node = node.children[char]
        return True
```

---

## Part 3: Sorting Algorithms

### Comparison

| Algorithm | Best | Average | Worst | Space | Stable |
|-----------|------|---------|-------|-------|--------|
| Bubble Sort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Selection Sort | O(n²) | O(n²) | O(n²) | O(1) | No |
| Insertion Sort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes |
| Quick Sort | O(n log n) | O(n log n) | O(n²) | O(log n) | No |
| Heap Sort | O(n log n) | O(n log n) | O(n log n) | O(1) | No |
| Counting Sort | O(n+k) | O(n+k) | O(n+k) | O(k) | Yes |
| Radix Sort | O(nk) | O(nk) | O(nk) | O(n+k) | Yes |

### Quick Sort

```python
def quick_sort(arr, low, high):
    if low < high:
        pivot = partition(arr, low, high)
        quick_sort(arr, low, pivot - 1)
        quick_sort(arr, pivot + 1, high)

def partition(arr, low, high):
    pivot = arr[high]
    i = low - 1
    for j in range(low, high):
        if arr[j] <= pivot:
            i += 1
            arr[i], arr[j] = arr[j], arr[i]
    arr[i+1], arr[high] = arr[high], arr[i+1]
    return i + 1
```

### Merge Sort

```python
def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    
    return merge(left, right)

def merge(left, right):
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result
```

---

## Part 4: Graph Algorithms

### BFS (Breadth-First Search)

```python
from collections import deque

def bfs(graph, start):
    visited = {start}
    queue = deque([start])
    order = []
    
    while queue:
        node = queue.popleft()
        order.append(node)
        
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)
    
    return order
```

### DFS (Depth-First Search)

```python
def dfs(graph, node, visited=None):
    if visited is None:
        visited = set()
    
    visited.add(node)
    order = [node]
    
    for neighbor in graph[node]:
        if neighbor not in visited:
            order.extend(dfs(graph, neighbor, visited))
    
    return order
```

### Dijkstra's Shortest Path

```python
import heapq

def dijkstra(graph, start):
    distances = {node: float('inf') for node in graph}
    distances[start] = 0
    pq = [(0, start)]
    previous = {node: None for node in graph}
    
    while pq:
        dist, node = heapq.heappop(pq)
        
        if dist > distances[node]:
            continue
        
        for neighbor, weight in graph[node].items():
            new_dist = dist + weight
            if new_dist < distances[neighbor]:
                distances[neighbor] = new_dist
                previous[neighbor] = node
                heapq.heappush(pq, (new_dist, neighbor))
    
    return distances, previous
```

### Topological Sort

```python
def topological_sort(graph):
    """Kahn's algorithm."""
    in_degree = {node: 0 for node in graph}
    for node in graph:
        for neighbor in graph[node]:
            in_degree[neighbor] += 1
    
    queue = deque([node for node in graph if in_degree[node] == 0])
    order = []
    
    while queue:
        node = queue.popleft()
        order.append(node)
        for neighbor in graph[node]:
            in_degree[neighbor] -= 1
            if in_degree[neighbor] == 0:
                queue.append(neighbor)
    
    return order
```

---

## Part 5: Dynamic Programming

### DP Patterns

| Pattern | When to Use | Example |
|---------|------------|---------|
| **Fibonacci** | Problem reduces to sum of previous states | Fibonacci, climbing stairs |
| **Knapsack** | Select items with weight/value constraints | 0/1 knapsack, subset sum |
| **LCS** | Find common subsequence | Longest common subsequence |
| **LIS** | Find increasing subsequence | Longest increasing subsequence |
| **Grid** | Paths in a 2D grid | Unique paths, minimum path sum |
| **Interval** | Overlapping intervals | Job scheduling, house robber |
| **Tree DP** | Optimal decisions on trees | Diameter of binary tree |

### Fibonacci (Memoization vs Tabulation)

```python
# ❌ Naive recursion: O(2^n)
def fib(n):
    if n <= 1: return n
    return fib(n-1) + fib(n-2)

# ✅ Memoization (top-down): O(n)
def fib_memo(n, memo={}):
    if n in memo: return memo[n]
    if n <= 1: return n
    memo[n] = fib_memo(n-1) + fib_memo(n-2)
    return memo[n]

# ✅ Tabulation (bottom-up): O(n)
def fib_tab(n):
    if n <= 1: return n
    dp = [0] * (n + 1)
    dp[1] = 1
    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    return dp[n]

# ✅ Space-optimized: O(1) space
def fib_opt(n):
    if n <= 1: return n
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b
```

### 0/1 Knapsack

```python
def knapsack(weights, values, capacity):
    n = len(weights)
    dp = [[0] * (capacity + 1) for _ in range(n + 1)]
    
    for i in range(1, n + 1):
        for w in range(capacity + 1):
            dp[i][w] = dp[i-1][w]  # Don't take item
            if weights[i-1] <= w:
                dp[i][w] = max(dp[i][w], dp[i-1][w-weights[i-1]] + values[i-1])
    
    return dp[n][capacity]
```

### Longest Common Subsequence

```python
def lcs(text1, text2):
    m, n = len(text1), len(text2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if text1[i-1] == text2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])
    
    return dp[m][n]
```

---

## Part 6: Greedy Algorithms

### When Greedy Works

| Problem | Greedy Strategy | Optimal? |
|---------|----------------|----------|
| Activity selection | Sort by end time, pick earliest | ✅ Yes |
| Huffman coding | Merge smallest frequencies | ✅ Yes |
| Fractional knapsack | Sort by value/weight ratio | ✅ Yes |
| 0/1 Knapsack | — | ❌ No (use DP) |
| Coin change | — | ❌ No (use DP) |

### Activity Selection

```python
def activity_selection(activities):
    """Select maximum non-overlapping activities."""
    # Sort by end time
    activities.sort(key=lambda x: x[1])
    
    selected = [activities[0]]
    last_end = activities[0][1]
    
    for start, end in activities[1:]:
        if start >= last_end:
            selected.append((start, end))
            last_end = end
    
    return selected
```

---

## Part 7: Problem-Solving Framework

### 1. Understand the Problem
- What are the inputs and outputs?
- What are the constraints?
- What are the edge cases?

### 2. Identify the Pattern
- Is it a search problem? → Binary search, BFS/DFS
- Is it optimization? → DP, greedy
- Is it about ordering? → Sorting, topological sort
- Is it about grouping? → Union-Find, hash map
- Is it about paths? → Graph algorithms

### 3. Choose the Algorithm
- Use the selection guide above
- Consider time/space trade-offs
- Check if a simpler solution exists

### 4. Implement
- Write pseudocode first
- Handle edge cases
- Test with examples

### 5. Optimize
- Can you reduce time complexity?
- Can you reduce space complexity?
- Can you use a better data structure?

---

## Output Format

```
## Algorithm Analysis

### Problem
[Description of the problem]

### Approach
[Algorithm selected and why]

### Complexity
- Time: O(X)
- Space: O(X)

### Implementation
[Code]

### Test Cases
- Input: [X] → Expected: [Y]
```

## Rules

- **Analyze before coding** — Understand the complexity requirements
- **Choose the right data structure** — The algorithm often depends on it
- **Handle edge cases** — Empty input, single element, duplicates
- **Test thoroughly** — Use multiple test cases including edge cases
- **Optimize only when needed** — Don't over-optimize for imaginary scale
- **Document your reasoning** — Future you needs to understand why
