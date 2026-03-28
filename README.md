# local

This repo now serves as the main home for a terminal-first local development
environment centered on Neovim, `kitty`, and `tmux`, while preserving the
existing shell setup and theme.

## Why This Setup

### Foundation choice: LazyVim

`LazyVim` is the Neovim base because it gives a battle-tested, widely-used,
actively maintained foundation with strong defaults for LSP, completion,
formatting, fuzzy finding, and project navigation. The custom layer in this
repo stays intentionally small so the setup remains durable instead of turning
into a bespoke hobby config.

## Repo Structure

```text
local/
├── .zshrc
├── Brewfile
├── README.md
├── bootstrap/
│   ├── common.sh
│   └── macos.sh
├── config/
│   ├── kitty/
│   │   └── kitty.conf
│   ├── nvim/
│   │   ├── init.lua
│   │   └── lua/
│   │       ├── config/
│   │       │   ├── autocmds.lua
│   │       │   ├── keymaps.lua
│   │       │   ├── lazy.lua
│   │       │   └── options.lua
│   │       └── plugins/
│   │           ├── editor.lua
│   │           ├── lazyvim.lua
│   │           └── lsp.lua
│   ├── tmux/
│   │   └── tmux.conf
│   └── zsh/
│       └── workflow.zsh
├── flatherskevin.zsh-theme
└── scripts/
    ├── dev
    ├── install-neovim-stack.sh
    ├── link-configs.sh
    └── validate-setup.sh
```

## Install

### Fresh macOS install

```bash
git clone https://github.com/flatherskevin/local.git ~/codebase/local
cd ~/codebase/local
chmod +x bootstrap/macos.sh scripts/*.sh scripts/dev
./bootstrap/macos.sh
```

The bootstrap script:

- installs Homebrew if missing
- installs editor and terminal tooling from `Brewfile`
- symlinks configs into `~/.config` and `~/.local/bin`
- keeps the existing root `.zshrc` as the main shell entrypoint
- installs Neovim plugins, Treesitter parsers, and Mason tools
- runs validation checks

Existing targets are backed up to `~/.dotfiles-backups/<timestamp>/` before
replacement.

## Core Responsibilities

- `kitty`: outer terminal app, tabs, windows, and a few memorable shortcuts
- `tmux`: persistent sessions and multi-repo workspaces
- `Neovim`: editing, navigation, search, LSP, formatting, diagnostics
- `.zshrc`: your long-standing shell config and aliases
- `config/zsh/workflow.zsh`: small terminal-first editor workflow layer

## Multi-Repo Workflow

Use one tmux session per repo or workstream.

```bash
dev
```

The `dev` script uses `fzf` to pick a repo, creates a side-by-side tmux layout,
starts `nvim` in the left pane, and leaves the right pane for tests, git, AI
tools, and logs. Re-running `dev` re-attaches to the existing session for that
repo.

## Learning The Setup

For a full tutorial on how to use this environment day to day, read:

- [`docs/README.md`](docs/README.md)

The tutorial is split into separate chapters rather than one long document. It
starts by explaining why the repo structure expanded, then walks through the
mental model, install and validation flow, VS Code migration, crawl/walk/run
adoption plan, and separate chapters for tmux, kitty, Neovim, multi-repo work,
and terminal-first AI usage.

## VS Code Migration Defaults

- `F1`: keymap help
- `F2`: rename symbol
- `F3`: format buffer
- `F4`: code action
- `F5`: grep project
- `F6`: find files
- `F7`: switch buffers
- `F8`: toggle file explorer
- `F9`: toggle terminal
- `F10`: LazyGit

## Validation

```bash
source ~/.zshrc
./scripts/validate-setup.sh
nvim
```

Inside Neovim, run `:checkhealth`, `:Lazy`, and `:Mason`.

## Updating Later

```bash
cd ~/codebase/local
git pull
./bootstrap/macos.sh
```

If you want tighter Neovim reproducibility later, commit the generated
`lazy-lock.json` after a successful install and plugin sync.
