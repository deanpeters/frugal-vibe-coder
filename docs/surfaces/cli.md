# Building with OpenCode — CLI Surface

## What this surface is for

Visual builders like Dyad are fast, but they don't show you what's happening. The CLI surface puts you closer to the process — you can see which files are created, read what the AI is doing at each step, and approve or redirect before anything is written.

This surface is about transparency and control. You're not just getting output — you're watching the work happen.

**Use this surface when:**
- you want to understand what the AI is actually doing, not just see the result
- you're comfortable in a terminal or want to learn to be
- you want to work on projects that live in real folders on your machine
- you want tighter control over what gets created or changed

**Prerequisite:** OpenCode installed and configured for Ollama ([setup guide](../setup/opencode.md)).

---

## How OpenCode works

You start OpenCode in a project folder. You type a prompt. OpenCode thinks through what needs to happen, shows you its plan, and asks before making changes. You review, approve, and the files are created or updated.

The loop:

```
Prompt → OpenCode plans → You review → You approve → Files change → Repeat
```

The key difference from a visual builder: **you see the plan before it executes.** You can redirect, clarify, or say no at any point.

---

## Getting comfortable with the terminal

If the terminal is new to you, here are the three commands you'll use most:

```bash
pwd
```
Shows where you are — which folder you're currently in. ("Print working directory.")

```bash
ls
```
Lists the files and folders in your current location.

```bash
cd folder-name
```
Moves you into a folder. `cd ..` moves you back up one level.

That's enough to navigate. OpenCode handles the rest.

---

## Build the example project: a decision helper

The same project as the no-code guide — a decision helper that takes a decision and returns a structured analysis. Here you'll see exactly what files get created and how the AI approaches the problem.

### Create a project folder

```bash
mkdir decision-helper
cd decision-helper
```

What this does: creates a new empty folder called `decision-helper` and moves you into it. This is where your project will live.

### Start OpenCode

```bash
opencode
```

You'll see the OpenCode prompt. You're now inside an AI-assisted session in your project folder.

### Enter the first prompt

```
Build a simple decision helper web app. The user enters a decision they're facing. When they submit, the app shows three sections: what we know, what we don't know, and questions to ask before deciding. Build it as a single HTML file with simple styling — no frameworks, no build tools.
```

### Watch what happens

OpenCode will show you its plan before writing anything. You'll see something like:

```
I'll create a single HTML file with:
- A text area for the decision input
- A submit button
- Three output sections rendered by JavaScript

Create index.html? [y/n]
```

Type `y` to approve. OpenCode writes the file.

### Check what was created

```bash
ls
```

You should see `index.html`. Open it in your browser to see the result:

```bash
open index.html        # macOS
start index.html       # Windows
xdg-open index.html    # Linux
```

### Iterate with follow-up prompts

Back in OpenCode, continue the conversation:

> "The three sections are all running together — add clear headings and some space between them"

> "Add a 'Clear' button that resets the form and output"

> "Make the text area larger so there's more room to describe the decision"

Each prompt shows a plan before executing. Review it before approving.

---

## Reading OpenCode's output

OpenCode will sometimes explain its reasoning before acting. Pay attention to this — it tells you not just what it's doing, but why it made a particular choice.

If the reasoning seems off, you can redirect before it writes anything:

> "Actually, instead of using JavaScript for this, just make it a static HTML page with example content — I want to see the layout first"

This is one of the advantages of the CLI surface: you catch misunderstandings before they become files you have to undo.

---

## When things go wrong

**OpenCode misunderstood the prompt:**
Redirect before approving. Type `n` when it asks for confirmation, then clarify what you actually wanted.

**A file was created but isn't working:**
Ask OpenCode to explain what the file does:
> "Explain what index.html is doing and why it's structured this way"

Then ask it to fix the specific problem:
> "The submit button isn't doing anything when I click it — fix that"

**You want to start over:**
Delete the files and start fresh:
```bash
rm index.html
```
Then re-prompt with a clearer description.

---

## What you now have

Experience with the CLI build loop: prompt → plan → approve → review. You've seen what files an AI creates for a real project, and you know how to redirect the work before it goes in the wrong direction.

---

## When to move to a different surface

**Move to no-code (Dyad) when:**
- you want faster iteration with less back-and-forth
- you're prototyping something visual and want to see it immediately

**Move to IDE (VS Code) when:**
- you want to open the files OpenCode created and read them properly
- you want to make targeted edits to specific lines
- you're ready to understand the code at a deeper level

---

**Want to go deeper?**
OpenCode's documentation covers its full command set, multi-file workflows, and configuration: [opencode.ai/docs](https://opencode.ai/docs)
