# Chapter 12: AI Terminal Workflow

The AI workflow in this setup is intentionally terminal-first.

## Human Goal

The point is not to surround yourself with more AI surfaces.

The point is to keep AI close enough to help while keeping you in control of the
code, the search tools, and the final decisions.

## Recommended Pattern

- left pane: Neovim
- right pane: AI tool, tests, git, and shell commands

## Why

It keeps AI close to the work without turning the editor into a chat
application.

## Good Uses

- code review
- diff review
- debugging help
- implementation assistance
- architecture tracing

## Bad Uses

- replacing basic navigation
- accepting large unreviewed changes
- using AI instead of search or LSP

AI should augment the workflow, not become the workflow.

## Practical Habit

Before accepting or acting on AI output:

1. inspect the code in Neovim
2. search the repo yourself if needed
3. run the relevant command or test in the shell
4. review the diff before moving on

That keeps the workflow disciplined and trustworthy.
