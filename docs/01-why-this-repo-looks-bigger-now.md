# Chapter 1: Why This Repo Looks Bigger Now

Your reaction is fair. The repo got larger because it stopped being only a
shell file repo and became a full local development environment repo.

That added files in four groups:

## 1. Bootstrap

Files in [`bootstrap/`](../bootstrap) exist so a fresh machine can be rebuilt
without manual setup drift.

- `bootstrap/macos.sh`: one command to install and wire everything up
- `bootstrap/common.sh`: shared helper functions for safe linking and backups

Without this layer, the setup is harder to recreate and easier to break.

## 2. Config

Files in [`config/`](../config) are the actual tool configs.

- `config/nvim/`: Neovim and LazyVim
- `config/kitty/`: terminal behavior
- `config/tmux/`: persistent session behavior
- `config/zsh/`: the new shell additions for this workflow

This split is intentional. Each tool gets its own folder so it stays readable
instead of being buried inside one giant shell file.

## 3. Scripts

Files in [`scripts/`](../scripts) are small helper entrypoints.

- `scripts/dev`: open or resume a repo-specific tmux session
- `scripts/link-configs.sh`: create symlinks into `~/.config`
- `scripts/install-neovim-stack.sh`: headless Neovim setup
- `scripts/validate-setup.sh`: smoke-check the environment

These are operational tasks, not config, so they belong outside the config
directories.

## 4. Documentation

Files in [`docs/`](.) explain how to use the environment.

This is especially important because the setup introduces three layers at once:

- kitty
- tmux
- Neovim

Without docs, the config exists but the workflow remains opaque.

## Why Not Keep Everything In `.zshrc`?

Because that does not scale.

A single shell file is fine for aliases and personal shell behavior. It is a bad
home for:

- Neovim config
- terminal config
- tmux config
- bootstrap automation
- validation logic
- a learning guide

The repo got larger because the responsibilities became explicit.

## What Stayed Intentionally Small

I did not add:

- AI plugins inside Neovim
- a giant tmux plugin ecosystem
- a highly bespoke Neovim config
- complicated shell framework changes

The structure expanded, but the design goal stayed conservative.

