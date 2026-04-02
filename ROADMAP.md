# ROADMAP.md

A forward-looking plan for frugal-vibe-coder. Phases are ordered by dependency — each builds on what came before. Nothing in a future phase should be started until the prior phase is stable and reviewed.

---

## Current state (complete)

- `/docs` — concepts, setup guides, surface guides, reference
- `/scripts` — shared library, per-tool installers, macOS/Linux entry point, Windows PowerShell entry point
- `frugal-vibe.conf` — committed config file, fully commented
- Core docs — `AGENTS.md`, `CLAUDE.md`, `README.md`

---

## Phase 2 — Sample Projects

### What it is
A small set of example projects that learners can build, study, and adapt. Each project is solved three ways — no-code (Dyad), CLI (OpenCode), and IDE (VS Code) — so learners can see how the same problem feels across different surfaces.

### What's included
- 3–4 projects at increasing complexity
- Each project has a `/docs/projects/[project-name]/` folder containing:
  - `overview.md` — the problem, scope, and what the learner will understand after building it
  - `no-code.md` — how to build it in Dyad with exact prompts
  - `cli.md` — how to build it in OpenCode, step by step
  - `ide.md` — how to build it in VS Code + Continue, with reading and reflection prompts

### Candidate projects (in order of complexity)
1. **Decision helper** — already used in surface docs; formalize it as the canonical starter
2. **Task tracker** — CRUD fundamentals, visible state, simple enough to complete in one session
3. **Feature prioritization tool** — product-minded, useful to PMs, introduces input/output thinking
4. **Simple status dashboard** — brings in the idea of multiple data sources displayed together

### Parameters
- Scope: small and completable in 60–90 minutes per surface
- No authentication, no external APIs, no databases for the first two projects
- Projects 3–4 may introduce light data persistence (local file or browser storage only)
- Prompts must be copy-paste ready — no "adapt this to your situation" placeholders
- Each project overview must state which learner profile it targets and what it teaches

### Open decisions
- Whether to include finished versions of each project as reference code in `/projects/`
- How to handle projects that behave differently across surfaces (some things are easier in one surface than another — lean into that rather than smoothing it over)

---

## Phase 3 — Instructor Resources

### What it is
Materials for educators running workshops, bootcamps, or cohorts using this repo. The goal is to reduce setup burden and let instructors focus on facilitation, not troubleshooting.

### What's included
- `docs/instructor/README.md` — overview of what's available and how to use it
- `docs/instructor/workshop-guide.md` — a 90-minute session plan for mixed-skill groups
- `docs/instructor/setup-checklist.md` — what to verify before a session (models pulled, tools installed, test on all three platforms)
- `docs/instructor/troubleshooting.md` — the 10 most common setup issues and how to resolve them
- `docs/instructor/session-outlines/` — modular session outlines for different goals (first build, surface comparison, model tradeoff discussion)

### Parameters
- Assume the instructor has moderate technical confidence but may not have done this before
- Every session plan must work on student hardware (8–16 GB, no GPU)
- Troubleshooting guide must be fast to scan — problems and fixes, not essays
- Session outlines should be adaptable: 60-minute version and 90-minute version of each

### Open decisions
- Whether to include slide deck templates or keep it text-only
- How to handle mixed-OS classrooms (Windows + Mac + Linux in the same room)
- Whether to create a "pre-session install party" guide as a separate resource

---

## Phase 4 — Paid Model Onboarding

### What it is
A complete guide for learners who are ready to try a paid model. Framed as an optional upgrade with clear guidance on when it's worth it and how to stay in control of costs.

### What's included
- `docs/setup/paid-models.md` — step-by-step setup for Anthropic and OpenAI keys, following the Learner Interaction Pattern
- `docs/concepts/when-to-pay.md` — a decision framework: what local models can't do well, what paid models unlock, how to evaluate the tradeoff
- `docs/reference/cost-guide.md` — rough cost estimates for common usage patterns, how to monitor spend, how to set usage limits

