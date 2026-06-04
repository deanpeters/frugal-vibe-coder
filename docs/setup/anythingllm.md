# Setting Up AnythingLLM

## The problem it solves

General-purpose chat is useful for thinking through problems. But a lot of PM work involves specific documents — a PRD you wrote last quarter, a research report, a set of meeting notes, a competitor analysis. A general AI model doesn't know what's in your files.

AnythingLLM solves this. You upload your documents, and it uses your local Ollama model to answer questions about them. Ask "What were the main concerns from the user research?" and it finds the answer in your actual files.

## What it is

AnythingLLM is a free, open-source desktop application for document question-answering and retrieval-augmented generation (RAG). You install it like any other desktop app — no Python, no terminal, no Docker required. It connects to Ollama and lets you create workspaces, each with its own set of uploaded documents.

## What you're about to do

Download and install the AnythingLLM desktop app, connect it to your local Ollama model, create a workspace, and verify it can answer a question about an uploaded document. This takes about 15–20 minutes.

**Prerequisite:** Ollama installed and running with `qwen3:8b` ([guide](ollama.md)).

---

## Fastest path with this repo

If you already have this repo on your machine and want the guided version of this setup:

- macOS / Linux: run `./scripts/install-anythingllm.sh`

The script opens the download page, walks you through installation, and guides you through the Ollama connection. Use the rest of this guide if you want to install manually or understand the steps in more detail.

---

## Check if you already have AnythingLLM

- **macOS** — check your Applications folder or Spotlight (`Cmd+Space`, type "AnythingLLM")
- **Linux** — check your application launcher

**Already installed:** skip to [Connect AnythingLLM to Ollama](#connect-anythingllm-to-ollama).

**Not installed:** continue below.

---

## Install AnythingLLM

Go to the AnythingLLM download page: [anythingllm.com/download](https://anythingllm.com/download)

### macOS

1. Download the macOS installer (`.dmg`)
2. Open the downloaded file
3. Drag AnythingLLM to your Applications folder
4. Open it from your Applications folder

**Security warning on first launch:** macOS may show a warning that the app is from an unidentified developer. If that happens:

1. Go to **System Settings → Privacy & Security**
2. Scroll down to the Security section
3. Click **Open Anyway** next to the AnythingLLM entry

---

### Linux — Debian, Ubuntu, Mint

**Using the .deb package (recommended):**

1. Download the `.deb` file from the download page
2. Install it with:

```bash
sudo apt install ./AnythingLLM-*.deb
```

**Using the AppImage:**

1. Download the `.AppImage` file
2. Make it executable:

```bash
chmod +x AnythingLLM-*.AppImage
```

3. Run it:

```bash
./AnythingLLM-*.AppImage
```

---

## Connect AnythingLLM to Ollama

When AnythingLLM opens for the first time, it will walk you through initial setup.

**When it asks you to choose a model provider:**

1. Select **Ollama** as the LLM provider
2. Set the Ollama base URL to: `http://localhost:11434`
3. Set the model to: `qwen3:8b`
4. Click **Save** or **Next**

AnythingLLM will test the connection automatically.

**If you skip the setup wizard:** go to **Settings → LLM Preferences** and fill in the same fields.

---

## Create a workspace and add a document

1. In AnythingLLM, click **New Workspace** and give it a name (e.g., "Product Research")
2. Inside the workspace, click the document upload icon or **Upload Files**
3. Upload any document — a PDF, text file, or Markdown file works well
4. Wait for AnythingLLM to process the document (it appears in the file list when ready)

---

## Verify it's working

In the workspace chat, ask a specific question about the document you uploaded.

If AnythingLLM returns an answer that references information from your file, the connection to Ollama is working and RAG is set up correctly.

---

## What you now have

A local document Q&A tool powered by your own Ollama model. You can upload files, ask specific questions about them, and get grounded answers — without any data leaving your machine or any API cost.

**Want to understand how this works?** See [/docs/concepts/what-is-rag.md](../concepts/what-is-rag.md).

**Next step:** head to [/docs/surfaces/no-code.md](../surfaces/no-code.md) for workflow guidance on the no-code surface.

---

**Want to go deeper?**
AnythingLLM documentation covers multi-user setup, embedding models, and workspace customization: [docs.anythingllm.com](https://docs.anythingllm.com)
