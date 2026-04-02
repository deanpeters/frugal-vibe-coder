# Building with VS Code — IDE Surface

## What this surface is for

At some point, the output matters less than the understanding. You want to open the files, read what's there, know why it's structured that way, and be able to change specific parts with confidence.

The IDE surface — VS Code — is where generated code becomes understood code. It's also where you start building skills that transfer beyond any single tool.

**Use this surface when:**
- you want to read and understand what the AI generated
- you want to make targeted edits to specific parts of a file
- you're ready to develop skills that work regardless of which AI tool you use next
- you want to move from "it works" to "I know why it works"

**Prerequisite:** VS Code installed with the Continue extension configured for Ollama ([setup guide](../setup/vscode.md)).

---

## How VS Code with Continue works

VS Code is your editor — it shows you files, lets you navigate them, and gives you tools for reading and modifying code. Continue is the AI layer — a panel on the left where you can ask questions, get explanations, and request changes, all backed by your local `qwen3:8b` model.

The two work together:

- **VS Code** gives you the full picture of what exists
- **Continue** helps you understand it and change it

The loop:

```
Open file → Read → Ask a question → Get explanation → Make a change → Verify
```

This is slower than the other surfaces by design. The goal here is understanding, not just output.

---

## A quick tour of VS Code

If VS Code is new to you, here are the parts you'll use most:

**Explorer panel (left sidebar)** — shows all the files in your project. Click a file to open it.

**Editor (center)** — where you read and edit files. You can have multiple files open as tabs.

**Continue panel (left sidebar)** — the AI chat interface. Ask questions here about whatever file you have open.

**Terminal (bottom)** — a built-in terminal. Open it with `` Ctrl+` `` (Windows/Linux) or `` Cmd+` `` (Mac). You can run the same commands here as you would in a standalone terminal.

**Command palette** — opens with `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux). Type any action to find it — this is the fastest way to do almost anything in VS Code.

---

## Build the example project: a decision helper

You'll either build the decision helper from scratch using Continue, or open the version you built in the CLI surface and explore it. Either way, the focus here is on reading and understanding the code, not just getting it to run.

### Option A — Open the project you built in the CLI surface

If you completed the CLI guide, open that project:

```bash
code ~/decision-helper
```

What this does: opens the `decision-helper` folder in VS Code. You'll see `index.html` in the Explorer panel.

### Option B — Start fresh

Open VS Code, open the terminal (`` Cmd+` `` or `` Ctrl+` ``), and run:

```bash
mkdir ~/decision-helper
code ~/decision-helper
```

Then use Continue to build it:

1. Click the Continue panel on the left
2. Enter this prompt:

```
Build a simple decision helper web app as a single index.html file. The user enters a decision they're facing. When they submit, the app shows three sections: what we know, what we don't know, and questions to ask before deciding. Use plain HTML, CSS, and JavaScript — no frameworks.
```

Continue will generate the file. Click **Accept** to write it to your project folder.

---

## Reading the code

Open `index.html` in the editor. You'll see three sections: HTML (structure), CSS (appearance), and JavaScript (behavior).

Don't try to understand everything at once. Pick one section and ask Continue to explain it.

Click on the JavaScript section, then in the Continue panel:

> "Explain what the JavaScript in this file is doing, in plain language — I'm not a developer"

Continue will walk through it. Ask follow-up questions:

> "What does the word 'function' mean here?"

> "Why is this part wrapped in curly braces?"

> "What would happen if I removed this section?"

There are no wrong questions. This is the point of the IDE surface — not to write code, but to develop a mental model of what's there.

---

## Making a targeted change

Once you have a sense of the file, try making a change with Continue's help.

In the Continue panel:

> "I want to add a fourth section to the output called 'Next step' — one concrete action the user could take. Add it to the HTML and update the JavaScript to generate it"

Continue will show you the proposed changes, highlighted in the editor. Review them before accepting:

- Do the changes look like what you asked for?
- Are they in the right place in the file?

Click **Accept** to apply. Open the file in your browser to verify.

---

## Verifying your changes

Open the built-in terminal and run:

```bash
open index.html        # macOS
start index.html       # Windows
xdg-open index.html    # Linux
```

Test the app. If something looks wrong, go back to Continue and describe the problem:

> "The new 'Next step' section isn't appearing after I submit — fix that"

---

## When things go wrong

**You accepted a change and it broke something:**
Use `Cmd+Z` (Mac) or `Ctrl+Z` (Windows/Linux) to undo. VS Code has full undo history.

**Continue's change was in the wrong place:**
Undo, then give a more specific prompt: "Add the new section after the 'Questions to ask' section in the HTML, not at the top of the file."

**You can't tell what a piece of code does:**
Select it, then right-click → Ask Continue. It will explain the selected code specifically.

**The file has gotten messy after many changes:**
Ask Continue to clean it up: "Reorganize this file so the HTML, CSS, and JavaScript are clearly separated and easy to read. Don't change the functionality."

---

## What you now have

The ability to open a file, read it with AI assistance, ask questions about it, and make targeted changes. You're no longer dependent on the output being right the first time — you can read it, understand it, and fix it yourself.

---

## When to move to a different surface

**Move to no-code (Dyad) when:**
- you want to prototype something quickly before diving into the code
- you want to see a visual result without worrying about structure first

**Move to CLI (OpenCode) when:**
- you want to build a multi-file project with more structure
- you want the AI to handle more of the construction while you review plans

---

**Want to go deeper?**
The Continue documentation explains its full feature set, including inline editing, codebase indexing, and using different models: [docs.continue.dev](https://docs.continue.dev)
