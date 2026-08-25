---
name: rag-implementation
description: >-
  Build production-grade RAG (Retrieval-Augmented Generation) systems.
  English: RAG pipeline, retrieval augmented generation, vector search, semantic search,
    embedding models, chunking strategies, reranking, context injection, grounding LLMs,
    document QA, knowledge base, enterprise search, hallucination prevention, RAGAS evaluation.
  فارسی: سیستم بازیابی تقویت‌شده، جستجوی برداری، جستجوی معنایی، مدل‌های embedding،
    تکه‌تکه‌سازی اسناد، بازrank‌بندی، تزریق زمینه، جلوگیری از توهم، ارزیابی RAGAS.
  中文: 检索增强生成，向量搜索，语义搜索，嵌入模型，文档分块，重排序，上下文注入，
    幻觉预防，RAGAS评估，知识库问答。
---

# RAG (Retrieval-Augmented Generation) Implementation

## Overview

Retrieval-Augmented Generation (RAG) is the architecture of grounding LLM outputs in retrieved evidence from an external knowledge base. Instead of relying solely on parametric memory (model weights), RAG retrieves relevant document chunks at inference time and injects them into the LLM context window. This reduces hallucination, enables domain-specific expertise without fine-tuning, and keeps knowledge fresh without retraining.

A production RAG pipeline consists of five stages: **Ingestion** (chunk → embed → store), **Retrieval** (query → search → filter), **Reranking** (score → prune → reorder), **Generation** (prompt → generate → cite), and **Evaluation** (measure → iterate → monitor). Each stage introduces failure modes that compound downstream — a poor chunking strategy destroys retrieval quality, which poisons generation, which makes evaluation misleading.

This skill covers the full lifecycle with actionable patterns, not just concepts. Every technique includes production trade-offs, failure modes, and measurement criteria.

## When to Use This Skill

- Building question-answering over proprietary document collections
- Creating domain-specific copilots (legal, medical, financial, code)
- Implementing enterprise search with natural language interface
- Reducing hallucination in LLM applications by grounding in sources
- Building chatbots that must cite sources or maintain factual accuracy
- Creating internal knowledge bases from Confluence, Slack, or wiki exports
- Supporting customer support automation with verified answers
- Building code assistants that retrieve from internal codebases and documentation

## When NOT to Use This Skill

- Tasks where the LLM's parametric knowledge is sufficient (general trivia)
- Real-time data that changes faster than indexing latency allows
- Highly structured data better served by SQL or graph queries
- Tasks requiring mathematical reasoning (use tool-augmented approaches)
- When the document corpus is tiny (< 10 documents) — direct context stuffing is simpler
- When latency budgets are under 100ms end-to-end (RAG adds retrieval latency)
- When the knowledge base requires complex relational reasoning (use GraphRAG or knowledge graphs)

---

## Workflow

### Phase 1: Document Ingestion and Chunking

**Objective:** Transform raw documents into searchable, semantically coherent chunks.

```
Raw Documents → Preprocessing → Chunking → Metadata Enrichment → Embedding → Vector Store
```

**Step 1.1 — Document Loading**
Load documents from source systems. Handle PDFs, Markdown, HTML, DOCX, code files, and structured formats. Strip boilerplate (headers, footers, navigation, ads) before chunking.

**Step 1.2 — Text Preprocessing**
Normalize whitespace, fix encoding issues, remove control characters. For code: preserve formatting. For multilingual content: detect language and route to appropriate tokenizer.

**Step 1.3 — Chunking Strategy Selection**
Choose a chunking strategy based on document type and query patterns:

| Strategy | Best For | Chunk Size | Overlap |
|---|---|---|---|
| Fixed-size | Uniform documents, logs | 512-1024 tokens | 50-100 tokens |
| Recursive splitting | Mixed content, markdown | 512-1024 tokens | 50-100 tokens |
| Semantic chunking | Narrative, research papers | Variable (2-10 sentences) | 1-2 sentences |
| Document-based | PDFs, HTML with structure | Per section/heading | None |
| Agentic chunking | Complex documents, code | LLM-determined | Variable |
| Parent-child | Detailed retrieval + context | Small (256) + Parent (1024) | None |
| Code-aware | Source code | Per function/class | None |

**Step 1.4 — Metadata Enrichment**
Attach metadata to each chunk: source document, page number, section heading, chunk index, document type, date, author. This enables filtered retrieval and citation.

**Step 1.5 — Embedding**
Generate vector embeddings using a model appropriate for your domain and languages. Store in a vector database with metadata.

### Phase 2: Retrieval Pipeline

