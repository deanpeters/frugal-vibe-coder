# What is a Visual Flow Builder?

## The problem it solves

A single prompt-to-model interaction is easy to understand: you send a message, the AI responds. But many useful AI workflows involve more than one step. You might want to:

- Search a set of documents, pass the results to a model, and format the output
- Route a user's question to different models depending on what it's asking
- Chain multiple prompts in sequence, where each one builds on the last
- Connect an AI response to a tool that takes action based on what it says

Wiring those steps together by writing code is possible — but it requires programming experience, and it's hard to see how the pieces relate to each other. A visual flow builder gives you a canvas instead.

## What it is

A visual flow builder represents each component of an AI workflow as a block on a canvas:

- **Models** — the AI that generates a response (like Ollama with `qwen3:8b`)
- **Prompts** — templates that shape what the model sees
- **Retrievers** — components that search documents and return relevant context
- **Tools** — external actions like web search, calculations, or API calls
- **Inputs and outputs** — where data enters and exits the flow

You connect the components together with lines — like connecting boxes in a diagram. Data flows through the connections in the order you've designed.

## How it works in practice

You start with a blank canvas. You drag components onto it, fill in their settings, and connect them in the order you want data to flow. Then you run it and test it in the browser.

If a component produces unexpected output, you can inspect what it received and what it returned — right in the interface. That visibility is the main advantage over writing the same logic in code.

## Why this is different from the other surfaces

| Surface | What you're designing |
|---------|----------------------|
| No-code (Dyad) | A complete app from a description |
| CLI (OpenCode) | Step-by-step code changes |
| IDE (VS Code) | Files and functions directly |
| Flow builder | How AI components connect to each other |

Flow builders are not for building user-facing apps — they're for designing AI pipelines. Think of them as the layer between your data and your model: they control what the model sees, how it processes it, and what happens next.

## What this teaches

Using a flow builder builds an understanding of AI architecture that single-prompt tools don't expose:

- What RAG actually looks like as a pipeline (retrieve → inject → generate)
- How to decompose a complex AI task into smaller, testable components
- The difference between a model, a chain, and an agent
- What "context window" means in practice when you can see what gets sent to the model

These are transferable concepts — you'll see them referenced in documentation for tools across the AI space, and understanding them from a visual tool first makes the code-level implementations easier to follow later.

## Tools in this category

- **LangFlow** — the recommended flow builder in this repo. Installs via pip, runs locally, connects to Ollama. ([setup guide](../setup/langflow.md))
- **Flowise** — an alternative with similar capabilities. Requires Node.js.

---

**Want to go deeper?**
LangFlow's documentation includes example flows for common patterns like RAG, agent routing, and prompt chaining: [docs.langflow.org](https://docs.langflow.org)
