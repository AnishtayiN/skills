---
name: context-management
description: >-
  Manage context windows, token limits, conversation state, context compression,
  summarization, sliding window, priority-based selection, and optimization.
  TRIGGERS: context, token, context window, token limit, context overflow, context too long,
  summarize context, compress context, token management, context optimization,
  sliding window, context priority, key information extraction,
  کانتکست, توکن, محدودیت توکن, ساختار مکالمه, مدیریت حافظه,
  بهینه‌سازی کانتکست, فشرده‌سازی کانتکست
priority: P1
dependencies: [tool-management]
conflicts: []
---

# Context Management Skill

## Purpose

Use context windows efficiently to maximize the quality and relevance of information
available to the agent. Prevent overflow, reduce noise, maintain coherence across
long conversations, and ensure that the most important information is always in scope.
This skill covers token counting, context window optimization, conversation
summarization, sliding window strategies, key information extraction, context
compression, and priority-based context selection.

## When to Activate

- Context window is getting full (approaching token limit)
- Token limit approaching threshold (80%+ usage)
- Conversation is too long for a single context window
- Need to summarize past context to free space
- Multiple large files are in context simultaneously
- Agent is losing track of earlier conversation turns
- User requests a context refresh or restart
- Task requires maintaining long-term memory across turns

## When NOT to Activate

- Fresh conversation with plenty of context space
- Single-turn interactions with minimal context
- User provides all information inline without tool calls
- Context usage is below 50% of available window

## Inputs Required

- Current context window size and usage
- Conversation history length
- List of files/content currently in context
- Task complexity and expected information needs
- Token budget remaining

## Preconditions

- Token counting mechanism is available
- Conversation history is accessible
- Context window size is known
- Summarization capability is available

---

## Workflow

### Step 1: Assess Context Usage

```
1. How much context is currently used?
   - Count tokens in conversation history
   - Count tokens in file references
   - Count tokens in tool results
   - Calculate total vs. available budget

2. What information is still needed?
   - Current task requirements
   - Relevant code snippets
   - Key decisions made so far
   - Error messages and debugging context

3. What can be safely discarded?
   - Completed task results
   - Old debugging attempts
   - Verbose tool outputs that have been processed
   - Intermediate calculation results

4. What should be summarized?
   - Long conversation threads
   - Multiple file contents
   - Repetitive patterns
   - Historical context that is still relevant
```

### Step 2: Optimize Context

```
Strategies (apply in order of preference):
1. Remove completed tasks from todo lists
2. Summarize old conversation turns (keep last 3-5 in detail)
3. Replace file contents with references/summaries
4. Compress verbose tool outputs
5. Remove intermediate debugging output
6. Focus on current task's relevant files only
7. Use sliding window for conversation history
8. Apply priority-based context selection
```

### Step 3: Manage State

```
1. Track completed steps and their outcomes
2. Track pending steps and their requirements
3. Track key decisions and their rationale
4. Track file changes and their locations
5. Track error patterns and their resolutions
6. Track user preferences and constraints
7. Maintain a compact "working memory" of current task
```

### Step 4: Compress and Store

```
When context is critically full:
1. Summarize entire conversation into key points
2. Store critical decisions in structured format
3. Keep only current task files in context
4. Use references for historical content
5. Verify that compressed context retains all essential information
```

---

## Advanced Techniques

### Technique 1: Token Counting and Budget Management

Implement precise token counting and budget allocation:

```javascript
// Token counter using tiktoken (OpenAI) or approximation
class TokenCounter {
  constructor(model = 'gpt-4') {
    this.model = model;
    this.encoding = getEncoding(model);
  }

  count(text) {
    if (!text) return 0;
    return this.encoding.encode(text).length;
  }

  countConversation(messages) {
    return messages.reduce((total, msg) => {
      return total + this.count(msg.content) + 4; // +4 for role tokens
    }, 0);
  }

  getBudget(usedTokens, maxTokens, reservePercent = 10) {
    const reserve = Math.floor(maxTokens * reservePercent / 100);
    return maxTokens - usedTokens - reserve;
  }
}

// Budget allocator for multi-section context
class ContextBudget {
  constructor(totalBudget) {
    this.totalBudget = totalBudget;
    this.allocated = new Map();
  }

  allocate(section, percentage) {
    this.allocated.set(section, Math.floor(this.totalBudget * percentage / 100));
  }

  getRemaining(section) {
    const limit = this.allocated.get(section) || 0;
    const used = this.sectionUsage.get(section) || 0;
    return limit - used;
  }

  report() {
    const report = [];
    for (const [section, limit] of this.allocated) {
      const used = this.sectionUsage.get(section) || 0;
      report.push({
        section,
        limit,
        used,
        remaining: limit - used,
        utilization: Math.round(used / limit * 100) + '%',
      });
    }
    return report;
  }
}
```

