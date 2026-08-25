---
name: rag-implementation
description: >-
  Implement Retrieval Augmented Generation (RAG) systems including vector databases, embedding pipelines, chunking strategies, retrieval logic, reranking, evaluation, and production deployment. Use this skill when the user mentions RAG, پیاده‌سازی RAG, retrieval augmented generation, vector database, embedding search, semantic search, document retrieval, knowledge base, chunking strategy, embedding model, similarity search, context retrieval, RAG pipeline, RAG system, RAG evaluation, retrieval pipeline, HyDE, multi-query retrieval, sentence window, parent-child indexing, reranking, vector store, knowledge base Q&A, or asks how to make an LLM answer questions from their own documents/data.
---

# RAG Implementation Skill — Complete Retrieval Augmented Generation Guide

## Overview

This skill provides comprehensive guidance for implementing Retrieval Augmented Generation (RAG) systems. RAG combines a retrieval system (find relevant documents) with a generation system (LLM synthesizes an answer from those documents). This guide covers every aspect: document preparation, advanced chunking strategies, embedding model selection, vector database configuration, sophisticated retrieval techniques, reranking, generation, evaluation with production metrics, monitoring, and deployment.

## When to Use This Skill

- User wants to build a system that answers questions from their documents
- User needs to implement vector search or semantic search
- User asks about embedding models, chunking, or retrieval strategies
- User wants to set up a vector database (Pinecone, Weaviate, Chroma, Qdrant, pgvector, Milvus, FAISS, etc.)
- User needs help with RAG pipeline architecture
- User wants to evaluate or improve their existing RAG system
- User mentions HyDE, multi-query, sentence window, parent-child indexing
- User asks about reranking strategies (Cohere, BGE, cross-encoder)
- User wants to deploy RAG in production with monitoring
- User mentions پیاده‌سازی RAG or سیستم بازیابی اطلاعات

## RAG Architecture

```
Documents → Ingestion → Chunking → Embedding → Vector Store
                                                    ↓
User Query → [Query Transformation] → Embedding → Retrieval → [Reranking] → Context Assembly → LLM → Answer
                                                                                                    ↓
                                                                                              [Evaluation]
```

### Advanced RAG Architecture (Multi-Stage)

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐    ┌────────────┐    ┌──────────┐
│  Document    │ →  │   Chunking   │ →  │  Embedding  │ →  │  Vector    │ →  │  Index   │
│  Ingestion   │    │  Strategy    │    │  Pipeline   │    │  Store     │    │  Builder │
└─────────────┘    └──────────────┘    └─────────────┘    └────────────┘    └──────────┘

┌─────────────┐    ┌──────────────┐    ┌─────────────┐    ┌────────────┐    ┌──────────┐
│  User Query  │ →  │    Query     │ →  │  Retrieval  │ →  │  Reranking │ →  │  LLM     │
│              │    │  Expansion   │    │  (Hybrid)   │    │  Engine    │    │  Generate │
└─────────────┘    └──────────────┘    └─────────────┘    └────────────┘    └──────────┘
```

## Implementation Workflow

### Phase 1: Understand Requirements

Before writing code, clarify:

1. **Data sources** — What documents? (PDFs, web pages, code, database records, plain text, markdown, HTML, DOCX)
2. **Scale** — How many documents? Total size? Expected query volume?
3. **Language** — What language(s) are the documents and queries? Multilingual?
4. **Latency** — Real-time (seconds) or batch processing?
5. **Accuracy** — What's the cost of a wrong answer? Hallucination tolerance?
6. **Infrastructure** — Cloud, on-prem, local? What's the deployment target?
7. **Budget** — API costs for embedding models and LLM generation?
8. **Update frequency** — How often do documents change? Incremental or full re-index?

### Phase 2: Document Preparation

#### Document Loading Patterns

| Format | Library | Notes |
|--------|---------|-------|
| PDF | PyMuPDF, pdfplumber, unstructured | Handle scanned PDFs with OCR (Tesseract) |
| DOCX | python-docx | Preserve structure (headings, lists, tables) |
| HTML | BeautifulSoup, trafilatura | Extract main content, remove boilerplate |
| Markdown | markdown-it-py, regex | Preserve heading hierarchy |
| CSV/TSV | pandas | Row-based or cell-based chunking |
| JSON/JSONL | json, ijson | Schema-aware chunking |
| Code files | tree-sitter, ast parsing | AST-aware chunking for code |
| Emails | email, imaplib | Parse headers, attachments separately |

#### Advanced Chunking Strategies

##### 1. Fixed-Size Chunking

```python
from langchain.text_splitter import CharacterTextSplitter

splitter = CharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
    separator="\n"
)
chunks = splitter.split_documents(documents)
```

**When to use:** Uniform documents, simple use cases, initial prototyping.
**Best for:** Plain text, logs, uniform content.
**Limitation:** May split mid-sentence or mid-paragraph.

##### 2. Sentence-Based Chunking

```python
from langchain.text_splitter import NLTKTextSplitter

splitter = NLTKTextSplitter(
    chunk_size=5,  # sentences per chunk
    chunk_overlap=1
)
chunks = splitter.split_documents(documents)
```

**When to use:** Q&A systems, conversational data, where sentence boundaries matter.
**Best for:** Support tickets, chat logs, FAQ data.

##### 3. Recursive Character Splitting

```python
from langchain.text_splitter import RecursiveCharacterTextSplitter

splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
    separators=["\n\n", "\n", ". ", " ", ""],
    length_function=len
)
chunks = splitter.split_documents(documents)
```

**When to use:** Mixed document types (headers + paragraphs + tables).
**Best for:** General-purpose, documents with clear hierarchy.
**Advantage:** Respects document structure by trying larger separators first.

##### 4. Semantic Chunking with Embeddings

```python
# Install: pip install langchain-experimental

