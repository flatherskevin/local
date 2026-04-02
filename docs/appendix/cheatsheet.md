# Cheatsheet

This repo includes a terminal cheatsheet script that displays keybindings
directly in your terminal with color formatting.

## Usage

```bash
cheat          # show all sections (piped through less)
cheat kitty    # kitty terminal keys
cheat tmux     # tmux keys (prefix: Ctrl-a)
cheat nvim     # Neovim F-key mappings
cheat lsp      # Neovim LSP navigation
cheat vim      # Vim essentials
cheat shell    # shell aliases
keys           # alias for cheat
```

## Why A Script Instead Of A Document

A script stays closer to the terminal where you actually work. You do not need
to leave your session to look something up.

The output uses color and formatting to make scanning fast. Single sections go
directly to stdout. The full output pipes through `less -RFX` so it exits
automatically if the content fits on screen.

## Keeping It Updated

The script lives at `scripts/cheat` in this repo. If you add keybindings or
aliases, update the corresponding section in that file.
