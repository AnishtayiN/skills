---
name: rag-implementation
description: >-
  Implement Retrieval Augmented Generation (RAG) systems including vector databases,
  embedding pipelines, chunking strategies, retrieval logic, and RAG evaluation.
  Use this skill when the user mentions: RAG, پیاده‌سازی RAG, retrieval augmented generation,
  vector database, embedding search, semantic search, document retrieval, knowledge base,
  chunking strategy, embedding model, similarity search, context retrieval, RAG pipeline,
  RAG system, RAG evaluation, retrieval pipeline, جستجوی معنایی, پایگاه دانش,
  make LLM answer from my documents, chat with my PDFs, AI knowledge base,
  document QA system, how to give LLM my data, custom knowledge for AI,
  vector store, vector index, embedding pipeline, text embedding,
  cosine similarity search, document chunking, text splitting strategy,
  RAG architecture, RAG vs fine-tuning, naive RAG, advanced RAG,
  agentic RAG, RAG with reranking, hybrid search RAG, RAG evaluation metrics,
  RAG chunking best practices, RAG retrieval optimization, context window management,
  hallucination prevention in RAG, RAG for enterprise, multi-document RAG.
---

# RAG Implementation Skill

## Overview

This skill guides the implementation of Retrieval Augmented Generation systems. RAG combines a retrieval system (find relevant documents) with a generation system (LLM synthesizes an answer from those documents). The skill covers the full pipeline: document preparation, embedding, indexing, retrieval, generation, and evaluation.

## When to Use This Skill

- User wants to build a system that answers questions from their documents
- User needs to implement vector search or semantic search
- User asks about embedding models, chunking, or retrieval strategies
- User wants to set up a vector database (Pinecone, Weaviate, Chroma, Qdrant, pgvector, etc.)
- User needs help with RAG pipeline architecture
- User wants to evaluate or improve their existing RAG system
- User asks how to prevent hallucination in document QA
- User wants to compare RAG vs fine-tuning approaches
- User needs multi-document or multi-source RAG
- User is building an enterprise knowledge base or internal AI tool

## RAG Architecture

```
Documents → Chunking → Embedding → Vector Store
                                           ↓
User Query → Embedding → Retrieval → Context Assembly → LLM → Answer
```

## Implementation Workflow

### Phase 1: Understand Requirements

Before writing code, clarify:

1. **Data sources** — What documents? (PDFs, web pages, code, database records, plain text?)
2. **Scale** — How many documents? Total size? Expected query volume?
3. **Language** — What language(s) are the documents and queries?
4. **Latency** — Real-time (seconds) or batch?
5. **Accuracy** — What's the cost of a wrong answer?
6. **Infrastructure** — Cloud, on-prem, local? What's the deployment target?

### Phase 2: Document Preparation

#### Chunking Strategy

| Strategy | Best For | Typical Size |
|----------|----------|-------------|
| **Fixed-size** | Uniform documents, simple use cases | 256-1024 tokens |
| **Sentence-based** | Q&A, where sentence boundaries matter | Variable, ~5-10 sentences |
| **Paragraph-based** | Long-form content, articles | Variable, 1-3 paragraphs |
| **Semantic** | Complex documents where topic shifts matter | Variable, topic-aligned |
| **Recursive** | Mixed document types (headers + paragraphs + tables) | Hierarchical |

**Key rules:**
- Include overlap between chunks (typically 10-20%) to avoid losing context at boundaries.
- Preserve metadata: source document, page number, section title, timestamp.
- Don't chunk across structural boundaries (e.g., don't split a table in half).

#### Chunking Implementation Checklist
- [ ] Choose chunking strategy based on document type
- [ ] Set chunk size and overlap
- [ ] Extract and attach metadata to each chunk
- [ ] Handle special content: tables, code blocks, images (alt text)
- [ ] Validate: are chunks coherent? Do they preserve meaning?

### Phase 3: Embedding

#### Embedding Model Selection

| Model | Dimensions | Strengths | Cost |
|-------|-----------|-----------|------|
| **OpenAI text-embedding-3-small** | 1536 | Good quality, fast, cheap | $0.02/1M tokens |
| **OpenAI text-embedding-3-large** | 3072 | Best quality from OpenAI | $0.13/1M tokens |
| **Cohere embed-v3** | 1024 | Good multilingual, built-in RAG features | Varies |
| **BGE-large / E5** | 1024 | Open-source, self-hostable, strong quality | Free (compute cost) |
| **Nomic embed** | 768 | Open-source, good for long context | Free (compute cost) |