from langchain_experimental.text_splitter import SemanticChunker
from langchain_community.embeddings import HuggingFaceEmbeddings

embeddings = HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")

semantic_splitter = SemanticChunker(
    embeddings,
    breakpoint_threshold_type="percentile",  # or "standard_deviation"
    breakpoint_threshold_amount=0.85,
    min_chunk_size_chars=300
)
chunks = semantic_splitter.split_documents(documents)
```

**How it works:**
1. Split document into sentences
2. Embed each sentence
3. Calculate cosine distance between consecutive sentence embeddings
4. When distance exceeds threshold, create a new chunk

**When to use:** Complex documents with varying topic density, research papers, books.
**Best for:** Documents where semantic boundaries don't align with character boundaries.
**Limitation:** Computationally expensive (requires embedding every sentence).

##### 5. Agentic Chunking

```python
from langchain.chat_models import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

llm = ChatOpenAI(model="gpt-4", temperature=0)

def agentic_chunking(text: str, llm) -> list:
    """Use LLM to determine optimal chunk boundaries."""
    prompt = ChatPromptTemplate.from_template("""
    Analyze the following text and identify the optimal chunk boundaries.
    Each chunk should represent a complete, self-contained topic or concept.
    Return the text with chunk markers: [CHUNK_START] and [CHUNK_END].
    
    Text: {text}
    """)
    
    chain = prompt | llm
    result = chain.invoke({"text": text})
    # Parse the result to extract chunks
    chunks = parse_chunk_markers(result.content)
    return chunks
```

**When to use:** High-value documents where quality matters more than cost.
**Best for:** Legal documents, medical records, technical specifications.
**Limitation:** Expensive (LLM calls per document), slower than other methods.

##### 6. Contextual Chunking

```python
def contextual_chunking(document, llm, chunk_size=500):
    """
    Add context to each chunk by prepending document metadata
    and the chunk's position within the document.
    """
    # First, chunk normally
    base_chunks = recursive_splitter.split_documents([document])
    
    # Then enrich each chunk with context
    enriched_chunks = []
    for i, chunk in enumerate(base_chunks):
        context = f"""
        Document: {document.metadata.get('title', 'Unknown')}
        Section: {get_section_heading(document, chunk)}
        Position: Chunk {i+1} of {len(base_chunks)}
        ---
        {chunk.page_content}
        """
        enriched_chunks.append(Document(
            page_content=context,
            metadata=chunk.metadata
        ))
    
    return enriched_chunks
```

**When to use:** When chunks lose context from their surrounding content.
**Best for:** Documents with heavy cross-references, academic papers.

##### 7. Parent-Child (Sentence Window) Chunking

```python
from langchain.text_splitter import SentenceTransformersTokenTextSplitter

def parent_child_chunking(document, window_size=3):
    """
    Create small child chunks for precise retrieval,
    but return the larger parent chunk for context.
    """
    # Split into sentences first
    sentences = sentence_splitter.split_text(document.page_content)
    
    parents = []
    children = []
    
    for i in range(len(sentences)):
        # Child: single sentence for precise matching
        child_text = sentences[i]
        child_metadata = {
            **document.metadata,
            "parent_index": i // window_size,
            "chunk_type": "child"
        }
        children.append(Document(page_content=child_text, metadata=child_metadata))
        
        # Parent: window of sentences for context
        if i % window_size == 0:
            parent_text = " ".join(sentences[i:i+window_size])
            parent_metadata = {
                **document.metadata,
                "parent_index": i // window_size,
                "chunk_type": "parent"
            }
            parents.append(Document(page_content=parent_text, metadata=parent_metadata))
    
    return parents, children
```

**When to use:** When you need precise retrieval but full context for generation.
**Best for:** Long documents, Q&A systems, knowledge bases.

##### 8. Code-Aware Chunking

```python
import tree_sitter
from tree_sitter import Language, Parser

def code_aware_chunking(code: str, language: str) -> list:
    """
    Parse code using AST and chunk by logical units
    (functions, classes, modules) rather than characters.
    """
    parser = Parser()
    parser.language = Language(tree_sitter.__get_language__(language))
    
    tree = parser.parse(bytes(code, "utf8"))
    
    chunks = []
    for node in tree.root_node.children:
        if node.type in ['function_definition', 'class_definition', 'import_statement']:
            chunks.append({
                'content': code[node.start_byte:node.end_byte],
                'type': node.type,
                'name': get_node_name(node),
                'start_line': node.start_point[0],
                'end_line': node.end_point[0]
            })
    
    return chunks
