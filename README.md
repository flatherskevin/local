# local

Terminal-first local development setup centered on Neovim, `kitty`, and `tmux`.

## Purpose

This repo installs and maintains my local development environment.

It uses `LazyVim` as the Neovim foundation and is designed for serious daily
development across multiple repositories.

## Install Paths

There are three supported ways to install this setup on macOS.

### 1. Managed Install From GitHub via `curl`

```bash
curl -fsSL https://raw.githubusercontent.com/flatherskevin/local/main/install.sh | bash
```

### 2. Managed Install From GitHub via `wget`

```bash
wget -qO- https://raw.githubusercontent.com/flatherskevin/local/main/install.sh | bash
```

By default this installs or updates the managed checkout at
`~/.flatherskevin/local` and runs the bootstrap flow.

Each install run stages a fresh shallow clone of `main` under
`~/.flatherskevin/releases`, bootstraps it, then atomically repoints the
managed `~/.flatherskevin/local` symlink only after the new release succeeds.
The previous successful release is kept for rollback.

### 3. Managed Install From This Local Clone

If you are working on this repo itself and want to install from your current
checkout instead of GitHub:

```bash
./scripts/dev install --local
```

Useful variants:

```bash
./scripts/dev install --local --with-ai
./scripts/dev install --local --ref main
```

`dev install --local` uses this repo as the installer source and updates your
actual `~/.flatherskevin`, `~/.config`, and `~/.local/bin` links. It clones
committed Git state from the current repo, so a dirty worktree triggers a
warning because uncommitted changes are not included.

### Direct Bootstrap From A Clone

This path is useful for manual setup and iteration, but it bypasses the managed
release lifecycle that `install.sh` provides.

```bash
git clone --depth 1 --branch main https://github.com/flatherskevin/local.git ~/codebase/local
cd ~/codebase/local
./bootstrap/macos.sh
```

The bootstrap uses Homebrew Bundle and the repo's `Brewfile`, including the
HashiCorp tap required for `terraform`. If `brew bundle` reports that no
formula named `terraform` is available, update to the latest `main` branch
before retrying.

## Base Setup Only

The base setup is the default install path.

To install the shared core workflow without optional personal additions:

- run any of the install paths above without enabling AI tools
- do not set `LOCAL_INSTALL_AI_CLI=1`
- do not create `~/.config/zsh/personal.zsh`
- do not add anything to `~/.localrc`

What that means in practice:

- managed core config is linked into place
- `config/zsh/personal.zsh` exists in the repo as an optional example, but is not linked automatically
- `~/.localrc` is sourced only if the user creates it

One important nuance: "base setup" here means the shared core workflow, not a
minimal generic shell profile. The base zsh config still includes the repo's
opinionated aliases and workflow defaults.

AI CLIs are optional. To install them during bootstrap, run:

```bash
LOCAL_INSTALL_AI_CLI=1 ./bootstrap/macos.sh
```

On macOS this uses native-style install paths:

- `claude` via Anthropic's native installer
- `codex` via `brew install --cask codex`

## Tutorial

For the actual usage guide, start here:

- [`docs/README.md`](docs/README.md)
- [`docs/ai/USAGE.md`](docs/ai/USAGE.md) for the canonical AI-facing operational guide

That tutorial covers Neovim, tmux, kitty, the VS Code transition, and the
crawl/walk/run learning path.

## Validation

After install:

```bash
source ~/.zshrc
~/.flatherskevin/local/scripts/validate-setup.sh
```

The validator reports required tools separately from optional extras such as
`claude`, `codex`, `colima`, and `docker`.

## Updating Later

```bash
curl -fsSL https://raw.githubusercontent.com/flatherskevin/local/main/install.sh | bash
```
