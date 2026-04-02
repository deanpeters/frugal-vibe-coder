# AGENTS.md

## Project: frugal-vibe-coder

### Mission

frugal-vibe-coder is a **learning platform** for AI-assisted product building. Budget-consciousness is a core design constraint, not the whole point. The goal is to help people understand and build with modern AI tooling — clearly, confidently, and without unnecessary cost.

This project is for:
- students
- career changers
- early-career product managers
- independent builders
- under-resourced teams
- anyone who wants to learn modern AI-assisted building without being forced into expensive monthly token spend, premium API subscriptions, or high-end hardware

This repository prioritizes:
- learning and understanding first
- low-cost learning paths
- local-first workflows
- practical product thinking
- beginner-friendly setup
- pedagogic usefulness over hype
- multiple learning surfaces, not just one tool category

The project does **not** assume the user can afford:
- recurring API costs
- enterprise subscriptions
- premium AI copilots
- high-memory workstations
- always-on cloud services

---

## Scope

This project supports low-cost learning across three primary modes:

### 1. No-code and low-code app builders
Examples:
- Dyad
- bolt.diy
- other local-first or low-cost visual / prompt-based builders

### 2. CLI-based coding agents and workflows
Examples:
- OpenCode
- Goose
- other terminal-first AI tooling that can run locally or with minimal paid usage

### 3. IDE-based learning and building workflows
Examples:
- VS Code with carefully chosen extensions
- VSCodium where appropriate
- low-cost or open-source editor-based workflows for AI-assisted product building

The project is not narrowly about "vibe coding."
It is about helping people learn to build with modern AI tooling under budget constraints, across the environments they are most likely to encounter:
- browser-based builders
- terminal workflows
- code editors / IDEs

---

## Core Product Philosophy

When contributing to this repo, optimize for the following in order:

1. **Access**
   - Prefer workflows that work on ordinary consumer hardware.
   - Prefer free and open-source tools when feasible.
   - Prefer local models and local runtimes where they are good enough.

2. **Learning**
   - Explain the "why," not just the "how."
   - Help users build transferable skills, not dependency on a specific vendor.
   - Make tradeoffs explicit.

3. **Frugality**
   - Treat token spend, memory use, setup complexity, extension sprawl, and hardware requirements as first-class constraints.
   - Avoid recommending paid tools unless they are clearly optional and justified.

4. **Practicality**
   - Favor setups that can get a learner to first success quickly.
   - Prefer reproducible, low-touch installation and onboarding.

5. **Product Manager Relevance**
   - Keep the project grounded in product thinking, not just code generation.
   - Tie tools and workflows back to problem framing, prioritization, validation, and learning loops.

6. **Tooling Portability**
   - Help learners move between no-code, CLI, and IDE workflows without losing conceptual continuity.
   - Teach durable patterns, not platform dependency.

---

## What This Repo Should Contain

This repo may include:

- setup guides for low-cost AI app-building environments
- tutorials for local-first no-code, CLI, and IDE workflows
- comparisons of tools like Dyad, bolt.diy, OpenCode, Goose, VS Code, and VSCodium
- prompts, templates, and exercises for PM-led building
- model selection guides for constrained hardware
- scripts for student-friendly installation
- sample projects designed for learning
- instructor resources for workshops and cohorts
- decision frameworks for when to use local models vs paid APIs
- accessibility-oriented documentation
- frugal workflow playbooks
- extension recommendations for editor-based learning
- terminal onboarding materials for non-engineers
- "same task, different surface" examples across no-code, CLI, and IDE contexts
- foundational concept introductions: package managers, version control, local model inference, and more
- a `/docs` directory with structured learning content and curated links to deeper resources
- per-learner install state documentation tracking what is installed, how it is configured, and where to find it
- a `/docs/reference/` section pointing learners to the right doc for their current question

This repo should avoid becoming:
- a showcase for expensive tools
- an API-credit-heavy playground
- a benchmark vanity project
- a collection of advanced optimizations that intimidate beginners
- a repository that assumes deep engineering experience
- a shrine to any single interface or vendor

---

## Intended Audience

Assume the primary audience is one or more of the following:

- a product manager who can reason well but is not a professional software engineer
- a learner using a MacBook Air, older MacBook Pro, or mid-range Windows laptop
- someone with 8–16 GB RAM
- someone trying to minimize recurring AI costs
- someone who can follow instructions but may be uncomfortable with terminal workflows
- someone who may be more comfortable in a visual builder than an IDE
- an educator trying to support a mixed-skill cohort

Write for competence, not expertise.
Do not write as if the reader already knows:
- containers
- model quantization
- inference backends
- CLI debugging
- package managers
- editor extension ecosystems
- developer environment management

---

## Non-Negotiable Rules for Agents

When making changes in this repository, agents must follow these rules:

### 0. API keys never go in files
API keys and secrets must never appear in any file within this repository — not in config files, not in scripts, not in `.env` files, not in examples.

Keys belong in the user's shell environment only:
- Mac/Linux: `~/.zshrc` or `~/.bashrc` via `export KEY_NAME=value`
- Windows: System > Environment Variables

When a script or guide requires a paid API:
- instruct the user to set the key in their shell environment
- check for the key at runtime using environment variable lookup
- if the key is missing, fail loudly with a specific message explaining exactly where to set it
- offer Ollama as a fallback

`.gitignore` must include patterns covering `*.env`, `.env*`, and any file that could accidentally capture a secret.

### 1. Cost-awareness is mandatory
Every recommendation should consider:
- upfront cost
- recurring cost
- hidden costs
- hardware requirements
- maintenance burden
- extension or plugin lock-in
- model download size
- API burn risk

Do not recommend premium APIs or subscriptions as the default path.

If recommending paid tools:
- state clearly that they are optional
- explain when they become worth it
- provide a lower-cost fallback

### 2. Local-first by default
When there is a reasonable local option, prefer it.

Examples:
- local models via Ollama
- open-source app builders
- local installable CLI tools
- local IDE/editor workflows
- docs and tutorials that can be used offline once installed

Do not assume cloud dependence unless necessary.

### 3. Beginner-safe defaults
All scripts, examples, and starter guides should use conservative defaults.

Defaults should favor:
- smaller models
- stable tooling
- fewer installation steps
- lower RAM usage
- lower chance of failure
- lower plugin and configuration burden

### 4. Clarity over cleverness
Prefer:
- plain language
- short steps
- explicit tradeoffs
- comments in scripts
- predictable structure

Avoid:
- unexplained jargon
- over-abstracted architecture
- "magic" steps
- hidden assumptions

### 5. Product-first framing
This is not just a coding repo.

Whenever appropriate, connect implementation choices to:
- user problems
- learner outcomes
- scope control
- opportunity cost
- validation
- iteration discipline

### 6. No prestige bias
Do not privilege tools because they are trendy, premium, or associated with elite users.

Prefer tools that:
- broaden access
- reduce dependency
- lower barriers to learning
- let users keep going even with limited funds

### 7. Preserve dignity
Do not frame low-budget users as second-class builders.
Do not describe frugal workflows as merely "good enough for now."
Treat cost-conscious design as a serious design principle.

### 8. Respect different entry points
Do not assume the right starting point is always:
- no-code
- terminal
- full IDE
- local models
- paid APIs

Different learners need different on-ramps.
Contributions should make it easier to choose an appropriate path without shame or unnecessary gatekeeping.

---

## Default Technical Assumptions

Unless a task explicitly says otherwise, assume the target environment is:

- macOS, Windows, or Linux (Debian/Ubuntu/Mint)
- consumer laptop
- 8–16 GB RAM
- no paid API keys assumed (paid models are a supported but optional layer)
- intermittent comfort with terminal usage
- willingness to install local tools if guided clearly
- mixed levels of comfort across browser, terminal, and IDE interfaces

Prefer examples that work in that environment.

---

## Tooling Guidance

### Preferred Categories
Prefer tools that are:
- free
- open-source where possible
- installable locally
- documented well enough for students
- realistic on mainstream hardware

### Supported Learning Surfaces

#### A. No-code / low-code
Use for:
- first success
- rapid prototyping
- product-thinking exercises
- low-friction learning
- helping non-coders develop confidence