```

**When to use:** Code repositories, documentation with code examples.
**Best for:** Developer tools, code search, documentation systems.

#### Chunking Strategy Selection Matrix

| Strategy | Best For | Typical Size | Cost | Quality |
|----------|----------|-------------|------|---------|
| **Fixed-size** | Uniform docs, simple use cases | 256-1024 tokens | Low | Medium |
| **Sentence-based** | Q&A, conversational | 5-10 sentences | Low | Medium-High |
| **Recursive** | Mixed doc types | 500-1500 tokens | Low | High |
| **Semantic** | Complex docs, topic shifts | Variable | Medium | Very High |
| **Agentic** | High-value documents | Variable | High | Highest |
| **Contextual** | Cross-referenced docs | 500-1000 tokens | Medium | High |
| **Parent-child** | Precise retrieval + context | Child: 1 sentence, Parent: 3-5 | Low | High |
| **Code-aware** | Source code, code docs | Function/class level | Medium | Very High |

#### Chunking Implementation Checklist

- [ ] Choose chunking strategy based on document type and use case
- [ ] Set chunk size and overlap (10-20% overlap recommended)
- [ ] Extract and attach metadata to each chunk
- [ ] Handle special content: tables, code blocks, images (alt text)
- [ ] Validate: are chunks coherent? Do they preserve meaning?
- [ ] Test with sample queries to ensure relevant chunks are retrieved
- [ ] Consider hybrid approach: different strategies for different content types

### Phase 3: Embedding

#### Embedding Model Selection

| Model | Dimensions | Strengths | Cost | Speed |
|-------|-----------|-----------|------|-------|
| **OpenAI text-embedding-3-small** | 1536 | Good quality, fast, cheap | $0.02/1M tokens | Fast |
| **OpenAI text-embedding-3-large** | 3072 | Best quality from OpenAI | $0.13/1M tokens | Fast |
| **Cohere embed-v3** | 1024 | Good multilingual, built-in RAG | Varies | Fast |
| **BGE-large-en-v1.5** | 1024 | Open-source, self-hostable | Free (compute) | Medium |
| **E5-large-v2** | 1024 | Strong retrieval performance | Free (compute) | Medium |
| **Nomic embed** | 768 | Open-source, long context | Free (compute) | Medium |
| **GTE-large** | 1024 | Alibaba, strong multilingual | Free (compute) | Medium |
| **all-MiniLM-L6-v2** | 384 | Lightweight, fast, good for prototyping | Free (compute) | Very Fast |

#### Embedding Best Practices

1. **Consistency**: Always use the same model for indexing and querying
2. **Batch processing**: Embed documents in batches (50-100) for efficiency
3. **Dimension reduction**: Consider Matryoshka embeddings if storage is a concern
4. **Fine-tuning**: For domain-specific terms, fine-tune on your data
5. **Normalization**: Normalize vectors for cosine similarity (most models do this automatically)

#### Embedding Pipeline Example

```python
from sentence_transformers import SentenceTransformer
import numpy as np

class EmbeddingPipeline:
    def __init__(self, model_name="BAAI/bge-large-en-v1.5"):
        self.model = SentenceTransformer(model_name)
    
    def embed_documents(self, documents, batch_size=32):
        """Embed documents in batches."""
        texts = [doc.page_content for doc in documents]
        embeddings = self.model.encode(
            texts,
            batch_size=batch_size,
            show_progress_bar=True,
            normalize_embeddings=True
        )
        return embeddings
    
    def embed_query(self, query: str) -> np.ndarray:
        """Embed a single query."""
        # Add instruction prefix for BGE models
        instruction = "Represent this sentence for searching relevant passages: "
        embedding = self.model.encode([instruction + query])
        return embedding[0]
```

### Phase 4: Vector Store Setup

#### Vector Database Comparison

| Database | Best For | Key Feature | Scalability | Ease of Use |
|----------|----------|-------------|-------------|-------------|
| **Chroma** | Prototyping, local dev | Embedded, zero-config | Low | Very Easy |
| **pgvector** | Production, existing Postgres | No new infrastructure | Medium | Easy |
| **Pinecone** | Production, managed | Fully managed, scales well | High | Easy |
| **Weaviate** | Production, hybrid search | Built-in hybrid (keyword + vector) | High | Medium |
| **Qdrant** | Production, performance | Fast, Rust-based, good filtering | High | Medium |
| **FAISS** | Local, high-throughput | In-memory, no server needed | Medium | Hard |
| **Milvus** | Large-scale production | Distributed, GPU support | Very High | Medium |
| **LanceDB** | Cost-effective storage | Columnar, serverless | Medium | Easy |

#### Database Configuration Examples

##### Chroma (Local Development)

```python
import chromadb

# Initialize client
client = chromadb.PersistentClient(path="./chroma_db")

# Create collection
collection = client.get_or_create_collection(
    name="documents",
    metadata={"hnsw:space": "cosine"}
)

# Add documents
collection.add(
    documents=["doc1 text", "doc2 text"],
    metadatas=[{"source": "file1.pdf"}, {"source": "file2.pdf"}],
    ids=["doc1", "doc2"]
)

# Query
results = collection.query(
    query_texts=["search query"],
    n_results=5,
    where={"source": "file1.pdf"}  # Metadata filtering
)
```

##### Qdrant (Production)

```python
from qdrant_client import QdrantClient
from qdrant_client.models import VectorParams, Distance, PointStruct

client = QdrantClient(host="localhost", port=6333)

# Create collection
client.create_collection(
    collection_name="documents",
    vectors_config=VectorParams(
        size=1024,
        distance=Distance.COSINE
    )
)

# Upsert points
client.upsert(
    collection_name="documents",
    points=[
        PointStruct(
            id=1,
            vector=[0.1] * 1024,
            payload={"text": "document text", "source": "file.pdf"}
        )
    ]
)

# Search with filtering
from qdrant_client.models import Filter, FieldCondition, MatchValue

results = client.search(
    collection_name="documents",
    query_vector=[0.1] * 1024,
    query_filter=Filter(
        must=[
            FieldCondition(
                key="source",
                match=MatchValue(value="file.pdf")
            )
        ]
    ),
    limit=5
)
```

##### pgvector (PostgreSQL)

```python
from sqlalchemy import create_engine, Column, Integer, String, ARRAY
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from pgvector.sqlalchemy import Vector

engine = create_engine("postgresql://user:pass@localhost/db")
Base = declarative_base()

class Document(Base):
    __tablename__ = "documents"
    
    id = Column(Integer, primary_key=True)
    content = Column(String)
    embedding = Column(VECTOR(1024))
    metadata_ = Column(String)