**Objective:** Given a user query, find the most relevant chunks from the knowledge base.

```
User Query → Query Preprocessing → Vector Search → Keyword Search → Hybrid Fusion → Candidates
```

**Step 2.1 — Query Preprocessing**
Clean and transform the query: expand abbreviations, fix typos, decompose complex questions into sub-queries (multi-query retrieval).

**Step 2.2 — Retrieval Strategy**
Execute one or more retrieval strategies in parallel:
- **Dense retrieval:** Embed the query, find nearest neighbors in vector space.
- **Sparse retrieval (BM25):** Token-based keyword matching with TF-IDF weighting.
- **Hybrid retrieval:** Combine dense and sparse scores with reciprocal rank fusion (RRF).

**Step 2.3 — Filtering and Pre-ranking**
Apply metadata filters (date range, document type, access control). Remove low-similarity results below a threshold. Deduplicate near-identical chunks.

### Phase 3: Reranking and Context Assembly

**Objective:** Refine retrieval results and assemble the optimal context window.

```
Candidates → Cross-encoder Reranking → MMR Deduplication → Context Assembly → Prompt
```

**Step 3.1 — Reranking**
Apply a cross-encoder reranker (e.g., Cohere Rerank, cross-encoder/ms-marco-MiniLM) to rescore the top-K candidates. Cross-encoders jointly process query and document, producing more accurate relevance scores than bi-encoder embeddings.

**Step 3.2 — Context Window Management**
Assemble the final context: fit the top reranked chunks into the LLM's context window, respecting token limits. Use lost-in-the-middle mitigation: place the most relevant chunks at the beginning and end of the context, not buried in the middle.

**Step 3.3 — Citation and Provenance**
Tag each chunk with a citation ID (e.g., [1], [2]) and track which source document it came from. The generation prompt should instruct the LLM to cite sources.

### Phase 4: Generation with Grounding

**Objective:** Generate accurate, grounded responses that cite retrieved evidence.

```
Prompt (System + Context + Query) → LLM → Response with Citations → Post-processing
```

**Step 4.1 — Prompt Engineering**
Construct the system prompt with clear instructions: answer only from the provided context, cite sources, say "I don't know" when evidence is insufficient, and distinguish between facts and inferences.

**Step 4.2 — Generation**
Call the LLM with the assembled prompt. Use temperature=0 for factual tasks, temperature=0.3-0.7 for creative or summarization tasks.

**Step 4.3 — Post-processing**
Validate that citations are real (not hallucinated). Extract source references. Optionally run a faithfulness check using an LLM-as-judge or RAGAS faithfulness score.

### Phase 5: Evaluation and Monitoring

**Objective:** Measure RAG quality across all dimensions and iteratively improve.

```
Test Set → Retrieval Metrics → Generation Metrics → End-to-end Metrics → Dashboard
```

**Step 5.1 — Build Evaluation Dataset**
Create a ground-truth dataset with (question, context_ids, answer) triples. Include adversarial questions (unanswerable, ambiguous, multi-hop).

**Step 5.2 — Run RAGAS Evaluation**
Compute RAGAS metrics: faithfulness, answer relevancy, context precision, context recall, answer correctness.

**Step 5.3 — A/B Testing**
Compare pipeline configurations (chunk size, embedding model, reranker, prompt) using held-out evaluation sets.

**Step 5.4 — Production Monitoring**
Log all queries, retrievals, and generations. Monitor for retrieval drift, latency, and user feedback (thumbs up/down).

---

## Advanced Techniques

### 1. Hierarchical Indexing with Summary Chains

Index documents at multiple levels of granularity. Create document-level summaries, section-level summaries, and paragraph-level chunks. At query time, first retrieve relevant documents by summary, then drill into specific sections, then retrieve precise chunks. This mimics how humans navigate large document collections.

```python
# Build hierarchical index
from langchain.text_splitter import RecursiveCharacterTextSplitter

def build_hierarchical_index(documents):
    # Level 1: Document summaries (1 per doc)
    doc_summaries = [summarize(doc) for doc in documents]
    
    # Level 2: Section chunks (512 tokens)
    section_splitter = RecursiveCharacterTextSplitter(
        chunk_size=512, chunk_overlap=50,
        separators=["## ", "### ", "#### ", "\n\n", "\n"]
    )
    sections = []
    for doc in documents:
        for chunk in section_splitter.split_text(doc.text):
            sections.append({
                "text": chunk,
                "doc_id": doc.id,
                "level": "section"
            })
    
    # Level 3: Fine chunks (256 tokens) for precise retrieval
    fine_splitter = RecursiveCharacterTextSplitter(
        chunk_size=256, chunk_overlap=30
    )
    fine_chunks = []
    for section in sections:
        for chunk in fine_splitter.split_text(section["text"]):
            fine_chunks.append({
                "text": chunk,
                "section_id": section["id"],
                "level": "fine"
            })
    
    return doc_summaries, sections, fine_chunks
```