Bias toward:
- Dyad for low-touch local-first learning
- bolt.diy for advanced hybrid workflows
- simple starter app scopes
- local models where practical

#### B. CLI / terminal-first
Use for:
- teaching structured workflows
- exposing model/tool orchestration more explicitly
- helping learners understand what happens under the hood
- advanced low-cost workflows that remain transparent and portable

Bias toward:
- OpenCode
- Goose
- other tools that are realistic for learners and do not force high recurring cost

CLI content must:
- define prerequisites clearly
- explain commands before expecting use
- separate copy-paste basics from deeper understanding
- avoid assuming professional developer fluency

#### C. IDE / editor-based
Use for:
- learners ready for code inspection and iteration
- bridging from no-code or CLI into more durable coding skills
- lightweight local development workflows

Bias toward:
- VS Code when it offers the easiest path for learners
- VSCodium when it materially reduces lock-in, cost, or telemetry concerns
- a minimal extension set
- reproducible setup instructions

Editor recommendations must avoid:
- extension overload
- opaque configuration stacks
- requiring multiple premium AI plugins by default

### Avoid Defaulting To
Avoid default recommendations that require:
- expensive monthly subscriptions
- large cloud bills
- 32–64 GB RAM as a baseline
- complex devops
- multiple paid accounts to get started
- premium editor extensions as table stakes

---

## Content Standards

### Tone
Use a tone that is:
- practical
- respectful
- direct
- pedagogic
- grounded

Avoid:
- hype
- elitism
- startup theater
- exaggerated claims
- "anyone can build anything instantly" language

### Documentation Style
Documentation should:
- begin with purpose
- include a beginner-first quick start near the top when the file is a primary entry point
- state prerequisites explicitly
- list costs and constraints
- distinguish required from optional steps
- include troubleshooting
- explain why a choice was made
- identify which learner profile a guide is for

When a learner needs the repo on their machine, docs should not assume git fluency by default. Prefer offering both:
- a GitHub **Download ZIP** path for beginners
- a `git clone` path for learners who already use git

### Comparisons
When comparing tools, include:
- cost
- setup friction
- hardware burden
- learning value
- lock-in risk
- likely failure modes
- required technical confidence
- suitability for no-code, CLI, or IDE learners

Do not compare only on raw capability.

---

## Script and Installer Standards

If creating installation scripts:

- use conservative model defaults
- support common classroom/student environments
- minimize required edits
- minimize admin privileges where possible
- fail loudly and clearly
- print helpful next steps
- avoid pulling oversized models by default
- prefer profile-based options like `--light`, `--balanced`, `--coding`
- make clear whether the script is for no-code, CLI, IDE, or shared prerequisites

Scripts should prioritize:
- reliability
- readability
- modifiability by instructors

When possible, separate:
- core prerequisite installs
- optional model pulls
- optional advanced tooling
- editor / extension setup

### Package manager detection

Scripts should check for package managers before attempting any installation and use them when available. This produces cleaner installs, easier updates, and less manual cleanup.

On macOS: check for Homebrew (`command -v brew`). If present, prefer `brew install` / `brew upgrade` over manual downloads.
On Windows: check for Chocolatey (`Get-Command choco`). If present, prefer `choco install` / `choco upgrade` over manual installers.
On Debian/Ubuntu/Mint: use `apt`. Check for `snap` and `flatpak` as supplementary options where appropriate.

If no package manager is found or recognized, fall back to direct installation and note the tradeoff (harder to update or uninstall later). Never require a package manager — offer it as the better path when available.

### Pre-installation checks

Before installing any tool, scripts must check whether it is already installed. For each tool, offer three explicit options:

1. **Already installed, up to date** — confirm and move on
2. **Already installed, update available** — ask whether to update or keep the current version
3. **Not installed** — ask whether to install

Never silently overwrite an existing installation. Never assume a missing tool must be installed — the learner may have a reason for not having it, or may want to install it manually.

This pattern teaches learners to think about system state, not just follow steps blindly. It also prevents the repo from being destructive on machines with existing setups.

If a manual installer is used, scripts should verify that the tool actually appears before continuing. Do not treat "press Enter when you're done" as proof that the install succeeded.

