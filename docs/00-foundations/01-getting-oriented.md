# Chapter 1: Getting Oriented

This chapter is about getting your bearings before you try to get fast.

If you are coming from VS Code, the biggest early mistake is assuming you need
to understand everything at once. You do not. You need a stable first-hour
workflow.

## What This Chapter Is For

By the end of this chapter, you should be able to answer three questions:

- where do I start work each day?
- what is the default layout I should use?
- which tool should I reach for first?

That is enough to begin using the setup productively.

## Your First Mental Reset

In VS Code, one application held most of your context:

- files
- search
- terminal
- source control
- language features

In this setup, that context is split across tools on purpose:

- `kitty` opens and contains your terminal windows
- `tmux` keeps your work alive and organized
- `Neovim` is where you edit and navigate code

This is not extra complexity for its own sake. It is a separation of jobs.

## Your Default Daily Starting Point

Start every work session with:

```bash
dev
```

That is the intended front door for daily work.

### What `dev` Does

The `dev` command automates the full startup sequence so you never have to
remember it:

1. Scans your code directories (`~/codebase`, `~/code`, `~/dev`, `~/src`,
   `~/work`, `~/workspace`) for git repositories.
2. Opens an `fzf` picker so you can fuzzy-select the repo you want.
3. Creates a tmux session named after the repo path (or reattaches to an
   existing one).
4. Splits the tmux window into two panes: Neovim on the left, a shell on the
   right.
5. Drops your cursor in the shell pane, ready to go.

You can also skip the picker by passing a path directly:

```bash
dev ~/codebase/my-project
```

If the session already exists, `dev` reattaches instead of creating a new one.
Your work survives terminal closes, laptop sleeps, and SSH disconnects.

### The Two-Pane Layout

This is what you see after running `dev`:

```
+------------------------------------------+---------------------+
|                                          |                     |
|  Neovim                                  |  Shell              |
|                                          |                     |
|  ~ open files here                       |  $ run commands     |
|  ~ search code here                      |  $ tests            |
|  ~ LSP features here                     |  $ git              |
|  ~ formatting here                       |  $ make / uv        |
|                                          |  $ logs             |
|                                          |  $ AI tools         |
|                                          |                     |
|  [F5] search  [F6] files  [F8] explorer  |                     |
|                                          |                     |
+------------------------------------------+---------------------+
  tmux pane 1 (editor)                       tmux pane 2 (shell)
```

The left pane takes about 60% of the width. Neovim opens there automatically.
The right pane is a normal shell for everything else.

Do not try to improve on this layout yet. Use it until it feels normal.

## What Each Side Is For

Use the left side for:

- opening files
- editing code
- searching code
- using LSP features

Use the right side for:

- tests
- `git`
- `make`
- `uv`
- logs
- terminal-based AI work

This split is one of the most important habits in the whole setup.

## What To Learn On Day One

Inside Neovim, only care about these at first:

### F5 -- Search in Project

Runs a live grep across every file in the repo. Type a search term, see matches
update as you type, press Enter to jump to the result.

```
F5 → type "def handle_request" → results filter live → Enter to open match
```

This replaces Cmd-Shift-F from VS Code. Use it constantly.

### F6 -- Find Files

Opens a fuzzy file finder. Type part of a filename, pick from the matches.

```
F6 → type "auth_mid" → matches auth_middleware.py → Enter to open
```

This replaces Cmd-P from VS Code. Faster than browsing a tree once you trust
it.

### F8 -- Toggle Explorer

Opens or closes the file tree sidebar (Neotree). Use it when you need to see
the directory structure or browse visually.

```
F8 → tree appears on left → navigate with j/k → Enter to open → F8 to close
```

This replaces the VS Code sidebar. Most of the time F6 is faster, but the
explorer is useful when you need spatial context.

### The Other Day-One Keys

These are also worth knowing immediately:

- `F2`: rename the symbol under the cursor (LSP rename)
- `F3`: format the current file
- `F10`: open LazyGit for staging, committing, and reviewing diffs

## What Success Looks Like Today

You do not need to feel elegant yet.

You are doing well if you can:

- open a repo quickly with `dev`
- find the file you want with F6
- search the codebase with F5
- make edits without panic
- run commands beside the editor in the right pane

That is the baseline this tutorial builds on.