# Create index
with engine.connect() as conn:
    conn.execute("""
        CREATE INDEX ON documents 
        USING ivfflat (embedding vector_cosine_ops) 
        WITH (lists = 100)
    """)

# Query
from sqlalchemy import text

results = engine.execute(text("""
    SELECT content, 1 - (embedding <=> :query_vector) as similarity
    FROM documents
    ORDER BY embedding <=> :query_vector
    LIMIT 5
"""), {"query_vector": str(query_embedding)})
```

##### Weaviate (Hybrid Search)

```python
import weaviate

client = weaviate.connect_to_local()

# Create collection
client.collections.create(
    name="Documents",
    vectorizer_config=weaviate.classes.config.Configure.Vectorizer.none(),
    vector_index_config=weaviate.classes.config.Configure.VectorIndex.hnsw(
        distance_metric=weaviate.classes.config.VectorDistances.COSINE
    )
)

# Add data
documents = client.collections.get("Documents")
documents.data.insert({
    "content": "document text",
    "source": "file.pdf"
})

# Hybrid search (vector + keyword)
results = documents.query.hybrid(
    query="search terms",
    alpha=0.7,  # 0=keyword, 1=vector, 0.5=balanced
    limit=5
)
```

#### Index Configuration Best Practices

- **Distance metric**: Cosine similarity (default for most embeddings), dot product for normalized vectors, L2 for absolute distance
- **Index type**: HNSW (fast, good for most cases), IVF (better for very large datasets), flat (exact but slow)
- **Sharding**: Split data across multiple shards for large datasets
- **Replication**: For high availability, replicate across multiple nodes
- **Metadata filtering**: Pre-filter by metadata before vector search when possible

### Phase 5: Retrieval Logic

#### Basic Retrieval

```python
def basic_retrieval(query: str, vector_store, k: int = 5):
    """
    Simple top-k retrieval.
    
    1. Embed the user query
    2. Search vector store for top-k most similar chunks
    3. Return chunks + metadata
    """
    results = vector_store.similarity_search_with_score(
        query=query,
        k=k
    )
    return results
```

#### Advanced Retrieval Techniques

##### 1. HyDE (Hypothetical Document Embeddings)

```python
def hyde_retrieval(query: str, llm, vector_store, k: int = 5):
    """
    Generate a hypothetical answer first, then use it for retrieval.
    Works because the hypothetical answer is semantically closer to
    the actual documents than the original question.
    """
    # Step 1: Generate hypothetical document
    prompt = f"""
    Please write a detailed, informative passage that would answer this question:
    {query}
    """
    hypothetical_answer = llm.generate(prompt)
    
    # Step 2: Use hypothetical answer for retrieval
    results = vector_store.similarity_search(
        query=hypothetical_answer,
        k=k
    )
    return results
```

**When to use:** When queries are short/ambiguous but documents are long/detailed.
**Best for:** Research Q&A, technical documentation.

##### 2. Multi-Query Retrieval

```python
def multi_query_retrieval(query: str, llm, vector_store, k: int = 5):
    """
    Generate multiple query variations and merge results.
    Increases recall by capturing different phrasings of the same concept.
    """
    # Step 1: Generate multiple queries
    prompt = f"""
    Given the user question: {query}
    Generate 3-5 different ways to ask this question, each focusing on
    different aspects or using different terminology.
    Return each query on a new line.
    """
    queries = llm.generate(prompt).split("\n")
    queries = [q.strip() for q in queries if q.strip()]
    
    # Step 2: Retrieve for each query
    all_results = {}
    for q in queries:
        results = vector_store.similarity_search(query=q, k=k)
        for doc, score in results:
            doc_id = doc.metadata.get("id", doc.page_content[:50])
            if doc_id not in all_results or score < all_results[doc_id][1]:
                all_results[doc_id] = (doc, score)
    
    # Step 3: Sort by score and return top-k
    sorted_results = sorted(all_results.values(), key=lambda x: x[1])
    return sorted_results[:k]
```

**When to use:** When users phrase questions in diverse ways.
**Best for:** Customer support, FAQ systems.

##### 3. Step-Back Prompting Retrieval

```python
def step_back_retrieval(query: str, llm, vector_store, k: int = 5):
    """
    Generate a more general/high-level query first, then retrieve.
    Useful when the specific query is too narrow.
    """
    # Step 1: Generate step-back query
    prompt = f"""
    The user is asking: {query}
    
    Generate a more general question that would help answer this specific question.
    Focus on the underlying concept rather than specific details.
    """
    step_back_query = llm.generate(prompt)
    
    # Step 2: Retrieve with both queries
    specific_results = vector_store.similarity_search(query=query, k=k)
    general_results = vector_store.similarity_search(query=step_back_query, k=k)
    
    # Step 3: Merge results (prefer specific, add general for context)
    combined = specific_results + [r for r in general_results if r not in specific_results]
    return combined[:k]
```

**When to use:** When specific queries return too few or irrelevant results.
**Best for:** Complex technical questions, research queries.

##### 4. Parent-Child Retrieval

```python
def parent_child_retrieval(query: str, vector_store, k: int = 5):
    """
    Search with small child chunks for precision,
    but return the larger parent chunks for context.
    """
    # Step 1: Search child chunks
    child_results = vector_store.similarity_search(
        query=query,
        k=k,
        filter={"chunk_type": "child"}
    )
    
    # Step 2: Get parent chunks for each child
    parent_results = []
    for child in child_results:
        parent_id = child.metadata.get("parent_index")
        parent = vector_store.similarity_search(
            query="",
            k=1,
            filter={
                "chunk_type": "parent",
                "parent_index": parent_id
            }
        )[0]
        parent_results.append(parent)
    
    return parent_results