### Technique 2: Context Window Optimization

Optimize the context window for maximum information density:

```javascript
// Context optimizer that selects the most relevant content
class ContextOptimizer {
  constructor(maxTokens) {
    this.maxTokens = maxTokens;
    this.tokenCounter = new TokenCounter();
  }

  optimize(sections, currentTask) {
    // Score each section by relevance
    const scored = sections.map(section => ({
      ...section,
      score: this.relevanceScore(section, currentTask),
      tokens: this.tokenCounter.count(section.content),
    }));

    // Sort by score descending
    scored.sort((a, b) => b.score - a.score);

    // Greedily pack sections into budget
    const selected = [];
    let usedTokens = 0;

    for (const section of scored) {
      if (usedTokens + section.tokens <= this.maxTokens) {
        selected.push(section);
        usedTokens += section.tokens;
      } else if (section.priority === 'critical') {
        // Always include critical sections, even if we need to trim
        const trimmed = this.trimToBudget(section, this.maxTokens - usedTokens);
        if (trimmed) {
          selected.push(trimmed);
          usedTokens += trimmed.tokens;
        }
      }
    }

    return { selected, usedTokens, totalBudget: this.maxTokens };
  }

  relevanceScore(section, task) {
    let score = 0;

    // Recency bonus (recent content scores higher)
    if (section.recency) score += section.recency * 0.3;

    // Task relevance (keyword matching)
    if (section.keywords && task.keywords) {
      const overlap = section.keywords.filter(k => task.keywords.includes(k));
      score += overlap.length * 0.4;
    }

    // Priority weight
    const priorityWeights = { critical: 1.0, high: 0.8, medium: 0.5, low: 0.2 };
    score += (priorityWeights[section.priority] || 0.5);

    // Penalty for very old content
    if (section.age > 10) score *= 0.5;

    return score;
  }

  trimToBudget(section, maxTokens) {
    const content = section.content;
    const tokens = this.tokenCounter.count(content);

    if (tokens <= maxTokens) return section;

    // Progressive trimming
    const lines = content.split('\n');
    const trimmed = [];
    let usedTokens = 0;

    for (const line of lines) {
      const lineTokens = this.tokenCounter.count(line);
      if (usedTokens + lineTokens <= maxTokens) {
        trimmed.push(line);
        usedTokens += lineTokens;
      }
    }

    if (trimmed.length === 0) return null;

    return {
      ...section,
      content: trimmed.join('\n') + '\n[... trimmed]',
      tokens: usedTokens,
    };
  }
}
```

### Technique 3: Conversation Summarization

Summarize long conversations while preserving key information:

```javascript
// Hierarchical conversation summarizer
class ConversationSummarizer {
  constructor(tokenCounter) {
    this.tokenCounter = tokenCounter;
  }

  // Summarize a window of conversation turns
  summarizeTurns(turns, maxTokens = 500) {
    if (turns.length === 0) return '';

    // Extract key information from each turn
    const keyPoints = turns.map(turn => ({
      role: turn.role,
      intent: this.extractIntent(turn.content),
      decisions: this.extractDecisions(turn.content),
      errors: this.extractErrors(turn.content),
      files: this.extractFileRefs(turn.content),
    }));

    // Build summary
    const summary = [];

    // Add context header
    summary.push(`[Conversation summary: ${turns.length} turns]`);

    // Key decisions
    const allDecisions = keyPoints.flatMap(kp => kp.decisions);
    if (allDecisions.length > 0) {
      summary.push('Key decisions:');
      allDecisions.forEach(d => summary.push(`  - ${d}`));
    }

    // Errors encountered
    const allErrors = keyPoints.flatMap(kp => kp.errors);
    if (allErrors.length > 0) {
      summary.push('Errors resolved:');
      allErrors.forEach(e => summary.push(`  - ${e}`));
    }

    // Files touched
    const allFiles = [...new Set(keyPoints.flatMap(kp => kp.files))];
    if (allFiles.length > 0) {
      summary.push(`Files involved: ${allFiles.join(', ')}`);
    }

    // Recent context (last 2 turns in detail)
    const recent = turns.slice(-2);
    summary.push('Recent:');
    recent.forEach(t => {
      const truncated = t.content.substring(0, 200);
      summary.push(`  ${t.role}: ${truncated}${t.content.length > 200 ? '...' : ''}`);
    });

    return summary.join('\n');
  }

  // Progressive summarization: summarize in layers
  progressiveSummarize(messages, targetTokens) {
    // Layer 1: Keep last 3 messages in full
    const recent = messages.slice(-3);

    // Layer 2: Summarize middle section
    const middle = messages.slice(0, -3);
    const middleSummary = this.summarizeTurns(middle, Math.floor(targetTokens * 0.5));

    // Layer 3: High-level summary of everything before
    const old = messages.slice(0, Math.floor(middle.length / 2));
    const oldSummary = this.highLevelSummary(old);

    return {
      fullContext: recent,
      summary: middleSummary,
      highLevel: oldSummary,
      totalTokens: this.estimateTokens(recent, middleSummary, oldSummary),
    };
  }

  extractIntent(content) {
    // Extract the main intent from a message
    const intents = {
      request: /(?:please|can you|could you|I need|I want)/i,
      question: /\?$/,
      error: /(?:error|failed|broken|doesn't work)/i,
      confirmation: /(?:yes|correct|that works|looks good)/i,
    };

    for (const [intent, pattern] of Object.entries(intents)) {
      if (pattern.test(content)) return intent;
    }
    return 'statement';
  }

  extractDecisions(content) {
    const decisions = [];
    const patterns = [
      /(?:decided?|chose?|going with|will use|selected)\s+(.+)/gi,
      /(?:let's|we'll|I'll)\s+(.+)/gi,
    ];
    for (const pattern of patterns) {
      let match;
      while ((match = pattern.exec(content))) {
        decisions.push(match[1].trim());
      }
    }
    return decisions;
  }

  extractErrors(content) {
    const errors = [];
    const patterns = [
      /(?:fixed|resolved|solved|patched)\s+(.+)/gi,
      /(?:error|bug|issue):\s*(.+)/gi,
    ];
    for (const pattern of patterns) {
      let match;
      while ((match = pattern.exec(content))) {
        errors.push(match[1].trim());
      }
    }
    return errors;
  }

  extractFileRefs(content) {
    const filePattern = /(?:`([^`]+\.[a-z]+)`|([\/\w.-]+\.\w{2,4}))/g;
    const files = [];
    let match;
    while ((match = filePattern.exec(content))) {
      files.push(match[1] || match[2]);
    }
    return files;
  }
}
```

### Technique 4: Sliding Window Strategy

Implement sliding window for conversation history management:

```javascript
// Sliding window context manager
class SlidingWindowContext {
  constructor(windowSize = 10, overlap = 2) {
    this.windowSize = windowSize;
    this.overlap = overlap;
    this.messages = [];
    this.summaries = []; // Summaries of each window
  }

  addMessage(message) {
    this.messages.push(message);

    if (this.messages.length > this.windowSize) {
      // Summarize the oldest messages before sliding
      const toSummarize = this.messages.slice(
        0, this.messages.length - this.windowSize + this.overlap
      );
      const summary = this.summarizeWindow(toSummarize);
      this.summaries.push(summary);

      // Keep only the overlap portion
      this.messages = this.messages.slice(
        this.messages.length - this.windowSize + this.overlap
      );
    }
  }

  getContext() {
    return {
      summaries: this.summaries, // Historical summaries
      currentWindow: this.messages, // Current sliding window
      totalMessages: this.summaries.reduce((sum, s) => sum + s.count, 0) + this.messages.length,
    };
  }

  summarizeWindow(messages) {
    return {
      count: messages.length,
      summary: this压缩messages.map(m => m.content).join('\n'),
      timespan: {
        start: messages[0].timestamp,
        end: messages[messages.length - 1].timestamp,
      },
      keyTopics: this.extractTopics(messages),
    };
  }

  extractTopics(messages) {
    const words = messages
      .map(m => m.content)
      .join(' ')
      .toLowerCase()
      .split(/\s+/);

    // Simple word frequency (exclude stopwords)
    const stopwords = new Set(['the', 'a', 'an', 'is', 'are', 'was', 'were', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for', 'of', 'with']);
    const freq = {};
    words.filter(w => !stopwords.has(w) && w.length > 3).forEach(w => {
      freq[w] = (freq[w] || 0) + 1;
    });

    return Object.entries(freq)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 5)
      .map(([word]) => word);
  }
}
```

### Technique 5: Key Information Extraction

Extract and preserve the most important information:

```javascript
// Key information extractor
class KeyInfoExtractor {
  constructor() {
    this.priorityCategories = [
      'decision', 'requirement', 'constraint', 'error', 'file', 'function', 'config',
    ];
  }

