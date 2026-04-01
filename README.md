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

By default this installs or updates the repo at `~/codebase/local` and runs the
bootstrap flow.

## Manual Install

```bash
git clone https://github.com/flatherskevin/local.git ~/codebase/local
cd ~/codebase/local
./bootstrap/macos.sh
```

## Tutorial

For the actual usage guide, start here:

- [`docs/README.md`](docs/README.md)

That tutorial covers Neovim, tmux, kitty, the VS Code transition, and the
crawl/walk/run learning path.

## Validation

After install:

```bash
source ~/.zshrc
~/codebase/local/scripts/validate-setup.sh
```

## Updating Later

```bash
curl -fsSL https://raw.githubusercontent.com/flatherskevin/local/main/install.sh | bash
```