```

**When to use:** When you need precise matching but full context for generation.
**Best for:** Long documents, knowledge bases.

##### 5. Sentence Window Retrieval

```python
def sentence_window_retrieval(query: str, vector_store, window_size: int = 3):
    """
    Retrieve individual sentences, then expand to include
    surrounding sentences for context.
    """
    # Step 1: Retrieve matching sentences
    sentence_results = vector_store.similarity_search(
        query=query,
        k=5,
        filter={"chunk_type": "sentence"}
    )
    
    # Step 2: Expand each sentence to include window
    expanded_results = []
    for sentence in sentence_results:
        sentence_idx = sentence.metadata.get("sentence_index")
        
        # Get surrounding sentences
        window_results = vector_store.similarity_search(
            query="",
            k=window_size * 2 + 1,
            filter={
                "sentence_index": {
                    "$gte": sentence_idx - window_size,
                    "$lte": sentence_idx + window_size
                }
            }
        )
        
        # Combine into single context
        context = " ".join([r.page_content for r in window_results])
        expanded_results.append(context)
    
    return expanded_results
```

**When to use:** When sentence-level precision is needed but context is important.
**Best for:** Legal documents, academic papers.

##### 6. Hybrid Search (Vector + Keyword)

```python
def hybrid_retrieval(query: str, vector_store, keyword_index, k: int = 5, alpha: float = 0.5):
    """
    Combine vector search with keyword (BM25) search.
    Alpha controls the balance: 0=keyword only, 1=vector only.
    """
    # Vector search
    vector_results = vector_store.similarity_search_with_score(query=query, k=k)
    
    # Keyword search (BM25)
    keyword_results = keyword_index.search(query=query, k=k)
    
    # Normalize scores and combine
    combined = {}
    for doc, score in vector_results:
        doc_id = doc.metadata.get("id", doc.page_content[:50])
        combined[doc_id] = {"doc": doc, "score": (1 - score) * alpha}
    
    for doc, score in keyword_results:
        doc_id = doc.metadata.get("id", doc.page_content[:50])
        if doc_id in combined:
            combined[doc_id]["score"] += score * (1 - alpha)
        else:
            combined[doc_id] = {"doc": doc, "score": score * (1 - alpha)}
    
    # Sort by combined score
    sorted_results = sorted(combined.values(), key=lambda x: x["score"], reverse=True)
    return [r["doc"] for r in sorted_results[:k]]
```

**When to use:** Documents have exact terms that matter (names, IDs, codes).
**Best for:** Technical documentation, legal texts, code search.

### Phase 6: Reranking

#### Reranking Strategies

##### 1. Cross-Encoder Reranking

```python
from sentence_transformers import CrossEncoder

def cross_encoder_reranking(query: str, documents: list, top_k: int = 5):
    """
    Re-score retrieved documents using a cross-encoder.
    Cross-encoders are more accurate but slower than bi-encoders.
    """
    model = CrossEncoder('cross-encoder/ms-marco-MiniLM-L-6-v2')
    
    # Create query-document pairs
    pairs = [(query, doc.page_content) for doc in documents]
    
    # Score each pair
    scores = model.predict(pairs)
    
    # Sort by score
    ranked_docs = sorted(
        zip(documents, scores),
        key=lambda x: x[1],
        reverse=True
    )
    
    return ranked_docs[:top_k]
```

##### 2. Cohere Rerank

```python
import cohere

def cohere_reranking(query: str, documents: list, top_k: int = 5):
    """
    Use Cohere's rerank API for high-quality reranking.
    """
    co = cohere.Client("YOUR_API_KEY")
    
    results = co.rerank(
        query=query,
        documents=[doc.page_content for doc in documents],
        model="rerank-english-v3.0",
        top_n=top_k,
        return_documents=True
    )
    
    return results.results
```

##### 3. BGE Reranker

```python
from FlagEmbedding import FlagReranker

def bge_reranking(query: str, documents: list, top_k: int = 5):
    """
    Use BGE reranker for open-source reranking.
    """
    reranker = FlagReranker('BAAI/bge-reranker-v2-m3', use_fp16=True)
    
    # Create query-document pairs
    pairs = [[query, doc.page_content] for doc in documents]
    
    # Score
    scores = reranker.compute_score(pairs)
    
    # Rank
    ranked_docs = sorted(
        zip(documents, scores),
        key=lambda x: x[1],
        reverse=True
    )
    
    return ranked_docs[:top_k]
```

##### 4. ColBERT Reranking

```python
from colbert import Searcher, ColBERT
from colbert.infra import ColBERTConfig

def colbert_reranking(query: str, documents: list, top_k: int = 5):
    """
    Use ColBERT's late interaction for reranking.
    Good balance between accuracy and speed.
    """
    config = ColBERTConfig(
        nbits=2,
        kmeans_niters=4,
        nranks=1
    )
    
    searcher = Searcher(
        index="path/to/colbert/index",
        config=config
    )
    
    results = searcher.search(query, k=top_k)
    return results
```

#### Reranking Comparison

| Method | Accuracy | Speed | Cost | Best For |
|--------|----------|-------|------|----------|
| **Cross-Encoder** | High | Slow | Free (compute) | General purpose |
| **Cohere Rerank** | Very High | Fast | API cost | Production, quality |
| **BGE Reranker** | High | Medium | Free (compute) | Open-source, multilingual |
| **ColBERT** | High | Fast | Free (compute) | Large-scale, latency-sensitive |

### Phase 7: Generation

#### Advanced Prompt Templates

##### Basic QA Template

```
Answer the question based only on the following context. If the context does not
contain enough information to answer the question, say "I don't have enough
information to answer this question accurately."