  extract(messages) {
    const extracted = {
      decisions: [],
      requirements: [],
      constraints: [],
      errors: [],
      files: new Set(),
      functions: new Set(),
      configs: new Set(),
    };

    for (const msg of messages) {
      const content = msg.content;

      // Extract decisions
      const decisions = content.match(/(?:decided|chose|going with|will use)\s+(.+)/gi);
      if (decisions) extracted.decisions.push(...decisions);

      // Extract requirements
      const requirements = content.match(/(?:must|should|needs to|required|shall)\s+(.+)/gi);
      if (requirements) extracted.requirements.push(...requirements);

      // Extract constraints
      const constraints = content.match(/(?:cannot|must not|don't|never|always)\s+(.+)/gi);
      if (constraints) extracted.constraints.push(...constraints);

      // Extract errors
      const errors = content.match(/(?:Error|Failed|Exception):\s*(.+)/gi);
      if (errors) extracted.errors.push(...errors);

      // Extract file references
      const files = content.match(/`([^`]+\.\w+)`/g);
      if (files) files.forEach(f => extracted.files.add(f.replace(/`/g, '')));

      // Extract function references
      const functions = content.match(/`(\w+)\(`\)/g);
      if (functions) functions.forEach(f => extracted.functions.add(f));
    }

    return {
      decisions: [...new Set(extracted.decisions)],
      requirements: [...new Set(extracted.requirements)],
      constraints: [...new Set(extracted.constraints)],
      errors: [...new Set(extracted.errors)],
      files: [...extracted.files],
      functions: [...extracted.functions],
    };
  }

  // Compress extracted info to fit budget
  compress(info, maxTokens) {
    const tokenCounter = new TokenCounter();
    const compressed = { ...info };

    // Priority order for keeping information
    const priorityOrder = ['errors', 'requirements', 'constraints', 'decisions', 'files', 'functions'];

    let totalTokens = tokenCounter.count(JSON.stringify(compressed));
    let idx = 0;

    while (totalTokens > maxTokens && idx < priorityOrder.length) {
      const category = priorityOrder[idx];
      if (compressed[category].length > 3) {
        compressed[category] = compressed[category].slice(0, Math.ceil(compressed[category].length / 2));
        totalTokens = tokenCounter.count(JSON.stringify(compressed));
      } else {
        idx++;
      }
    }

    return compressed;
  }
}
```

### Technique 6: Context Compression

Compress context while preserving essential information:

```javascript
// Context compressor with multiple strategies
class ContextCompressor {
  constructor(tokenCounter) {
    this.tokenCounter = tokenCounter;
  }

  // Strategy 1: Remove redundancy
  removeRedundancy(text) {
    const sentences = text.split(/[.!?]+/).filter(s => s.trim());
    const unique = [];
    const seen = new Set();

    for (const sentence of sentences) {
      const normalized = sentence.toLowerCase().trim();
      // Simple dedup by checking if a very similar sentence was already seen
      const key = normalized.substring(0, 50);
      if (!seen.has(key)) {
        seen.add(key);
        unique.push(sentence.trim());
      }
    }

    return unique.join('. ');
  }

  // Strategy 2: Abbreviate common patterns
  abbreviate(text) {
    return text
      .replace(/for example/gi, 'e.g.')
      .replace(/that is/gi, 'i.e.')
      .replace(/for instance/gi, 'e.g.')
      .replace(/in order to/gi, 'to')
      .replace(/due to the fact that/gi, 'because')
      .replace(/at this point in time/gi, 'now')
      .replace(/in the event that/gi, 'if');
  }

  // Strategy 3: Extract bullet points from prose
  extractBullets(text) {
    const sentences = text.split(/[.!?]+/).filter(s => s.trim().length > 10);
    return sentences.map(s => `- ${s.trim()}`).join('\n');
  }

  // Strategy 4: Compress file contents
  compressFileContent(content, maxTokens) {
    const currentTokens = this.tokenCounter.count(content);
    if (currentTokens <= maxTokens) return content;

    // Keep imports, exports, and public API surface
    const lines = content.split('\n');
    const important = lines.filter(line =>
      /import|export|class|function|interface|type|const|let|var/.test(line) ||
      /def |class |from |import /.test(line) // Python
    );

    const compressed = important.join('\n');
    const remaining = maxTokens - this.tokenCounter.count(compressed) - 50;

    if (remaining > 0) {
      // Add a portion of the implementation
      const impl = lines.filter(l => !important.includes(l)).slice(0, 20).join('\n');
      return compressed + '\n// ... implementation excerpt:\n' + impl.substring(0, remaining * 4);
    }

    return compressed + '\n// [truncated - see full file]';
  }

