# Chapter 8: Tmux Workflow

Tmux is here because persistent sessions matter in real work.

## What This Chapter Should Help You Feel

Tmux should stop feeling like extra machinery and start feeling like your
workspace memory.

## What Tmux Owns

- session persistence
- repo workspaces
- panes
- windows

## Default Tmux Commands

- `Ctrl-a |`: split side by side
- `Ctrl-a -`: split stacked
- `Ctrl-a c`: new window
- `Ctrl-a h/j/k/l`: move between panes
- `Ctrl-a H/J/K/L`: resize panes
- `Ctrl-a z`: zoom pane
- `F5`: session and window tree

## Recommended Pattern

- pane 1: Neovim
- pane 2: shell

Add more panes only when you truly need them. Prefer extra tmux windows over a
mess of panes.

## Common Beginner Mistake

Do not try to replace every VS Code panel with another tmux pane.

Use panes for side-by-side active work. Use windows for separate contexts.