Context:
{retrieved_chunks_with_sources}

Question: {user_query}

Answer:
```

##### Multi-Document Synthesis Template

```
You have access to multiple documents below. Synthesize information from all
relevant documents to provide a comprehensive answer.

Documents:
{numbered_chunks_with_sources}

Question: {user_query}

Instructions:
1. Cite which document(s) each piece of information comes from
2. If documents conflict, note the discrepancy
3. If the documents don't contain enough information, say so clearly

Answer:
```

##### Conversational RAG Template

```
You are a helpful assistant with access to a knowledge base. Use the following
context to answer the user's question. Consider the conversation history for
context.

Conversation History:
{chat_history}

Context:
{retrieved_chunks_with_sources}

User Question: {user_query}

Instructions:
1. Answer based on the context provided
2. If the context doesn't contain enough information, say so
3. Maintain conversation context when follow-up questions are asked

Answer:
```

#### Generation Best Practices

- **Explicitly instruct the model to say when it doesn't know** — prevents hallucination
- **Include source references** — so users can verify
- **Keep context window within limits** — quality degrades past ~5-8 chunks
- **Use temperature=0 for factual Q&A** — deterministic, consistent answers
- **Implement confidence scoring** — return confidence level with answers

### Phase 8: Evaluation

#### Evaluation Framework

```python
from ragas import evaluate
from ragas.metrics import (
    faithfulness,
    answer_relevancy,
    context_precision,
    context_recall
)

def evaluate_rag_system(test_dataset):
    """
    Comprehensive RAG evaluation using RAGAS framework.
    """
    results = evaluate(
        dataset=test_dataset,
        metrics=[
            faithfulness,        # Is answer grounded in context?
            answer_relevancy,    # Does answer address the question?
            context_precision,   # Are retrieved contexts relevant?
            context_recall       # Are all relevant contexts retrieved?
        ]
    )
    
    return results
```

#### Detailed Metrics

| Metric | What It Measures | How to Measure | Target |
|--------|-----------------|----------------|--------|
| **Retrieval Precision** | Are retrieved chunks relevant? | Manual review or LLM-judged | >0.8 |
| **Retrieval Recall** | Are all needed chunks retrieved? | Compare against gold-standard | >0.7 |
| **Context Relevancy** | Are contexts relevant to the question? | LLM-judged | >0.7 |
| **Context Recall** | Does context cover the answer? | Compare against reference answer | >0.8 |
| **Faithfulness** | Does the answer follow from context? | LLM-judged: "Is every claim supported?" | >0.9 |
| **Answer Relevancy** | Does the answer address the question? | LLM-judged: "Does this answer the question?" | >0.8 |
| **Hallucination Rate** | Does the model make up information? | Compare against context | <0.05 |
| **End-to-End Accuracy** | Is the final answer correct? | Human-annotated answers | >0.85 |

#### Evaluation Pipeline

```python
def comprehensive_evaluation(rag_system, test_cases):
    """
    Run full evaluation pipeline.
    """
    results = {
        "retrieval_precision": [],
        "retrieval_recall": [],
        "faithfulness": [],
        "answer_relevancy": []
    }
    
    for case in test_cases:
        # Retrieve
        retrieved = rag_system.retrieve(case["query"])
        
        # Generate
        answer = rag_system.generate(case["query"], retrieved)
        
        # Evaluate retrieval
        precision = calculate_precision(retrieved, case["relevant_docs"])
        recall = calculate_recall(retrieved, case["relevant_docs"])
        
        # Evaluate generation
        faithfulness = evaluate_faithfulness(answer, retrieved)
        relevancy = evaluate_relevancy(answer, case["query"])
        
        results["retrieval_precision"].append(precision)
        results["retrieval_recall"].append(recall)
        results["faithfulness"].append(faithfulness)
        results["answer_relevancy"].append(relevancy)
    
    # Aggregate results
    return {k: sum(v)/len(v) for k, v in results.items()}
```

### Phase 9: Production Deployment

#### Production Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Load Balancer                             │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    API Gateway                               │
└─────────────────────────────────────────────────────────────┘
                              │
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  RAG Service │  │  RAG Service │  │  RAG Service │
│  (Instance 1)│  │  (Instance 2)│  │  (Instance 3)│
└──────────────┘  └──────────────┘  └──────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│              Vector Database Cluster                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                   │
│  │  Node 1  │  │  Node 2  │  │  Node 3  │                   │
│  └──────────┘  └──────────┘  └──────────┘                   │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│              Monitoring & Observability                      │
│  - Prometheus metrics                                       │
│  - Jaeger tracing                                           │
│  - Structured logging                                       │
└─────────────────────────────────────────────────────────────┘
```

#### Deployment Checklist

- [ ] **Scalability**: Vector database supports horizontal scaling
- [ ] **High availability**: Replication and failover configured
- [ ] **Security**: API authentication, data encryption at rest and in transit
- [ ] **Monitoring**: Metrics, logging, and alerting configured
- [ ] **Cost optimization**: Embedding caching, query optimization
- [ ] **A/B testing**: Framework for testing different retrieval strategies
- [ ] **Rollback strategy**: Ability to revert to previous version

### Phase 10: Monitoring & Observability

#### Key Metrics to Monitor

| Category | Metric | Description | Alert Threshold |
|----------|--------|-------------|-----------------|
| **Latency** | p50/p95/p99 retrieval time | Time to retrieve documents | p99 > 500ms |
| **Latency** | p50/p95/p99 generation time | Time to generate answer | p99 > 2s |
| **Quality** | Faithfulness score | Answer grounded in context | < 0.8 |
| **Quality** | Relevancy score | Answer addresses question | < 0.7 |
| **Usage** | Query volume | Queries per minute | Unexpected spikes |
| **Cost** | Embedding cost | API costs for embedding | Budget threshold |
| **Cost** | Generation cost | API costs for LLM | Budget threshold |
| **Reliability** | Error rate | Failed queries | > 1% |