### 2. Query Decomposition and Multi-Query Retrieval

Complex questions often cannot be answered by a single retrieval. Decompose the query into sub-questions, retrieve for each independently, then merge results.

```python
from langchain.chat_models import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

async def multi_query_retrieval(query: str, retriever, top_k: int = 5):
    """Decompose complex query into sub-queries and merge results."""
    
    decomposition_prompt = ChatPromptTemplate.from_template(
        """Given the user question, generate 3-5 sub-questions that 
        together would fully answer the original question.
        
        User question: {question}
        
        Sub-questions (one per line):"""
    )
    
    llm = ChatOpenAI(model="gpt-4", temperature=0.3)
    response = await llm.ainvoke(
        decomposition_prompt.format_messages(question=query)
    )
    
    sub_queries = [q.strip() for q in response.content.split("\n") if q.strip()]
    sub_queries.append(query)  # Include original query
    
    # Retrieve for each sub-query
    all_results = {}
    for sq in sub_queries:
        results = await retriever.aretrieve(sq)
        for doc in results:
            # Use sub-query count as diversity signal
            doc_id = doc.metadata.get("id", doc.page_content[:50])
            if doc_id not in all_results:
                all_results[doc_id] = {"doc": doc, "score": 0, "queries": []}
            all_results[doc_id]["score"] += 1
            all_results[doc_id]["queries"].append(sq)
    
    # Merge and rank by multi-query coverage
    ranked = sorted(
        all_results.values(), 
        key=lambda x: (x["score"], len(x["queries"])), 
        reverse=True
    )
    
    return [r["doc"] for r in ranked[:top_k]]
```

### 3. Parent-Child Retrieval with Contextual Compression

Retrieve small, precise child chunks for matching, but return the larger parent chunk for context. This solves the precision-recall tradeoff in chunking.

```python
def build_parent_child_index(documents, child_size=256, parent_size=1024):
    """Build parent-child chunk index."""
    parent_splitter = RecursiveCharacterTextSplitter(
        chunk_size=parent_size, chunk_overlap=100
    )
    child_splitter = RecursiveCharacterTextSplitter(
        chunk_size=child_size, chunk_overlap=30
    )
    
    parents = []
    children = []
    
    for doc in documents:
        parent_chunks = parent_splitter.split_text(doc.text)
        for i, parent_text in enumerate(parent_chunks):
            parent_id = f"{doc.id}_p{i}"
            parents.append({"id": parent_id, "text": parent_text, "doc_id": doc.id})
            
            child_chunks = child_splitter.split_text(parent_text)
            for j, child_text in enumerate(child_chunks):
                children.append({
                    "text": child_text,
                    "parent_id": parent_id,
                    "doc_id": doc.id,
                })
    
    return parents, children

async def parent_child_retrieve(query, child_retriever, parent_index, top_k=5):
    """Retrieve via child chunks, return parent context."""
    child_results = await child_retriever.aretrieve(query)
    
    seen_parents = set()
    parent_results = []
    for child in child_results:
        parent_id = child.metadata["parent_id"]
        if parent_id not in seen_parents:
            seen_parents.add(parent_id)
            parent = parent_index[parent_id]
            parent_results.append(parent)
    
    return parent_results[:top_k]
```

### 4. Hybrid Search with Reciprocal Rank Fusion

Combine dense (semantic) and sparse (keyword) retrieval using Reciprocal Rank Fusion to get the best of both worlds.

```python
import numpy as np
from typing import List, Dict

def reciprocal_rank_fusion(
    ranked_lists: List[List[str]], 
    k: int = 60
) -> List[str]:
    """Fuse multiple ranked lists using RRF."""
    scores: Dict[str, float] = {}
    doc_map: Dict[str, str] = {}
    
    for ranked_list in ranked_lists:
        for rank, doc_id in enumerate(ranked_list):
            if doc_id not in scores:
                scores[doc_id] = 0.0
            scores[doc_id] += 1.0 / (k + rank + 1)
            doc_map[doc_id] = doc_id
    
    # Sort by fused score
    fused = sorted(scores.items(), key=lambda x: x[1], reverse=True)
    return [doc_id for doc_id, _ in fused]

async def hybrid_retrieve(query, dense_retriever, sparse_retriever, top_k=10):
    """Combine dense and sparse retrieval with RRF."""
    dense_results = await dense_retriever.aretrieve(query)
    sparse_results = await sparse_retriever.aretrieve(query)
    
    dense_ids = [r.metadata["id"] for r in dense_results]
    sparse_ids = [r.metadata["id"] for r in sparse_results]
    
    fused_ids = reciprocal_rank_fusion([dense_ids, sparse_ids])
    
    # Retrieve full documents for fused results
    doc_map = {r.metadata["id"]: r for r in dense_results + sparse_results}
    return [doc_map[did] for did in fused_ids[:top_k] if did in doc_map]
```

