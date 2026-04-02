# Building with Dyad — No-Code Surface

## What this surface is for

Sometimes you just want to see something work. You have an idea, you want to test it quickly, and you don't want setup complexity or code getting in the way.

The no-code surface — Dyad — is for that. You describe what you want in plain language. Dyad generates a working app. You iterate until it does what you need.

**Use this surface when:**
- you're trying something new and want fast feedback
- you're more comfortable describing than specifying
- you want to validate an idea before investing more time
- you're early in your learning and want a first win

**Prerequisite:** Dyad installed and connected to Ollama ([setup guide](../setup/dyad.md)).

---

## How Dyad works

You write a prompt. Dyad sends it to your local `qwen3:8b` model, which generates the app code. Dyad then runs that code and shows you the result — all in one window, with no terminal involved.

When the result isn't right, you describe what to change. Dyad updates the app. You repeat until it's what you wanted.

The whole loop looks like this:

```
Describe → See → React → Describe again
```

---

## Writing prompts that work

The most common mistake is being too vague. "Make me an app" gives the model too little to work with. The more specific you are about what the app does and who uses it, the better the output.

A useful prompt structure:

> "Build me a [type of thing] that lets [who] [do what]. It should [key behavior]. Keep it simple."

Examples:

| Too vague | More useful |
|----------|------------|
| "Make a decision tool" | "Build a simple decision helper that lets me type a decision I'm facing and see a structured list of pros, cons, and questions to ask before deciding" |
| "Build something for tasks" | "Build a task tracker with a text field to add tasks, a list showing all tasks, and a way to mark tasks as done" |
| "Make a tool for my team" | "Build a simple weekly status update form with fields for what was done, what's next, and what's blocked" |

---

## Build the example project: a decision helper

This is a simple tool that helps you frame a product decision. You describe the decision, and it returns a structured breakdown of what you know, what you don't know, and what questions to ask before deciding.

### Start a new project in Dyad

Open Dyad and create a new project.

### Enter this prompt

```
Build a simple decision helper app. The user types a decision they're facing into a text area. When they click "Analyze", the app shows three sections:

1. What we know — facts and context about the decision
2. What we don't know — key uncertainties
3. Questions to ask — the most important questions to answer before deciding

Keep the design clean and simple. No login, no database — just the form and the output.
```

### Review the output

Dyad will generate and display the app. Ask yourself:
- Does it do what I described?
- Is the layout clear?
- Are the three sections present?

If something is missing or off, describe what you'd like to change.

### Iterate

Try follow-up prompts like:

> "Make the output sections easier to read — add some visual separation between them"

> "Add a field at the top for me to label the decision, so I can tell outputs apart"

> "Make the button larger and centered"

Each prompt updates the app. You don't start over — Dyad applies changes to what's already there.

---

## When things go wrong

**The output doesn't match what you described:**
Add more detail to your prompt. Describe the gap between what you got and what you wanted. For example: "The app is missing the 'Questions to ask' section — please add it as a third output section below the other two."

**The app looks broken or won't run:**
Click the regenerate or reset option in Dyad. Start with a simpler version of the prompt, get something working, then add complexity in follow-up prompts.

**The model seems confused by a long prompt:**
Break it into smaller steps. Get the basic layout working first, then add behavior, then refine the design.

---

## What you now have

A working mental model of the no-code build loop: describe → see → react → describe again. You've built something real without writing a line of code, and you know how to iterate when the output isn't right.

---

## When to move to a different surface

**Move to CLI (OpenCode) when:**
- you want to see what files are being created and why
- you want to work on a project that lives in a folder on your machine
- you want more control over each step the AI takes

**Move to IDE (VS Code) when:**
- you want to look at the code Dyad generated and understand it
- you want to modify specific parts of the output directly
- you're ready to start building transferable coding skills

---

**Want to go deeper?**
Dyad's documentation covers advanced features including multi-file projects and deployment: [dyad.sh/docs](https://dyad.sh/docs)