  // Full compression pipeline
  compress(text, targetTokens) {
    let result = text;
    let currentTokens = this.tokenCounter.count(result);

    if (currentTokens <= targetTokens) return result;

    // Step 1: Remove redundancy
    result = this.removeRedundancy(result);
    currentTokens = this.tokenCounter.count(result);
    if (currentTokens <= targetTokens) return result;

    // Step 2: Abbreviate
    result = this.abbreviate(result);
    currentTokens = this.tokenCounter.count(result);
    if (currentTokens <= targetTokens) return result;

    // Step 3: Convert to bullets
    result = this.extractBullets(result);
    currentTokens = this.tokenCounter.count(result);
    if (currentTokens <= targetTokens) return result;

    // Step 4: Truncate with indicator
    const chars = Math.floor(targetTokens * 4);
    return result.substring(0, chars) + '\n[... compressed from ' + currentTokens + ' tokens]';
  }
}
```

### Technique 7: Priority-Based Context Selection

Select and prioritize context based on task relevance:

```javascript
// Priority-based context selector
class PriorityContextSelector {
  constructor() {
    this.priorityLevels = {
      CRITICAL: 1,  // Must include: current task, error state
      HIGH: 2,      // Should include: related files, recent decisions
      MEDIUM: 3,    // Nice to have: background context
      LOW: 4,       // Optional: historical, tangential
    };
  }

  selectContext(available, budget, currentTask) {
    // Score and rank all available context
    const scored = available.map(item => ({
      ...item,
      score: this.scoreRelevance(item, currentTask),
      priority: this.determinePriority(item, currentTask),
    }));

    // Sort by priority first, then by relevance score
    scored.sort((a, b) => {
      if (a.priority !== b.priority) return a.priority - b.priority;
      return b.score - a.score;
    });

    // Greedily select until budget is filled
    const selected = [];
    let usedTokens = 0;

    for (const item of scored) {
      if (usedTokens + item.tokens <= budget) {
        selected.push(item);
        usedTokens += item.tokens;
      } else if (item.priority === this.priorityLevels.CRITICAL) {
        // Force include critical items by trimming others
        const needed = item.tokens;
        const available = budget - usedTokens;

        if (available >= needed * 0.5) {
          // Trim the item to fit
          selected.push({
            ...item,
            content: item.content.substring(0, available * 4) + '...[trimmed]',
            tokens: available,
          });
          usedTokens += available;
        }
      }
    }

    return { selected, usedTokens, budget };
  }

  scoreRelevance(item, task) {
    let score = 0;

    // Direct keyword match
    if (item.keywords && task.keywords) {
      const overlap = item.keywords.filter(k =>
        task.keywords.some(tk => k.toLowerCase().includes(tk.toLowerCase()))
      );
      score += overlap.length * 2;
    }

    // File match
    if (item.files && task.files) {
      const overlap = item.files.filter(f => task.files.includes(f));
      score += overlap.length * 3;
    }

    // Recency (more recent = more relevant)
    if (item.timestamp) {
      const age = Date.now() - item.timestamp;
      const hoursOld = age / (1000 * 60 * 60);
      score += Math.max(0, 10 - hoursOld);
    }

    // User focus (mentioned by user recently)
    if (item.mentionedByUser) score += 5;

    return score;
  }