### 5. Self-RAG with Reflection Tokens

Let the LLM decide when to retrieve, whether retrieved context is relevant, whether the generation is supported, and whether the generation is useful. This adds adaptive retrieval to avoid unnecessary retrieval calls.

```python
SELF_RAG_PROMPT = """You are a self-reflective RAG assistant.

For each question, follow this process:
1. [Retrieve] Decide: Do I need external information? (Yes/No)
   - If No: answer from your knowledge and mark as [No Retrieval]
   - If Yes: output [Retrieve: <specific search query>]

2. [IsRel] After seeing retrieved passages, evaluate each:
   - [IsRel+]: passage is relevant to answering the question
   - [IsRel-]: passage is not relevant (ignore it)

3. [IsSup] For each claim in your answer:
   - [IsSup+]: claim is directly supported by a retrieved passage
   - [IsSup-]: claim is not supported (remove or flag as uncertain)
   - [IsSup?]: claim is uncertain

4. [IsUse] Final answer utility:
   - [IsUse+]: answer is useful and complete
   - [IsUse-]: answer is incomplete or low quality (revise)

Question: {question}

Process:"""
```

### 6. Adaptive Chunking with Semantic Boundaries

Instead of fixed-size chunking, detect semantic boundaries using embedding similarity between adjacent sentences. Create chunks at natural topic transitions.

```python
import numpy as np
from sentence_transformers import SentenceTransformer

def adaptive_semantic_chunks(
    text: str, 
    model: SentenceTransformer,
    threshold: float = 0.5,
    min_chunk_sentences: int = 2,
    max_chunk_sentences: int = 15
) -> list:
    """Split text at semantic boundaries."""
    sentences = split_into_sentences(text)
    if len(sentences) <= min_chunk_sentences:
        return [text]
    
    embeddings = model.encode(sentences)
    
    # Compute similarity between adjacent sentences
    similarities = []
    for i in range(len(embeddings) - 1):
        sim = np.dot(embeddings[i], embeddings[i+1]) / (
            np.linalg.norm(embeddings[i]) * np.linalg.norm(embeddings[i+1])
        )
        similarities.append(sim)
    
    # Find break points where similarity drops below threshold
    break_points = [0]
    for i, sim in enumerate(similarities):
        if sim < threshold:
            break_points.append(i + 1)
    break_points.append(len(sentences))
    
    # Enforce min/max chunk sizes
    chunks = []
    for i in range(len(break_points) - 1):
        start = break_points[i]
        end = break_points[i + 1]
        chunk_sents = sentences[start:end]
        
        if len(chunk_sents) < min_chunk_sentences and chunks:
            # Merge with previous chunk
            chunks[-1].extend(chunk_sents)
        elif len(chunk_sents) > max_chunk_sentences:
            # Split further
            for j in range(0, len(chunk_sents), max_chunk_sentences):
                chunks.append(chunk_sents[j:j + max_chunk_sentences])
        else:
            chunks.append(chunk_sents)
    
    return [" ".join(chunk) for chunk in chunks]
```

### 7. Hallucination Detection with Attribution Verification

Verify that every claim in the LLM output is attributable to a specific retrieved chunk. Detect and flag unsupported statements.

