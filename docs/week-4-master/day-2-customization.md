# Week 4, Day 2: Customization

## Goal

Understand the config file structure and make your first personal customizations.

## New Concepts

- **`config/nvim/`** -- Neovim configuration. LazyVim base with custom keymaps and plugins. The keymaps live in `config/nvim/lua/config/keymaps.lua`.
- **`config/tmux/tmux.conf`** -- tmux configuration. Prefix key, bindings, status bar, and plugin settings.
- **`config/kitty/kitty.conf`** -- Kitty terminal configuration. Font, colors, window behavior.
- **`config/zsh/workflow.zsh`** -- shell aliases and functions. This is where `dev`, `v`, `lg`, `tl`, `ta`, `cheat`, and `keys` are defined.
- **`Ctrl-a r`** -- reload tmux config without restarting.
- **`source ~/.zshrc`** -- reload shell config to pick up new aliases.
- **`:source %`** -- in Neovim, reload the current Lua file (useful when editing keymaps).

## Exercises

### 1. Tour the config files

1. Run `dev` and open this dotfiles repo itself
2. In Neovim, press `F8` to open the file explorer
3. Navigate to `config/zsh/workflow.zsh`. Read through it. Notice how aliases are defined: `alias name="command"`
4. Press `F6` and type `tmux.conf`. Open it. Skim the bindings. Find where `Ctrl-a` is set as the prefix
5. Press `F6` and type `kitty.conf`. Open it. Notice font and color settings
6. Press `F6` and type `keymaps.lua`. Open it. Notice the pattern: `vim.keymap.set("n", "<key>", "<action>", { desc = "description" })`

### 2. Add a personal shell alias

1. In Neovim, open `config/zsh/workflow.zsh`
2. Press `G` to go to the end of the file
3. Press `o` to open a new line below and enter insert mode
4. Type a new alias. For example:
   ```
   alias gs="git status"
   ```
5. Press `Esc`, then type `:w` and press Enter to save
6. Press `Ctrl-a l` to switch to the shell pane
7. Type `source ~/.zshrc` and press Enter
8. Type `gs` and press Enter. You should see `git status` output
9. Your alias works. You just customized your shell

### 3. Add a Neovim keymap

1. Press `Ctrl-a h` to go back to Neovim
2. Open `config/nvim/lua/config/keymaps.lua` with `F6`
3. Study the existing keymaps. Each one follows this pattern:
   ```lua
   vim.keymap.set("n", "<key>", "<action>", { desc = "Description" })
   ```
   The first argument is the mode (`"n"` for normal, `"v"` for visual, `"i"` for insert).
4. Go to the end of the file. Press `G`, then `o` to add a new line
5. Add a simple keymap. For example, to clear search highlights:
   ```lua
   vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })
   ```
6. Save with `:w`
7. Reload the file with `:source %`
8. Press `Space h` to test your new keymap. Search highlights should clear

### 4. Reload tmux config

1. Open `config/tmux/tmux.conf` in Neovim
2. Read through it. Find a setting you understand, like the status bar position or a color
3. You do not need to change anything today. Just note that you could
4. Press `Ctrl-a r` to reload the tmux config. The status bar may briefly flash. Config reloaded
5. This is how you test tmux changes: edit the file, press `Ctrl-a r`, see the result

### 5. Verify your changes

1. Press `Ctrl-a l` to go to the shell
2. Type `gs` to confirm your alias still works
3. Press `Ctrl-a h` to go back to Neovim
4. Press `F1` to open WhichKey and look for your new keymap under the `h` key (or whatever key you chose)
5. Both customizations persist because they live in version-controlled config files

## Success Check

- [ ] I can name the four config file locations (nvim, tmux, kitty, zsh) from memory
- [ ] I added a shell alias to `workflow.zsh`, sourced it, and used it
- [ ] I added a keymap to `keymaps.lua`, reloaded it, and tested it
- [ ] I reloaded tmux config with `Ctrl-a r`
- [ ] I understand the pattern for adding aliases and keymaps and could add more on my own