#### Monitoring Implementation

```python
import time
from prometheus_client import Counter, Histogram, Gauge
from opentelemetry import trace

# Metrics
QUERY_DURATION = Histogram('rag_query_duration_seconds', 'RAG query duration')
RETRIEVAL_DURATION = Histogram('rag_retrieval_duration_seconds', 'Retrieval duration')
GENERATION_DURATION = Histogram('rag_generation_duration_seconds', 'Generation duration')
QUERY_COUNT = Counter('rag_queries_total', 'Total queries')
FAITHFULNESS_SCORE = Gauge('rag_faithfulness_score', 'Average faithfulness score')

# Tracing
tracer = trace.get_tracer(__name__)

def monitored_rag_query(query: str):
    """RAG query with full monitoring."""
    with tracer.start_as_current_span("rag_query") as span:
        span.set_attribute("query", query)
        
        start = time.time()
        
        # Track retrieval
        with tracer.start_as_current_span("retrieval"):
            retrieval_start = time.time()
            documents = retrieve(query)
            RETRIEVAL_DURATION.observe(time.time() - retrieval_start)
        
        # Track generation
        with tracer.start_as_current_span("generation"):
            generation_start = time.time()
            answer = generate(query, documents)
            GENERATION_DURATION.observe(time.time() - generation_start)
        
        # Track overall duration
        QUERY_DURATION.observe(time.time() - start)
        QUERY_COUNT.inc()
        
        return answer
```

### Phase 11: Cost Optimization

#### Cost Reduction Strategies

1. **Embedding Caching**: Cache frequently used embeddings
2. **Query Deduplication**: Detect and merge similar queries
3. **Tiered Retrieval**: Use cheaper models for initial retrieval, expensive for reranking
4. **Batch Processing**: Process queries in batches when possible
5. **Model Selection**: Use smaller models for simpler queries

```python
class CostOptimizedRAG:
    def __init__(self):
        self.embedding_cache = {}
        self.query_cache = {}
    
    def get_embedding(self, text: str, model) -> np.ndarray:
        """Cache embeddings to avoid recomputation."""
        if text in self.embedding_cache:
            return self.embedding_cache[text]
        
        embedding = model.encode(text)
        self.embedding_cache[text] = embedding
        return embedding
    
    def retrieve_with_caching(self, query: str, vector_store, k: int = 5):
        """Cache query results for repeated queries."""
        if query in self.query_cache:
            return self.query_cache[query]
        
        results = vector_store.similarity_search(query=query, k=k)
        self.query_cache[query] = results
        return results
```

### Phase 12: Real-World Examples

#### Example 1: Document Q&A System

```python
from langchain.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain.chat_models import ChatOpenAI
from langchain.chains import RetrievalQA

def build_document_qa(pdf_path: str):
    """Complete document Q&A system."""
    # Load
    loader = PyPDFLoader(pdf_path)
    documents = loader.load()
    
    # Chunk
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=1000,
        chunk_overlap=200
    )
    chunks = text_splitter.split_documents(documents)
    
    # Embed and store
    embeddings = OpenAIEmbeddings()
    vectorstore = Chroma.from_documents(chunks, embeddings)
    
    # Create QA chain
    qa_chain = RetrievalQA.from_chain_type(
        llm=ChatOpenAI(model="gpt-4", temperature=0),
        chain_type="stuff",
        retriever=vectorstore.as_retriever(search_kwargs={"k": 5}),
        return_source_documents=True
    )
    
    return qa_chain

# Usage
qa = build_document_qa("research_paper.pdf")
result = qa.invoke("What is the main finding of this paper?")
print(result["result"])
print("Sources:", [doc.metadata for doc in result["source_documents"]])
```

#### Example 2: Multi-Document Research Assistant

```python
from langchain.document_loaders import DirectoryLoader
from langchain.text_splitter import CharacterTextSplitter
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.vectorstores import FAISS
from langchain.chat_models import ChatOpenAI
from langchain.chains import ConversationalRetrievalChain

def build_research_assistant(docs_dir: str):
    """Multi-document research assistant with conversation memory."""
    # Load all documents
    loader = DirectoryLoader(docs_dir, glob="**/*.pdf")
    documents = loader.load()
    
    # Chunk
    text_splitter = CharacterTextSplitter(
        chunk_size=1500,
        chunk_overlap=200,
        separator="\n"
    )
    chunks = text_splitter.split_documents(documents)
    
    # Embed
    embeddings = HuggingFaceEmbeddings(
        model_name="BAAI/bge-large-en-v1.5"
    )
    
    # Store in FAISS (fast, local)
    vectorstore = FAISS.from_documents(chunks, embeddings)
    
    # Create conversational chain
    chain = ConversationalRetrievalChain.from_llm(
        llm=ChatOpenAI(model="gpt-4", temperature=0),
        retriever=vectorstore.as_retriever(search_kwargs={"k": 5}),
        return_source_documents=True,
        verbose=True
    )
    
    return chain

# Usage
assistant = build_research_assistant("./research_papers/")
chat_history = []

# First question
result = assistant.invoke({
    "question": "What are the key findings?",
    "chat_history": chat_history
})
print(result["answer"])

# Follow-up question
chat_history.append((result["question"], result["answer"]))
result = assistant.invoke({
    "question": "Can you elaborate on the methodology?",
    "chat_history": chat_history
})
print(result["answer"])
```