```python
async def verify_attribution(
    response: str, 
    retrieved_chunks: list,
    llm,
    threshold: float = 0.7
) -> dict:
    """Verify that each claim in the response is grounded in retrieved context."""
    
    # Step 1: Extract claims from the response
    claims_prompt = f"""Extract all factual claims from this response as a JSON list.
Each claim should be a standalone statement.

Response: {response}

Claims (JSON array of strings):"""
    
    claims_response = await llm.ainvoke(claims_prompt)
    claims = parse_json_list(claims_response.content)
    
    # Step 2: Verify each claim against retrieved chunks
    verifications = []
    for claim in claims:
        verification_prompt = f"""Given these retrieved passages, determine if the claim 
is directly supported by at least one passage.

Claim: {claim}

Passages:
{format_chunks(retrieved_chunks)}

Answer as JSON: {{"supported": true/false, "evidence": "quote from passage", "chunk_id": N}}"""
        
        v_response = await llm.ainvoke(verification_prompt)
        v = parse_json(v_response.content)
        v["claim"] = claim
        verifications.append(v)
    
    # Step 3: Compute attribution score
    supported = sum(1 for v in verifications if v.get("supported", False))
    attribution_score = supported / len(verifications) if verifications else 0
    
    return {
        "attributed_claims": [v for v in verifications if v.get("supported")],
        "unsupported_claims": [v for v in verifications if not v.get("supported")],
        "attribution_score": attribution_score,
        "meets_threshold": attribution_score >= threshold
    }
```

---

## Common Patterns

### Pattern 1: Basic RAG Pipeline with LangChain

```python
from langchain.document_loaders import DirectoryLoader, TextLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain.chat_models import ChatOpenAI
from langchain.chains import RetrievalQA
from langchain.prompts import ChatPromptTemplate

# --- Ingestion ---
loader = DirectoryLoader("./docs", glob="**/*.md", loader_cls=TextLoader)
documents = loader.load()

splitter = RecursiveCharacterTextSplitter(
    chunk_size=512,
    chunk_overlap=50,
    separators=["\n\n", "\n", ". ", " "],
    length_function=len,
)
chunks = splitter.split_documents(documents)

# --- Vector Store ---
embeddings = OpenAIEmbeddings(model="text-embedding-3-small")
vectorstore = Chroma.from_documents(
    chunks, embeddings,
    collection_metadata={"hnsw:space": "cosine"},
    persist_directory="./chroma_db"
)

# --- Retrieval QA ---
prompt = ChatPromptTemplate.from_template("""
Answer the question based ONLY on the following context. 
If the context doesn't contain enough information, say "I don't have enough information to answer this question."
Always cite your sources using [1], [2], etc.

Context:
{context}

Question: {question}

Answer with citations:""")

qa_chain = RetrievalQA.from_chain_type(
    llm=ChatOpenAI(model="gpt-4", temperature=0),
    chain_type="stuff",
    retriever=vectorstore.as_retriever(
        search_type="mmr",
        search_kwargs={"k": 5, "fetch_k": 20}
    ),
    return_source_documents=True,
    chain_type_kwargs={"prompt": prompt}
)

result = qa_chain.invoke({"query": "What are the deployment steps?"})
print(result["result"])
for doc in result["source_documents"]:
    print(f"Source: {doc.metadata['source']}, Page: {doc.metadata.get('page', 'N/A')}")
```

### Pattern 2: Hybrid Search with Pinecone

```python
import pinecone
from sentence_transformers import SentenceTransformer
from rank_bm25 import BM25Okapi
import numpy as np

# --- Setup ---
pinecone.init(api_key="YOUR_KEY", environment="us-east-1")
index = pinecone.Index("rag-documents")
encoder = SentenceTransformer("BAAI/bge-small-en-v1.5")

# --- Ingestion with metadata ---
def upsert_documents(documents, index):
    for doc in documents:
        chunks = split_document(doc)
        for i, chunk in enumerate(chunks):
            embedding = encoder.encode(chunk["text"]).tolist()
            index.upsert([(doc["id"] + f"_c{i}", embedding, {
                "text": chunk["text"],
                "source": doc["source"],
                "section": chunk.get("section", ""),
                "date": doc.get("date", ""),
            })])

# --- Hybrid retrieval ---
async def hybrid_search(query, index, bm25_index, doc_map, top_k=10):
    # Dense search
    query_embedding = encoder.encode(query).tolist()
    dense_results = index.query(
        vector=query_embedding, top_k=top_k * 2,
        include_metadata=True
    )
    
    # Sparse search (BM25)
    tokenized_query = query.lower().split()
    bm25_scores = bm25_index.get_scores(tokenized_query)
    bm25_top_indices = np.argsort(bm25_scores)[-top_k * 2:][::-1]
    
    # Reciprocal Rank Fusion
    dense_ranks = {m["id"]: i for i, m in enumerate(dense_results["matches"])}
    bm25_ranks = {doc_map[i]["id"]: rank for rank, i in enumerate(bm25_top_indices)}
    
    all_ids = set(dense_ranks.keys()) | set(bm25_ranks.keys())
    rrf_scores = {}
    for doc_id in all_ids:
        rrf_scores[doc_id] = (
            1.0 / (60 + dense_ranks.get(doc_id, 100)) +
            1.0 / (60 + bm25_ranks.get(doc_id, 100))
        )
    
    ranked = sorted(rrf_scores.items(), key=lambda x: x[1], reverse=True)
    return [doc_map[doc_id] for doc_id, _ in ranked[:top_k]]
```