  determinePriority(item, task) {
    if (item.type === 'error' && task.phase === 'debugging') {
      return this.priorityLevels.CRITICAL;
    }
    if (item.type === 'requirement') {
      return this.priorityLevels.CRITICAL;
    }
    if (item.type === 'current-task-file') {
      return this.priorityLevels.HIGH;
    }
    if (item.type === 'recent-decision') {
      return this.priorityLevels.HIGH;
    }
    if (item.type === 'background') {
      return this.priorityLevels.MEDIUM;
    }
    return this.priorityLevels.LOW;
  }
}
```

---

## Common Patterns

### Pattern 1: Context Health Check

```javascript
// Monitor and report context health
function contextHealthCheck(context, maxTokens) {
  const tokenCounter = new TokenCounter();
  const used = tokenCounter.countConversation(context.messages);
  const utilization = used / maxTokens;

  const health = {
    status: utilization < 0.7 ? 'healthy' : utilization < 0.9 ? 'warning' : 'critical',
    utilization: `${Math.round(utilization * 100)}%`,
    usedTokens: used,
    maxTokens,
    recommendations: [],
  };

  if (utilization > 0.7) {
    health.recommendations.push('Summarize old conversation turns');
  }
  if (utilization > 0.8) {
    health.recommendations.push('Remove completed task outputs');
    health.recommendations.push('Replace file contents with summaries');
  }
  if (utilization > 0.9) {
    health.recommendations.push('Apply aggressive context compression');
    health.recommendations.push('Archive non-essential context');
  }

  return health;
}
```

### Pattern 2: Smart Context Pruning

```javascript
// Smart pruning that preserves important context
function smartPrune(messages, maxTokens) {
  const tokenCounter = new TokenCounter();
  const totalTokens = tokenCounter.countConversation(messages);

  if (totalTokens <= maxTokens) return messages;

  // Keep structure: system message + recent + key summaries
  const systemMessage = messages[0]; // Always keep system
  const recent = messages.slice(-5); // Keep last 5 turns
  const middle = messages.slice(1, -5); // Prunable middle

  // Summarize middle section
  const summary = summarizeTurns(middle);

  // Build pruned context
  const pruned = [systemMessage, summary, ...recent];
  return pruned;
}
```

### Pattern 3: Context Refresh Strategy

```javascript
// Full context refresh when context is stale
async function refreshContext(agent, task) {
  // 1. Summarize entire conversation
  const summary = await agent.summarizeConversation();

  // 2. Re-extract key information
  const keyInfo = extractKeyInfo(summary);

  // 3. Reload relevant files
  const relevantFiles = await identifyRelevantFiles(task);

  // 4. Rebuild context
  agent.context = {
    summary,
    keyInfo,
    files: relevantFiles,
    currentTask: task,
    tokenUsage: 0, // Reset counter
  };

  return agent.context;
}
```

### Pattern 4: File Content Caching

```javascript
// Cache file contents with token-aware eviction
class FileCache {
  constructor(maxTokens = 10000) {
    this.cache = new Map();
    this.maxTokens = maxTokens;
    this.tokenCounter = new TokenCounter();
    this.totalTokens = 0;
  }

  set(filePath, content) {
    const tokens = this.tokenCounter.count(content);

    // Evict if necessary
    while (this.totalTokens + tokens > this.maxTokens && this.cache.size > 0) {
      // Evict least recently used
      const oldest = this.cache.keys().next().value;
      const oldestTokens = this.cache.get(oldest).tokens;
      this.cache.delete(oldest);
      this.totalTokens -= oldestTokens;
    }

    this.cache.set(filePath, { content, tokens, lastAccess: Date.now() });
    this.totalTokens += tokens;
  }

  get(filePath) {
    const entry = this.cache.get(filePath);
    if (entry) {
      entry.lastAccess = Date.now();
      return entry.content;
    }
    return null;
  }
}
```

### Pattern 5: Context Priority Queue

```javascript
// Priority queue for context elements
class ContextPriorityQueue {
  constructor() {
    this.items = [];
  }

  enqueue(item, priority) {
    this.items.push({ item, priority, timestamp: Date.now() });
    this.items.sort((a, b) => a.priority - b.priority);
  }

  dequeue() {
    return this.items.shift()?.item;
  }

  peek() {
    return this.items[0]?.item;
  }

  size() {
    return this.items.length;
  }

  // Remove items that are no longer relevant
  prune(maxAge = 300000) { // 5 minutes
    const cutoff = Date.now() - maxAge;
    this.items = this.items.filter(i => i.timestamp > cutoff);
  }

