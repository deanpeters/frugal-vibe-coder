# Introducing Frugal Vibe Coder

## A more affordable learning platform for AI-assisted product building

Want to start vibe-coding, but do not know where to begin, or cannot afford the usual path? This project is for builders learning under real constraints.

## Why This Exists

There is a strange gap in AI tooling right now.

On one side, there is more possibility than ever. A product manager, student, career changer, or independent builder can now prototype apps, explore ideas, and learn new technical skills faster than was practical even a few years ago.

On the other side, a lot of the current conversation starts from assumptions many people do not actually meet.

* It assumes recurring API spend.
* It assumes comfort with developer tooling.
* It assumes a premium AI subscription.
* It assumes a high-end machine.
* It assumes confidence in the terminal.

And most maddening of all:

* It assumes prior experience with repos, editors, package managers, and local models.

That mismatch matters.

A lot of people are curious about modern AI-assisted building, but they are meeting it through tutorials, setup guides, and product recommendations that quietly assume they can afford to experiment expensively and already know how the surrounding tooling works.

That is not a good foundation for learning.

I want a learner to be able to say:

* I can try this on the laptop I already have
* I understand what is running on my machine
* I know when a local model is enough
* I know when a paid model might actually be worth it
* I can start with the surface that fits me best, not the one the internet thinks is most serious

That is the reason for [frugal-vibe-coder](https://github.com/deanpeters/frugal-vibe-coder).

It is not a repo for hype.
It is not a repo for prestige tooling.
It is not a repo that treats budget-conscious learners like second-class builders.

It is a learning platform for AI-assisted product building under real-world constraints.

## A scenario

Imagine a product manager with a normal laptop, limited technical confidence, and no desire to sign up for two paid chatbots and three LLM APIs just to learn the basics.

They may be trying to answer questions like:

* Should I start with a visual builder or a code editor?
* What even is [Ollama](https://ollama.com), and what is it doing on my machine?
* Do I need a paid API key to learn this properly?
* Which setup is realistic on 8 to 16 GB of RAM?
* How do I build something small without feeling lost immediately?

Right now, those questions often get answered in fragments.

One guide explains a tool.
Another assumes Docker.
Another assumes Git.
Another assumes the terminal feels normal.
Another quietly leads back to a paid default.

That is not a learning path. That is a scavenger hunt wearing a tutorial's name tag, with trap doors under the beginner steps and a velvet rope across the easy parts.

The [frugal-vibe-coder](https://github.com/deanpeters/frugal-vibe-coder) project is an attempt to make that experience more coherent, more respectful, and more teachable.

## How might we?

Once the who and why are clear, the next question comes into focus:

> *"How might we create a learning tool that helps people build with modern AI without assuming high budgets, premium subscriptions, or deep engineering fluency?"*

More specifically:

* How might we help learners start on ordinary hardware?
* How might we make local-first workflows the default without making them feel intimidating?
* How might we teach judgment, not just produce output?
* How might we support different entry points, including no-code, CLI, and IDE workflows?
* How might we reduce setup friction enough that educators could use this in mixed-skill groups?

That question drives the project.

## What this is

[frugal-vibe-coder](https://github.com/deanpeters/frugal-vibe-coder) is a nascent learning platform for AI-assisted product building.

Today, the repo is focused on the foundation:

* plain-language docs for core concepts like package managers, [Ollama](https://ollama.com), config files, and API keys
* setup guides for low-cost local-first tooling
* three learning surfaces:

  * no-code with [Dyad](https://www.dyad.sh)
  * CLI with [OpenCode](https://github.com/sst/opencode)
  * IDE with [VS Code](https://code.visualstudio.com) and [Continue](https://www.continue.dev)
* guided setup scripts for macOS, Windows, and Debian, Ubuntu, and Mint-friendly Linux workflows
* a single shared config approach through `frugal-vibe.conf`
* an install log pattern so learners can see what changed on their machine

The current default model across the learning surfaces is `qwen3:8b` via [Ollama](https://ollama.com).

The repo is opinionated. That is intentional.

This audience is not only asking coding questions. They are often asking broader product, strategy, and learning questions too. A general-use local model is a better beginner default than jumping straight to a coding-specialized model or a paid API.

This repo is still early.

That means it is useful, but not finished.
It means the scaffolding is up, but the wind and weather have not hit every side of it yet.
It means the ideas are ready for contact with more real machines, more real learners, and more real edge cases.
It also means the sharp corners have not all introduced themselves yet.

## What I need help with

I would love help testing this across platforms and learner scenarios so this can become a genuinely useful learning tool rather than another promising sketch pinned to the wall.

In particular, I am looking for people willing to test:

* macOS
* Windows
* Linux, especially Debian, Ubuntu, and Mint

I am especially interested in feedback from people using:

* older MacBooks
* lower-RAM laptops
* mixed-skill classroom or workshop settings
* beginner or nervous terminal workflows
* setups where local-first matters because recurring spend is a real constraint

Here is the kind of feedback that would help most:

* Where did the setup feel clear?
* Where did it feel confusing or fragile?
* What assumptions did the docs make that did not match your reality?
* Which commands or steps felt intimidating?
* Which platform-specific instructions broke down?
* What should be simpler before this is ready for wider use?

## The goal

The goal is not to create one more AI tool repo.

The goal is to create a learning tool that respects both ambition and constraint.

Something sturdy enough for the learner with a hand-me-down laptop.
Something clear enough for the nervous beginner.
Something flexible enough for the educator trying to teach a room full of mixed starting points.

Something a student can use.
Something a product manager can use.
Something an educator can use.
Something that works whether a learner starts in a visual builder, a terminal, or an editor.

If that sounds useful to you, I would love your help testing it, breaking it, and improving it.

Start here:

* [frugal-vibe-coder on GitHub](https://github.com/deanpeters/frugal-vibe-coder)

This is the early version.

The point now is to learn what it needs in order to become broadly useful.
