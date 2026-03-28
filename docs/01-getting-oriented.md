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

It should put you into a simple layout:

- left pane: `nvim`
- right pane: shell

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

- `F5`: search across the project
- `F6`: find files
- `F8`: toggle the explorer
- `F2`: rename symbol
- `F3`: format file
- `F10`: open LazyGit

That is enough for real work.

## What Success Looks Like Today

You do not need to feel elegant yet.

You are doing well if you can:

- open a repo quickly
- find the file you want
- search the codebase
- make edits without panic
- run commands beside the editor

That is the baseline this tutorial builds on.