  // Get top N items
  top(n) {
    return this.items.slice(0, n).map(i => i.item);
  }
}
```

---

## Edge Cases & Pitfalls

### 1. Token Count Mismatch
Different tokenizers count tokens differently. What fits in one model's window may not fit in another's. Always use the correct tokenizer for the target model.

### 2. Context Window Boundary Effects
Content at the very beginning and end of the context window gets more attention from models. Place important information at these positions, not in the middle.

### 3. Summarization Information Loss
Summaries inevitably lose detail. Critical edge cases, specific error messages, and exact values may be lost. Always preserve key numeric values and error codes in summaries.

### 4. Sliding Window Discontinuity
When the sliding window moves, the model loses awareness of the boundary content. This can cause it to repeat decisions or miss dependencies across the boundary.

### 5. Circular Context Dependencies
Summarizing a summary produces compounding information loss. Limit the number of summary layers (max 3) and periodically refresh from source content.

### 6. Token Budget Overflow from Tool Results
Tool results (file contents, search results) can be unexpectedly large and blow the token budget. Always validate and truncate tool results before adding to context.

### 7. Context Contamination
Irrelevant information in context can confuse the model and degrade response quality. Aggressively prune content that is not directly related to the current task.

### 8. Priority Misclassification
Incorrectly classifying information priority can cause critical context to be pruned. When in doubt, err on the side of keeping more context.

### 9. Stale Context After Environment Change
If files are modified externally, cached context becomes stale. Refresh context when the working environment changes significantly.

### 10. Language Mixing Overhead
Bilingual content (e.g., English + Persian + Chinese) may use tokens less efficiently. Account for higher token usage when mixing languages.

### 11. Code Block Token Inefficiency
Code blocks use more tokens than prose due to syntax characters. Consider using abbreviated representations for code in summaries.

### 12. Loss of Conversation Coherence
Heavy summarization can break the conversational flow and make the model lose track of the dialogue structure. Preserve turn-taking patterns in summaries.

### 13. Silent Context Truncation
When context is silently truncated (e.g., by the API), the model may behave unpredictably. Always explicitly manage context rather than relying on API truncation.

### 14. Over-Summarization
Summarizing too aggressively can remove context that turns out to be important later. Keep more detail than seems necessary — you can always prune further.

### 15. Token Budget Fragmentation
When many small pieces of context are kept, the overhead of managing them (metadata, separators) can consume significant token budget. Batch small pieces together.

---

## Integration with Other Skills

| Skill | Relationship | Integration Point |
|-------|-------------|-------------------|
| tool-management | Sibling | Tool results consume context tokens; coordinate to avoid overflow |
| project-analysis | Upstream | Project structure informs what files to include in context |
| requirement-analysis | Upstream | Requirements help prioritize which context is most relevant |
| task-planning | Sibling | Task structure determines context organization and priority |
| code-generation | Downstream | Context quality directly affects code generation quality |
| debugging | Downstream | Debugging requires maintaining error context across turns |
| verification | Downstream | Verification needs access to acceptance criteria in context |
| agent-orchestration | Parent | Agent orchestration depends on well-managed context |
| performance-optimization | Sibling | Context management is a key performance optimization |
| error-handling | Sibling | Error context must be preserved for debugging |

---

## Output Format Templates

### Template 1: Context Status Report

```
## Context Status Report

### Token Usage
- **Total Budget:** [N] tokens
- **Used:** [N] tokens ([%]%)
- **Available:** [N] tokens
- **Status:** ✅ HEALTHY | ⚠️ WARNING | 🚨 CRITICAL

### Breakdown by Section
| Section | Tokens | % of Budget | Status |
|---------|--------|-------------|--------|
| System prompt | [N] | [%] | ✅ |
| Conversation history | [N] | [%] | ⚠️ |
| File contents | [N] | [%] | ✅ |
| Tool results | [N] | [%] | ✅ |
| Task context | [N] | [%] | ✅ |

### Recommendations
1. [recommendation 1]
2. [recommendation 2]
```

### Template 2: Context Optimization Plan

```
## Context Optimization Plan

### Current State
- **Token Usage:** [N] / [N] ([%]%)
- **Conversation Length:** [N] turns
- **Files in Context:** [N] files
- **Compression Level:** None | Light | Moderate | Aggressive

### Optimization Actions
| # | Action | Expected Savings | Priority |
|---|--------|-----------------|----------|
| 1 | Summarize turns 1-20 | [N] tokens | HIGH |
| 2 | Prune file X | [N] tokens | MEDIUM |
| 3 | Compress tool output | [N] tokens | LOW |

### After Optimization
- **Projected Token Usage:** [N] / [N] ([%]%)
- **Information Preserved:** [%]%
- **Risk of Information Loss:** LOW | MEDIUM | HIGH
```

### Template 3: Conversation Summary

```
## Conversation Summary

### Session Overview
- **Duration:** [time range]
- **Total Turns:** [N]
- **Key Topic:** [topic]

### Decisions Made
1. [decision 1] — rationale: [reason]
2. [decision 2] — rationale: [reason]

### Errors Resolved
1. [error 1] → [solution]
2. [error 2] → [solution]

### Files Modified
- `path/to/file1.ts` — [what changed]
- `path/to/file2.py` — [what changed]

### Current State
- **Task:** [current task description]
- **Status:** [in progress / blocked / completed]
- **Next Steps:** [what happens next]
```

### Template 4: Context Refresh Log

```
## Context Refresh Log