### Pattern 3: RAGAS Evaluation Pipeline

```python
from ragas import evaluate
from ragas.metrics import (
    faithfulness,
    answer_relevancy,
    context_precision,
    context_recall,
    answer_correctness
)
from datasets import Dataset

def build_ragas_dataset(test_questions, rag_pipeline):
    """Run RAG pipeline and build evaluation dataset."""
    data = {
        "question": [],
        "answer": [],
        "contexts": [],
        "ground_truth": []
    }
    
    for q in test_questions:
        result = rag_pipeline.invoke(q["question"])
        data["question"].append(q["question"])
        data["answer"].append(result["result"])
        data["contexts"].append([
            doc.page_content for doc in result["source_documents"]
        ])
        data["ground_truth"].append(q["ground_truth"])
    
    return Dataset.from_dict(data)

def evaluate_rag_pipeline(rag_pipeline, test_dataset):
    """Comprehensive RAGAS evaluation."""
    eval_data = build_ragas_dataset(test_dataset, rag_pipeline)
    
    result = evaluate(
        eval_data,
        metrics=[
            faithfulness,      # Are answers grounded in context?
            answer_relevancy,  # Do answers address the question?
            context_precision,# Are retrieved contexts relevant?
            context_recall,   # Did we retrieve all necessary context?
            answer_correctness  # Is the answer factually correct?
        ]
    )
    
    print("=== RAGAS Evaluation Results ===")
    print(f"Faithfulness:          {result['faithfulness']:.3f}")
    print(f"Answer Relevancy:      {result['answer_relevancy']:.3f}")
    print(f"Context Precision:     {result['context_precision']:.3f}")
    print(f"Context Recall:        {result['context_recall']:.3f}")
    print(f"Answer Correctness:    {result['answer_correctness']:.3f}")
    
    return result
```

### Pattern 4: Streaming RAG with Citations

```python
import asyncio
from typing import AsyncGenerator

async def streaming_rag(
    query: str, 
    retriever, 
    llm, 
    top_k: int = 5
) -> AsyncGenerator[str, None]:
    """Stream RAG response with inline citations."""
    
    # Retrieve context
    docs = await retriever.aretrieve(query)
    
    # Build context with citation markers
    context_parts = []
    for i, doc in enumerate(docs):
        citation_id = i + 1
        context_parts.append(f"[{citation_id}] {doc.page_content}")
    
    context = "\n\n".join(context_parts)
    
    system_prompt = f"""You are a helpful assistant. Answer the question using ONLY the 
provided context. Cite sources using [1], [2], etc. format.

If the context doesn't contain enough information, say so.

CONTEXT:
{context}"""
    
    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": query}
    ]
    
    # Stream response
    stream = await llm.astream(messages)
    async for chunk in stream:
        yield chunk.content
    
    # Append sources
    yield "\n\n---\n**Sources:**\n"
    for i, doc in enumerate(docs):
        yield f"[{i+1}] {doc.metadata.get('source', 'Unknown')} "
        yield f"(page {doc.metadata.get('page', 'N/A')})\n"
```

### Pattern 5: Agentic RAG with Tool Use

```python
from langchain.agents import create_openai_tools_agent, AgentExecutor
from langchain.tools import Tool

def create_agentic_rag(vectorstores: dict):
    """Create an agent that can query multiple knowledge bases."""
    
    tools = []
    for name, vs in vectorstores.items():
        retriever = vs.as_retriever(search_kwargs={"k": 5})
        
        def make_search(vstore):
            def search(query):
                docs = vstore.similarity_search(query, k=5)
                return "\n\n".join([
                    f"Source: {d.metadata.get('source', 'Unknown')}\n{d.page_content}"
                    for d in docs
                ])
            return search
        
        tools.append(Tool(
            name=f"search_{name}",
            func=make_search(vs),
            description=f"Search the {name} knowledge base. Use for questions about {name}."
        ))
    
    llm = ChatOpenAI(model="gpt-4", temperature=0)
    prompt = ChatPromptTemplate.from_messages([
        ("system", """You have access to multiple knowledge bases. Choose the most 
appropriate one(s) for each question. You may query multiple bases and synthesize 
the results. Always cite your sources."""),
        ("human", "{input}"),
        ("placeholder", "{agent_scratchpad}")
    ])
    
    agent = create_openai_tools_agent(llm, tools, prompt)
    return AgentExecutor(agent=agent, tools=tools, verbose=True, max_iterations=5)
```

