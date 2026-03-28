# Chapter 11: Multi-Repo Workflow

This setup is designed around the reality of working across multiple repos.

## Human Problem This Solves

Multiple repos are exhausting when all their terminals, logs, editors, and git
states bleed together.

This chapter is about preventing that sprawl.

## Recommended Shape

- one kitty tab per major workstream
- one tmux session per repo
- one Neovim pane plus one shell pane as the default

## Example

- kitty tab 1 -> backend repo session
- kitty tab 2 -> frontend repo session
- kitty tab 3 -> infrastructure repo session

## Why This Works

It reduces context mixing.

You stop treating the terminal as one giant bucket of panes and start treating
each repo as its own clean workspace.

## Rule Of Thumb

When in doubt, create a separate repo session instead of a more complicated
shared session.
