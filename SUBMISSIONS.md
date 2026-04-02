# SUBMISSIONS.md

This file explains what kinds of tools, workflows, docs, and examples are a good fit for `frugal-vibe-coder`.

The short version:

- affordability matters
- ease of use matters
- learning value matters
- open source is strongly preferred
- a free version is acceptable only if it is genuinely useful for learning

This repo is not trying to collect every AI tool. It is trying to curate tools and workflows that help people learn modern AI-assisted product building without unnecessary cost, lock-in, or intimidation.

---

## What belongs here

A submission is a good fit when it helps learners build durable understanding with realistic constraints.

Good submissions include:

- tools that support one of the repo's learning surfaces:
  - no-code / low-code
  - CLI
  - IDE / editor
- setup guides
- learning exercises
- sample projects
- comparisons and decision frameworks
- troubleshooting help
- instructor resources

---

## Tool Admission Criteria

When evaluating a tool for this repo, these are the priorities.

### 1. Learning value

The tool should help the learner build transferable understanding, not just produce output.

It should teach something durable about:

- product thinking
- prompting and iteration
- local vs paid model tradeoffs
- code reading or editing
- workflow choice
- model and tool awareness

If a tool mostly creates dependency on one vendor or one interface, it is a weak fit.

### 2. Ease of use

The tool should be realistic for beginners and mixed-skill learners.

That means:

- setup is understandable
- docs are available
- failure modes are survivable
- the learner does not need advanced terminal or infrastructure experience to get first success

If a tool is powerful but fragile, confusing, or hard to recover from, it should be deferred until this repo can support it responsibly.

### 3. Affordability

The tool should have a genuinely usable free path or a realistically affordable starting path.

Free versions are acceptable when they are not heavily crippled.

That means the learner should be able to meaningfully:

- install it
- try it
- complete a small learning exercise
- understand the workflow

If the free version is basically a teaser that blocks real learning, it is not a good fit.

### 4. Openness and portability

Open source is highly valued in this repo.

Why:

- it usually improves access
- it reduces lock-in
- it supports local-first use
- it helps learners understand what they are using
- it creates longer-term portability

Closed-source tools can still be considered, but they should clear a higher bar on affordability, ease of use, and learning value.

---

## Strong Preferences

These are not all strict requirements, but they strongly improve fit:

- open-source
- local-first or self-hostable where practical
- works on ordinary hardware, ideally 8–16 GB RAM
- available on mainstream platforms
- low recurring cost
- low lock-in
- clear documentation
- realistic for PMs, students, educators, and independent builders

---

## Reasons to Defer or Exclude

Submissions should usually be deferred or rejected if they are:

- paid-only by default
- "free" but too limited to be genuinely useful
- dependent on high recurring API spend
- unrealistic on ordinary consumer hardware
- too brittle for beginner use
- dependent on advanced DevOps or infrastructure knowledge
- redundant with an already supported tool without offering distinct learning value
- prestige-driven rather than learner-driven

---

## Decision Questions

Before adding a tool, ask:

1. Can a learner start with this affordably?
2. Can a learner use it without advanced technical confidence?
3. Does it teach something durable?
4. Is the free path genuinely useful?
5. Is open source or low-lock-in part of the value?
6. Does it work on ordinary hardware?
7. Does it fit a real learning need in no-code, CLI, or IDE workflows?

If the answer is mostly no, it probably does not belong here yet.

---

## Submission Categories

Not every promising tool should become "supported now" immediately.

Use these categories:

### Supported now

We actively support it with docs, setup guidance, examples, or scripts.

### Under consideration

The tool seems aligned with the mission, but we are not ready to support it yet.

Reasons might include:

- not enough testing yet
- docs not ready
- unclear platform support
- too much overlap with an existing tool

### Deferred or out of scope

The tool may be interesting, but it does not fit the learner profile, current phase, or affordability standard of the repo.

---

## If You Want to Propose a Tool

Please include:

- the tool name
- which learning surface it fits: no-code, CLI, IDE, or future category
- whether it is open-source, closed-source, or mixed
- whether it has a free version, and whether that free version is genuinely usable
- platform support
- hardware expectations
- why it improves learning value, affordability, or ease of use
- what it offers that current supported tools do not

Useful proposals are concrete. "This tool is cool" is not enough. "This tool gives beginners a realistic, free, low-friction path for [specific learning need]" is much more useful.

---

## If You Want to Help

The most valuable help right now is not just naming tools. It is helping validate whether the current repo actually works for real learners on real machines.

That can include:

- testing setup scripts on macOS, Windows, and Linux
- identifying confusing setup steps
- proposing better docs or examples
- suggesting sample projects
- highlighting tools that better meet the criteria above

The goal is not to collect more tooling.
The goal is to make learning more accessible, affordable, and understandable.