---

## Edge Cases & Pitfalls

### 1. Chunking Misalignment
**Problem:** Chunking splits a sentence or code block mid-way, destroying semantic meaning.
**Solution:** Use document-aware or semantic chunking. Always test chunk boundaries manually on sample documents.

### 2. Embedding Model Domain Mismatch
**Problem:** General-purpose embeddings perform poorly on domain-specific content (medical, legal, code).
**Solution:** Fine-tune embeddings on domain-specific query-document pairs, or use a domain-specialized model (e.g., Med-CPT for biomedical, CodeBERT for code).

### 3. Context Window Overflow
**Problem:** Retrieved chunks exceed the LLM's context window, causing silent truncation.
**Solution:** Track token counts explicitly. Implement context budget management: allocate tokens to system prompt, context, and query with hard limits.

### 4. Lost in the Middle
**Problem:** LLMs pay less attention to information buried in the middle of long contexts.
**Solution:** Place the most relevant chunks at the beginning and end of the context window. Use reranking to ensure top results are first.

### 5. Hallucinated Citations
**Problem:** The LLM generates citation numbers that don't correspond to actual retrieved chunks.
**Solution:** Post-process the output to validate citations. Use prompt instructions that explicitly list the available citation IDs.

### 6. Query-Document Vocabulary Mismatch
**Problem:** User queries use different terminology than the documents (e.g., "heart attack" vs "myocardial infarction").
**Solution:** Use query expansion with synonyms or HyDE (Hypothetical Document Embeddings) — generate a hypothetical answer, embed it, and use that for retrieval.

### 7. Duplicate Content Across Documents
**Problem:** Multiple documents contain similar or identical content, causing redundant retrieval.
**Solution:** Deduplicate at ingestion time using MinHash or SimHash. During retrieval, apply MMR (Maximal Marginal Relevance) to diversify results.

### 8. Temporal Knowledge Conflicts
**Problem:** Documents from different time periods contain contradictory information (policies that changed, deprecated APIs).
**Solution:** Include timestamps in metadata. Filter by recency when appropriate. Make the LLM aware of document dates and instruct it to prefer recent information.

### 9. Multi-hop Reasoning Failures
**Problem:** The question requires connecting information from multiple chunks that aren't individually sufficient.
**Solution:** Implement query decomposition. Use iterative retrieval: retrieve → reason → determine if more information is needed → retrieve again.

### 10. Embedding Drift After Model Updates
**Problem:** Changing the embedding model invalidates existing vector indexes. Queries encoded with the new model don't match old embeddings.
**Solution:** Plan for embedding model migrations. Re-encode all documents when changing models. Use versioned collections.

### 11. Access Control Leakage
**Problem:** Users retrieve documents they shouldn't have access to because the vector store doesn't enforce permissions.
**Solution:** Implement pre-retrieval filtering using metadata-based access control. Filter chunks by user role, department, or classification level before scoring.

### 12. Latency Spikes from Reranking
**Problem:** Cross-encoder reranking on large candidate sets causes unacceptable latency.
**Solution:** Limit reranking to top-20 candidates. Use lightweight rerankers (MiniLM) for latency-sensitive paths. Cache frequent query results.

### 13. Code Chunk Breaking Functions
**Problem:** Code-aware chunking splits functions or classes, making code snippets incomplete and unusable.
**Solution:** Use AST-aware chunking that respects function/class boundaries. Use tree-sitter or language-specific parsers.

### 14. Multilingual Retrieval Degradation
**Problem:** Embedding models trained primarily on English perform poorly for other languages, especially for mixed-language queries.
**Solution:** Use multilingual embedding models (e.g., multilingual-e5-large). Separate collections by language or use language-aware metadata filtering.

### 15. Evaluation Dataset Staleness
**Problem:** The evaluation dataset becomes outdated as the knowledge base evolves, making metrics misleading.
**Solution:** Automate evaluation dataset updates by sampling recent production queries. Periodically refresh ground-truth answers.

---

## Integration with Other Skills

