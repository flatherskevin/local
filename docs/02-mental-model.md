# Chapter 2: Mental Model

The setup makes the most sense once you see the layers clearly.

## What You Should Get From This Chapter

By the end of this chapter, you should understand which tool is responsible for
which part of your day so you do not feel like three tools are competing for the
same job.

## Kitty

Kitty is the outer terminal app.

Use it for:

- OS windows
- tabs
- quick splits

Kitty is where your terminal session lives visually.

## Tmux

Tmux is the persistent workspace manager.

Use it for:

- long-lived sessions
- repo-specific workspaces
- side-by-side panes
- resuming work later

If kitty is the building, tmux is the floor plan.

## Neovim

Neovim is the editor inside the workspace.

Use it for:

- editing
- search
- file finding
- LSP
- formatting
- diagnostics

If tmux manages context, Neovim manages code.

## The Default Daily Shape

1. Open kitty
2. Run `dev`
3. Pick a repo
4. Attach to its tmux session
5. Edit in the left pane
6. Use the right pane for commands, git, tests, and AI

That is the main loop.

If you only remember one thing from this chapter, remember this:

- kitty opens the environment
- tmux holds the environment
- Neovim edits inside the environment