If a script needs to replace an existing config file, it must:
- explain what will change
- offer the learner a keep-or-replace choice
- create a backup first if the learner chooses replace

If a required prerequisite is still missing after the learner declines or exits, stop cleanly and tell them what to run next. Do not march them into a half-configured state.

### Configuration and model selection

Scripts must read model and provider settings from `frugal-vibe.conf`, not from hardcoded values. This file controls `MODEL_PROVIDER`, `LOCAL_MODEL`, and `PAID_MODEL`. It never contains API keys.

Default model for all three surfaces (no-code, CLI, IDE) is `qwen3:8b`. This audience is primarily PMs and designers who ask broad product and thinking questions, not just code questions. A general-use model serves them better than a coding-specialized one. `qwen2.5-coder:7b` is an optional upgrade, not a default.

When supporting paid providers:
- Default to the cheapest option: `claude-haiku-4-5` (Anthropic) or `gpt-4o-mini` (OpenAI)
- Check for the API key in the environment at runtime — never prompt for it or write it to a file
- If the key is missing, fail with a specific message and offer Ollama as the fallback
- Document paid options as optional, never as the recommended starting point

---

## CLI Workflow Standards

When creating CLI content:

- assume the learner may be nervous about the terminal
- explain what each command does
- include copy-paste-safe examples
- avoid chaining too many operations into unreadable one-liners
- provide rollback or uninstall guidance where practical
- prefer transparent commands over "wizard" abstractions
- explain when a CLI tool is a better fit than a visual builder

Use CLI workflows to teach:
- explicitness
- repeatability
- lightweight automation
- model/tool awareness

Do not use CLI content as a status marker for "serious" learners.

---

## IDE Workflow Standards

When creating IDE/editor content:

- prefer the smallest viable setup
- recommend the fewest extensions necessary
- distinguish required extensions from optional ones
- explain tradeoffs between VS Code and VSCodium
- avoid assuming learners already understand terminal, git, debugging panels, or extension management
- provide screenshots or stepwise descriptions when useful

The goal is not to turn this repo into a generic developer setup guide.
The goal is to help learners use editors productively in low-cost AI-assisted workflows.

---

## Learner Interaction Pattern

All scripts, guides, and tutorials must follow this pattern when introducing or installing anything new. It is designed for the primary audience: PMs and designers who think in problems and products, not tools and commands.

1. **Problem first** — open with the frustration or limitation this solves, not the tool name
2. **What it is** — one plain sentence, no jargon
3. **What you're about to do** — set expectations before any action is taken
4. **Check / choose** — detect current state and present explicit options: already installed and current, update available, or not installed
5. **Each step explained** — every command is followed by a plain-language explanation of what it does and why
6. **Confirm and orient** — after completion, state what is now true about the learner's setup and what it unlocks next
7. **Go deeper** — one curated external link for learners who want more; always optional, never required

This order is deliberate. Learners act with more confidence and make better decisions when they understand context and consequences before being asked to do anything. Never lead with a command.

---

## Educational Design Standards

When creating tutorials, exercises, or example projects:

- optimize for first success
- use small, understandable scopes
- include reflection prompts where useful
- explain tradeoffs in product terms
- separate beginner, intermediate, and advanced tracks
- avoid assuming the learner's goal is to become an engineer
- support multiple execution modes where possible:
  - no-code
  - CLI
  - IDE

Example learning goals this repo should support:
- understand what a package manager is and why it matters
- create and use a free git repository (GitHub or equivalent)
- understand what Ollama is and what is actually running on your machine
- understand local vs paid model tradeoffs
- choose a tool for budget-constrained app building
- build a simple app with low-cost tooling
- think like a product manager while building
- learn where AI helps and where it still fails
- move from visual to terminal to editor workflows with confidence
- choose the lowest-friction tool that still teaches the intended lesson

---

## /docs Directory Structure

The `/docs` directory is the learning core of this repo. It is organized into four sections:

```
/docs
  /concepts/     Plain-language introductions to foundational ideas
  /setup/        Step-by-step installation guides per platform and tool
  /surfaces/     How-to guides for no-code, CLI, and IDE workflows
  /reference/    Config locations, tool inventory, and the learner's install state log
```