| Skill | Integration Type | Description |
|---|---|---|
| **Prompt Engineering** | Dependency | RAG quality depends heavily on system prompt design for grounding and citation |
| **Embedding Fine-tuning** | Enhancement | Fine-tune embeddings on domain-specific query-document pairs for better retrieval |
| **Data Cleaning** | Dependency | Ingestion quality directly impacts retrieval — clean, well-structured documents chunk better |
| **Technical Writing** | Companion | Documentation quality affects chunking and retrieval — well-structured docs retrieve better |
| **Data Analysis** | Evaluation | Use statistical analysis to evaluate retrieval quality and optimize hyperparameters |
| **Summarization** | Complementary | Summarize retrieved chunks for context compression before generation |
| **Code Understanding** | Enhancement | AST-aware chunking and code-specific retrieval for codebase RAG |
| **Monitoring & Observability** | Production | Track retrieval quality, latency, and generation faithfulness in production |

---

## Output Format Templates

### Standard RAG Response

```markdown
## Answer

{answer_text}

## Sources

| # | Source | Section | Relevance |
|---|--------|---------|-----------|
| [1] | {source_1} | {section_1} | High |
| [2] | {source_2} | {section_2} | Medium |

*Answer generated from {n} retrieved passages. Confidence: {confidence}/10*
```

### Quick RAG Response

```markdown
**{concise_answer}**

Sources: [{source_citations}]
```

### Deep RAG Response (Multi-source, Analytical)

```markdown
## Answer

### Overview
{overview_paragraph}

### Detailed Analysis
{detailed_analysis_with_citations}

### Key Findings
- **Finding 1:** {finding_1} [1]
- **Finding 2:** {finding_2} [2]
- **Finding 3:** {finding_3} [3]

### Caveats and Limitations
{caveats_about_information_coverage}

## Evidence

| Source | Type | Date | Citation |
|--------|------|------|----------|
| {source_1} | {type_1} | {date_1} | [1] |
| {source_2} | {type_2} | {date_2} | [2] |

*Retrieved from {total_chunks} chunks across {total_sources} sources.*
*RAG Faithfulness Score: {faithfulness_score}*
```

### Agent RAG Response (Multi-step, Tool-using)

```markdown
## Reasoning Steps

### Step 1: Query Analysis
**Intent:** {detected_intent}
**Sub-queries:** {sub_queries}
**Knowledge bases queried:** {kb_list}

### Step 2: Retrieval
- Queried {kb_name_1}: {n1} results, top relevance: {score1}
- Queried {kb_name_2}: {n2} results, top relevance: {score2}

### Step 3: Synthesis
{synthesis_text}

## Answer
{final_answer_with_citations}

## Execution Metadata
- Total retrieval calls: {retrieval_calls}
- Total reranking operations: {reranking_ops}
- End-to-end latency: {latency_ms}ms
- Sources cited: {citation_count}
```

---

## Rules

1. **Always chunk before embedding** — Never embed entire documents. Chunk into semantically meaningful units of 256-1024 tokens with 10-20% overlap.
2. **Test chunking strategies empirically** — Don't assume one strategy works for all content. Benchmark retrieval quality across at least 3 strategies.
3. **Use hybrid retrieval by default** — Pure semantic search misses keyword-specific queries. Combine dense + sparse (BM25) with reciprocal rank fusion.
4. **Rerank top-K candidates** — Always apply a cross-encoder reranker to refine retrieval results. Bi-encoder scores are approximate; cross-encoder scores are precise.
5. **Manage context window budgets** — Track token counts. Allocate: 15-20% system prompt, 60-70% context, 10-15% query + response space.
6. **Place most relevant chunks at context boundaries** — Mitigate lost-in-the-middle by positioning top results at the start and end of the context.
7. **Validate citations post-generation** — Never trust LLM citations without verification. Cross-check that referenced sources actually exist and support the claim.
8. **Evaluate with RAGAS, not just vibes** — Measure faithfulness, answer relevancy, context precision, and context recall quantitatively. Track over time.
9. **Include metadata in every chunk** — Source document, page, section, date, chunk index. Metadata enables filtered retrieval and source attribution.
10. **Handle unanswerable questions gracefully** — Train the pipeline to return "I don't have enough information" rather than hallucinating. This is a feature, not a bug.
11. **Version your vector indexes** — Embedding model changes or ingestion pipeline updates should produce new, versioned collections. Never overwrite in place.
12. **Monitor retrieval quality in production** — Log queries, retrieved chunks, and user feedback. Set alerts for retrieval score degradation.
13. **Implement access control at retrieval time** — Filter chunks by user permissions before scoring. Don't rely on post-retrieval filtering alone.
14. **Optimize for your dominant query pattern** — If 80% of queries are factual lookups, optimize for precision. If 80% are exploratory, optimize for recall and diversity.
15. **Prefer incremental ingestion** — Process new/changed documents, not the entire corpus. Use document fingerprints or checksums to detect changes.