### Refresh Trigger
- [ ] Token limit approaching ([%]% used)
- [ ] Context staleness detected
- [ ] Environment change detected
- [ ] User requested refresh

### Actions Taken
1. Summarized [N] conversation turns → saved [N] tokens
2. Pruned [N] files → saved [N] tokens
3. Compressed tool outputs → saved [N] tokens

### Result
- **Before:** [N] tokens used
- **After:** [N] tokens used
- **Freed:** [N] tokens ([%]% reduction)
- **Information Preserved:** [%]% of key information

### Validation
- [ ] All critical decisions preserved
- [ ] All active file references intact
- [ ] Current task context complete
- [ ] Error history preserved
```

---

## Rules

1. **Never exceed the context window limit.** Always track token usage and proactively manage context before hitting the limit. Budget 10% reserve for incoming information.

2. **Summarize before overflow.** When context usage exceeds 70%, begin summarizing older conversation turns. When it exceeds 85%, apply aggressive compression.

3. **Keep state organized and structured.** Use consistent formats for tracking completed steps, pending steps, key decisions, and file changes. Structured data is easier to compress and retrieve.

4. **Reference files instead of copying content.** Never copy entire files into context unless absolutely necessary. Use file references, summaries, or excerpts instead.

5. **Preserve critical information across summaries.** Error messages, user requirements, key decisions, and file paths must never be lost during summarization. Mark these as "must preserve."

6. **Use sliding window for long conversations.** Implement a sliding window of the last 5-10 turns in full detail, with summaries of older turns. This balances detail with efficiency.

7. **Score and prioritize context by relevance.** Not all context is equally valuable. Score context items by task relevance, recency, and user focus. Always prioritize critical and high-priority items.

8. **Refresh stale context.** When the working environment changes significantly (files modified, project structure changed), refresh the context to avoid working with stale information.

9. **Account for bilingual content overhead.** When mixing languages (English, Persian, Chinese), expect higher token usage. Adjust budgets and summarization thresholds accordingly.

10. **Validate token counts before critical operations.** Before sending context to the model, verify that token counts are within limits. Use the correct tokenizer for the target model.

11. **Avoid circular summarization.** Limit summary layers to maximum 3. After 3 layers, refresh from source content to prevent compounding information loss.

12. **Monitor context health continuously.** Track token usage, utilization percentage, and context freshness throughout the conversation. Report health status at regular intervals.

13. **Clean up completed tasks immediately.** When a task is completed, remove its detailed context and keep only a brief summary. This frees space for new tasks.

14. **Batch small context pieces.** Combine many small pieces of context (individual file snippets, short messages) into larger batches to reduce metadata overhead.

15. **Test context quality.** After compression or summarization, verify that the model can still answer questions about the compressed content. If not, restore more detail.

---

## Execution Rules

- Never exceed context limits — budget 10% reserve
- Summarize before overflow (70% warning, 85% critical)
- Keep state organized and structured
- Reference files instead of copying content
- Preserve critical information across summaries
- Use sliding window for long conversations
- Score and prioritize context by relevance
- Refresh stale context when environment changes
- Account for bilingual content overhead
- Validate token counts before critical operations

## Anti-Patterns

- ❌ Ignoring context limits until overflow
- ❌ Copying entire files into context unnecessarily
- ❌ Not summarizing old conversations
- ❌ Losing track of state across turns
- ❌ Over-summarizing and losing critical details
- ❌ Keeping irrelevant context that clutters the window
- ❌ Using wrong tokenizer for token counting
- ❌ Not refreshing stale cached content
- ❌ Treating all context as equally important
- ❌ Allowing circular summarization chains

## Skill Interactions

- ← tool-management: Tool results must be managed within context budget
- ↔ project-analysis: Project structure informs context organization
- ← requirement-analysis: Requirements guide context prioritization
- ↔ task-planning: Task structure determines context flow
- → code-generation: Context quality affects code generation
- → debugging: Debug context must be preserved across turns
- → verification: Acceptance criteria need context access
- ← agent-orchestration: Agent workflows depend on context management
- ↔ performance-optimization: Context management is key optimization
- ↔ error-handling: Error context must be preserved

## Verification Checklist

- [ ] Token usage tracked and within budget
- [ ] Summaries preserve critical information
- [ ] Sliding window maintains recent context
- [ ] Priority scoring is accurate
- [ ] Stale context is refreshed
- [ ] File references used instead of copies
- [ ] Bilingual overhead accounted for
- [ ] Context health is monitored continuously