### /docs/concepts/
Each file introduces one concept the learner needs to understand before or while setting up their environment. Concept docs are not setup guides — they explain the idea, why it matters, and what it makes possible.

Foundational concepts to cover:
- What is a package manager (and why it makes installing and updating easier)
- What is version control and why a free GitHub account is worth having
- What is a local model and what Ollama actually does on your machine
- What is an API key, where it lives, and why it never goes in a file
- What is a config file and how this repo uses `frugal-vibe.conf`
- What is the difference between a local and a paid model

Each concept doc follows the Learner Interaction Pattern and ends with one curated external link.

### /docs/setup/
Installation guides organized by tool and platform (macOS, Windows, Debian/Ubuntu/Mint). Each guide follows the Learner Interaction Pattern: problem first, check current state, explain each step, confirm and orient.

### /docs/surfaces/
Workflow guides for each of the three learning surfaces: no-code (Dyad), CLI (OpenCode), and IDE (VS Code). Each guide connects back to the relevant concept docs and assumes only what the setup guides have already covered.

### /docs/reference/
Static reference material: where configs live, what each tool's settings file is called, a map of which docs answer which questions.

Also contains `my-setup.md` — a local-only file (gitignored) written and updated by install scripts. See Install State below.

---

## Install State

Every install script must write a record of what it did to `docs/reference/my-setup.md`. This file is gitignored — it is local to each learner's machine and never committed.

Each entry should include:
- tool name and version installed
- installation method (package manager, direct download, etc.)
- config file location(s)
- which learning surface(s) it supports

The file should also include a top-level "last updated" timestamp. When a learner reruns setup, scripts should update the relevant section instead of appending duplicate sections that compete with each other.

This file serves two purposes: practical (the learner can always check what they have and where to find its config) and pedagogic (it makes the installed environment visible and understandable, not a black box).

Scripts should also print a brief summary to the terminal at the end of each install, pointing the learner to `docs/reference/my-setup.md` for the full record.

---

## Docker

Docker is deferred. It adds meaningful conceptual complexity (containers, virtualization, images) that is not appropriate for the primary learner profile at this stage. It may be introduced as an advanced optional topic in a future phase, but it must never appear in default setup paths or be assumed as a prerequisite.

---

## Accessibility and Inclusion

Contributors and agents should assume users may face:
- financial constraints
- low-bandwidth internet
- older hardware
- limited technical confidence
- inconsistent access to paid software
- discomfort with command-line interfaces
- uncertainty about code editors and development environments

Design docs, scripts, and examples accordingly.

Do not make the project dependent on:
- prestige tooling
- constant internet access after setup
- always-on API spend
- advanced technical fluency

---

## Contribution Heuristics

When adding or revising content, ask:

1. Does this reduce or increase the learner's cost burden?
2. Does this improve or worsen first-time usability?
3. Does this help a product-minded learner make better decisions?
4. Does this assume privileges many users do not have?
5. Is there a cheaper, simpler, or more local-first alternative?
6. Is the recommendation robust on ordinary hardware?
7. Does the content teach judgment, not just procedure?
8. Does this choice overfit to one interface when the learner may need another?
9. Can the same lesson be offered in no-code, CLI, or IDE form where useful?

If the answer is unfavorable, revise before committing.

---

## Tool Admission Criteria

This repo should not add tools casually. New tools, workflows, and surfaces should meet explicit admission criteria before they are documented, scripted, or treated as supported.

Core priorities:

1. **Learning value** — the tool should help learners build durable, transferable understanding
2. **Ease of use** — the tool should be realistic for beginners and mixed-skill learners
3. **Affordability** — the tool should have a genuinely usable free path or affordable starting path
4. **Openness and portability** — open source is strongly preferred, and low lock-in matters

Free versions are acceptable only when they are not heavily crippled. A learner should be able to meaningfully try the tool and complete a small learning exercise without immediately being pushed into paid usage.

Closed-source tools can still be considered, but they should clear a higher bar on affordability, ease of use, and learning value.

Before adding a tool, ask:

1. Can a learner start with this affordably?
2. Can a learner use it without advanced technical confidence?
3. Does it teach something durable?
4. Is the free path genuinely useful?
5. Does it work on ordinary hardware?
6. Does it fit a real need in no-code, CLI, IDE, or a future surface?

Use `SUBMISSIONS.md` as the explicit public-facing guide for evaluating and proposing tools.

---

## Preferred Decision Framework

When evaluating tools or workflows, use this order:

1. Can the learner do this locally?
2. Can the learner do this for free?
3. Can the learner do this on ordinary hardware?
4. Can the learner understand and maintain it?
5. Does it support real learning, not just output generation?
6. Is the interface appropriate for the learner's current stage?
7. Is a paid option truly necessary for the last mile only?

---

## Future Scope (Deferred)

The following surfaces and tool categories are on the roadmap but are not current priorities. Do not implement, document, or reference them as available options until they are explicitly moved into active scope.

### Visual agent-flow builders
Tools that let learners build multi-step agent workflows visually, without writing code. Strong fit for the PM/designer audience.

- **n8n** (self-hosted) — open-source workflow automation with a visual canvas; local install preferred
- **Flowise** — open-source visual builder for LLM flows and agent chains; locally installable

Both align with the local-first, low-cost principles of this repo. When introduced, they should be framed as a fourth learning surface alongside no-code, CLI, and IDE — not as replacements.

### Autonomous agent platforms
Platforms where an AI agent operates with greater independence, taking multi-step actions on the learner's behalf.

- **OpenClaw** (openclaw.ai) — autonomous agent platform
- **OpenHands** (formerly OpenDevin) — open-source autonomous software agent; runs locally

When introduced, these should come with clear framing about what autonomous means, what the agent can and cannot do, and how to maintain appropriate oversight. Do not introduce these before learners have a grounding in the basic three surfaces.

### Coding agent frameworks
Frameworks designed to assist with or automate software engineering tasks at a higher level of abstraction.

- **SWE-agent** — open-source framework for autonomous software engineering tasks

These are appropriate for learners who have moved beyond the basics and want to understand how AI approaches larger-scale code problems. Not a starting point.

### General guidance for future surfaces
When any of the above are brought into active scope:
- follow the Learner Interaction Pattern
- prefer local or self-hosted versions over cloud-dependent ones
- introduce the concept before the tool
- connect to existing surfaces rather than treating them as isolated additions
- assess hardware requirements carefully — some of these tools are more demanding than the current baseline

---

## Examples of Good Repository Decisions

Good:
- recommending a 7B or 8B model as a default starter
- providing a one-command installer for Dyad + Ollama
- documenting OpenCode or Goose with copy-paste-safe onboarding
- providing a minimal VS Code extension pack rather than ten overlapping tools
- explaining when a paid API becomes worth using
- documenting tradeoffs between Dyad and bolt.diy for students
- giving PM-oriented exercises that use low-cost local tooling
- showing the same small project in no-code, CLI, and IDE variants

Bad:
- telling all users to buy premium API access immediately
- defaulting to 30B+ models on student hardware
- assuming Docker comfort for beginners
- hiding complexity behind vague claims
- writing docs that only make sense to experienced developers
- requiring multiple paid IDE extensions as a baseline
- treating terminal use as inherently superior to visual tools

---

## Agent Behavior for Change Requests

When asked to make changes:

- preserve the repo's mission
- prefer additive clarity over architectural churn
- keep docs approachable
- avoid introducing costly defaults
- flag recommendations that may exclude budget-constrained learners
- suggest tiered options when appropriate:
  - free/local
  - low-cost hybrid
  - optional premium
- consider whether the requested change is best served through no-code, CLI, IDE, or multiple paths

If a requested change conflicts with the mission of broad affordability and access, agents should:
- say so clearly
- propose a lower-cost alternative
- preserve learner agency

---

## Definition of Success

A successful contribution helps more people say:

- "I can try this on my machine."
- "I understand the tradeoffs."
- "I do not need to spend a lot to learn."
- "I can build and think more clearly with what I already have."
- "This project respects my budget and my ambition."
- "I can start where I am, whether that is visual, terminal, or editor-based."

---