### Parameters
- Shell environment only for keys — never in files (already established; this formalizes the guide)
- Default to cheapest model in each provider (`claude-haiku-4-5`, `gpt-4o-mini`)
- Cost guide must use real numbers, not vague language like "it can add up"
- Must include how to turn paid models off and return to Ollama

### Open decisions
- Whether to include a comparison table of local vs paid model quality for common learner tasks
- Whether to cover free-tier API access (both Anthropic and OpenAI have limited free tiers)

---

## Phase 5 — Prompts and Templates

### What it is
A library of reusable prompts and templates for PM-oriented building. Not a generic prompt collection — prompts tied to specific tasks this audience actually does.

### What's included
- `docs/prompts/README.md` — how to use this library, how to adapt prompts
- `docs/prompts/product-thinking/` — prompts for framing problems, writing user stories, prioritization decisions
- `docs/prompts/building/` — prompts for common build tasks (add a feature, debug something, explain this output)
- `docs/prompts/reflection/` — prompts for after a build session (what worked, what didn't, what to do differently)

### Parameters
- Every prompt must be copy-paste ready with clear placeholders marked as `[like this]`
- Include a note on which surface each prompt works best with
- Reflection prompts are surface-agnostic — they apply to any build session
- No prompts that require deep technical knowledge to use

### Open decisions
- Whether to organize by surface or by task type (task type is probably more useful)
- Whether to include "prompt chains" — sequences of prompts for multi-step tasks

---

## Phase 6 — Future Surfaces

### What it is
Introduction of new learning surfaces as the learner's skills and confidence grow. Each new surface follows the same structure as the current three: a concept doc, a setup guide, and a surface workflow guide.

### Surfaces and sequencing

**Visual agent-flow builders** (earliest candidate for introduction)
- n8n (self-hosted) and Flowise
- Natural fit for this audience — visual, no-code, but more powerful than Dyad
- Prerequisite: learner has completed at least one project on the no-code surface
- Hardware note: n8n self-hosted requires Docker — this is the forcing function for introducing Docker as a concept

**Autonomous agent platforms** (after visual builders)
- OpenClaw and OpenHands
- Require the learner to understand what an agent is before they can use one well
- Prerequisite: learner has completed projects on at least two surfaces
- Must include explicit framing on oversight — what the agent can do without asking

**Coding agent frameworks** (advanced, optional)
- SWE-agent
- Designed for learners who have moved into real code work
- Prerequisite: comfortable with the IDE surface

### Parameters for all future surfaces
- Follow the Learner Interaction Pattern without exception
- Prefer local or self-hosted versions — cloud-dependent surfaces are introduced only when no local option exists
- Each new surface must connect back to existing surface docs (what's different, what's similar)
- Hardware requirements must be stated clearly upfront — some of these tools are more demanding

### Docker decision point
Visual agent-flow builders (n8n in particular) likely require Docker. When Phase 6 begins, a `docs/concepts/what-is-docker.md` and a `docs/setup/docker.md` should be written before any surface that depends on it. Docker should be framed as infrastructure, not a learning goal in itself.

### Open decisions
- Exact ordering of n8n vs Flowise as the first visual builder introduced
- Whether OpenClaw and OpenHands get separate guides or a shared "autonomous agents" guide
- How to handle the Docker prerequisite cleanly without making it feel like a barrier

---

## What does not belong in this repo (ever)

- Paid-only workflows presented as the default path
- Tools that require 32+ GB RAM as a baseline
- Content that assumes professional developer fluency
- Benchmarking or vanity comparisons between models
- Tutorials that only make sense if you're building a startup

---

## Review cadence

Each phase should be reviewed before the next begins. Review criteria:

1. Does the content follow the Learner Interaction Pattern?
2. Does it work on the target hardware (8–16 GB, no GPU)?
3. Is it tested on all three supported platforms?
4. Does it teach judgment, not just procedure?
5. Would a PM or designer with no coding background be able to follow it?