#### Example 3: Enterprise Knowledge Base with Hybrid Search

```python
from qdrant_client import QdrantClient
from qdrant_client.models import VectorParams, Distance
from sentence_transformers import SentenceTransformer
import rank_bm25
import numpy as np

class EnterpriseKnowledgeBase:
    def __init__(self, qdrant_url: str = "localhost"):
        self.qdrant = QdrantClient(url=qdrant_url)
        self.embedder = SentenceTransformer("BAAI/bge-large-en-v1.5")
        self.bm25 = None
        self.documents = []
    
    def index_documents(self, documents: list):
        """Index documents with hybrid search support."""
        self.documents = documents
        
        # Create Qdrant collection
        self.qdrant.create_collection(
            collection_name="knowledge_base",
            vectors_config=VectorParams(size=1024, distance=Distance.COSINE)
        )
        
        # Embed and store
        texts = [doc["content"] for doc in documents]
        embeddings = self.embedder.encode(texts, show_progress_bar=True)
        
        # Index in Qdrant
        points = [
            {
                "id": i,
                "vector": embeddings[i].tolist(),
                "payload": {
                    "content": documents[i]["content"],
                    "title": documents[i].get("title", ""),
                    "source": documents[i].get("source", "")
                }
            }
            for i in range(len(documents))
        ]
        self.qdrant.upsert(collection_name="knowledge_base", points=points)
        
        # Build BM25 index
        tokenized = [text.split() for text in texts]
        self.bm25 = rank_bm25.BM25Okapi(tokenized)
    
    def hybrid_search(self, query: str, k: int = 5, alpha: float = 0.7):
        """Hybrid search combining vector and keyword search."""
        # Vector search
        query_embedding = self.embedder.encode([query])[0]
        vector_results = self.qdrant.search(
            collection_name="knowledge_base",
            query_vector=query_embedding.tolist(),
            limit=k * 2
        )
        
        # BM25 search
        tokenized_query = query.split()
        bm25_scores = self.bm25.get_scores(tokenized_query)
        bm25_top_indices = np.argsort(bm25_scores)[::-1][:k * 2]
        
        # Combine scores
        combined = {}
        for i, result in enumerate(vector_results):
            doc_id = result.id
            combined[doc_id] = {
                "score": (1 - result.score) * alpha,
                "payload": result.payload
            }
        
        for idx in bm25_top_indices:
            if idx in combined:
                combined[idx]["score"] += bm25_scores[idx] * (1 - alpha)
            else:
                combined[idx] = {
                    "score": bm25_scores[idx] * (1 - alpha),
                    "payload": self.documents[idx] if idx < len(self.documents) else {}
                }
        
        # Sort and return top-k
        sorted_results = sorted(combined.items(), key=lambda x: x[1]["score"], reverse=True)
        return sorted_results[:k]
```

## Output Format

When delivering RAG implementation:

```python
# Project structure recommendation
project/
├── ingest/
│   ├── document_loader.py      # Document loading
│   ├── chunker.py              # Chunking strategies
│   └── preprocessor.py         # Text preprocessing
├── embed/
│   ├── embedding_model.py      # Embedding model wrapper
│   └── batch_embedder.py       # Batch embedding pipeline
├── store/
│   ├── vector_store.py         # Vector store operations
│   └── metadata_store.py       # Metadata management
├── retrieve/
│   ├── basic_retrieval.py      # Simple retrieval
│   ├── advanced_retrieval.py   # HyDE, multi-query, etc.
│   └── reranker.py             # Reranking logic
├── generate/
│   ├── prompt_templates.py     # Prompt templates
│   └── llm_wrapper.py          # LLM interface
├── evaluate/
│   ├── metrics.py              # Evaluation metrics
│   └── test_dataset.py         # Test cases
├── monitor/
│   ├── metrics.py              # Prometheus metrics
│   └── tracing.py              # OpenTelemetry tracing
├── config.py                   # Configuration
├── main.py                     # Main entry point
└── tests/                      # Test suite
```

Include:
- Working code for each pipeline stage
- Configuration with sensible defaults
- Example usage with a small test dataset
- Estimated costs at the user's expected scale
- Deployment instructions

## Common Pitfalls to Avoid

- **Don't skip chunking strategy.** Bad chunks are the #1 cause of poor RAG performance.
- **Don't use different embedding models for indexing and querying.** They must match.
- **Don't retrieve too many chunks.** More context ≠ better answers. Quality degrades past ~5-8 chunks.
- **Don't forget to handle the "I don't know" case.** Without explicit instructions, the model will hallucinate.
- **Don't ignore metadata filtering.** Filtering by source, date, or category before vector search dramatically improves precision.
- **Don't over-engineer the first version.** Start with basic retrieval, measure, then add reranking/hybrid/etc. only if needed.
- **Don't ignore evaluation.** Without metrics, you can't know if changes improve or degrade performance.
- **Don't skip monitoring in production.** Track latency, costs, and quality metrics.
- **Don't forget about security.** Implement proper authentication and data access controls.
- **Don't ignore cost optimization.** Caching and tiered retrieval can significantly reduce costs.

## References

- LangChain Documentation: https://python.langchain.com/
- LlamaIndex Documentation: https://docs.llamaindex.ai/
- RAGAS Evaluation Framework: https://docs.ragas.io/
- Qdrant Documentation: https://qdrant.tech/documentation/
- Weaviate Documentation: https://weaviate.io/developers
- Pinecone Documentation: https://docs.pinecone.io/
- Chroma Documentation: https://docs.trychroma.com/
- pgvector Documentation: https://github.com/pgvector/pgvector
