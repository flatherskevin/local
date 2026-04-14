# local

Terminal-first local development setup centered on Neovim, `kitty`, and `tmux`.

## Purpose

This repo installs and maintains my local development environment.

It uses `LazyVim` as the Neovim foundation and is designed for serious daily
development across multiple repositories.

## Install

### macOS via `curl`

```bash
curl -fsSL https://raw.githubusercontent.com/flatherskevin/local/main/install.sh | bash
```

### macOS via `wget`

```bash
wget -qO- https://raw.githubusercontent.com/flatherskevin/local/main/install.sh | bash
```

By default this installs or updates the managed checkout at
`~/.flatherskevin/local` and runs the bootstrap flow.

Each install run refreshes that managed checkout with a fresh shallow clone of
`main`.

## Manual Install

```bash
git clone --depth 1 --branch main https://github.com/flatherskevin/local.git ~/.flatherskevin/local
cd ~/.flatherskevin/local
./bootstrap/macos.sh
```

The bootstrap uses Homebrew Bundle and the repo's `Brewfile`, including the
HashiCorp tap required for `terraform`. If `brew bundle` reports that no
formula named `terraform` is available, update to the latest `main` branch
before retrying.

## Tutorial

For the actual usage guide, start here:

- [`docs/README.md`](docs/README.md)

That tutorial covers Neovim, tmux, kitty, the VS Code transition, and the
crawl/walk/run learning path.

## Validation

After install:

```bash
source ~/.zshrc
~/.flatherskevin/local/scripts/validate-setup.sh
```

## Updating Later

```bash
curl -fsSL https://raw.githubusercontent.com/flatherskevin/local/main/install.sh | bash
```
