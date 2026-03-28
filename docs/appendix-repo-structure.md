# Appendix: Repo Structure

This is not part of the tutorial sequence. It exists to explain the repo layout
briefly.

## Why There Are More Files Now

This repo used to be mostly shell setup. It now also contains:

- Neovim config
- kitty config
- tmux config
- bootstrap scripts
- helper scripts
- documentation

Those concerns are split by purpose so they stay maintainable.

## Top-Level Layout

- [`bootstrap/`](../bootstrap): install and symlink flow
- [`config/`](../config): tool configurations
- [`scripts/`](../scripts): helper entrypoints and validation
- [`docs/`](.): human usage guides

## Why Not Put Everything In `.zshrc`

Because `.zshrc` is the wrong place for:

- Neovim configuration
- terminal configuration
- tmux configuration
- install automation
- validation scripts
- tutorials

The file count increased because responsibilities were separated, not because
the setup was trying to become clever.
