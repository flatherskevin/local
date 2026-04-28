# Cheatsheet

This repo includes a terminal cheatsheet script that displays keybindings
directly in your terminal with color formatting.

## Usage

```bash
cheat          # show all sections (piped through less)
cheat kitty    # kitty terminal keys
cheat tmux     # tmux keys (prefix: Ctrl-a)
cheat nvim     # Neovim F-key mappings
cheat neotree  # Neo-tree file explorer
cheat lsp      # Neovim LSP navigation
cheat diag     # diagnostics (show/hide/toggle)
cheat vim      # Vim essentials
cheat replace  # find and replace
cheat gitdiff  # git diff and history
cheat conflict # git conflict resolution
cheat shell    # shell aliases
keys           # alias for cheat
```

## Why A Script Instead Of A Document

A script stays closer to the terminal where you actually work. You do not need
to leave your session to look something up.

The output uses color and formatting to make scanning fast. All output goes
directly to stdout so you can scroll freely in your terminal or tmux
scrollback.

## Keeping It Updated

The script lives at `scripts/cheat` in this repo. If you add keybindings or
aliases, update the corresponding section in that file.