**Selection criteria:**
- Language support (Cohere and multilingual models for non-English)
- Deployment constraints (open-source if data can't leave your infrastructure)
- Dimension size affects storage and latency in the vector store

### Phase 4: Vector Store Setup

#### Vector Database Selection

| Database | Best For | Key Feature |
|----------|----------|-------------|
| **Chroma** | Prototyping, local dev | Embedded, zero-config |
| **pgvector** | Production, existing Postgres | No new infrastructure |
| **Pinecone** | Production, managed | Fully managed, scales well |
| **Weaviate** | Production, hybrid search | Built-in hybrid (keyword + vector) |
| **Qdrant** | Production, performance | Fast, Rust-based, good filtering |
| **FAISS** | Local, high-throughput | In-memory, no server needed |

#### Index Configuration
- Choose distance metric: cosine similarity (default for most embeddings) or dot product
- Set index parameters: number of shards, replication factor
- Configure metadata filtering if the database supports it

### Phase 5: Retrieval Logic

#### Basic Retrieval

1. Embed the user query using the same model used for documents
2. Search the vector store for top-k most similar chunks (k=5 is a good default)
3. Return the chunks + metadata

#### Advanced Retrieval Techniques

| Technique | What It Does | When to Use |
|-----------|-------------|-------------|
| **Hybrid search** | Combines vector + keyword (BM25) search | Documents have exact terms that matter (names, IDs, codes) |
| **Reranking** | Applies a cross-encoder to re-score retrieved chunks | When top-k retrieval misses relevant results |
| **Query expansion** | Rewrites or expands the query before retrieval | When user queries are vague or use different terms than the documents |
| **Parent-child indexing** | Stores small chunks but retrieves their parent section | When you need precise matching but full context |
| **Multi-query** | Generates multiple query variations and merges results | When the user's question might match documents via different phrasings |

### Phase 6: Generation

#### Prompt Template
```
Answer the question based only on the following context. If the context does not
contain enough information to answer the question, say "I don't have enough
information to answer this question accurately."

Context:
{retrieved_chunks_with_sources}

Question: {user_query}

Answer:
```

**Key principles:**
- Explicitly instruct the model to say when it doesn't know — this prevents hallucination.
- Include source references so the user can verify.
- Keep the context window within limits — if you retrieve too many chunks, the model may lose focus.

### Phase 7: Evaluation

Evaluate RAG systems on these metrics:

| Metric | What It Measures | How to Measure |
|--------|-----------------|----------------|
| **Retrieval precision** | Are retrieved chunks relevant? | Manual review or LLM-judged relevance on test set |
| **Retrieval recall** | Are all needed chunks retrieved? | Compare against gold-standard relevant chunks |
| **Answer faithfulness** | Does the answer follow from the context? | LLM-judged: "Is every claim in the answer supported by the context?" |
| **Answer relevance** | Does the answer address the question? | LLM-judged: "Does this answer the user's question?" |
| **End-to-end accuracy** | Is the final answer correct? | Compare against human-annotated answers |

## Advanced Techniques

### Technique 1: Query Rewrite with LLM

Before embedding the user's query, use a fast LLM call to rewrite it for better retrieval:

```python
REWRITE_PROMPT = """
Rewrite this user question to be more specific and better suited for
semantic search against a document corpus. Produce 3 variations.

Original question: {query}

Variations:
1.
2.
3.
"""

# Then embed all 3 variations, retrieve for each, merge and deduplicate.
```

This catches cases where the user's phrasing doesn't match the document vocabulary.

### Technique 2: Cross-Encoder Reranking

After initial retrieval, use a cross-encoder (not a bi-encoder) for more accurate relevance scoring:

```python
from sentence_transformers import CrossEncoder

reranker = CrossEncoder("cross-encoder/ms-marco-MiniLM-L-6-v2")

# candidate_pairs = [(query, chunk_text), ...]
scores = reranker.predict(candidate_pairs)
# Re-sort by score and take top-k
```

Cross-encoders are more accurate than bi-encoders because they process query and document together, but they're too slow for initial retrieval over large corpora. Use them as a second stage.

### Technique 3: Parent-Child (Auto-Merging) Retrieval

Store small chunks for precise matching, but retrieve the parent section for full context:

```python
# During indexing:
parent_chunks = split_document(chunk_size=1000)
for parent in parent_chunks:
    children = split_text(parent, chunk_size=200, overlap=50)
    for child in children:
        store(child, metadata={"parent_id": parent.id, "parent_text": parent.text})

# During retrieval:
small_results = vector_search(query, top_k=20)
parent_ids = set(r.metadata["parent_id"] for r in small_results)
final_context = [get(parent_id) for parent_id in parent_ids][:5]
```

This gives you the precision of small chunks with the context of large chunks.

### Technique 4: HyDE (Hypothetical Document Embedding)

Generate a hypothetical answer to the query, embed that, and use it for retrieval:

```python
# Step 1: Ask the LLM to write a hypothetical answer
hypothetical_answer = llm.generate(f"Write a detailed answer to: {query}")

# Step 2: Embed the hypothetical answer (not the query)
hypothetical_embedding = embed(hypothetical_answer)

# Step 3: Retrieve using the hypothetical embedding
results = vector_search(hypothetical_embedding, top_k=5)
```

Works well when documents are longer and more detailed than the query.

### Technique 5: Agentic RAG

Use an LLM agent that can decide when to retrieve, what to retrieve, and whether to retrieve more:

```python
AGENT_PROMPT = """
You have access to a knowledge base search tool. For the user's question:
1. Decide if you need to search the knowledge base.
2. If yes, formulate a search query.
3. After seeing the results, decide if you need to search again with different terms.
4. Once you have sufficient information, answer the question.

If the knowledge base doesn't contain relevant information, say so.
"""
```

This is more expensive but significantly more flexible than fixed-pipeline RAG.

### Technique 6: Metadata-PreFiltered Retrieval

Filter by metadata BEFORE vector search to reduce the search space and improve precision:

```python
# Instead of searching all documents, filter first:
results = vector_store.search(
    query_embedding=embed(query),
    top_k=5,
    filters={
        "source_type": "financial_report",
        "year": {"$gte": 2023},
        "department": "engineering"
    }
)
```

Dramatically improves precision when the user's context implies specific metadata constraints.

### Technique 7: Recursive Retrieval

When retrieved chunks reference other documents or sections, follow those references:

```python
def recursive_retrieve(query, depth=2, visited=None):
    if visited is None:
        visited = set()
    chunks = vector_search(query, top_k=3)
    all_chunks = []
    for chunk in chunks:
        if chunk.id not in visited:
            visited.add(chunk.id)
            all_chunks.append(chunk)
            # If the chunk references another document, retrieve that too
            if chunk.references and depth > 0:
                for ref in chunk.references:
                    all_chunks.extend(recursive_retrieve(ref, depth-1, visited))
    return all_chunks
```

## Common Patterns (Real-World Examples)

### Pattern 1: PDF Knowledge Base (LangChain)

```python
from langchain.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma

# Load and chunk
loader = PyPDFLoader("company_handbook.pdf")
docs = loader.load()
splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
chunks = splitter.split_documents(docs)

# Embed and store
embeddings = OpenAIEmbeddings(model="text-embedding-3-small")
vectorstore = Chroma.from_documents(chunks, embeddings, persist_directory="./db")

# Retrieve and generate
retriever = vectorstore.as_retriever(search_kwargs={"k": 5})
```

### Pattern 2: Code Repository RAG

```python
# Chunk code by file/function, preserving language and file path metadata
from langchain.text_splitter import Language, RecursiveCharacterTextSplitter

splitter = RecursiveCharacterTextSplitter.from_language(
    language=Language.PYTHON,
    chunk_size=1000,
    chunk_overlap=100
)

# Attach metadata: file_path, language, function_name, class_name
for chunk in chunks:
    chunk.metadata["language"] = "python"
    chunk.metadata["file_path"] = extract_path(chunk)
```

### Pattern 3: Conversational RAG with Chat History

```python
# Include conversation history in the query for follow-up questions
CONVERSATIONAL_RAG_PROMPT = """
Given the conversation history and a follow-up question, reformulate the
follow-up question to be a standalone question, then answer it using
the context.

Chat History:
{chat_history}

Follow-up: {question}

Standalone question: {reformulated_question}

Context: {context}

Answer: """
```

### Pattern 4: Multi-Source RAG with Source Attribution

```python
# Retrieve from multiple collections, tag each chunk with its source
SOURCES = {
    "handbook": vectorstore_handbook,
    "policies": vectorstore_policies,
    "faq": vectorstore_faq
}

all_results = []
for source_name, store in SOURCES.items():
    results = store.search(query, top_k=3)
    for r in results:
        r.metadata["source_collection"] = source_name
    all_results.extend(results)

# Sort by score, take top 5 across all sources
all_results.sort(key=lambda x: x.score, reverse=True)
final_context = all_results[:5]
```

### Pattern 5: RAG Evaluation Pipeline

```python
eval_questions = [
    {"question": "What is the vacation policy?", "expected_answer": "...", "relevant_chunks": [...]},
    # ... 50+ questions covering different topics and difficulty levels
]

for q in eval_questions:
    retrieved = retrieve(q["question"], top_k=5)
    answer = generate(q["question"], retrieved)

    # Faithfulness: is every claim in the answer supported by context?
    faithfulness = llm_judge(faithfulness_prompt.format(answer=answer, context=retrieved))

    # Relevance: does the answer address the question?
    relevance = llm_judge(relevance_prompt.format(answer=answer, question=q["question"]))

    # Retrieval recall: did we retrieve the expected chunks?
    retrieved_ids = {r.id for r in retrieved}
    expected_ids = {c.id for c in q["relevant_chunks"]}
    recall = len(retrieved_ids & expected_ids) / len(expected_ids)

print(f"Avg faithfulness: {avg_faithfulness}, Avg relevance: {avg_relevance}, Avg recall: {avg_recall}")
```

## Edge Cases & Pitfalls

1. **Embedding model mismatch** — Using model A for indexing and model B for querying. The embeddings are in different vector spaces and similarity is meaningless. Always use the exact same model for both.

2. **Chunk boundary information loss** — Splitting a sentence in half so neither chunk contains the full meaning. Always use overlap and respect structural boundaries.

3. **Context window overflow** — Retrieving 20 chunks that total 15,000 tokens, leaving no room for the LLM to generate. Track token counts carefully; 5-8 chunks is usually the sweet spot.

4. **Stale embeddings** — Documents were updated but embeddings weren't regenerated. Implement a re-indexing pipeline that runs on document changes.

5. **Table/chunk corruption** — Chunking across table rows or columns destroys tabular data. Detect tables and chunk them as atomic units.

6. **Query-embedding distribution shift** — Short queries ("refund policy") produce different embedding distributions than document chunks. Use query expansion or HyDE to bridge the gap.

7. **Metadata filter over-filtering** — Applying too many metadata filters returns zero results. Always have a fallback: if filtered search returns < 3 results, retry without filters.

8. **Hallucination despite RAG** — The model generates answers not supported by the retrieved context. Mitigate with explicit grounding instructions and faithfulness evaluation.

9. **Multilingual document mixing** — Embedding English and Farsi documents in the same index with a monolingual model. Use multilingual embedding models for mixed-language corpora.

10. **Cost blindness** — Not calculating per-query cost. Each query involves: 1 embedding call + vector search + context assembly + 1 LLM call. At scale, this adds up. Calculate and budget.

11. **No fallback for empty retrieval** — When no relevant chunks are found, the system still sends an empty context to the LLM, which then hallucinates. Always detect empty results and return a "no information found" response.

12. **Ignoring document quality** — RAG cannot fix bad source documents. If the documents are inaccurate, outdated, or poorly written, the RAG answers will be too. Garbage in, garbage out.

13. **Single-vector-per-chunk limitation** — Long chunks with multiple topics get a single averaged embedding that doesn't match any specific query well. Consider multi-vector representations or smaller chunks.

14. **Missing re-indexing on schema changes** — When chunking strategy or embedding model changes, old indexes become incompatible. Plan for full re-indexing when these change.

## Integration with Related Skills

- **Prompt Engineering** — The RAG generation prompt is a critical prompt engineering task. Grounding instructions, format specs, and hallucination prevention all depend on good prompt design. See `prompt-engineering` skill.
- **Chain-of-Thought** — Complex RAG queries benefit from step-by-step reasoning: "Based on the documents, here's my reasoning..." See `chain-of-thought` skill.
- **Self-Correction** — RAG answers should be self-verified: "Check that every claim in your answer is supported by the retrieved context." See `self-correction` skill.
- **Fullstack Dev** — RAG systems need web APIs, frontends, and deployment. See `fullstack-dev` skill.
- **Web Search** — Combine RAG (internal knowledge) with web search (external knowledge) for a comprehensive system. See `web-search` skill.
- **Web Reader** — Use web reader to ingest web pages into your RAG pipeline. See `web-reader` skill.

## Output Format Templates

### Template 1: Full RAG Implementation

```python
# Project structure recommendation
project/
├── ingest.py          # Document loading and chunking
├── embed.py           # Embedding generation
├── store.py           # Vector store operations
├── retrieve.py        # Retrieval logic
├── generate.py        # LLM generation with context
├── config.py          # Configuration (model names, chunk sizes, etc.)
└── evaluate.py        # Evaluation pipeline
```

Include:
- Working code for each pipeline stage
- Configuration with sensible defaults
- Example usage with a small test dataset
- Estimated costs at the user's expected scale

### Template 2: RAG Architecture Decision

```
## RAG Architecture Recommendation

### Requirements
| Factor | Value |
|--------|-------|
| Document types | {types} |
| Scale | {N} documents, {size} total |
| Language | {lang} |
| Latency target | {N}ms p95 |

### Recommended Stack
- **Chunking:** {strategy} with {size} tokens, {overlap}% overlap
- **Embedding:** {model} ({dimensions}d)
- **Vector Store:** {database} — {justification}
- **Retrieval:** {basic/hybrid/reranked/agentic}
- **Generation:** {model} with {prompt strategy}

### Estimated Costs
- Indexing (one-time): ${cost} for {N} documents
- Per-query: ${cost} (embedding + retrieval + generation)
- Monthly at {QPS} queries/day: ~${cost}/month

### Next Steps
1. {step 1}
2. {step 2}
3. {step 3}
```

### Template 3: RAG Evaluation Report

```
## RAG Evaluation Report

### Test Set
- {N} questions covering {topics}
- Difficulty distribution: {N} easy, {N} medium, {N} hard

### Results
| Metric | Score | Target | Status |
|--------|-------|--------|--------|
| Retrieval Precision | {N}% | >80% | {✅/❌} |
| Retrieval Recall | {N}% | >70% | {✅/❌} |
| Answer Faithfulness | {N}% | >90% | {✅/❌} |
| Answer Relevance | {N}% | >85% | {✅/❌} |

### Failure Analysis
- {N} failures due to {cause}
- {N} failures due to {cause}

### Recommendations
1. {improvement_suggestion}
2. {improvement_suggestion}
```

### Template 4: RAG Improvement Plan

```
## RAG Improvement Plan for {system_name}

### Current State
- Architecture: {description}
- Known issues: {list}

### Priority Improvements

**1. {improvement}** [Priority: HIGH]
- Problem: {what's wrong}
- Solution: {how to fix}
- Expected impact: {metric improvement}
- Effort: {small/medium/large}

**2. {improvement}** [Priority: MEDIUM]
...

### Quick Wins (< 1 day)
- {quick win 1}
- {quick win 2}

### Long-Term Improvements
- {long-term 1}
- {long-term 2}
```

## Principles Summary

1. **Start simple, measure, then complicate.** Basic retrieval → evaluate → add reranking/hybrid/agentic only if needed.
2. **Chunking is the highest-leverage decision.** Better chunks beat better retrieval algorithms.
3. **Always handle the "not found" case.** Empty retrieval results must produce a graceful response, not hallucination.
4. **Same model for indexing and querying.** No exceptions.
5. **Evaluate with a real test set.** Intuition about RAG quality is unreliable; measure it.
6. **Budget for re-indexing.** Documents change; your index must keep up.
7. **Separate retrieval quality from generation quality.** Fix retrieval problems first; they cause most RAG failures.
