# What is RAG?

## The problem it solves

AI models are trained on large amounts of text — but that training has a cutoff date, and the model doesn't know anything about your specific files, documents, or notes. Ask a general model "What were the key findings from the user research we did last quarter?" and it will make something up, because it has never seen your research.

RAG (Retrieval-Augmented Generation) is a technique that fixes this. Instead of asking the model to remember your documents, you give it the relevant parts right before it answers.

## What it is

RAG works in two stages:

**1. Search your documents**
When you ask a question, the system searches through your uploaded files to find the passages most relevant to your question. This search uses a technique called semantic similarity — it matches meaning, not just keywords.

**2. Include the results in the prompt**
The system automatically adds the relevant passages to the prompt it sends to the model: "Here is some context from the documents: [excerpt]. Now answer this question: [your question]."

The model sees the relevant content as part of the conversation and uses it to give a grounded, specific answer.

## Why this matters for product work

PMs and designers often work with a lot of documents: PRDs, research reports, competitive analyses, meeting notes, user interview transcripts. A general AI chat can help you think — but it can't answer questions about your specific documents.

With RAG, you can ask questions like:
- "What were the main objections users raised in the interviews?"
- "What does the spec say about error handling for the payment flow?"
- "Summarize the risks section of the product brief."

And get answers grounded in what you actually wrote — not a generic response.

## What it doesn't do

RAG doesn't make the AI model smarter about your topic. It just makes the relevant parts of your documents available to the model at the moment it's answering your question.

The quality of the answers depends on:
- Whether your documents have clear, well-organized writing
- Whether the question matches the content in the documents
- The quality of the model doing the answering

## Tools that use RAG

- **AnythingLLM** — a desktop app designed specifically for document Q&A using RAG ([setup guide](../setup/anythingllm.md))
- **LangFlow** — lets you build custom RAG pipelines visually ([setup guide](../setup/langflow.md))
- **Open WebUI** — includes a document upload and RAG feature alongside standard chat ([setup guide](../setup/open-webui.md))

---

**Want to go deeper?**
RAG is well-documented in the AI research community. The original paper is "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" (Lewis et al., 2020) — though reading it isn't required to use RAG effectively.
